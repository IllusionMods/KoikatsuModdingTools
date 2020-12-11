#if UNITY_EDITOR
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.SceneManagement;

public class PreviewShaders : UnityEditor.AssetModificationProcessor
{
    public static readonly Dictionary<string, Shader> Shaders = new Dictionary<string, Shader>();
    public static Texture RampGradient;
    public static float LineWidth = 0.3f;
    public static Color AmbientShadow = new Color(0f, 0f, 0f, 0.3f);
    public static Color LineColor = new Color(0.5f, 0.5f, 0.5f, 0f);

    static PreviewShaders()
    {
        var ab = AssetBundle.LoadFromFile("Assets/kk_shaders.unity3d");
        foreach (var obj in ab.LoadAllAssets<GameObject>())
            foreach (var mat in obj.GetComponentInChildren<Renderer>().sharedMaterials)
                Shaders[mat.shader.name] = mat.shader;
        ab.Unload(false);

        ab = AssetBundle.LoadFromFile("Assets/ramp.unity3d");
        RampGradient = ab.LoadAsset<Texture2D>("ramp_tex");
        ab.Unload(false);

        Shader.SetGlobalFloat("_linewidthG", LineWidth);
        Shader.SetGlobalTexture("_RampG", RampGradient);
        Shader.SetGlobalColor("_ambientshadowG", AmbientShadow);
        Shader.SetGlobalColor("_LineColorG", LineColor);
    }

    /// <summary>
    /// Revert materials to the original before a scene is saved
    /// </summary>
    /// <param name="paths"></param>
    /// <returns></returns>
    private static string[] OnWillSaveAssets(string[] paths)
    {
        foreach (string path in paths)
        {
            if (path.EndsWith(".unity"))
            {
                SetAllMaterialsOriginal();
                break;
            }
        }
        return paths;
    }

    /// <summary>
    /// Set all the materials in the scene back to their original. Must be called before exiting Unity, before building asset bundles, and before saving a scene or materials will become corrupt.
    /// </summary>
    public static void SetAllMaterialsOriginal()
    {
        foreach (var go in GetRootObjects())
            SetMaterialsOriginal(go);
    }

    /// <summary>
    /// Set all the materials in the scene to their preview state with functional shaders
    /// </summary>
    public static void SetAllMaterialsPreview()
    {
        foreach (var go in GetRootObjects())
            SetMaterialsPreview(go);
    }

    /// <summary>
    /// Set all the materials of the currently selected objects to the original placeholder shaders
    /// </summary>
    public static void SetSelectedMaterialsOriginal()
    {
        foreach (var selected in Selection.gameObjects)
            SetMaterialsOriginal(GetGameObjectRoot(selected));
    }

    /// <summary>
    /// Set all the materials of the currently selected objects to the functional shaders
    /// </summary>
    public static void SetSelectedMaterialsPreview()
    {
        foreach (var selected in Selection.gameObjects)
            SetMaterialsPreview(GetGameObjectRoot(selected));
    }

    private static void SetMaterialsOriginal(GameObject go)
    {
        ChaCustomHairComponent chaCustomHairComponent = go.GetComponentInChildren<ChaCustomHairComponent>();
        if (chaCustomHairComponent != null)
            chaCustomHairComponent.SetMaterialsOriginal();
        ChaClothesComponent chaClothesComponent = go.GetComponentInChildren<ChaClothesComponent>();
        if (chaClothesComponent != null)
            chaClothesComponent.SetMaterialsOriginal();
        Studio.ItemComponent itemComponent = go.GetComponentInChildren<Studio.ItemComponent>();
        if (itemComponent != null)
            itemComponent.SetMaterialsOriginal();
        ChaAccessoryComponent chaAccessoryComponent = go.GetComponentInChildren<ChaAccessoryComponent>();
        if (chaAccessoryComponent != null)
            chaAccessoryComponent.SetMaterialsOriginal();
    }

