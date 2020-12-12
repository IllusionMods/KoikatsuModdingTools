using System;
using System.Linq;
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
        public Info[] info;
        public Color defShadow = Color.white;
        public float alpha = 1f;
        public Color defGlass = Color.white;
        public Color defLineColor = Color.white;
        public float defLineWidth = 1f;
        public Color defEmissionColor = Color.white;
        public float defEmissionPower;
        public float defLightCancel;

        [HideInInspector]
        public int setcolor;

#if UNITY_EDITOR
        private void Awake()
        {
            VerifyInfo();
            SetMaterialsPreview();
        }

        private void OnDestroy()
        {
            SetMaterialsOriginal();
        }

        private void OnValidate()
        {
            VerifyInfo();
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

        /// <summary>
        /// Verify that the Info array has exactly three elements
        /// </summary>
        public void VerifyInfo()
        {
            if (info == null)
            {
                var newInfo = new Info[3];
                for (int i = 0; i < 3; i++)
                {
                    newInfo[i] = new Info();
                    newInfo[i].useColor = false;
                }

                info = newInfo;
            }
            else if (info.Length != 3)
            {
                var newInfo = new Info[3];

                //Copy existing data, if present
                if (info.Length >= 1)
                    newInfo[0] = info[0];
                if (info.Length >= 2)
                    newInfo[1] = info[1];
                if (info.Length >= 3)
                    newInfo[2] = info[2];

                for (int i = 0; i < 3; i++)
                    if (newInfo[i] == null)
                    {
                        newInfo[i] = new Info();
                        newInfo[i].useColor = false;
                    }

                info = newInfo;
            }
        }

        /// <summary>
        /// Add all renderers to the rendNormal array
        /// </summary>
        public void PopulateRendNormalArray()
        {
            rendNormal = gameObject.GetComponentsInChildren<Renderer>().ToArray();
            SetMaterialsPreview();
        }

        private void SetColors(Renderer[] renderers)
        {
            if (renderers == null)
                return;

            foreach (var rend in renderers)
            {
                foreach (var mat in rend.sharedMaterials)
                {
                    if (info[0].useColor)
                        mat.SetColor("_Color", info[0].defColor);
                    if (info[1].useColor)
                        mat.SetColor("_Color2", info[1].defColor);
                    if (info[2].useColor)
                        mat.SetColor("_Color3", info[2].defColor);
                }
            }
        }
#endif
    }
}
