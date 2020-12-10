using AssetBundleBrowser.AssetBundleDataSource;
using IllusionMods.KoikatuModdingTools;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using UnityEditor;
using UnityEngine;

namespace AssetBundleBrowser
{
    [System.Serializable]
    internal class AssetBundleBuildTab
    {
        private const string KoikatsuPathDefault = "C:/Illusion/Koikatu";

        [SerializeField]
        private bool m_AdvancedSettings;

        [SerializeField]
        private Vector2 m_ScrollPosition;

        private class ToggleData
        {
            internal ToggleData(bool s,
                string title,
                string tooltip,
                List<string> onToggles,
                BuildAssetBundleOptions opt = BuildAssetBundleOptions.None)
            {
                if (onToggles.Contains(title))
                    state = true;
                else
                    state = s;
                content = new GUIContent(title, tooltip);
                option = opt;
            }
            internal bool state;
            internal GUIContent content;
            internal BuildAssetBundleOptions option;
        }

        private AssetBundleInspectTab m_InspectTab;

        [SerializeField]
        private BuildTabData m_UserData;
        private List<ToggleData> m_ToggleData;
        private ToggleData m_ForceRebuild;
        private GUIContent m_CompressionContent;

        internal enum CompressOptions
        {
            Uncompressed = 0,
            StandardCompression,
            ChunkBasedCompression,
        }

        internal AssetBundleBuildTab()
        {
            m_AdvancedSettings = false;
            m_UserData = new BuildTabData();
            m_UserData.m_OnToggles = new List<string>();
            if (m_UserData.m_KoikatsuPath == null || m_UserData.m_KoikatsuPath == "")
                m_UserData.m_KoikatsuPath = KoikatsuPathDefault;
        }

        internal void OnDisable()
        {
            var dataPath = Path.GetFullPath(".");
            dataPath = dataPath.Replace("\\", "/");
            dataPath += "/Library/AssetBundleBrowserBuild.dat";

            BinaryFormatter bf = new BinaryFormatter();
            FileStream file = File.Create(dataPath);

            bf.Serialize(file, m_UserData);
            file.Close();

        }
        internal void OnEnable(EditorWindow parent)
        {
            m_InspectTab = (parent as AssetBundleBrowserMain).m_InspectTab;

            //LoadData...
            var dataPath = Path.GetFullPath(".");
            dataPath = dataPath.Replace("\\", "/");
            dataPath += "/Library/AssetBundleBrowserBuild.dat";

            if (File.Exists(dataPath))
            {
                BinaryFormatter bf = new BinaryFormatter();
                FileStream file = File.Open(dataPath, FileMode.Open);
                var data = bf.Deserialize(file) as BuildTabData;
                if (data != null)
                    m_UserData = data;
                file.Close();
            }

            m_ToggleData = new List<ToggleData>();
            m_ToggleData.Add(new ToggleData(
                false,
                "Exclude Type Information",
                "Do not include type information within the asset bundle (don't write type tree).",
                m_UserData.m_OnToggles,
                BuildAssetBundleOptions.DisableWriteTypeTree));
            m_ToggleData.Add(new ToggleData(
                false,
                "Force Rebuild",
                "Force rebuild the asset bundles",
                m_UserData.m_OnToggles,
                BuildAssetBundleOptions.ForceRebuildAssetBundle));
            m_ToggleData.Add(new ToggleData(
                false,
                "Ignore Type Tree Changes",
                "Ignore the type tree changes when doing the incremental build check.",
                m_UserData.m_OnToggles,
                BuildAssetBundleOptions.IgnoreTypeTreeChanges));
            m_ToggleData.Add(new ToggleData(
                false,
                "Strict Mode",
                "Do not allow the build to succeed if any errors are reporting during it.",
                m_UserData.m_OnToggles,
                BuildAssetBundleOptions.StrictMode));
            m_ToggleData.Add(new ToggleData(
                false,
                "Dry Run Build",
                "Do a dry run build.",
                m_UserData.m_OnToggles,
                BuildAssetBundleOptions.DryRunBuild));


            m_ForceRebuild = new ToggleData(
                false,
                "Clear Folders",
                "Will wipe out all contents of build directory.",
                m_UserData.m_OnToggles);

            m_CompressionContent = new GUIContent("Compression", "Whether to build asset bundles uncompressed or with LZ4 compression. LZ4 takes longer to build but results in smaller file size with no performance impact. Use this for distributing mods.");
        }

