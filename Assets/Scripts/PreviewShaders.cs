#if UNITY_EDITOR
using System.Collections.Generic;
using UnityEngine;

public static class PreviewShaders
{
    private static readonly Dictionary<string, Shader> shaders = new Dictionary<string, Shader>();
    private static bool LoadedShaders = false;

    private static void LoadShaders()
    {
        Shader.SetGlobalFloat(Shader.PropertyToID("_linewidthG"), 0.5f);
        Shader.SetGlobalTexture(Shader.PropertyToID("_RampG"), null);
        Shader.SetGlobalColor(Shader.PropertyToID("_ambientshadowG"), Color.black);
        Shader.SetGlobalColor(Shader.PropertyToID("_LineColorG"), Color.black);

        if (LoadedShaders)
            return;

        var ab = AssetBundle.LoadFromFile("Assets/kk_shaders.unity3d");
        foreach (var obj in ab.LoadAllAssets<GameObject>())
        {
            foreach (var mat in obj.GetComponentInChildren<Renderer>().sharedMaterials)
            {
                var sha = mat.shader;
                shaders[mat.shader.name] = sha;
            }
        }
        ab.Unload(false);

        LoadedShaders = true;
    }

    public static void Preview(Renderer[] renderers)
    {
        LoadShaders();

        foreach (var renderer in renderers)
            Preview(renderer);
    }

    public static void Preview(Renderer renderer)
    {
        if (!renderer)
            return;

        LoadShaders();

        foreach (var material in renderer.materials)
            Preview(material);
    }

    public static void Preview(GameObject[] gameObjects)
    {
        LoadShaders();

        foreach (var gameObject in gameObjects)
            Preview(gameObject.GetComponentsInChildren<Renderer>());
    }

    public static void Preview(GameObject gameObject)
    {
        if (!gameObject)
            return;

        LoadShaders();

        Preview(gameObject.GetComponentsInChildren<Renderer>());
    }

    public static void Preview(Material[] materials)
    {
        LoadShaders();

        foreach (var material in materials)
            Preview(material);
    }

    public static void Preview(Material material)
    {
        if (!material)
            return;

        LoadShaders();

        Shader sha;
        if (shaders.TryGetValue(material.shader.name, out sha))
            material.shader = sha;
    }
}
#endif

//public class NewBehaviourScript
//{
//    private static readonly Dictionary<string, Shader> shaders = new Dictionary<string, Shader>();

//    [MenuItem("Shaders/Preview")]
//    private static void Preview()
//    {
//        var ab = AssetBundle.LoadFromFile("Assets/KK_Shaders2.unity3d");
//        foreach (var obj in ab.LoadAllAssets<GameObject>())
//        {
//            foreach (var mat in obj.GetComponentInChildren<Renderer>().sharedMaterials)
//            {
//                var sha = mat.shader;
//                shaders[mat.shader.name] = sha;
//            }
//        }
//        ab.Unload(false);

//        ab = AssetBundle.LoadFromFile("Assets/mt_ramp_00.unity3d");
//        var rampTex = ab.LoadAsset<Texture2D>("gt_ramp_05");
//        Debug.Log("rampTex:" + rampTex);
//        ab.Unload(false);

//        ab = AssetBundle.LoadFromFile("Assets/mt_hairgloss_00.unity3d");
//        var glossTex = ab.LoadAsset<Texture2D>("cf_hair_00_04_mh");
//        Debug.Log("glossTex:" + glossTex);
//        ab.Unload(false);

//        foreach (var target in Selection.gameObjects)
//            foreach (var rend in target.GetComponentsInChildren<Renderer>())
//                foreach (var mat in rend.sharedMaterials)
//                {
//                    Shader sha;
//                    if (shaders.TryGetValue(mat.shader.name, out sha))
//                        mat.shader = sha;
//                }

//        Shader.SetGlobalFloat(Shader.PropertyToID("_linewidthG"), 0.5f);
//        Shader.SetGlobalTexture(Shader.PropertyToID("_RampG"), rampTex);
//        Shader.SetGlobalColor(Shader.PropertyToID("_ambientshadowG"), Color.black);
//        Shader.SetGlobalColor(Shader.PropertyToID("_LineColorG"), Color.black);
//    }
//}
