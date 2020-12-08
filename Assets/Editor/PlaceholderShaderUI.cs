using UnityEditor;
using UnityEngine;

/// <summary>
/// Used by the placeholder shaders
/// </summary>
public class PlaceholderShaderUI : ShaderGUI
{
    /// <summary>
    /// Switch to the preview shader when changing to a placeholder shader
    /// </summary>
    public override void AssignNewShaderToMaterial(Material material, Shader oldShader, Shader newShader)
    {
        base.AssignNewShaderToMaterial(material, oldShader, newShader);
        PreviewShaders.SetSelectedMaterialsPreview();
    }
}
