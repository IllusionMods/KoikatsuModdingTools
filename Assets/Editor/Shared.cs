using System;
using System.Reflection;
using Debug = UnityEngine.Debug;

namespace IllusionMods.KoikatuModdingTools
{
    internal static class Shared
    {
        /// <summary>
        /// Get the path of the currently selected folder.
        /// </summary>
        public static string GetProjectPath()
        {
            try
            {
                var projectBrowserType = Type.GetType("UnityEditor.ProjectBrowser,UnityEditor");
                var projectBrowser = projectBrowserType.GetField("s_LastInteractedProjectBrowser", BindingFlags.Static | BindingFlags.Public).GetValue(null);
                var invokeMethod = projectBrowserType.GetMethod("GetActiveFolderPath", BindingFlags.NonPublic | BindingFlags.Instance);
                return (string)invokeMethod.Invoke(projectBrowser, new object[] { });
            }
            catch (Exception exception)
            {
                Debug.LogWarning("Error while trying to get current project path.");
                Debug.LogWarning(exception.Message);
                return string.Empty;
            }
        }
    }
}
