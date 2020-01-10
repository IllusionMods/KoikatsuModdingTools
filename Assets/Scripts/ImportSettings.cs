#if UNITY_EDITOR
using UnityEditor;
/// <summary>
/// Automatically sets texture compression to Uncompressed
/// </summary>
internal class TexturePostprocessor : AssetPostprocessor
{
    private void OnPreprocessTexture()
    {
        //TextureImporter textureImporter = (TextureImporter)assetImporter;
        //textureImporter.textureCompression = TextureImporterCompression.Uncompressed;
    }
}
#endif