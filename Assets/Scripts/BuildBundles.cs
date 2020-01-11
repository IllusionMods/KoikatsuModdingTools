#if UNITY_EDITOR
using Ionic.Zip;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Xml.Linq;
using UnityEditor;
using UnityEngine;
using Debug = UnityEngine.Debug;

namespace IllusionMods.KoikatuModdingTools
{
    /// <summary>
    /// Adds a menu item to build asset bundles
    /// </summary>
    public class MenuItems
    {
        //User defined stuff, needs a better home
        const string KoikatsuInstallPath = @"C:\Illusion\Koikatu";
        const bool CopyModToGameFolder = true;

        const string BuildPath = @"Build\abdata";
        const string ModsPath = @"Assets\Mods";
        const string ExamplesPath = @"Assets\Examples";
        const string SB3UtilityScriptPath = @"Tools\SB3UGS\SB3UtilityScript.exe";
        private static readonly Dictionary<string, string> ShaderABs = new Dictionary<string, string>() { { "Shader Forge/main_item", "chara/ao_arm_00.unity3d" } };
        private static readonly HashSet<string> GameNameList = new HashSet<string>() { "koikatsu", "koikatu", "コイカツ" };
        private static readonly RNGCryptoServiceProvider rng = new RNGCryptoServiceProvider();

        [MenuItem("Assets/Build All Asset Bundles")]
        [MenuItem("Build/Build All Asset Bundles")]
        internal static void BuildAssetBundles()
        {
            var di = new DirectoryInfo(BuildPath);
            if (!di.Exists)
                di.Create();

            //Build the asset bundles
            Debug.Log("Building asset bundles...");
            BuildPipeline.BuildAssetBundles(BuildPath, BuildAssetBundleOptions.ChunkBasedCompression | BuildAssetBundleOptions.ForceRebuildAssetBundle, BuildTarget.StandaloneWindows64);

            //Generate and run the script to replace shader references            
            Debug.Log("Generating SB3UGS script...");
            string script = GenerateScript();
            if (script != "")
            {
                Debug.Log("Running SB3UGS script...");
                RunScript(script);
            }

            Debug.Log("Cleaning up...");
            //Delete ABs containing dummy shaders
            foreach (var ab in ShaderABs.Values)
                File.Delete(Path.Combine(BuildPath, ab));

            //Delete useless .manifest files
            foreach (var file in di.GetFiles("*.manifest", SearchOption.AllDirectories))
                file.Delete();

            Debug.Log("Finished building asset bundles.");
        }

        [MenuItem("Assets/Build Mod")]
        internal static void BuildMod()
        {
            string projectPath = GetProjectPath();
            BuildSingleMod(projectPath);
        }

        [MenuItem("Assets/Build All Mods")]
        [MenuItem("Build/Build All Mods")]
        internal static void BuildMods()
        {
            var di = new DirectoryInfo(ModsPath);
            foreach (var file in di.GetFiles("manifest.xml", SearchOption.AllDirectories))
            {
                string projectPath = file.Directory.FullName;
                projectPath = projectPath.Substring(projectPath.IndexOf(ModsPath));
                BuildSingleMod(projectPath);
            }
        }

