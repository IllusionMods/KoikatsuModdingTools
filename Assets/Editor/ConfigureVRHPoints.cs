using UnityEditor;
using UnityEngine;

namespace IllusionMods.KoikatuModdingTools
{
    class ConfigureVRHPoints
    {
        [MenuItem("Assets/Configure VR HPoints")]
        internal static void CreateBoneList()
        {
            string manifestFolder = Shared.GetManifestPath();

            if (string.IsNullOrEmpty(manifestFolder))
            {
                Debug.LogError("Could not locate manifest.xml.");
                return;
            }

            var prefabs = AssetDatabase.FindAssets("t:Prefab", new string[] { manifestFolder });
            if (prefabs.Length == 0)
            {
                Debug.Log("No prefabs were found.");
                return;
            }

            int configCount = 0;
            //Find the bones for each prefab and at them to the list
            foreach (var assetguid in prefabs)
            {
                string assetPath = AssetDatabase.GUIDToAssetPath(assetguid);
                if (assetPath.Contains("/VRPoint/HPoint"))
                {
                    configCount++;
                    var go = AssetDatabase.LoadAssetAtPath<GameObject>(assetPath);

                    foreach (var hPoint in go.GetComponentsInChildren<H.HPointData>())
                    {
                        //Add and configure the VRPoint
                        VRPoint vrPoint = hPoint.gameObject.GetOrAddComponent<VRPoint>();
                        vrPoint.disableWhenIdle = false;
                        vrPoint.holdButtonToGrab = false;
                        vrPoint.stayGrabbedOnTeleport = false;
                        vrPoint.isUsable = true;
                        vrPoint.pointerActivatesUseAction = true;

                        foreach (var child in hPoint.GetComponentsInChildren<Transform>())
                        {
                            if (child.GetComponent<CapsuleCollider>() != null)
                            {
                                //Add and configure the Rigidbody
                                Rigidbody rigidbody = child.gameObject.GetOrAddComponent<Rigidbody>();
                                rigidbody.useGravity = false;
                                rigidbody.isKinematic = true;

                                //Add and configure the VRPoint
                                VRPoint childVRPoint = child.gameObject.GetOrAddComponent<VRPoint>();
                                childVRPoint.disableWhenIdle = false;
                                childVRPoint.holdButtonToGrab = false;
                                childVRPoint.stayGrabbedOnTeleport = true;
                                childVRPoint.isUsable = true;
                                childVRPoint.pointerActivatesUseAction = true;
                            }
                        }
                    }
                }
            }

            if (configCount == 0)
                Debug.Log("No prefabs were found in the VRPoint folder. To use this script, create HPoints prefabs for the map, create a folder named VRPoint in the same directory as the manifest.xml, and copy the HPoint prefabs. Run this script to configure the copies then assigned them to an asset bundle in the vr/common/ folder.");
            else
                Debug.Log("Configured " + configCount + " HPoint prefabs.");

            AssetDatabase.Refresh();
        }
    }
}
