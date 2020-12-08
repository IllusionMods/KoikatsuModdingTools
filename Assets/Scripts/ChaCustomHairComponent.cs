using UnityEngine;

[ExecuteInEditMode]
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

#if UNITY_EDITOR
    private void Awake()
    {
        SetMaterialsPreview();
    }

    private void OnApplicationQuit()
    {
        SetMaterialsOriginal();
    }

    private void OnDestroy()
    {
        SetMaterialsOriginal();
    }

    public void SetMaterialsPreview()
    {
        PreviewShaders.ReplaceShadersPreview(rendHair);
        PreviewShaders.ReplaceShadersPreview(rendAccessory);

        SetAccessoryColor();
    }

    public void SetMaterialsOriginal()
    {
        PreviewShaders.ReplaceShadersOriginal(rendHair);
        PreviewShaders.ReplaceShadersOriginal(rendAccessory);
    }

    public void SetAccessoryColor()
    {
        foreach (var rend in rendAccessory)
            foreach (var mat in rend.sharedMaterials)
                mat.SetColor("_Color", Color.red);
    }
#endif
}
