using System.IO;
using System.Text;
using UnityEditor;
using UnityEngine;

namespace IllusionMods.KoikatuModdingTools
{
    class ItemBoneListCreate
    {
        [MenuItem("Assets/Create/ItemBoneList.csv")]
        internal static void Create()
        {
            string projectPath = Shared.GetProjectPath();
            string searchFolder = projectPath;

            //If inside the list folder search the root directory for prefabs instead of the current
            if (projectPath.Contains(@"List\Studio"))
            {
                string manifestFolder = Shared.GetManifestPath();
                if (!string.IsNullOrEmpty(manifestFolder))
                    searchFolder = manifestFolder;
            }

            var prefabs = AssetDatabase.FindAssets("t:Prefab", new string[] { searchFolder });
            if (prefabs.Length == 0)
            {
                Debug.Log("No prefabs were found.");
                return;
            }

            var sb = new StringBuilder();
            sb.AppendLine("ItemBoneList");
            foreach (var assetguid in prefabs)
            {
                string assetPath = AssetDatabase.GUIDToAssetPath(assetguid);
                var go = AssetDatabase.LoadAssetAtPath<GameObject>(assetPath);
                bool comma = false;

                foreach (var transform in go.GetComponentsInChildren<Transform>())
                {
                    if (comma)
                        sb.Append(",");
                    sb.Append(transform.name);
                    comma = true;
                }
                sb.AppendLine();
            }

            using (StreamWriter file = new StreamWriter(Path.Combine(projectPath, "ItemBoneList_00_00.csv")))
                file.WriteLine(sb.ToString());

            AssetDatabase.Refresh();
        }
    }
}
