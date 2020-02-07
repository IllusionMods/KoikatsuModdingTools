using System.IO;
using System.Text;
using UnityEditor;
using UnityEngine;

namespace IllusionMods.KoikatuModdingTools
{
    class BonelistCreate
    {
        [MenuItem("Assets/Create/Bonelist")]
        internal static void Create()
        {
            string projectPath = Shared.GetProjectPath();
            var sb = new StringBuilder();

            var prefabs = AssetDatabase.FindAssets("t:Prefab", new string[] { projectPath });
            if (prefabs.Length == 0)
            {
                Debug.Log("No prefabs were were found.");
                return;
            }

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

            using (StreamWriter file = new StreamWriter(Path.Combine(projectPath, "Bonelist.csv")))
                file.WriteLine(sb.ToString());

            AssetDatabase.Refresh();
        }
    }
}
