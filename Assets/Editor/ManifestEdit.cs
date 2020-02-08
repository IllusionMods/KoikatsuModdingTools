using System;
using System.Xml.Linq;
using UnityEditor;
using UnityEngine;

namespace IllusionMods.KoikatuModdingTools
{
    [CustomEditor(typeof(TextAsset))]
    public class ManifestEditor : Editor
    {
        string modGUID = "";
        string modName = "";
        string modVersion = "";
        string modAuthor = "";
        string modDescription = "";
        string modWebsite = "";
        GameName modGame = GameName.Any;

        string filename = "";
        XDocument manifestDocument = null;

        internal void OnEnable()
        {
            filename = AssetDatabase.GetAssetPath(target);

            manifestDocument = XDocument.Load(filename);
            if (manifestDocument.Root.Element("guid") != null)
                modGUID = manifestDocument.Root.Element("guid").Value;
            if (manifestDocument.Root.Element("name") != null)
                modName = manifestDocument.Root.Element("name").Value;
            if (manifestDocument.Root.Element("version") != null)
                modVersion = manifestDocument.Root.Element("version").Value;
            if (manifestDocument.Root.Element("author") != null)
                modAuthor = manifestDocument.Root.Element("author").Value;
            if (manifestDocument.Root.Element("description") != null)
                modDescription = manifestDocument.Root.Element("description").Value;
            if (manifestDocument.Root.Element("website") != null)
                modWebsite = manifestDocument.Root.Element("website").Value;
            if (manifestDocument.Root.Element("game") != null)
            {
                var game = manifestDocument.Root.Element("game").Value;
                if (Constants.GameNameList.Contains(game.ToLower()))
                    modGame = GameName.Koikatsu;
            }
        }

        public override void OnInspectorGUI()
        {
            GUI.enabled = true;
            GUILayout.Label("Editing: " + filename.Replace("Assets/Mods/", "").Replace("Assets/Examples/", ""));

            var modGUIDNew = EditorGUILayout.TextField("GUID", modGUID);
            var modNameNew = EditorGUILayout.TextField("Name", modName);
            var modVersionNew = EditorGUILayout.TextField("Version", modVersion);
            var modAuthorNew = EditorGUILayout.TextField("Author", modAuthor);
            var modDescriptionNew = EditorGUILayout.TextField("Description", modDescription);
            var modWebsiteNew = EditorGUILayout.TextField("Website", modWebsite);
            var modGameNew = (GameName)EditorGUILayout.Popup("Game", (int)modGame, Enum.GetNames(typeof(GameName)));

            if (!string.IsNullOrEmpty(modGUIDNew) && modGUIDNew != modGUID)
            {
                modGUID = modGUIDNew;
                if (manifestDocument.Root.Element("guid") == null)
                    manifestDocument.Root.Add(new XElement("guid"));
                manifestDocument.Root.Element("guid").Value = modGUID;
                manifestDocument.Save(filename);
            }
            if (modNameNew != modName)
            {
                modName = modNameNew;
                if (manifestDocument.Root.Element("name") == null)
                    manifestDocument.Root.Add(new XElement("name"));
                manifestDocument.Root.Element("name").Value = modName;
                manifestDocument.Save(filename);
            }
            if (modVersionNew != modVersion)
            {
                modVersion = modVersionNew;
                if (manifestDocument.Root.Element("version") == null)
                    manifestDocument.Root.Add(new XElement("version"));
                manifestDocument.Root.Element("version").Value = modVersion;
                manifestDocument.Save(filename);
            }
            if (modAuthorNew != modAuthor)
            {
                modAuthor = modAuthorNew;
                if (manifestDocument.Root.Element("author") == null)
                    manifestDocument.Root.Add(new XElement("author"));
                manifestDocument.Root.Element("author").Value = modAuthor;
                manifestDocument.Save(filename);
            }
            if (modDescriptionNew != modDescription)
            {
                modDescription = modDescriptionNew;
                if (manifestDocument.Root.Element("description") == null)
                    manifestDocument.Root.Add(new XElement("description"));
                manifestDocument.Root.Element("description").Value = modDescription;
                manifestDocument.Save(filename);
            }
            if (modWebsiteNew != modWebsite)
            {
                modWebsite = modWebsiteNew;
                if (manifestDocument.Root.Element("website") == null)
                    manifestDocument.Root.Add(new XElement("website"));
                manifestDocument.Root.Element("website").Value = modWebsite;
                manifestDocument.Save(filename);
            }
            if (modGameNew != modGame)
            {
                modGame = modGameNew;
                if (manifestDocument.Root.Element("game") == null)
                    manifestDocument.Root.Add(new XElement("game"));
                if (modGame == GameName.Koikatsu)
                    manifestDocument.Root.Element("game").Value = "Koikatsu";
                else
                    manifestDocument.Root.Element("game").Value = "";
                manifestDocument.Save(filename);
            }
        }

        public enum GameName { Any, Koikatsu }
    }
}
