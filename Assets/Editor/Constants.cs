using System.Collections.Generic;

namespace IllusionMods.KoikatuModdingTools
{
    internal static class Constants
    {
        internal const string ModsPath = @"Assets\Mods";
        internal const string ExamplesPath = @"Assets\Examples";
        internal const string ScriptsPath = @"Assets\Scripts";
        internal const string ShadersPath = @"Assets\Shaders";
        internal const string SB3UtilityScriptPath = @"Tools\SB3UGS\SB3UtilityScript.exe";

        internal static readonly HashSet<string> GameNameList = new HashSet<string>() { "koikatsu", "koikatu", "コイカツ" };
        internal static readonly Dictionary<string, string> ShaderABs = new Dictionary<string, string>()
        {
            { "Shader Forge/create_body", "chara/mm_base.unity3d" },
            { "Shader Forge/create_eye", "chara/mm_base.unity3d" },
            { "Shader Forge/create_hair", "chara/mm_base.unity3d" },
            { "Shader Forge/create_head", "chara/mm_base.unity3d" },
            { "Shader Forge/create_topN", "chara/mm_base.unity3d" },
            { "Shader Forge/main_alpha", "chara/co_bra_00.unity3d" },
            { "Shader Forge/main_emblem", "chara/co_top_00.unity3d" },
            { "Shader Forge/main_emblem_clothes", "chara/co_bra_00.unity3d" },
            { "Shader Forge/main_color", "chara/ao_head_00.unity3d" },
            { "Shader Forge/main_hair", "chara/bo_hair_b_00.unity3d" },
            { "Shader Forge/main_hair_front", "chara/bo_hair_f_00.unity3d" },
            { "Shader Forge/main_hair_low", "chara/bo_hair_b_00.unity3d" },
            { "Shader Forge/main_item", "chara/ao_arm_00.unity3d" },
            { "Shader Forge/main_item_ditherd", "chara/ao_head_09.unity3d" },
            { "Shader Forge/main_item_emission", "chara/ao_head_08.unity3d" },
            { "Shader Forge/main_item_low", "chara/bo_hair_b_00.unity3d" },
            { "Shader Forge/main_item_studio_add", "chara/ao_head_08.unity3d" },
            { "Shader Forge/main_opaque", "chara/co_bra_00.unity3d" },
            { "Shader Forge/main_opaque2", "chara/co_bra_10.unity3d" },
            { "Shader Forge/main_skin", "chara/mm_base.unity3d" },
            { "Shader Forge/main_opaque_low", "chara/co_bra_00.unity3d" },
            { "Shader Forge/main_opaque_low2", "chara/co_bra_10.unity3d" },
            { "Shader Forge/main_texture", "chara/ao_hair_00.unity3d" },
            { "Shader Forge/toon_glasses_lod0", "chara/ao_face_00.unity3d" },
        };
    }
}
