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
            [Tooltip("Whether to use this color")]
            public bool useColor = true;
            [Tooltip("Default color")]
            public Color defColor = Color.white;
            [Tooltip("Whether to allow pattern texture usage")]
            public bool usePattern = true;
            [Tooltip("Default color of the pattern")]
            public Color defColorPattern = Color.white;
            [Tooltip("Whether the pattern is clamped (does not tile) by default")]
            public bool defClamp = true;
            [Tooltip("Default values which control pattern position and size.\nX: Horizontal position\nY: Vertical position\nZ: Horizontal scale\nW: Vertical scale")]
            public Vector4 defUV = Vector4.zero;
            [Tooltip("Default pattern rotation")]
            public float defRot;
        }

        [Header("Normal Parts")]
        [Tooltip("All renderers of the object")]
        public Renderer[] rendNormal;

        [Header("Transparent Parts")]
        [Tooltip("Renderers affected by the alpha slider")]
        public Renderer[] rendAlpha;

        [Header("Glass Parts")]
        [Tooltip("Glass renderers which have their own color picker")]
        public Renderer[] rendGlass;

        [Header("Configuration Info")]
        [Tooltip("Array of information about the colors, must contain exactly 3 elements")]
        public Info[] info;
        [Tooltip("Default shadow color")]
        public Color defShadow = Color.white;
        [Tooltip("Default value of the alpha slider")]
        public float alpha = 1f;
        [Tooltip("Default color of the glass renderers")]
        public Color defGlass = Color.white;
        [Tooltip("Default line color")]
        public Color defLineColor = Color.white;
        [Tooltip("Default line width")]
        public float defLineWidth = 1f;
        [Tooltip("Default emission color")]
        public Color defEmissionColor = Color.white;
        [Tooltip("Default emission power")]
        public float defEmissionPower;
        [Tooltip("Default light cancel")]
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
