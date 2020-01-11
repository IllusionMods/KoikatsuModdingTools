#if UNITY_EDITOR
using Ionic.Zip;
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;
using UnityEditor;
using UnityEngine;
using Debug = UnityEngine.Debug;
using System.Xml;
using System.Xml.Linq;

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
        const string SB3UtilityScriptPath = @"Tools\SB3UGS\SB3UtilityScript.exe";
        private static readonly Dictionary<string, string> ShaderABs = new Dictionary<string, string>() { { "Shader Forge/main_item", "chara/ao_arm_00.unity3d" } };
        private static readonly HashSet<string> GameNameList = new HashSet<string>() { "koikatsu", "koikatu", "コイカツ" };

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
            Debug.Log("Generating shader replacement script...");
            string script = GenerateScript();
            if (script != "")
            {
                Debug.Log("Running shader replacement script...");
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
        /// Look through the asset bundles, find all materials that have a Koikatsu shader, generate a script that will replace it with a reference to the real shader
        /// </summary>
        private static string GenerateScript()
        {
            bool wroteScript = false;
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("LoadPlugin(PluginDirectory+\"UnityPlugin.dll\")");

            var di = new DirectoryInfo(BuildPath);
            if (!di.Exists) return "";

            foreach (var file in di.GetFiles("*.unity3d", SearchOption.AllDirectories))
            {
                var bundlePath = file.FullName;
                var bundle = AssetBundle.LoadFromFile(bundlePath);
                var gameObjects = bundle.LoadAllAssets<GameObject>();

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
                                sb.AppendLine("unityEditorMainAB.SaveUnity3d(keepBackup=False, backupExtension=\".unit-y3d\", background=False, clearMainAsset=True, pathIDsMode=-1, compressionLevel=2, compressionBufferSize=262144)");
                                wroteScript = true;
                            }
                        }
                    }
                    UnityEngine.Object.DestroyImmediate(go);
                }
            }

            if (wroteScript)
                return sb.ToString();
            else
                Debug.Log("No shaders found to replace.");

            return "";
        }

        private static void RunScript(string script)
        {
            string output = BuildPath + "/output.txt";
            File.WriteAllText(output, script);
            string root = Application.dataPath.Replace("/Assets", "/");
            output = root + output;
            string sb3u = root + SB3UtilityScriptPath;

            System.Diagnostics.Process.Start("\"" + sb3u + "\"", "\"" + output + "\"");
        }

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