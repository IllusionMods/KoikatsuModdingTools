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

        public static bool BuildAndRunScripts(string buildPath, string koikatsuPath)
        {
            BuildPath = buildPath;
            KoikatsuPath = koikatsuPath;

            string script = GenerateScript();
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
        private static string GenerateScript()
        {
            bool wroteScript = false;
            var bundlesToRandomize = GetBundlesToRandomize();
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("LoadPlugin(PluginDirectory+\"UnityPlugin.dll\")");

            foreach (var assetguid in AssetDatabase.FindAssets("t:Prefab", new string[] { Constants.ModsPath, Constants.ExamplesPath }))
            {
                string assetPath = AssetDatabase.GUIDToAssetPath(assetguid);
                string modAB = AssetDatabase.GetImplicitAssetBundleName(assetPath);
                string mainABPath = new FileInfo(Path.Combine(BuildPath, modAB)).FullName;
                var go = AssetDatabase.LoadAssetAtPath<GameObject>(assetPath);

                var renderers = go.GetComponentsInChildren<Renderer>();
                foreach (var renderer in renderers)
                {
                    foreach (var material in renderer.sharedMaterials)
                    {
                        string materialName = material.name;
                        string shaderName = material.shader.name;

                        string shaderAB;
                        if (Constants.ShaderABs.TryGetValue(shaderName, out shaderAB))
                        {
                            string shaderABPath = KoikatsuPath + "/" + "abdata" + "/" + shaderAB;

                            sb.AppendLine("unityParserMainAB = OpenUnity3d(path=\"" + mainABPath + "\")");
                            sb.AppendLine("unityEditorMainAB = Unity3dEditor(parser=unityParserMainAB)");
                            sb.AppendLine("unityEditorMainAB.GetAssetNames(filter=True)");
                            sb.AppendLine("animatorIndexMainAB = unityEditorMainAB.ComponentIndex(name=\"" + go.name + "\", clsIDname=\"GameObject\")");

                            sb.AppendLine("unityParserShaderAB = OpenUnity3d(path=\"" + shaderABPath + "\")");
                            sb.AppendLine("unityEditorShaderAB = Unity3dEditor(parser=unityParserShaderAB)");
                            sb.AppendLine("unityEditorShaderAB.GetAssetNames(filter=True)");
                            sb.AppendLine("shaderIndexShaderAB = unityEditorShaderAB.ComponentIndex(name=\"" + shaderName + "\", clsIDname=\"Shader\")");

                            sb.AppendLine("virtualAnimatorMainAB = unityEditorMainAB.OpenVirtualAnimator(componentIndex=animatorIndexMainAB)");
                            sb.AppendLine("animatorEditorMainAB = AnimatorEditor(parser=virtualAnimatorMainAB)");
                            sb.AppendLine("unityEditorMainAB.GetAssetNames(filter=True)");
                            sb.AppendLine("unityEditorShaderAB.GetAssetNames(filter=True)");

                            sb.AppendLine("sh = unityEditorShaderAB.LoadWhenNeeded(componentIndex=shaderIndexShaderAB)");
                            sb.AppendLine("animatorEditorMainAB.SetMaterialShader(id=0, shader=sh)");
                            sb.AppendLine("unityEditorMainAB.SaveUnity3d(keepBackup=False, backupExtension=\".unit-y3d\", background=False, clearMainAsset=True, pathIDsMode=-1, compressionLevel=2, compressionBufferSize=262144)");
                            wroteScript = true;
                        }
                    }
                }
            }

            foreach (var modAB in bundlesToRandomize)
            {
                string mainABPath = new FileInfo(Path.Combine(BuildPath, modAB)).FullName;
                var cab = GetRandomCABString();
                sb.AppendLine("unityParserMainAB = OpenUnity3d(path=\"" + mainABPath + "\")");
                sb.AppendLine("unityEditorMainAB = Unity3dEditor(parser=unityParserMainAB)");
                sb.AppendLine("unityEditorMainAB.GetAssetNames(filter=True)");
                sb.AppendLine("unityEditorMainAB.RenameCabinet(cabinetIndex=0, name=\"" + cab + "\")");
                sb.AppendLine("unityEditorMainAB.SaveUnity3d(keepBackup=False, backupExtension=\".unit-y3d\", background=False, clearMainAsset=True, pathIDsMode=-1, compressionLevel=2, compressionBufferSize=262144)");
                wroteScript = true;
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
