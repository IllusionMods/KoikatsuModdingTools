using System;
using System.Linq;
using UnityEngine;

namespace Studio
{
    public class ItemComponent : MonoBehaviour
    {
        [Serializable]
        public class Info
        {
            public bool useColor = true;
            public Color defColor = Color.white;
            public bool usePattern = true;
            public Color defColorPattern = Color.white;
            public bool defClamp = true;
            public Vector4 defUV = Vector4.zero;
            public float defRot;

            public float ut
            {
                get
                {
                    return defUV.x;
                }
                set
                {
                    defUV.x = value;
                }
            }

            public float vt
            {
                get
                {
                    return defUV.y;
                }
                set
                {
                    defUV.y = value;
                }
            }

            public float us
            {
                get
                {
                    return defUV.z;
                }
                set
                {
                    defUV.z = value;
                }
            }

            public float vs
            {
                get
                {
                    return defUV.w;
                }
                set
                {
                    defUV.w = value;
                }
            }
        }

        [Header("Normal Parts")]
        public Renderer[] rendNormal;

        [Header("Transparent Parts")]
        public Renderer[] rendAlpha;

        [Header("Glass Parts")]
        public Renderer[] rendGlass;

        [Header("Configuration Info")]
        [Space]
        public Info[] info;
        public Color defShadow = Color.white;
        public float alpha = 1f;
        public Color defGlass = Color.white;
        public Color defLineColor = Color.white;
        public float defLineWidth = 1f;
        public Color defEmissionColor = Color.white;
        public float defEmissionPower;
        public float defLightCancel;

        [Space]
        public int setcolor;
    }
}
