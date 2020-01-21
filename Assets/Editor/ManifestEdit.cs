//Code adapted from https://answers.unity.com/questions/1167941/writing-a-custom-inspector-for-a-filetype.html
using System;
using System.Xml.Linq;
using UnityEditor;
using UnityEngine;

namespace IllusionMods.KoikatuModdingTools
{
    [InitializeOnLoad]
    public class ManifestFileGlobal
    {
        private static ManifestFileWrapper wrapper = null;
        private static bool selectionChanged = false;

        static ManifestFileGlobal()
        {
            Selection.selectionChanged += SelectionChanged;
            EditorApplication.update += Update;
        }

        private static void SelectionChanged()
        {
            selectionChanged = true;
            // can't do the wrapper stuff here. it does not work 
            // when you Selection.activeObject = wrapper
            // so do it in Update
        }

        private static void Update()
        {
            if (selectionChanged == false) return;

            selectionChanged = false;
            if (Selection.activeObject != wrapper)
            {
                string fn = AssetDatabase.GetAssetPath(Selection.activeInstanceID);
                if (fn.ToLower().EndsWith("manifest.xml"))
                {
                    if (wrapper == null)
                    {
                        wrapper = ScriptableObject.CreateInstance<ManifestFileWrapper>();
                        wrapper.hideFlags = HideFlags.DontSave;
                    }

                    wrapper.fileName = fn;
                    Selection.activeObject = wrapper;

                    Editor[] ed = Resources.FindObjectsOfTypeAll<ManifestFileWrapperInspector>();
                    if (ed.Length > 0) ed[0].Repaint();
                }
            }
        }
    }

    public class ManifestFileWrapper : ScriptableObject
    {
        [NonSerialized] public string fileName; // path is relative to Assets/
    }

    [CustomEditor(typeof(ManifestFileWrapper))]
    public class ManifestFileWrapperInspector : Editor
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
            ManifestFileWrapper Target = (ManifestFileWrapper)target;
            filename = Target.fileName;

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
            GUILayout.Label("Editing: " + filename);

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
