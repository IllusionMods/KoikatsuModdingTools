using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Xml.Linq;
using UnityEditor;
using UnityEngine;

namespace IllusionMods.KoikatuModdingTools
{
    public static class SB3UScript
    {
        private static readonly RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();
        private static string BuildPath;
        private static string KoikatsuPath;
        private static bool Compression;

        public static bool BuildAndRunScripts(string buildPath, string koikatsuPath, bool compression, List<string> changedFiles)
        {
            BuildPath = buildPath.Replace("/", @"\");
            KoikatsuPath = koikatsuPath.Replace("/", @"\");
            Compression = compression;

            string script = GenerateScript(changedFiles);
            if (script == "")
                return false;
            else
                RunScript(script);
            return true;
        }

        /// <summary>
        /// Look through the asset bundles, find all materials that have a Koikatsu shader, generate a script that will replace it with a reference to the real shader.
        /// Also randomized CAB-strings if necessary.
        /// </summary>
        private static string GenerateScript(List<string> changedFiles)
        {
            List<string> bundlesToCompress = changedFiles.ToList();
            bool wroteScript = false;
            var bundlesToRandomize = GetBundlesToRandomize();
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("LoadPlugin(PluginDirectory+\"UnityPlugin.dll\")");

            Dictionary<string, HashSet<string>> shaderABs = new Dictionary<string, HashSet<string>>();

            //Create a list of asset bundles and all the shaders inside it that need replacement
            foreach (var assetguid in AssetDatabase.FindAssets("t:Prefab", new string[] { Constants.ModsPath, Constants.ExamplesPath }))
            {
                string assetPath = AssetDatabase.GUIDToAssetPath(assetguid);
                string modAB = AssetDatabase.GetImplicitAssetBundleName(assetPath);
                if (string.IsNullOrEmpty(modAB))
                    continue;
                modAB = Path.Combine(BuildPath, modAB).Replace("/", @"\");
                string mainABPath = new FileInfo(modAB).FullName;
                if (!changedFiles.Contains(mainABPath))
                    continue;

                var go = AssetDatabase.LoadAssetAtPath<GameObject>(assetPath);
                var renderers = go.GetComponentsInChildren<Renderer>();
                foreach (var renderer in renderers)
                {
                    foreach (var material in renderer.sharedMaterials)
                    {
                        if (material == null) continue;
                        if (material.shader == null) continue;

                        if (Constants.ShaderABs.ContainsKey(material.shader.name))
                        {
                            HashSet<string> shaderList;
                            if (!shaderABs.TryGetValue(modAB, out shaderList))
                            {
                                shaderList = new HashSet<string>();
                                shaderABs[modAB] = shaderList;
                            }
                            shaderList.Add(material.shader.name);
                        }
                    }
                }
            }

            //find shaders assigned to materials that are not assigned to game objects
            foreach (var assetguid in AssetDatabase.FindAssets("t:Material", new string[] { Constants.ModsPath, Constants.ExamplesPath }))
            {
                string assetPath = AssetDatabase.GUIDToAssetPath(assetguid);
                string modAB = AssetDatabase.GetImplicitAssetBundleName(assetPath);
                if (string.IsNullOrEmpty(modAB))
                    continue;
                modAB = Path.Combine(BuildPath, modAB).Replace("/", @"\");
                string mainABPath = new FileInfo(modAB).FullName;
                if (!changedFiles.Contains(mainABPath))
                    continue;

                var material = AssetDatabase.LoadAssetAtPath<Material>(assetPath);

                if (Constants.ShaderABs.ContainsKey(material.shader.name))
                {
                    HashSet<string> shaderList;
                    if (!shaderABs.TryGetValue(modAB, out shaderList))
                    {
                        shaderList = new HashSet<string>();
                        shaderABs[modAB] = shaderList;
                    }
                    shaderList.Add(material.shader.name);
                }
            }

            //Generate the shader replacement script
            foreach (var ab in shaderABs)
            {
                string modAB = ab.Key;
                string mainABPath = new FileInfo(modAB).FullName;
                bundlesToCompress.Remove(mainABPath);

                sb.AppendLine("Log(\"Replacing shaders for: " + modAB + "\")");
                sb.AppendLine("unityParserMainAB = OpenUnity3d(path=\"" + mainABPath + "\")");
                sb.AppendLine("unityEditorMainAB = Unity3dEditor(parser=unityParserMainAB)");
                foreach (string shaderName in ab.Value)
                {
                    string shaderAB;
                    if (Constants.ShaderABs.TryGetValue(shaderName, out shaderAB))
                    {
                        string shaderABPath;
                        if (shaderAB == Constants.ShaderABPath)
                            shaderABPath = Path.Combine(Directory.GetCurrentDirectory(), shaderAB);
                        else
                            shaderABPath = KoikatsuPath + @"\" + "abdata" + @"\" + shaderAB;

                        sb.AppendLine("Log(\"Replacing shader: " + shaderName + "\")");
                        sb.AppendLine("unityEditorMainAB.GetAssetNames(filter=True)");
                        sb.AppendLine("shaderIndexMainAB = unityEditorMainAB.ComponentIndex(name=\"" + shaderName + "\", clsIDname=\"Shader\")");

                        sb.AppendLine("unityParserShaderAB = OpenUnity3d(path=\"" + shaderABPath + "\")");
                        sb.AppendLine("unityEditorShaderAB = Unity3dEditor(parser=unityParserShaderAB)");
                        sb.AppendLine("unityEditorShaderAB.GetAssetNames(filter=True)");
                        sb.AppendLine("shaderIndexShaderAB = unityEditorShaderAB.ComponentIndex(name=\"" + shaderName + "\", clsIDname=\"Shader\")");

                        sb.AppendLine("assetMainAB = unityEditorMainAB.LoadWhenNeeded(componentIndex=shaderIndexMainAB)");
                        sb.AppendLine("assetShaderAB = unityEditorShaderAB.LoadWhenNeeded(componentIndex=shaderIndexShaderAB)");

                        sb.AppendLine("unityEditorMainAB.CopyInPlace(src=assetShaderAB, dest=assetMainAB)");
                    }
                }
                if (Compression)
                {
                    sb.AppendLine("Log(\"Compressing...\")");
                    sb.AppendLine("unityEditorMainAB.SaveUnity3d(keepBackup=False, backupExtension=\".unit-y3d\", background=False, clearMainAsset=True, pathIDsMode=-1, compressionLevel=2, compressionBufferSize=262144)");
                }
                else
                {
                    sb.AppendLine("Log(\"Saving...\")");
                    sb.AppendLine("unityEditorMainAB.SaveUnity3d(keepBackup=False, backupExtension=\".unit-y3d\", background=False, clearMainAsset=True, pathIDsMode=-1)");
                }
                wroteScript = true;
            }

            //Randomize asset bundle CAB strings where configured in the mod settings
            foreach (var bundle in bundlesToRandomize)
            {
                string modAB = Path.Combine(BuildPath, bundle);
                string mainABPath = new FileInfo(modAB).FullName;
                if (!changedFiles.Contains(mainABPath))
                    continue;
                bundlesToCompress.Remove(mainABPath);

                var cab = GetRandomCABString();
                sb.AppendLine("Log(\"Randomizing CAB for " + modAB + "\")");
                sb.AppendLine("unityParserMainAB = OpenUnity3d(path=\"" + mainABPath + "\")");
                sb.AppendLine("unityEditorMainAB = Unity3dEditor(parser=unityParserMainAB)");
                sb.AppendLine("unityEditorMainAB.GetAssetNames(filter=True)");
                sb.AppendLine("unityEditorMainAB.RenameCabinet(cabinetIndex=0, name=\"" + cab + "\")");
                if (Compression)
                    sb.AppendLine("unityEditorMainAB.SaveUnity3d(keepBackup=False, backupExtension=\".unit-y3d\", background=False, clearMainAsset=True, pathIDsMode=-1, compressionLevel=2, compressionBufferSize=262144)");
                else
                    sb.AppendLine("unityEditorMainAB.SaveUnity3d(keepBackup=False, backupExtension=\".unit-y3d\", background=False, clearMainAsset=True, pathIDsMode=-1)");
                wroteScript = true;
            }

            if (Compression)
            {
                foreach (string bundlePath in bundlesToCompress)
                {
                    string bundle = bundlePath;
                    int index = bundle.IndexOf(BuildPath);
                    if (index > 0)
                        bundle = bundle.Substring(index);

                    sb.AppendLine("Log(\"Compressing " + bundle + "...\")");
                    sb.AppendLine("unityParserMainAB = OpenUnity3d(path=\"" + bundlePath + "\")");
                    sb.AppendLine("unityEditorMainAB = Unity3dEditor(parser=unityParserMainAB)");
                    sb.AppendLine("unityEditorMainAB.GetAssetNames(filter=True)");
                    sb.AppendLine("unityEditorMainAB.SaveUnity3d(keepBackup=False, backupExtension=\".unit-y3d\", background=False, clearMainAsset=True, pathIDsMode=-1, compressionLevel=2, compressionBufferSize=262144)");
                    wroteScript = true;
                }
            }

            if (wroteScript)
                return sb.ToString();

            return "";
        }

        /// <summary>
        /// Sends a string to SB3UGS to be run.
        /// </summary>
        /// <param name="script">String containing the script.</param>
        private static void RunScript(string script)
        {
            string output = BuildPath + "/output.txt";
            File.WriteAllText(output, script);
            string root = Application.dataPath.Replace("/Assets", "/");
            output = root + output;
            string sb3u = root + Constants.SB3UtilityScriptPath;

            System.Diagnostics.Process.Start("\"" + sb3u + "\"", "\"" + output + "\"");
        }

        /// <summary>
        /// Get a list of asset bundles that need to have their CAB-string randomized
        /// </summary>
        private static HashSet<string> GetBundlesToRandomize()
        {
            HashSet<string> randomizedBundles = new HashSet<string>();
            var di = new DirectoryInfo(Constants.ModsPath);
            foreach (var file in di.GetFiles("mod_settings.xml", SearchOption.AllDirectories))
            {
                XDocument mod_settings = XDocument.Load(file.FullName);
                foreach (var element in mod_settings.Root.Element("assetBundles").Elements("bundle"))
                    if (element.Attribute("path") != null && element.Attribute("randomizeCAB") != null)
                        if (element.Attribute("randomizeCAB").Value.ToLower() == "true" && element.Attribute("path").Value != "")
                            randomizedBundles.Add(element.Attribute("path").Value.Replace("/", @"\"));
            }

            di = new DirectoryInfo(Constants.ExamplesPath);
            foreach (var file in di.GetFiles("mod_settings.xml", SearchOption.AllDirectories))
            {
                XDocument mod_settings = XDocument.Load(file.FullName);
                foreach (var element in mod_settings.Root.Element("assetBundles").Elements("bundle"))
                    if (element.Attribute("path") != null && element.Attribute("randomizeCAB") != null)
                        if (element.Attribute("randomizeCAB").Value.ToLower() == "true" && element.Attribute("path").Value != "")
                            randomizedBundles.Add(element.Attribute("path").Value.Replace("/", @"\"));
            }

            return randomizedBundles;
        }

        /// <summary>
        /// Generate a random CAB string.
        /// </summary>
        private static string GetRandomCABString()
        {
            var rnbuf = new byte[16];
            rng.GetBytes(rnbuf);
            string CAB = "CAB-" + string.Concat(rnbuf.Select((x) => ((int)x).ToString("X2")).ToArray()).ToLower();
            return CAB;
        }
    }
}
