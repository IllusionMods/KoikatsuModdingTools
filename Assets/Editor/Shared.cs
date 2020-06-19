using System;
using System.IO;
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
                string projectPath = (string)invokeMethod.Invoke(projectBrowser, new object[] { });
                projectPath = projectPath.Replace("/", @"\");
                return projectPath;
            }
            catch (Exception exception)
            {
                Debug.LogWarning("Error while trying to get current project path.");
                Debug.LogWarning(exception.Message);
                return string.Empty;
            }
        }

        /// <summary>
        /// Get the path to the manifest.xml for the specified folder or from its parent folder.
        /// </summary>
        /// <param name="projectPath">Folder to search for manifest.xml</param>
        /// <returns>Path to the manifest.xml if it exists or null if not</returns>
        public static string GetManifestPath(string projectPath)
        {
            string manifestPath = Path.Combine(projectPath, "manifest.xml");
            if (File.Exists(manifestPath))
                return manifestPath;

            while (projectPath != "" && projectPath.Contains(@"\") && projectPath != @"Assets\Mods" && projectPath != @"Assets\Examples")
            {
                projectPath = projectPath.Remove(projectPath.LastIndexOf(@"\"));
                manifestPath = Path.Combine(projectPath, "manifest.xml");
                if (File.Exists(manifestPath))
                    return manifestPath;
            }
            return null;
        }

        /// <summary>
        /// Get the path to the manifest.xml for the current folder or from its parent folder.
        /// </summary>
        /// <returns>Path to the manifest.xml if it exists or null if not</returns>
        public static string GetManifestFilePath()
        {
            return GetManifestPath(GetProjectPath());
        }

        /// <summary>
        /// Get the folder containing the manifest.xml for the current folder or from its parent folder.
        /// </summary>
        /// <returns>Folder containing the manifest.xml if it exists or null if not</returns>
        public static string GetManifestPath()
        {
            string path = GetManifestPath(GetProjectPath());
            if (path == null)
                return null;
            return GetManifestPath(GetProjectPath()).Replace(@"\manifest.xml", "");
        }
    }
}
