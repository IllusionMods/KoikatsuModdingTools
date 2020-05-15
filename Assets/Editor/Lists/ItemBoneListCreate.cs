using IllusionMods.KoikatuModdingTools.Lists;
using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;

namespace IllusionMods.KoikatuModdingTools
{
    class ItemBoneListCreate
    {
        [MenuItem("Assets/Create/ItemBoneList.csv (SMR only)")]
        internal static void CreateBoneList()
        {
            Create(true);
        }
        [MenuItem("Assets/Create/ItemBoneList.csv (all transforms)")]
        internal static void CreateBoneListTransform()
        {
            Create(false);
        }

        internal static void Create(bool smrOnly = true)
        {
            string projectPath = Shared.GetProjectPath();
            string manifestFolder = Shared.GetManifestPath();
            List<StudioItemListFile> ItemListFiles = new List<StudioItemListFile>();

            //If inside the list folder search the root directory for prefabs instead of the current
            if (!projectPath.Contains(@"List\Studio"))
            {
                Debug.LogError(@"ItemBoneLists can only be generated from within the List\Studio folder.");
                return;
            }

            if (string.IsNullOrEmpty(manifestFolder))
            {
                Debug.LogError("Could not locate manifest.xml.");
                return;
            }

            foreach (var assetguid in AssetDatabase.FindAssets("t:TextAsset", new string[] { projectPath }))
            {
                string assetPath = AssetDatabase.GUIDToAssetPath(assetguid);
                FileInfo file = new FileInfo(assetPath);

                //Read the ItemLists
                if (file.Name.StartsWith("ItemList_"))
                    ItemListFiles.Add(new StudioItemListFile(file));
            }

            if (ItemListFiles.Count == 0)
            {
                Debug.LogError("Could not locate any ItemList files.");
                return;
            }

            var prefabs = AssetDatabase.FindAssets("t:Prefab", new string[] { manifestFolder });
            if (prefabs.Length == 0)
            {
                Debug.Log("No prefabs were found.");
                return;
            }

            //Find the bones for each prefab and at them to the list
            foreach (var assetguid in prefabs)
            {
                string assetPath = AssetDatabase.GUIDToAssetPath(assetguid);
                var go = AssetDatabase.LoadAssetAtPath<GameObject>(assetPath);

                StudioItemListData itemListInfo = null;

                foreach (var itemListFile in ItemListFiles)
                {
                    foreach (var itemList in itemListFile.Lines)
                    {
                        if (itemList.Value.FileName == go.name)
                        {
                            itemListInfo = itemList.Value;
                            goto ExitLoop;
                        }
                    }
                }
            ExitLoop:

                if (itemListInfo == null) continue;
                List<string> bones = new List<string>();
                List<string> transforms = new List<string>();

                foreach (var renderer in go.GetComponentsInChildren<SkinnedMeshRenderer>())
                    foreach (var transform in renderer.bones)
                        if (!bones.Contains(transform.name))
                            bones.Add(transform.name);
                itemListInfo.BoneList = bones;

                foreach (var transform in go.GetComponentsInChildren<Transform>())
                    if (transform.name != go.name && !transforms.Contains(transform.name))
                        transforms.Add(transform.name);
                itemListInfo.TransformList = transforms;
            }

            foreach (var itemListFile in ItemListFiles)
                itemListFile.WriteBoneList(projectPath, smrOnly);

            AssetDatabase.Refresh();
        }
    }
}
