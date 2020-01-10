using UnityEngine;

public class ChaCustomHairComponent : MonoBehaviour
{
    public Renderer[] rendHair;
    public Renderer[] rendAccessory;
    public Transform[] trfLength;
    public float[] baseLength;
    public float addLength;
    [Range(0f, 1f)]
    public float lengthRate;
    public Color[] acsDefColor;
    public int initialize;
    public int setcolor;
}
