#if UNITY_EDITOR

using H;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public static class GizmosHelper
{
    const float AXIS_SIZE = 0.3f;

    private static readonly Vector3 offset = new Vector3(0, 1.145f, 0);
    private static readonly Color characterGizmoColor = Color.white;
    private static readonly float hpdSafeSize = 1f;
    private static readonly Vector3 hpdCubeSize = new Vector3(0.3f, 1f, 0.3f);
    private static readonly Vector3 hpdCubeOffset = new Vector3(0, hpdCubeSize.y / 2f, 0);

    private enum HPointGizmoType { F1, F1M, F2, F2M }

    private static readonly Dictionary<int, HPointGizmoType> HPointGizmoInfo = new Dictionary<int, HPointGizmoType>()
    {
        //HPoint
        { 0, HPointGizmoType.F1 }, //Floor
        { 1, HPointGizmoType.F1 }, //Stand
        { 2, HPointGizmoType.F1 }, //Chair
        { 3, HPointGizmoType.F1 }, //Backless Chair
        { 4, HPointGizmoType.F1 }, //Couch
        { 5, HPointGizmoType.F1 }, //Backless Couch
        { 6, HPointGizmoType.F1M }, //Class Desk
        { 7, HPointGizmoType.F1M }, //Desk
        { 8, HPointGizmoType.F1M }, //Wall
        { 9, HPointGizmoType.F1 }, //Pool
        { 12, HPointGizmoType.F1M }, //Bench Blowjob
        { 1002, HPointGizmoType.F1 }, //Bookshelf Caress
        { 1003, HPointGizmoType.F1 }, //Mischeivous Caress
        { 1004, HPointGizmoType.F1M }, //Pool Paizuri
        { 1005, HPointGizmoType.F1M }, //Pool Behind
        { 1200, HPointGizmoType.F1M }, //Chair Straddling Fellatio

        //HPoint_Add
        { 1010, HPointGizmoType.F1 }, //Corner Masturbation
        { 1011, HPointGizmoType.F1 }, //Chair Masturbation
        { 1012, HPointGizmoType.F1 }, //Standing Masturbation
        { 1013, HPointGizmoType.F1 }, //Hurdle Masturbation

        { 1100, HPointGizmoType.F2 }, //Tribbing
        { 1101, HPointGizmoType.F2 }, //Chair Cunnilingus
        { 1102, HPointGizmoType.F2 }, //Mutual Groping

        //HPoint_3P
        { 3000, HPointGizmoType.F2M }, //3P
    };

    public static void HPoint(HPointData hpointData)
    {
        var t = hpointData.transform;
        var pos = t.position + hpointData._offsetPos;
        var rot = Quaternion.Euler(t.rotation.eulerAngles + hpointData._offsetAngle);

        Gizmos.matrix = Matrix4x4.TRS(pos, rot, t.lossyScale);

        if (hpointData._categorys.Length != 0)
        {
            int category = hpointData._categorys[0];

            HPointGizmoType gizmoType;
            if (HPointGizmoInfo.TryGetValue(category, out gizmoType))
            {
                switch (gizmoType)
                {
                    case HPointGizmoType.F1:
                        DrawFemale1(category);
                        break;
                    case HPointGizmoType.F1M:
                        DrawFemale1(category);
                        DrawMale(category);
                        break;
                    case HPointGizmoType.F2:
                        DrawFemale1(category);
                        DrawFemale2(category);
                        break;
                    case HPointGizmoType.F2M:
                        DrawFemale1(category);
                        DrawFemale2(category);
                        DrawMale(category);
                        break;
                }
            }
            else
            {
                Gizmos.DrawWireSphere(Vector3.zero, hpdSafeSize);
                Gizmos.color = Color.yellow;
                Gizmos.DrawCube(hpdCubeOffset, hpdCubeSize);
            }
            DrawAxis();
        }

        Gizmos.matrix = Matrix4x4.identity;
        Gizmos.color = Color.white;
    }

    private static void DrawFemale1(int category)
    {
        Mesh mesh = (Mesh)AssetDatabase.LoadAssetAtPath("Assets/Gizmos/hpoint_" + category + "_f.obj", typeof(Mesh));
        if (mesh != null)
        {
            Gizmos.color = characterGizmoColor;
            Gizmos.DrawWireMesh(mesh, offset);
        }
    }

    private static void DrawFemale2(int category)
    {
        Mesh mesh = (Mesh)AssetDatabase.LoadAssetAtPath("Assets/Gizmos/hpoint_" + category + "_f2.obj", typeof(Mesh));
        if (mesh != null)
        {
            Gizmos.color = characterGizmoColor;
            Gizmos.DrawWireMesh(mesh, offset);
        }
    }

    private static void DrawMale(int category)
    {
        Mesh mesh = (Mesh)AssetDatabase.LoadAssetAtPath("Assets/Gizmos/hpoint_" + category + "_m.obj", typeof(Mesh));
        if (mesh != null)
        {
            Gizmos.color = characterGizmoColor;
            Gizmos.DrawWireMesh(mesh, offset);
        }
    }

    private static void DrawAxis()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(Vector3.zero, Vector3.right * AXIS_SIZE);
        Gizmos.color = Color.green;
        Gizmos.DrawLine(Vector3.zero, Vector3.up * AXIS_SIZE);
        Gizmos.color = Color.blue;
        Gizmos.DrawLine(Vector3.zero, Vector3.forward * AXIS_SIZE);
    }

    public static void DrawAxis(Transform t)
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(t.position, t.position + t.right * AXIS_SIZE);
        Gizmos.color = Color.green;
        Gizmos.DrawLine(t.position, t.position + t.up * AXIS_SIZE);
        Gizmos.color = Color.blue;
        Gizmos.DrawLine(t.position, t.position + t.forward * AXIS_SIZE);
    }
}

#endif