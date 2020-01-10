using UnityEngine;

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
}
