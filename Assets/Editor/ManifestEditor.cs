using System;
using System.Xml.Linq;
using UnityEditor;
using UnityEngine;

namespace IllusionMods.KoikatuModdingTools
{
    public static class ManifestEditor
    {
        private static string ModGUID = "";
        private static string ModName = "";
        private static string ModVersion = "";
        private static string ModAuthor = "";
        private static string ModDescription = "";
        private static string ModWebsite = "";
        private static GameName ModGame = GameName.KoikatsuAndEmotionCreators;

        private static string Path = "";
        private static XDocument ManifestDocument = null;

        public static void OnEnable(string path)
        {
            Path = path;
            ManifestDocument = XDocument.Load(path);
            if (ManifestDocument.Root.Element("guid") != null)
                ModGUID = ManifestDocument.Root.Element("guid").Value;
            if (ManifestDocument.Root.Element("name") != null)
                ModName = ManifestDocument.Root.Element("name").Value;
            if (ManifestDocument.Root.Element("version") != null)
                ModVersion = ManifestDocument.Root.Element("version").Value;
            if (ManifestDocument.Root.Element("author") != null)
                ModAuthor = ManifestDocument.Root.Element("author").Value;
            if (ManifestDocument.Root.Element("description") != null)
                ModDescription = ManifestDocument.Root.Element("description").Value;
            if (ManifestDocument.Root.Element("website") != null)
                ModWebsite = ManifestDocument.Root.Element("website").Value;
            if (ManifestDocument.Root.Element("game") != null)
            {
                var game = ManifestDocument.Root.Element("game").Value;
                if (Constants.GameNameList.Contains(game.ToLower()))
                    ModGame = GameName.Koikatsu;
            }
        }

        public static void OnInspectorGUI()
        {
            GUI.enabled = true;
            GUILayout.Label("Editing: " + Path.Replace("Assets/Mods/", "").Replace("Assets/Examples/", ""));

            var modGUIDNew = EditorGUILayout.TextField("GUID", ModGUID);
            var modNameNew = EditorGUILayout.TextField("Name", ModName);
            var modVersionNew = EditorGUILayout.TextField("Version", ModVersion);
            var modAuthorNew = EditorGUILayout.TextField("Author", ModAuthor);
            var modDescriptionNew = EditorGUILayout.TextField("Description", ModDescription);
            var modWebsiteNew = EditorGUILayout.TextField("Website", ModWebsite);
            var modGameNew = (GameName)EditorGUILayout.Popup("Game", (int)ModGame, Enum.GetNames(typeof(GameName)));

            if (!string.IsNullOrEmpty(modGUIDNew) && modGUIDNew != ModGUID)
            {
                ModGUID = modGUIDNew;
                if (ManifestDocument.Root.Element("guid") == null)
                    ManifestDocument.Root.Add(new XElement("guid"));
                ManifestDocument.Root.Element("guid").Value = ModGUID;
                ManifestDocument.Save(Path);
            }
            if (modNameNew != ModName)
            {
                ModName = modNameNew;
                if (ManifestDocument.Root.Element("name") == null)
                    ManifestDocument.Root.Add(new XElement("name"));
                ManifestDocument.Root.Element("name").Value = ModName;
                ManifestDocument.Save(Path);
            }
            if (modVersionNew != ModVersion)
            {
                ModVersion = modVersionNew;
                if (ManifestDocument.Root.Element("version") == null)
                    ManifestDocument.Root.Add(new XElement("version"));
                ManifestDocument.Root.Element("version").Value = ModVersion;
                ManifestDocument.Save(Path);
            }
            if (modAuthorNew != ModAuthor)
            {
                ModAuthor = modAuthorNew;
                if (ManifestDocument.Root.Element("author") == null)
                    ManifestDocument.Root.Add(new XElement("author"));
                ManifestDocument.Root.Element("author").Value = ModAuthor;
                ManifestDocument.Save(Path);
            }
            if (modDescriptionNew != ModDescription)
            {
                ModDescription = modDescriptionNew;
                if (ManifestDocument.Root.Element("description") == null)
                    ManifestDocument.Root.Add(new XElement("description"));
                ManifestDocument.Root.Element("description").Value = ModDescription;
                ManifestDocument.Save(Path);
            }
            if (modWebsiteNew != ModWebsite)
            {
                ModWebsite = modWebsiteNew;
                if (ManifestDocument.Root.Element("website") == null)
                    ManifestDocument.Root.Add(new XElement("website"));
                ManifestDocument.Root.Element("website").Value = ModWebsite;
                ManifestDocument.Save(Path);
            }
            if (modGameNew != ModGame)
            {
                ModGame = modGameNew;
                if (ManifestDocument.Root.Element("game") == null)
                    ManifestDocument.Root.Add(new XElement("game"));
                if (ModGame == GameName.Koikatsu)
                    ManifestDocument.Root.Element("game").Value = "Koikatsu";
                else
                    ManifestDocument.Root.Element("game").Value = "";
                ManifestDocument.Save(Path);
            }

            EditorGUILayout.Space();
            GUI.enabled = false;
            GUILayout.TextArea(ManifestDocument.ToString(), GUILayout.ExpandHeight(true), GUILayout.ExpandWidth(true), GUILayout.MinHeight(70), GUILayout.MaxHeight(250));
            GUI.enabled = true;
        }

        public enum GameName { KoikatsuAndEmotionCreators, Koikatsu }
    }
}