    private static void SetMaterialsPreview(GameObject go)
    {
        ChaCustomHairComponent chaCustomHairComponent = go.GetComponentInChildren<ChaCustomHairComponent>();
        if (chaCustomHairComponent != null)
            chaCustomHairComponent.SetMaterialsPreview();
        ChaClothesComponent chaClothesComponent = go.GetComponentInChildren<ChaClothesComponent>();
        if (chaClothesComponent != null)
            chaClothesComponent.SetMaterialsPreview();
        Studio.ItemComponent itemComponent = go.GetComponentInChildren<Studio.ItemComponent>();
        if (itemComponent != null)
            itemComponent.SetMaterialsPreview();
        ChaAccessoryComponent chaAccessoryComponent = go.GetComponentInChildren<ChaAccessoryComponent>();
        if (chaAccessoryComponent != null)
            chaAccessoryComponent.SetMaterialsPreview();
    }

    /// <summary>
    /// Get all the root objects in the scene
    /// </summary>
    /// <returns></returns>
    public static List<GameObject> GetRootObjects()
    {
        List<GameObject> rootObjects = new List<GameObject>();
        Scene scene = SceneManager.GetActiveScene();
        scene.GetRootGameObjects(rootObjects);
        return rootObjects;
    }

    /// <summary>
    /// Get the root GameObject of the specified GameObject
    /// </summary>
    /// <param name="go"></param>
    /// <returns></returns>
    public static GameObject GetGameObjectRoot(GameObject go)
    {
        if (go.transform.parent == null)
            return go;
        return GetGameObjectRoot(go.transform.parent.gameObject);
    }

    /// <summary>
    /// Replace shaders on the renderers with the preview version
    /// </summary>
    /// <param name="renderers"></param>
    public static void ReplaceShadersPreview(Renderer[] renderers)
    {
        if (renderers == null)
            return;

        foreach (var renderer in renderers)
            ReplaceShadersPreview(renderer);
    }

    /// <summary>
    /// Replace shaders on all the renderers of the gameobjects with the preview version
    /// </summary>
    /// <param name="gameObjects"></param>
    public static void ReplaceShadersPreview(GameObject[] gameObjects)
    {
        if (gameObjects == null)
            return;

        foreach (var go in gameObjects)
            ReplaceShadersPreview(go.GetComponentsInChildren<Renderer>());
    }

    /// <summary>
    /// Replace shaders on the renderer with the preview version
    /// </summary>
    /// <param name="renderer"></param>
    public static void ReplaceShadersPreview(Renderer renderer)
    {
        if (renderer == null)
            return;

        foreach (var material in renderer.sharedMaterials)
        {
            Shader sha;
            if (Shaders.TryGetValue(material.shader.name, out sha))
                material.shader = sha;
        }
    }

    /// <summary>
    /// Replace shaders on the renderers with the original placerholder version
    /// </summary>
    /// <param name="renderers"></param>
    public static void ReplaceShadersOriginal(Renderer[] renderers)
    {
        if (renderers == null)
            return;

        foreach (var renderer in renderers)
            ReplaceShadersOriginal(renderer);
    }

    /// <summary>
    /// Replace shaders on all the renderers of the gameobjects with the original placerholder version
    /// </summary>
    /// <param name="gameObjects"></param>
    public static void ReplaceShadersOriginal(GameObject[] gameObjects)
    {
        if (gameObjects == null)
            return;

        foreach (var go in gameObjects)
            ReplaceShadersOriginal(go.GetComponentsInChildren<Renderer>());
    }

    /// <summary>
    /// Replace shaders on the renderer with the original placerholder version
    /// </summary>
    /// <param name="renderer"></param>
    public static void ReplaceShadersOriginal(Renderer renderer)
    {
        if (renderer == null)
            return;

        foreach (var material in renderer.sharedMaterials)
        {
            string filename;
            if (ShaderFilenames.TryGetValue(material.shader.name, out filename))
            {
                Shader sha = (Shader)AssetDatabase.LoadAssetAtPath("Assets/Shaders/" + filename, typeof(Shader));
                if (sha != null)
                    material.shader = sha;
            }
        }
    }

