using UnityEditor;
using UnityEngine;

/// <summary>
/// Convert grey-style normalmaps to red-style to make normalmaps compatible with both KK and EC
/// </summary>
public class ConvertNormalMaps : AssetPostprocessor
{
    internal void OnPostprocessTexture(Texture2D texture)
    {
        var textureImpoter = assetImporter as TextureImporter;
        if (textureImpoter.textureType != TextureImporterType.NormalMap) return;

        //Set the entire red color channel to white
        Color[] c = texture.GetPixels(0);
        for (int i = 0; i < c.Length; i++)
            c[i].r = 1;

        texture.SetPixels(c, 0);
        texture.Apply(true);
    }
}