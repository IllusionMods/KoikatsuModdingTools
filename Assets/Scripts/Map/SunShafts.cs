using UnityEngine;
using UnityStandardAssets.ImageEffects;

// Token: 0x02000574 RID: 1396
[ExecuteInEditMode]
    [RequireComponent(typeof(Camera))]
    [AddComponentMenu("Image Effects/Rendering/Sun Shafts")]
    public class SunShafts : PostEffectsBase
    {
        // Token: 0x06001A3D RID: 6717 RVA: 0x00076758 File Offset: 0x00074B58
        public override bool CheckResources()
        {
            base.CheckSupport(this.useDepthTexture);
            this.sunShaftsMaterial = base.CheckShaderAndCreateMaterial(this.sunShaftsShader, this.sunShaftsMaterial);
            this.simpleClearMaterial = base.CheckShaderAndCreateMaterial(this.simpleClearShader, this.simpleClearMaterial);
            if (!this.isSupported)
            {
                base.ReportAutoDisable();
            }
            return this.isSupported;
        }

        // Token: 0x06001A3E RID: 6718 RVA: 0x000767BC File Offset: 0x00074BBC
        private void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (!this.CheckResources())
            {
                Graphics.Blit(source, destination);
                return;
            }
            if (this.useDepthTexture)
            {
                base.GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;
            }
            int num = 4;
            if (this.resolution == SunShafts.SunShaftsResolution.Normal)
            {
                num = 2;
            }
            else if (this.resolution == SunShafts.SunShaftsResolution.High)
            {
                num = 1;
            }
            Vector3 vector = Vector3.one * 0.5f;
            if (this.sunTransform)
            {
                vector = base.GetComponent<Camera>().WorldToViewportPoint(this.sunTransform.position);
            }
            else
            {
                vector = new Vector3(0.5f, 0.5f, 0f);
            }
            int width = source.width / num;
            int height = source.height / num;
            RenderTexture temporary = RenderTexture.GetTemporary(width, height, 0);
            this.sunShaftsMaterial.SetVector("_BlurRadius4", new Vector4(1f, 1f, 0f, 0f) * this.sunShaftBlurRadius);
            this.sunShaftsMaterial.SetVector("_SunPosition", new Vector4(vector.x, vector.y, vector.z, this.maxRadius));
            this.sunShaftsMaterial.SetVector("_SunThreshold", this.sunThreshold);
            if (!this.useDepthTexture)
            {
                RenderTextureFormat format = (!base.GetComponent<Camera>().allowHDR) ? RenderTextureFormat.Default : RenderTextureFormat.DefaultHDR;
                RenderTexture temporary2 = RenderTexture.GetTemporary(source.width, source.height, 0, format);
                RenderTexture.active = temporary2;
                GL.ClearWithSkybox(false, base.GetComponent<Camera>());
                this.sunShaftsMaterial.SetTexture("_Skybox", temporary2);
                Graphics.Blit(source, temporary, this.sunShaftsMaterial, 3);
                RenderTexture.ReleaseTemporary(temporary2);
            }
            else
            {
                Graphics.Blit(source, temporary, this.sunShaftsMaterial, 2);
            }
            base.DrawBorder(temporary, this.simpleClearMaterial);
            this.radialBlurIterations = Mathf.Clamp(this.radialBlurIterations, 1, 4);
            float num2 = this.sunShaftBlurRadius * 0.00130208337f;
            this.sunShaftsMaterial.SetVector("_BlurRadius4", new Vector4(num2, num2, 0f, 0f));
            this.sunShaftsMaterial.SetVector("_SunPosition", new Vector4(vector.x, vector.y, vector.z, this.maxRadius));
            for (int i = 0; i < this.radialBlurIterations; i++)
            {
                RenderTexture temporary3 = RenderTexture.GetTemporary(width, height, 0);
                Graphics.Blit(temporary, temporary3, this.sunShaftsMaterial, 1);
                RenderTexture.ReleaseTemporary(temporary);
                num2 = this.sunShaftBlurRadius * (((float)i * 2f + 1f) * 6f) / 768f;
                this.sunShaftsMaterial.SetVector("_BlurRadius4", new Vector4(num2, num2, 0f, 0f));
                temporary = RenderTexture.GetTemporary(width, height, 0);
                Graphics.Blit(temporary3, temporary, this.sunShaftsMaterial, 1);
                RenderTexture.ReleaseTemporary(temporary3);
                num2 = this.sunShaftBlurRadius * (((float)i * 2f + 2f) * 6f) / 768f;
                this.sunShaftsMaterial.SetVector("_BlurRadius4", new Vector4(num2, num2, 0f, 0f));
            }
            if (vector.z >= 0f)
            {
                this.sunShaftsMaterial.SetVector("_SunColor", new Vector4(this.sunColor.r, this.sunColor.g, this.sunColor.b, this.sunColor.a) * this.sunShaftIntensity);
            }
            else
            {
                this.sunShaftsMaterial.SetVector("_SunColor", Vector4.zero);
            }
            this.sunShaftsMaterial.SetTexture("_ColorBuffer", temporary);
            Graphics.Blit(source, destination, this.sunShaftsMaterial, (this.screenBlendMode != SunShafts.ShaftsScreenBlendMode.Screen) ? 4 : 0);
            RenderTexture.ReleaseTemporary(temporary);
        }

        // Token: 0x04001347 RID: 4935
        public SunShafts.SunShaftsResolution resolution = SunShafts.SunShaftsResolution.Normal;

        // Token: 0x04001348 RID: 4936
        public SunShafts.ShaftsScreenBlendMode screenBlendMode;

        // Token: 0x04001349 RID: 4937
        public Transform sunTransform;

        // Token: 0x0400134A RID: 4938
        public int radialBlurIterations = 2;

        // Token: 0x0400134B RID: 4939
        public Color sunColor = Color.white;

        // Token: 0x0400134C RID: 4940
        public Color sunThreshold = new Color(0.87f, 0.74f, 0.65f);

        // Token: 0x0400134D RID: 4941
        public float sunShaftBlurRadius = 2.5f;

        // Token: 0x0400134E RID: 4942
        public float sunShaftIntensity = 1.15f;

        // Token: 0x0400134F RID: 4943
        public float maxRadius = 0.75f;

        // Token: 0x04001350 RID: 4944
        public bool useDepthTexture = true;

        // Token: 0x04001351 RID: 4945
        public Shader sunShaftsShader;

        // Token: 0x04001352 RID: 4946
        private Material sunShaftsMaterial;

        // Token: 0x04001353 RID: 4947
        public Shader simpleClearShader;

        // Token: 0x04001354 RID: 4948
        private Material simpleClearMaterial;

        // Token: 0x02000575 RID: 1397
        public enum SunShaftsResolution
        {
            // Token: 0x04001356 RID: 4950
            Low,
            // Token: 0x04001357 RID: 4951
            Normal,
            // Token: 0x04001358 RID: 4952
            High
        }

        // Token: 0x02000576 RID: 1398
        public enum ShaftsScreenBlendMode
        {
            // Token: 0x0400135A RID: 4954
            Screen,
            // Token: 0x0400135B RID: 4955
            Add
        }
    }
