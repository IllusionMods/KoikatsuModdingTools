using UnityEngine;

[ExecuteInEditMode]
public class ChaAccessoryComponent : MonoBehaviour
{
    [Header("Normal Parts")]
    [Tooltip("Renderers affected by the main three color pickers")]
    public Renderer[] rendNormal;
    [Tooltip("Whether to show the first color picker")]
    public bool useColor01;
    [Tooltip("Default color")]
    public Color defColor01 = Color.white;
    [Tooltip("Whether to show the second color picker")]
    public bool useColor02;
    [Tooltip("Default color")]
    public Color defColor02 = Color.white;
    [Tooltip("Whether to show the third color picker")]
    public bool useColor03;
    [Tooltip("Default color")]
    public Color defColor03 = Color.white;
    [Header("Transparent Parts")]
    [Tooltip("Renderers affected by the fourth color picker which allows for transparency")]
    public Renderer[] rendAlpha;
    [Tooltip("Default color of the transparent parts")]
    public Color defColor04 = Color.white;
    [Header("Hair Parts")]
    [Tooltip("Renderers which will automatically match the primary hair color")]
    public Renderer[] rendHair;

    [HideInInspector]
    public bool noOutline;
    [HideInInspector]
    public int initialize;
    [HideInInspector]
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