        internal void OnGUI()
        {
            if (m_UserData.m_KoikatsuPath == null || m_UserData.m_KoikatsuPath == "")
                m_UserData.m_KoikatsuPath = KoikatsuPathDefault;

            m_ScrollPosition = EditorGUILayout.BeginScrollView(m_ScrollPosition);
            bool newState = false;
            var centeredStyle = new GUIStyle(GUI.skin.GetStyle("Label"));
            centeredStyle.alignment = TextAnchor.UpperCenter;
            GUILayout.Label(new GUIContent("Asset Bundle And Mod Build Setup"), centeredStyle);
            //basic options
            EditorGUILayout.Space();
            GUILayout.BeginVertical();

            using (new EditorGUI.DisabledScope(!AssetBundleModel.Model.DataSource.CanSpecifyBuildOutputDirectory))
            {
                //Koikatsu path
                GUILayout.BeginHorizontal();
                var newKKPath = EditorGUILayout.TextField("Koikatsu Path", m_UserData.m_KoikatsuPath);
                if (!string.IsNullOrEmpty(newKKPath) && newKKPath != m_UserData.m_KoikatsuPath)
                {
                    m_UserData.m_KoikatsuPath = newKKPath;
                }
                GUILayout.EndHorizontal();
                GUILayout.BeginHorizontal();
                GUILayout.FlexibleSpace();
                if (GUILayout.Button("Browse", GUILayout.MaxWidth(75f)))
                    BrowseForKoikatsuFolder();
                GUILayout.EndHorizontal();
                EditorGUILayout.Space();

                newState = GUILayout.Toggle(
                    m_ForceRebuild.state,
                    m_ForceRebuild.content);
                if (newState != m_ForceRebuild.state)
                {
                    if (newState)
                        m_UserData.m_OnToggles.Add(m_ForceRebuild.content.text);
                    else
                        m_UserData.m_OnToggles.Remove(m_ForceRebuild.content.text);
                    m_ForceRebuild.state = newState;
                }

                bool copyMods = GUILayout.Toggle(
                    m_UserData.m_CopyMods,
                    new GUIContent("Copy Mods", "Copy built zipmods to the Koikatsu mods folder"));
                if (copyMods != m_UserData.m_CopyMods)
                    m_UserData.m_CopyMods = copyMods;
            }

            // advanced options
            using (new EditorGUI.DisabledScope(!AssetBundleModel.Model.DataSource.CanSpecifyBuildOptions))
            {
                EditorGUILayout.Space();
                m_AdvancedSettings = EditorGUILayout.Foldout(m_AdvancedSettings, "Advanced Settings");
                if (m_AdvancedSettings)
                {
                    var indent = EditorGUI.indentLevel;
                    EditorGUI.indentLevel = 1;
                    bool cmp = EditorGUILayout.ToggleLeft(m_CompressionContent, m_UserData.m_Compression);
                    if (cmp != m_UserData.m_Compression)
                        m_UserData.m_Compression = cmp;

                    foreach (var tog in m_ToggleData)
                    {
                        newState = EditorGUILayout.ToggleLeft(tog.content, tog.state);
                        if (newState != tog.state)
                        {
                            if (newState)
                                m_UserData.m_OnToggles.Add(tog.content.text);
                            else
                                m_UserData.m_OnToggles.Remove(tog.content.text);
                            tog.state = newState;
                        }
                    }
                    EditorGUILayout.Space();
                    EditorGUI.indentLevel = indent;
                }
            }

            EditorGUILayout.Space();
            if (GUILayout.Button("Build Asset Bundles"))
            {
                EditorApplication.delayCall += ExecuteBuild;
            }

            if (GUILayout.Button("Build All Zipmods"))
            {
                EditorApplication.delayCall += delegate { Zipmod.BuildAllMods(m_UserData.m_KoikatsuPath, m_UserData.m_CopyMods); };
            }

            if (GUILayout.Button("Build Zipmod (Current Folder)"))
            {
                EditorApplication.delayCall += delegate { Zipmod.BuildSingleMod(m_UserData.m_KoikatsuPath, m_UserData.m_CopyMods); };
            }

            EditorGUILayout.Space();

            if (GUILayout.Button("Build Test Zipmod (Current Folder)"))
            {
                EditorApplication.delayCall += delegate { Zipmod.BuildSingleMod(m_UserData.m_KoikatsuPath, m_UserData.m_CopyMods, true); };
            }

            if (GUILayout.Button("Clean Up Test Zipmod (Current Folder)"))
            {
                EditorApplication.delayCall += delegate { Zipmod.CleanUpTestMod(m_UserData.m_KoikatsuPath); };
            }

            GUILayout.EndVertical();
            EditorGUILayout.EndScrollView();
        }

