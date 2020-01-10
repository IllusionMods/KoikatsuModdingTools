#if UNITY_EDITOR
using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;
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
        const string BuildDir = "Build/abdata";
        const string SB3UtilityScriptPath = "Tools/SB3UGS/SB3UtilityScript.exe";
        const string KoikatsuInstallPath = "C:/Illusion/Koikatu";
        static readonly Dictionary<string, string> ShaderABs = new Dictionary<string, string>() { { "Shader Forge/main_item", "chara/ao_arm_00.unity3d" } };

        [MenuItem("Assets/Build Asset Bundles")]
        [MenuItem("Build/Build Asset Bundles")]
        internal static void BuildAssetBundles()
        {
            var di = new DirectoryInfo(BuildDir);
            if (!di.Exists)
                di.Create();

            //Build the asset bundles
            Debug.Log("Building asset bundles...");
            BuildPipeline.BuildAssetBundles(BuildDir, BuildAssetBundleOptions.ChunkBasedCompression | BuildAssetBundleOptions.ForceRebuildAssetBundle, BuildTarget.StandaloneWindows64);

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
                File.Delete(Path.Combine(BuildDir, ab));

            //Delete useless .manifest files
            foreach (var file in di.GetFiles("*.manifest", SearchOption.AllDirectories))
                file.Delete();

            Debug.Log("Finished building asset bundles.");
        }

        private static string GenerateScript()
        {
            bool wroteScript = false;
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("LoadPlugin(PluginDirectory+\"UnityPlugin.dll\")");

            var di = new DirectoryInfo(BuildDir);
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
            string output = BuildDir + "/output.txt";
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