using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

// https://docs.unity3d.com/560/Documentation/ScriptReference/AssetPostprocessor.OnPostprocessModel.html

public class BlenderFBX_Postprocessor : AssetPostprocessor
{
    void OnPostprocessModel(GameObject g)
    {
        SkinnedMeshRenderer[] smrArr = Object.FindObjectsOfType<SkinnedMeshRenderer>();
        string smrInfo = string.Empty;
        foreach (SkinnedMeshRenderer smr in smrArr)
        {
            if (smr.transform.root.gameObject == g)
            {
                HashSet<int> usedBones = GetUsedBones(smr.sharedMesh);
                if (usedBones.Count < smr.bones.Length)
                {
                    Dictionary<int, int> map = new Dictionary<int, int>(usedBones.Count);
                    int[] boneIndices = CreateBoneMapping(usedBones, map);
                    Transform[] newBones = new Transform[boneIndices.Length];
                    Matrix4x4[] newPoses = new Matrix4x4[boneIndices.Length];
                    for (int i = 0; i < boneIndices.Length; i++)
                    {
                        newBones[i] = smr.bones[boneIndices[i]];
                        newPoses[i] = smr.sharedMesh.bindposes[boneIndices[i]];
                    }
                    BoneWeight[] newWeights = new BoneWeight[smr.sharedMesh.vertexCount];
                    for (int i = 0; i < newWeights.Length; i++)
                    {
                        BoneWeight w = smr.sharedMesh.boneWeights[i];
                        BoneWeight newW = new BoneWeight();
                        if (w.weight0 > 0)
                        {
                            newW.boneIndex0 = map[w.boneIndex0];
                            newW.weight0 = w.weight0;
                        }
                        if (w.weight1 > 0)
                        {
                            newW.boneIndex1 = map[w.boneIndex1];
                            newW.weight1 = w.weight1;
                        }
                        if (w.weight2 > 0)
                        {
                            newW.boneIndex2 = map[w.boneIndex2];
                            newW.weight2 = w.weight2;
                        }
                        if (w.weight3 > 0)
                        {
                            newW.boneIndex3 = map[w.boneIndex3];
                            newW.weight3 = w.weight3;
                        }
                        newWeights[i] = newW;
                    }
                    smr.sharedMesh.boneWeights = newWeights;
                    smr.sharedMesh.bindposes = newPoses;
                    smr.bones = newBones;

                    if (smrInfo.Length > 0)
                    {
                        smrInfo += ", ";
                    }
                    smrInfo += smr.name + ": number of bones reduced to " + usedBones.Count;
                }
            }
        }
        if (smrInfo.Length > 0)
        {
            Debug.Log("Imported Root \"" + g.name + "\" SMR Info: " + smrInfo);
        }
    }

    private HashSet<int> GetUsedBones(Mesh mesh)
    {
        HashSet<int> usedBones = new HashSet<int>();
        for (int i = 0; i < mesh.boneWeights.Length; i++)
        {
            BoneWeight w = mesh.boneWeights[i];
            if (w.weight0 > 0)
            {
                usedBones.Add(w.boneIndex0);
            }
            if (w.weight1 > 0)
            {
                usedBones.Add(w.boneIndex1);
            }
            if (w.weight2 > 0)
            {
                usedBones.Add(w.boneIndex2);
            }
            if (w.weight3 > 0)
            {
                usedBones.Add(w.boneIndex3);
            }
        }
        return usedBones;
    }

    private int[] CreateBoneMapping(HashSet<int> usedBones, Dictionary<int, int> map)
    {
        int[] boneIndices = new int[usedBones.Count];
        int i = 0;
        foreach (int b in usedBones)
        {
            map.Add(b, map.Count);
            boneIndices[i++] = b;
        }
        return boneIndices;
    }
}