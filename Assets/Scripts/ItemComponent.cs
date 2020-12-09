using System;
using UnityEngine;

namespace Studio
{
    [ExecuteInEditMode]
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

#if UNITY_EDITOR
        private void Awake()
        {
            SetMaterialsPreview();
        }

        private void OnDestroy()
        {
            SetMaterialsOriginal();
        }

        public void SetMaterialsPreview()
        {
            PreviewShaders.ReplaceShadersPreview(rendNormal);
            PreviewShaders.ReplaceShadersPreview(rendAlpha);
            PreviewShaders.ReplaceShadersPreview(rendGlass);

            SetColors(rendNormal);
            SetColors(rendAlpha);
            SetColors(rendGlass);
        }

        public void SetMaterialsOriginal()
        {
            PreviewShaders.ReplaceShadersOriginal(rendNormal);
            PreviewShaders.ReplaceShadersOriginal(rendAlpha);
            PreviewShaders.ReplaceShadersOriginal(rendGlass);
        }

        private void SetColors(Renderer[] renderers)
        {
            foreach (var rend in renderers)
            {
                foreach (var mat in rend.sharedMaterials)
                {
                    mat.SetColor("_Color", info[0].defColor);
                    mat.SetColor("_Color2", info[1].defColor);
                    mat.SetColor("_Color3", info[2].defColor);
                }
            }
        }
#endif
    }
}
