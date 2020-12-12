using UnityEngine;

[ExecuteInEditMode]
public class ChaClothesComponent : MonoBehaviour
{
    [Header("Normal Parts")]
    [Tooltip("Renderers affected by the first set of MainTex and ColorMask textures configured in the list file")]
    public Renderer[] rendNormal01;
    [Tooltip("Renderers affected by the second set of MainTex and ColorMask textures configured in the list file")]
    public Renderer[] rendNormal02;
    [Tooltip("Renderers affected by the third set of MainTex and ColorMask textures configured in the list file")]
    public Renderer[] rendNormal03;

    [Tooltip("Whether to show the first color picker")]
    public bool useColorN01;
    [Tooltip("Whether to show the second color picker")]
    public bool useColorN02;
    [Tooltip("Whether to show the third color picker")]
    public bool useColorN03;

    [HideInInspector]
    public Renderer[] rendAlpha01;
    [HideInInspector]
    public Renderer[] rendAlpha02;
    [HideInInspector]
    public bool useColorA01;
    [HideInInspector]
    public bool useColorA02;
    [HideInInspector]
    public bool useColorA03;

    [Header("Decorative Part (Uniform)")]
    [Tooltip("Decoration parts used on the jacket or sailor uniform types")]
    public Renderer rendAccessory;

    [Header("Emblem Parts")]
    [Tooltip("Renderer which uses the first emblem")]
    public Renderer rendEmblem01;
    [Tooltip("Additional renderers which use the first emblem")]
    public Renderer[] exRendEmblem01;

    [Header("Emblem Parts 2")]
    [Tooltip("Renderer which uses the second emblem")]
    public Renderer rendEmblem02;
    [Tooltip("Additional renderers which use the second emblem")]
    public Renderer[] exRendEmblem02;

    [Header("Default Colors")]
    [Tooltip("Default value for the first color")]
    public Color defMainColor01 = Color.white;
    [Tooltip("Default value for the second color")]
    public Color defMainColor02 = Color.white;
    [Tooltip("Default value for the third color")]
    public Color defMainColor03 = Color.white;

    [Header("Default Color (Decorative Part)")]
    [Tooltip("Default value for the decoration color")]
    public Color defAccessoryColor = Color.white;

    [Header("Optional Parts")]
    [Tooltip("Renderers which can be toggled off by the first option checkbox")]
    public GameObject[] objOpt01;
    [Tooltip("Renderers which can be toggled off by the second option checkbox")]
    public GameObject[] objOpt02;

    [Header("Sleeve Parts")]
    [Tooltip("Renderers for the first set of sleeves")]
    public GameObject[] objSleeves01;
    [Tooltip("Renderers for the second set of sleeves")]
    public GameObject[] objSleeves02;
    [Tooltip("Renderers for the third set of sleeves")]
    public GameObject[] objSleeves03;

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
        PreviewShaders.ReplaceShadersPreview(rendNormal01);
        PreviewShaders.ReplaceShadersPreview(rendNormal02);
        PreviewShaders.ReplaceShadersPreview(rendNormal03);

        PreviewShaders.ReplaceShadersPreview(rendAlpha01);
        PreviewShaders.ReplaceShadersPreview(rendAlpha02);

        PreviewShaders.ReplaceShadersPreview(rendEmblem01);
        PreviewShaders.ReplaceShadersPreview(exRendEmblem01);
        PreviewShaders.ReplaceShadersPreview(rendEmblem02);
        PreviewShaders.ReplaceShadersPreview(exRendEmblem02);

        PreviewShaders.ReplaceShadersPreview(objOpt01);
        PreviewShaders.ReplaceShadersPreview(objOpt02);
        PreviewShaders.ReplaceShadersPreview(objSleeves01);
        PreviewShaders.ReplaceShadersPreview(objSleeves02);
        PreviewShaders.ReplaceShadersPreview(objSleeves03);
    }

    public void SetMaterialsOriginal()
    {
        PreviewShaders.ReplaceShadersOriginal(rendNormal01);
        PreviewShaders.ReplaceShadersOriginal(rendNormal02);
        PreviewShaders.ReplaceShadersOriginal(rendNormal03);

        PreviewShaders.ReplaceShadersOriginal(rendAlpha01);
        PreviewShaders.ReplaceShadersOriginal(rendAlpha02);

        PreviewShaders.ReplaceShadersOriginal(rendEmblem01);
        PreviewShaders.ReplaceShadersOriginal(exRendEmblem01);
        PreviewShaders.ReplaceShadersOriginal(rendEmblem02);
        PreviewShaders.ReplaceShadersOriginal(exRendEmblem02);

        PreviewShaders.ReplaceShadersOriginal(objOpt01);
        PreviewShaders.ReplaceShadersOriginal(objOpt02);
        PreviewShaders.ReplaceShadersOriginal(objSleeves01);
        PreviewShaders.ReplaceShadersOriginal(objSleeves02);
        PreviewShaders.ReplaceShadersOriginal(objSleeves03);
    }
#endif
}
