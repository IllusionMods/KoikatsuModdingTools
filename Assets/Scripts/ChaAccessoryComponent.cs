using UnityEngine;

[ExecuteInEditMode]
public class ChaAccessoryComponent : MonoBehaviour
{
    [Header("Normal Parts")]
    public Renderer[] rendNormal;
    public bool useColor01;
    public Color defColor01 = Color.white;
    public bool useColor02;
    public Color defColor02 = Color.white;
    public bool useColor03;
    public Color defColor03 = Color.white;
    [Header("Transparent Parts")]
    public Renderer[] rendAlpha;
    public Color defColor04 = Color.white;
    [Header("Hair Parts")]
    public Renderer[] rendHair;
    public bool noOutline;
    public int initialize;
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
        //Better handled by the ChaCustomHairComponent
        if (gameObject.GetComponent<ChaCustomHairComponent>())
            return;

        PreviewShaders.ReplaceShadersPreview(rendNormal);
        PreviewShaders.ReplaceShadersPreview(rendAlpha);
        PreviewShaders.ReplaceShadersPreview(rendHair);

        SetColors(rendNormal);
        SetColors(rendAlpha);
        SetColors(rendHair);
    }

    public void SetMaterialsOriginal()
    {
        PreviewShaders.ReplaceShadersOriginal(rendNormal);
        PreviewShaders.ReplaceShadersOriginal(rendAlpha);
        PreviewShaders.ReplaceShadersOriginal(rendHair);
    }

    private void SetColors(Renderer[] renderers)
    {
        foreach (var rend in renderers)
        {
            foreach (var mat in rend.sharedMaterials)
            {
                mat.SetColor("_Color", defColor01);
                mat.SetColor("_Color2", defColor02);
                mat.SetColor("_Color3", defColor03);
                mat.SetColor("_Color4", defColor04);
            }
        }
    }
#endif
}
