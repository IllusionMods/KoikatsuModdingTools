#if UNITY_EDITOR

using H;
using UnityEngine;

public static class GizmosHelper
{
    const float AXIS_SIZE = 0.3f;

    public static void Axis(Transform t)
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(t.position, t.position + t.right * AXIS_SIZE);
        Gizmos.color = Color.green;
        Gizmos.DrawLine(t.position, t.position + t.up * AXIS_SIZE);
        Gizmos.color = Color.blue;
        Gizmos.DrawLine(t.position, t.position + t.forward * AXIS_SIZE);
    }

    public static void Axis()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawLine(Vector3.zero, Vector3.right * AXIS_SIZE);
        Gizmos.color = Color.green;
        Gizmos.DrawLine(Vector3.zero, Vector3.up * AXIS_SIZE);
        Gizmos.color = Color.blue;
        Gizmos.DrawLine(Vector3.zero, Vector3.forward * AXIS_SIZE);
    }

    private static readonly float hpdSafeSize = 1f;
    private static readonly Vector3 hpdCubeSize = new Vector3(0.3f, 1f, 0.3f);
    private static readonly Vector3 hpdCubeOffset = new Vector3(0, hpdCubeSize.y/2f, 0);

    private static readonly Vector3 hpdWallSize = new Vector3(1.2f, 1.6f, 0.03f);
    private static readonly Vector3 hpdWallOffset = new Vector3(0, hpdWallSize.y / 2f, hpdWallSize.z);
    private static readonly Color hpdWallColor = new Color(0, 1f, 0, 0.3f);

    private static readonly Vector3 hpdDeskSize = new Vector3(1f, 0.65f, 0.8f);
    private static readonly Vector3 hpdDeskOffset = new Vector3(0, hpdDeskSize.y / 2f, 0);
    private static readonly Vector3 hpdDeskSafeSize = new Vector3(1f, 1.2f, 0.5f);
    private static readonly Vector3 hpdDeskSafeOffset = new Vector3(0, hpdDeskSafeSize.y / 2f, hpdDeskSize.z/2f + hpdDeskSafeSize.z/2f);

    public static readonly string[] HPOS_GIZMO_MAP = new [] {
        "hpos_floor",
        "hpos_stand",
        "hpos_chair",
        "hpos_backlesschair",
        "hpos_couch",
        "",
        "hpos_classdesk",
        "hpos_desk",
        "hpos_wall",
        "hpos_pool",
        "",
        "",
    };

    public static void HPoint(HPointData hpd)
    {
        var t = hpd.transform;

        var pos = t.position + hpd._offsetPos;
        var rot = Quaternion.Euler(t.rotation.eulerAngles + hpd._offsetAngle);

        Gizmos.matrix = Matrix4x4.TRS(pos, rot, t.lossyScale);

        var hpointData = hpd.GetComponent<HPointData>();
        if (hpointData._categorys.Length != 0)
        {
            Gizmos.color = Color.white;
            switch (hpointData._categorys[0])
            {
                case 0:
                    Gizmos.DrawWireSphere(Vector3.zero, hpdSafeSize);
                    Gizmos.DrawIcon(pos + Vector3.up * 0.5f, "hpos_floor");
                    Axis();
                    break;
                case 1:
                    Gizmos.DrawWireSphere(Vector3.zero, hpdSafeSize);
                    Gizmos.DrawIcon(pos + Vector3.up * 0.5f, "hpos_stand");
                    Axis();
                    break;
                case 2:
                    Gizmos.DrawWireSphere(Vector3.zero, hpdSafeSize);
                    Gizmos.DrawIcon(pos + Vector3.up * 0.5f, "hpos_chair");
                    Axis();
                    break;
                case 3:
                    Gizmos.DrawWireSphere(Vector3.zero, hpdSafeSize);
                    Gizmos.DrawIcon(pos + Vector3.up * 0.5f, "hpos_backlesschair");
                    Axis();
                    break;
                case 4:
                    Gizmos.DrawWireSphere(Vector3.zero, hpdSafeSize);
                    Gizmos.DrawIcon(pos + Vector3.up * 0.5f, "hpos_couch");
                    Axis();
                    break;
                case 5:
                    Gizmos.DrawWireSphere(Vector3.zero, hpdSafeSize);
                    Gizmos.DrawIcon(pos + Vector3.up * 0.5f, "hpos_backless_couch");
                    Axis();
                    break;
                case 6:
                    Gizmos.DrawIcon(pos + Vector3.up * 0.5f, "hpos_classdesk");
                    Gizmos.DrawWireCube(hpdDeskOffset, hpdDeskSize);
                    Gizmos.DrawWireCube(hpdDeskSafeOffset, hpdDeskSafeSize);
                    Axis();
                    break;
                case 7:
                    Gizmos.DrawIcon(pos + Vector3.up * 0.5f, "hpos_desk");
                    Gizmos.DrawWireCube(hpdDeskOffset, hpdDeskSize);
                    Gizmos.DrawWireCube(hpdDeskSafeOffset, hpdDeskSafeSize);
                    Axis();
                    break;
                case 8:
                    Gizmos.DrawIcon(pos + Vector3.up * 0.5f, "hpos_wall");
                    Gizmos.color = hpdWallColor;
                    Gizmos.DrawCube(hpdWallOffset, hpdWallSize);
                    Axis();
                    break;
                case 9:
                    Gizmos.DrawWireSphere(Vector3.zero, hpdSafeSize);
                    Gizmos.DrawIcon(pos + Vector3.up * 0.5f, "hpos_pool");
                    Axis();
                    break;
                default:
                    Gizmos.DrawWireSphere(Vector3.zero, hpdSafeSize);
                    Gizmos.color = Color.yellow;
                    Gizmos.DrawCube(hpdCubeOffset, hpdCubeSize);
                    Axis();
                    break;
            }
        }


        Gizmos.matrix = Matrix4x4.identity;
        Gizmos.color = Color.white;
    }
}

#endif