        private void ExecuteBuild()
        {
            var prebuildTime = System.DateTime.Now;

            if (AssetBundleModel.Model.DataSource.CanSpecifyBuildOutputDirectory)
            {
                if (m_ForceRebuild.state)
                {
                    string message = "Do you want to delete all files in the directory " + Constants.BuildPath + "?";
                    if (EditorUtility.DisplayDialog("File delete confirmation", message, "Yes", "No"))
                    {
                        try
                        {
                            if (Directory.Exists(Constants.BuildPath))
                                Directory.Delete(Constants.BuildPath, true);
                        }
                        catch (System.Exception e)
                        {
                            Debug.LogException(e);
                        }
                    }
                }
                if (!Directory.Exists(Constants.BuildPath))
                    Directory.CreateDirectory(Constants.BuildPath);
            }

            BuildAssetBundleOptions opt = BuildAssetBundleOptions.None;

            if (AssetBundleModel.Model.DataSource.CanSpecifyBuildOptions)
            {
                opt |= BuildAssetBundleOptions.UncompressedAssetBundle;

                foreach (var tog in m_ToggleData)
                {
                    if (tog.state)
                        opt |= tog.option;
                }
            }

            ABBuildInfo buildInfo = new ABBuildInfo();

            buildInfo.outputDirectory = Constants.BuildPath;
            buildInfo.options = opt;
            buildInfo.buildTarget = BuildTarget.StandaloneWindows;
            buildInfo.onBuild = (assetBundleName) =>
            {
                if (m_InspectTab == null)
                    return;
                m_InspectTab.AddBundleFolder(buildInfo.outputDirectory);
                m_InspectTab.RefreshBundles();
            };

            PreviewShaders.SetAllMaterialsOriginal();
            AssetBundleModel.Model.DataSource.BuildAssetBundles(buildInfo);

            DirectoryInfo di = new DirectoryInfo(buildInfo.outputDirectory);
            List<string> changedFiles = di.GetFiles("*.unity3d", SearchOption.AllDirectories).Where(x => x.LastWriteTime >= prebuildTime).Select(x => x.FullName).ToList();

            AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate);

            SB3UScript.BuildAndRunScripts(Constants.BuildPath, m_UserData.m_KoikatsuPath, m_UserData.m_Compression, changedFiles);

            if (changedFiles.Count == 1)
                Debug.Log("Successfully built 1 asset bundle.");
            else
                Debug.Log("Successfully built " + changedFiles.Count + " asset bundles.");
            PreviewShaders.SetAllMaterialsPreview();
        }

        private void BrowseForKoikatsuFolder()
        {
            var newPath = EditorUtility.OpenFolderPanel("Koikatsu Folder", m_UserData.m_KoikatsuPath, string.Empty);
            if (!string.IsNullOrEmpty(newPath))
                m_UserData.m_KoikatsuPath = newPath;
        }

        //Note: this is the provided BuildTarget enum with some entries removed as they are invalid in the dropdown
        internal enum ValidBuildTarget
        {
            //NoTarget = -2,        --doesn't make sense
            //iPhone = -1,          --deprecated
            //BB10 = -1,            --deprecated
            //MetroPlayer = -1,     --deprecated
            StandaloneOSXUniversal = 2,
            StandaloneOSXIntel = 4,
            StandaloneWindows = 5,
            WebPlayer = 6,
            WebPlayerStreamed = 7,
            iOS = 9,
            PS3 = 10,
            XBOX360 = 11,
            Android = 13,
            StandaloneLinux = 17,
            StandaloneWindows64 = 19,
            WebGL = 20,
            WSAPlayer = 21,
            StandaloneLinux64 = 24,
            StandaloneLinuxUniversal = 25,
            WP8Player = 26,
            StandaloneOSXIntel64 = 27,
            BlackBerry = 28,
            Tizen = 29,
            PSP2 = 30,
            PS4 = 31,
            PSM = 32,
            XboxOne = 33,
            SamsungTV = 34,
            N3DS = 35,
            WiiU = 36,
            tvOS = 37,
            Switch = 38
        }

        [System.Serializable]
        internal class BuildTabData
        {
            internal List<string> m_OnToggles;
            internal ValidBuildTarget m_BuildTarget = ValidBuildTarget.StandaloneWindows;
            internal bool m_Compression = true;
            internal string m_KoikatsuPath = KoikatsuPathDefault;
            internal bool m_CopyMods = true;
        }
    }
}