using System.IO;
using UnityEngine;

[ExecuteInEditMode]
public class ChaCustomHairComponent : MonoBehaviour
{
    [Tooltip("Renderers controlled by the hair color")]
    public Renderer[] rendHair;
    [Tooltip("Renderers controlled by the hair accessory color")]
    public Renderer[] rendAccessory;
    [Tooltip("Transforms modified by the hair length slider")]
    public Transform[] trfLength;
    [Tooltip("Default position of the hair length transforms")]
    public float[] baseLength;
    [Tooltip("Rate at which the length slider affects positions of the transforms")]
    public float addLength;

    [HideInInspector]
    [Range(0f, 1f)]
    public float lengthRate;

    [Tooltip("Required when using Rend Accessory")]
    public Color[] acsDefColor;

    [HideInInspector]
    public int initialize;
    [HideInInspector]
    public int setcolor;

#if UNITY_EDITOR

    private static Color BaseColor = new Color(0.69020f, 0.49412f, 0.31765f);
    private static Color RootColor = new Color(0.62745f, 0.47451f, 0.45882f);
    private static Color TipColor = new Color(0.78824f, 0.80784f, 0.75294f);
    public static Texture HairGloss;

    private void Awake()
    {
        if (!HairGloss)
            HairGloss = TextureFromBytes(File.ReadAllBytes("Assets/HairGloss.png"));
        SetMaterialsPreview();
    }

	// having Start() gives Inspector enable/disable checkbox for the script
	// needed because an exception in Awake() will disable the script
	void Start()
	{
	}

    private void OnDestroy()
    {
        SetMaterialsOriginal();
    }

    public void SetMaterialsPreview()
    {
        PreviewShaders.ReplaceShadersPreview(rendHair);
        PreviewShaders.ReplaceShadersPreview(rendAccessory);

        SetHairMaterials(true);
        SetAccessoryColor();
    }

    public void SetMaterialsOriginal()
    {
        PreviewShaders.ReplaceShadersOriginal(rendHair);
        PreviewShaders.ReplaceShadersOriginal(rendAccessory);

        SetHairMaterials(false);
    }

    public void SetAccessoryColor()
    {
		if (rendAccessory == null)
			return;
		
        foreach (var rend in rendAccessory)
			if (rend != null)
	            foreach (var mat in rend.sharedMaterials)
	                mat.SetColor("_Color", Color.red);
    }

    public void SetHairMaterials(bool enabled)
    {
		if (rendHair == null)
			return;
		
        foreach (var rend in rendHair)
			if (rend != null)
	            foreach (var mat in rend.sharedMaterials)
	            {
	                mat.SetTexture("_HairGloss", enabled ? HairGloss : null);

	                mat.SetColor("_Color", BaseColor);
	                mat.SetColor("_Color2", RootColor);
	                mat.SetColor("_Color3", TipColor);

	                float H;
	                float S;
	                float V;
	                Color.RGBToHSV(BaseColor, out H, out S, out V);
	                Color outlineColor = Color.HSVToRGB(H, S, Mathf.Max(V - 0.4f, 0f));
	                mat.SetColor("_LineColor", outlineColor);
	            }
    }

    private static Texture2D TextureFromBytes(byte[] texBytes, TextureFormat format = TextureFormat.ARGB32, bool mipmaps = true)
    {
        if (texBytes == null || texBytes.Length == 0) return null;

        var tex = new Texture2D(2, 2, format, mipmaps);
        tex.LoadImage(texBytes);
        return tex;
    }

	/// <summary>
	/// Add all renderers to the rendHair array
	/// </summary>
	public void PopulateRendHairArray()
	{
		rendHair = gameObject.GetComponentsInChildren<Renderer>();
		SetMaterialsPreview();
	}
#endif
}