        /// <summary>
        /// Packs up a mod including its manifest.xml, list files, and asset bundles. Copies the mod to the user's install folder.
        /// </summary>
        /// <param name="projectPath">Path of the project containing the mod, manifest.xml should be in the root.</param>
        private static void BuildSingleMod(string projectPath)
        {
            string manifestPath = Path.Combine(projectPath, "manifest.xml");
            string makerListPath = Path.Combine(projectPath, @"List\Maker");
            string studioListPath = Path.Combine(projectPath, @"List\Studio");

            HashSet<string> modABs = new HashSet<string>();
            HashSet<string> makerListFiles = new HashSet<string>();
            HashSet<string> studioListFiles = new HashSet<string>();

            Debug.Log("Building zipmod...");
            if (!File.Exists(manifestPath))
            {
                Debug.Log("manifest.xml does not exist in the directory, mod creation aborted.");
                return;
            }

            //Read the manifest.xml
            XDocument manifestDocument = XDocument.Load(manifestPath);
            string modGUID = manifestDocument.Root.Element("guid").Value;
            string modName = "";
            string modVersion = "";
            string modAuthor = "";
            string modGame = "";
            if (manifestDocument.Root.Element("name") != null)
                modName = manifestDocument.Root.Element("name").Value;
            if (manifestDocument.Root.Element("version") != null)
                modVersion = manifestDocument.Root.Element("version").Value;
            if (manifestDocument.Root.Element("author") != null)
                modAuthor = manifestDocument.Root.Element("author").Value;
            if (manifestDocument.Root.Element("game") != null)
                modGame = manifestDocument.Root.Element("game").Value;

            if (modGame != "")
            {
                if (!GameNameList.Contains(modGame.ToLower().Replace("!", "")))
                {
                    Debug.Log("The manifest.xml lists a game other than Koikatsu, this mod will not be built.");
                    return;
                }
                else
                    modGame = "KK";
            }

            //Create a name for the .zipmod based on manifest.xml
            string zipFileName = "";
            if (modAuthor != "" && modName != "")
            {
                if (modAuthor != "")
                    zipFileName += "[" + modAuthor + "]";
                if (modGame != "")
                    zipFileName += "[" + modGame + "]";
                if (modName != "")
                    zipFileName += modName;
            }
            else
                zipFileName = modGUID;
            string zipFileNamePrexix = zipFileName;
            if (modVersion != "")
                zipFileName += " v" + modVersion;
            zipFileName += ".zipmod";
            string zipPath = Path.Combine("Build", zipFileName);

            //Find all the asset bundles for this mod
            foreach (var assetguid in AssetDatabase.FindAssets("", new string[] { projectPath }))
            {
                string assetPath = AssetDatabase.GUIDToAssetPath(assetguid);
                string modAB = AssetDatabase.GetImplicitAssetBundleName(assetPath);
                if (modAB != string.Empty)
                    modABs.Add(Path.Combine(BuildPath, modAB));
            }

            var di = new DirectoryInfo(makerListPath);
            if (di.Exists)
                foreach (var file in di.GetFiles("*.csv", SearchOption.AllDirectories))
                    makerListFiles.Add(file.FullName);

            di = new DirectoryInfo(studioListPath);
            if (di.Exists)
                foreach (var file in di.GetFiles("*.csv", SearchOption.AllDirectories))
                    studioListFiles.Add(file.FullName);

            if (makerListFiles.Count == 0 && studioListFiles.Count == 0)
                Debug.Log("No list files were found for this mod. If this mod is overriding vanilla assets, no list files are required. Any mod adding new content to maker or studio requires list files");

            //Build the zip file
            File.Delete(zipPath);
            ZipFile zipFile = new ZipFile(zipPath, Encoding.UTF8);
            zipFile.CompressionLevel = Ionic.Zlib.CompressionLevel.None;

            //Add the manifest
            zipFile.AddFile(manifestPath, "");

            //Add asset bundles
            foreach (var modAB in modABs)
            {
                string folderAB = modAB.Replace("/", @"\").Replace(@"Build\", "");
                folderAB = folderAB.Remove(folderAB.LastIndexOf(@"\")); //Remove the .unity3d filename
                zipFile.AddFile(modAB, folderAB);
            }

            //Add list files
            foreach (var listFile in makerListFiles)
                zipFile.AddFile(listFile, @"abdata\list\characustom\00\");

            zipFile.Save();
            zipFile.Dispose();

            if (CopyModToGameFolder)
            {
                var modsFolder = Path.Combine(KoikatsuInstallPath, "mods");
                var copyPath = Path.Combine(modsFolder, zipFileName);
                di = new DirectoryInfo(modsFolder);
                if (di.Exists)
                {
                    Debug.Log(zipFileNamePrexix);
                    foreach (var file in di.GetFiles("*.zipmod"))
                    {
                        Debug.Log(file.Name);
                        if (file.Name.StartsWith(zipFileNamePrexix))
                            file.Delete();
                    }
                    File.Copy(zipPath, copyPath);
                }
                else
                    Debug.Log("Mods folder not found, could not copy .zipmod files to game install.");
            }

            Debug.Log("Mod built sucessfully.");
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

            var di = new DirectoryInfo(BuildPath);
            if (!di.Exists) return "";

            foreach (var file in di.GetFiles("*.unity3d", SearchOption.AllDirectories))
            {
                bool doCABRandomization = false;
                var bundlePath = file.FullName;
                var bundle = AssetBundle.LoadFromFile(bundlePath);
                var gameObjects = bundle.LoadAllAssets<GameObject>();

                var bundlePathShort = bundlePath.Remove(0, bundlePath.IndexOf(BuildPath)).Replace(BuildPath + @"\", "");
                if (bundlesToRandomize.Contains(bundlePathShort))
                    doCABRandomization = true;

                foreach (var gameObject in gameObjects)
                {
                    GameObject go = UnityEngine.Object.Instantiate(bundle.LoadAsset<GameObject>(gameObject.name));
                    go.name = go.name.Replace("(Clone)", "");

                    var renderers = go.GetComponentsInChildren<Renderer>();
                    foreach (var renderer in renderers)
                    {
                        foreach (var material in renderer.sharedMaterials)
                        {
                            string materialName = material.name;
                            string shaderName = material.shader.name;

                            string shaderAB;
                            if (ShaderABs.TryGetValue(shaderName, out shaderAB))
                            {
                                string shaderABPath = KoikatsuInstallPath + "/" + "abdata" + "/" + shaderAB;

                                sb.AppendLine();
                                sb.AppendLine("unityParserMainAB = OpenUnity3d(path=\"" + bundlePath + "\")");
                                sb.AppendLine("unityEditorMainAB = Unity3dEditor(parser=unityParserMainAB)");
                                sb.AppendLine("unityEditorMainAB.GetAssetNames(filter=True)");
                                sb.AppendLine("animatorIndexMainAB = unityEditorMainAB.ComponentIndex(name=\"" + go.name + "\", clsIDname=\"GameObject\")");
                                sb.AppendLine("");
                                sb.AppendLine("unityParserShaderAB = OpenUnity3d(path=\"" + shaderABPath + "\")");
                                sb.AppendLine("unityEditorShaderAB = Unity3dEditor(parser=unityParserShaderAB)");
                                sb.AppendLine("unityEditorShaderAB.GetAssetNames(filter=True)");
                                sb.AppendLine("shaderIndexShaderAB = unityEditorShaderAB.ComponentIndex(name=\"" + shaderName + "\", clsIDname=\"Shader\")");
                                sb.AppendLine("");
                                sb.AppendLine("virtualAnimatorMainAB = unityEditorMainAB.OpenVirtualAnimator(componentIndex=animatorIndexMainAB)");
                                sb.AppendLine("animatorEditorMainAB = AnimatorEditor(parser=virtualAnimatorMainAB)");
                                sb.AppendLine("unityEditorMainAB.GetAssetNames(filter=True)");
                                sb.AppendLine("unityEditorShaderAB.GetAssetNames(filter=True)");
                                sb.AppendLine("");
                                sb.AppendLine("sh = unityEditorShaderAB.LoadWhenNeeded(componentIndex=shaderIndexShaderAB)");
                                sb.AppendLine("animatorEditorMainAB.SetMaterialShader(id=0, shader=sh)");
                                if (doCABRandomization)
                                {
                                    var cab = GetRandomCABString();
                                    sb.AppendLine("unityEditorMainAB.RenameCabinet(cabinetIndex=0, name=\"" + cab + "\")");
                                    doCABRandomization = false;
                                }
                                sb.AppendLine("unityEditorMainAB.SaveUnity3d(keepBackup=False, backupExtension=\".unit-y3d\", background=False, clearMainAsset=True, pathIDsMode=-1, compressionLevel=2, compressionBufferSize=262144)");
                                wroteScript = true;
                            }
                        }
                    }
                    UnityEngine.Object.DestroyImmediate(go);
                }
                if (doCABRandomization)
                {
                    var cab = GetRandomCABString();
                    sb.AppendLine("unityParserMainAB = OpenUnity3d(path=\"" + bundlePath + "\")");
                    sb.AppendLine("unityEditorMainAB = Unity3dEditor(parser=unityParserMainAB)");
                    sb.AppendLine("unityEditorMainAB.GetAssetNames(filter=True)");
                    sb.AppendLine("unityEditorMainAB.RenameCabinet(cabinetIndex=0, name=\"" + cab + "\")");
                    sb.AppendLine("unityEditorMainAB.SaveUnity3d(keepBackup=False, backupExtension=\".unit-y3d\", background=False, clearMainAsset=True, pathIDsMode=-1, compressionLevel=2, compressionBufferSize=262144)");

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
            string sb3u = root + SB3UtilityScriptPath;

            System.Diagnostics.Process.Start("\"" + sb3u + "\"", "\"" + output + "\"");
        }

        /// <summary>
        /// Get a list of asset bundles that need to have their CAB-string randomized
        /// </summary>
        private static HashSet<string> GetBundlesToRandomize()
        {
            HashSet<string> randomizedBundles = new HashSet<string>();
            var di = new DirectoryInfo(ModsPath);
            foreach (var file in di.GetFiles("mod_settings.xml", SearchOption.AllDirectories))
            {
                XDocument mod_settings = XDocument.Load(file.FullName);
                foreach (var element in mod_settings.Root.Element("assetBundles").Elements("bundle"))
                    if (element.Attribute("path") != null && element.Attribute("randomizeCAB") != null)
                        if (element.Attribute("randomizeCAB").Value.ToLower() == "true" && element.Attribute("path").Value != "")
                            randomizedBundles.Add(element.Attribute("path").Value.Replace("/", @"\"));
            }

            di = new DirectoryInfo(ExamplesPath);
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

        /// <summary>
        /// Get the path of the currently selected folder.
        /// </summary>
        public static string GetProjectPath()
        {
            try
            {
                var projectBrowserType = Type.GetType("UnityEditor.ProjectBrowser,UnityEditor");
                var projectBrowser = projectBrowserType.GetField("s_LastInteractedProjectBrowser", BindingFlags.Static | BindingFlags.Public).GetValue(null);
                var invokeMethod = projectBrowserType.GetMethod("GetActiveFolderPath", BindingFlags.NonPublic | BindingFlags.Instance);
                return (string)invokeMethod.Invoke(projectBrowser, new object[] { });
            }
            catch (Exception exception)
            {
                Debug.LogWarning("Error while trying to get current project path.");
                Debug.LogWarning(exception.Message);
                return string.Empty;
            }
        }
    }
}
#endif