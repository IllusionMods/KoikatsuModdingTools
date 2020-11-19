using UnityEngine;

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
        PreviewShaders.Preview(rendNormal01);
        PreviewShaders.Preview(rendNormal02);
        PreviewShaders.Preview(rendNormal03);

        PreviewShaders.Preview(rendAlpha01);
        PreviewShaders.Preview(rendAlpha02);

        PreviewShaders.Preview(rendEmblem01);
        PreviewShaders.Preview(exRendEmblem01);
        PreviewShaders.Preview(rendEmblem02);
        PreviewShaders.Preview(exRendEmblem02);

        PreviewShaders.Preview(objOpt01);
        PreviewShaders.Preview(objOpt02);
        PreviewShaders.Preview(objSleeves01);
        PreviewShaders.Preview(objSleeves02);
        PreviewShaders.Preview(objSleeves03);
    }
#endif
}
