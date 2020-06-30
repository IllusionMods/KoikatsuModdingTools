#if UNITY_EDITOR

using H;
using UnityEngine;

namespace Assets.Map.Editor
{
    public class VisualiseGizmos : MonoBehaviour
    {
        public Transform HPoint_Container;

        void OnDrawGizmos()
        {
            var spawn = transform.Find("h_free");
            if (spawn)
            {
                Gizmos.DrawIcon(spawn.position + Vector3.up * 0.5f, "h_free");
                GizmosHelper.DrawAxis(spawn);
            }

            if (HPoint_Container)
            {
                foreach (var hpd in HPoint_Container.GetComponentsInChildren<HPointData>())
                {
                    GizmosHelper.HPoint(hpd);
                }
            }
        }
    }
}

#endif
