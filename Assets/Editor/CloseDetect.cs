using System.Reflection;
using UnityEditor;
using UnityEngine.Events;

/// <summary>
/// Detect when editor is closing and run whatever code is required
/// </summary>
[InitializeOnLoad]
public class CloseDetect
{
    static CloseDetect()
    {
        var t = typeof(EditorApplication);
        var f = t.GetField("editorApplicationQuit", BindingFlags.NonPublic | BindingFlags.Static);

        UnityAction ua = Quitting;
        f.SetValue(null, ua);
    }

    /// <summary>
    /// Code to run on editor quit
    /// </summary>
    private static void Quitting()
    {
        PreviewShaders.SetAllMaterialsOriginal();
    }
}