    /// <summary>
    /// Shader names and their associated placeholder shader filenames
    /// </summary>
    private static readonly Dictionary<string, string> ShaderFilenames = new Dictionary<string, string>
        {
            { "Custom/CustomUnlit-Outline",  "Custom_CustomUnlit-Outline.shader" },
            { "Custom/Blend/Zero_Subtractive",  "Custom_Blend_Zero_Subtractive.shader" },
            { "Custom/Blend/Additive",  "Custom_Blend_Additive.shader" },
            { "Custom/Silhouette", "Custom_Silhouette.shader" },
            { "CustomUnlit/Transparent DoubleSide",  "CustomUnlit_Transparent DoubleSide.shader" },
            { "Shader Forge/create_body", "Shader Forge_create_body.shader" },
            { "Shader Forge/create_eye", "Shader Forge_create_eye.shader" },
            { "Shader Forge/create_eyewhite", "Shader Forge_create_eyewhite.shader" },
            { "Shader Forge/create_hair", "Shader Forge_create_hair.shader" },
            { "Shader Forge/create_head", "Shader Forge_create_head.shader" },
            { "Shader Forge/create_topN", "Shader Forge_create_topN.shader" },
            { "Shader Forge/main_alpha", "Shader Forge_main_alpha.shader" },
            { "Shader Forge/main_color", "Shader Forge_main_color.shader" },
            { "Shader Forge/main_emblem", "Shader Forge_main_emblem.shader" },
            { "Shader Forge/main_emblem_clothes", "Shader Forge_main_emblem_clothes.shader" },
            { "Shader Forge/main_hair", "Shader Forge_main_hair.shader" },
            { "Shader Forge/main_hair_front", "Shader Forge_main_hair_front.shader" },
            { "Shader Forge/main_hair_low", "Shader Forge_main_hair_low.shader" },
            { "Shader Forge/main_item", "Shader Forge_main_item.shader" },
            { "Shader Forge/main_item_ditherd", "Shader Forge_main_item_ditherd.shader" },
            { "Shader Forge/main_item_emission", "Shader Forge_main_item_emission.shader" },
            { "Shader Forge/main_item_low", "Shader Forge_main_item_low.shader" },
            { "Shader Forge/main_item_studio", "Shader Forge_main_item_studio.shader" },
            { "Shader Forge/main_item_studio_add", "Shader Forge_main_item_studio_add.shader" },
            { "Shader Forge/main_item_studio_alpha", "Shader Forge_main_item_studio_alpha.shader" },
            { "Shader Forge/main_opaque", "Shader Forge_main_opaque.shader" },
            { "Shader Forge/main_opaque2", "Shader Forge_main_opaque2.shader" },
            { "Shader Forge/main_opaque_low", "Shader Forge_main_opaque_low.shader" },
            { "Shader Forge/main_opaque_low2", "Shader Forge_main_opaque_low2.shader" },
            { "Shader Forge/main_skin", "Shader Forge_main_skin.shader" },
            { "Shader Forge/main_skin_low", "Shader Forge_main_skin_low.shader" },
            { "Shader Forge/main_StandardMDK_studio","Shader Forge_main_StandardMDK_studio.shader" },
            { "Shader Forge/main_texture", "Shader Forge_main_texture.shader" },
            { "Shader Forge/main_texture_studio", "Shader Forge_main_texture_studio.shader" },
            { "Shader Forge/mnpb", "Shader Forge_mnpb.shader" },
            { "Shader Forge/shadowcast", "Shader Forge_shadowcast.shader" },
            { "Shader Forge/toon_eye_lod0", "Shader Forge_toon_eye_lod0.shader" },
            { "Shader Forge/toon_eyew_lod0", "Shader Forge_toon_eyew_lod0.shader" },
            { "Shader Forge/toon_glasses_lod0", "Shader Forge_toon_glasses_lod0.shader" },
            { "Shader Forge/toon_nose_lod0", "Shader Forge_toon_nose_lod0.shader" },
            { "Shader Forge/toon_textureanimation", "Shader Forge_toon_textureanimation.shader" },
        };

    private static Texture2D TextureFromBytes(byte[] texBytes, TextureFormat format = TextureFormat.ARGB32, bool mipmaps = true)
    {
        if (texBytes == null || texBytes.Length == 0) return null;

        var tex = new Texture2D(2, 2, format, mipmaps);
        tex.LoadImage(texBytes);
        return tex;
    }
}
#endif
