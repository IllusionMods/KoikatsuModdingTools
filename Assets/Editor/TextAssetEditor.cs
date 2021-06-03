using UnityEditor;
using UnityEngine;

namespace IllusionMods.KoikatuModdingTools
{
    //Only one CustomEditor is allowed per asset type, this is the base class for a TextAsset editor and dispatches method calls to the appropriate class based on file type
    [CustomEditor(typeof(TextAsset))]
    public class TextAssetEditor : Editor
    {
        private TextAssetType AssetType;

        internal void OnEnable()
        {
            string path = AssetDatabase.GetAssetPath(target);
            if (path.EndsWith("manifest.xml"))
            {
                AssetType = TextAssetType.Manifest;
                ManifestEditor.OnEnable(path);
            }
            else if (path.ToLower().Contains("list/maker/") && path.ToLower().EndsWith(".csv"))
            {
                AssetType = TextAssetType.MakerListFile;
                //MakerListfileEditor.OnEnable(path, this);
            }
            else
                AssetType = TextAssetType.Other;
        }

        public override void OnInspectorGUI()
        {
            if (AssetType == TextAssetType.Manifest)
                ManifestEditor.OnInspectorGUI();
            //else if (AssetType == TextAssetType.MakerListFile)
            //    MakerListfileEditor.OnInspectorGUI();
            base.OnInspectorGUI();
        }

        private enum TextAssetType { Manifest, MakerListFile, Other }
    }
}
