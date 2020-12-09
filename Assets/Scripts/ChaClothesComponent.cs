using UnityEngine;

[ExecuteInEditMode]
public class ChaClothesComponent : MonoBehaviour
{
    [Header("Normal Parts")]
    public Renderer[] rendNormal01;
    public Renderer[] rendNormal02;
    public Renderer[] rendNormal03;

    public bool useColorN01;
    public bool useColorN02;
    public bool useColorN03;

    [Header("Transparent Parts")]
    public Renderer[] rendAlpha01;
    public Renderer[] rendAlpha02;

    public bool useColorA01;
    public bool useColorA02;
    public bool useColorA03;

    [Header("Decorative Part (Uniform)")]
    public Renderer rendAccessory;

    [Header("Emblem Parts")]
    public Renderer rendEmblem01;
    public Renderer[] exRendEmblem01;

    [Header("Emblem Parts 2")]
    public Renderer rendEmblem02;
    public Renderer[] exRendEmblem02;

    [Header("Default Colors")]
    public Color defMainColor01 = Color.white;
    public Color defMainColor02 = Color.white;
    public Color defMainColor03 = Color.white;

    [Header("Default Color (Decorative Part)")]
    public Color defAccessoryColor = Color.white;

    [Header("Optional Parts")]
    public GameObject[] objOpt01;
    public GameObject[] objOpt02;

    [Header("Sleeve Parts")]
    public GameObject[] objSleeves01;
    public GameObject[] objSleeves02;
    public GameObject[] objSleeves03;

    [Space]
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
