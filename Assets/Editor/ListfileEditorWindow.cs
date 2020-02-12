using IllusionMods.KoikatuModdingTools.Lists;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEditor;
using UnityEngine;

namespace IllusionMods.KoikatuModdingTools
{
    [CustomEditor(typeof(TextAsset))]
    public class CSVEditor : Editor
    {
        public static MakerListFile makerListFile;
        public static CSVEditor instance;

        internal void OnEnable()
        {
            instance = this;
            string path = AssetDatabase.GetAssetPath(target);
            if (path.ToLower().Contains("list/maker/") && path.ToLower().EndsWith(".csv"))
                makerListFile = new MakerListFile(new FileInfo(path));
            else
                makerListFile = null;
        }

        public override void OnInspectorGUI()
        {
            if (makerListFile != null)
            {
                CSVInspectorGUI();
                base.OnInspectorGUI();
            }
            else
            {
                base.OnInspectorGUI();
            }
        }

        private void CSVInspectorGUI()
        {
            GUI.enabled = true;

            if (GUILayout.Button("Open List File Editor"))
            {
                ListfileEditorWindow window = (ListfileEditorWindow)EditorWindow.GetWindow(typeof(ListfileEditorWindow), false, "List File Editor");
                window.Show();
            }

            GUILayout.Label(makerListFile.CSVFileInfo.Name);
            GUI.enabled = false;
            GUILayout.TextArea(makerListFile.GetCSVText(), GUILayout.ExpandHeight(true), GUILayout.ExpandWidth(true), GUILayout.MinHeight(70), GUILayout.MaxHeight(250));
            GUI.enabled = true;
        }
    }

    public class ListfileEditorWindow : EditorWindow
    {
        private static readonly string[] categoryListLookup = Enum.GetValues(typeof(CategoryNo)).Cast<CategoryNo>().Select(x => (int)x + " - " + x.ToString()).ToArray();
        private static readonly List<CategoryNo> categoryListLookup2 = Enum.GetValues(typeof(CategoryNo)).Cast<CategoryNo>().ToList();

        [SerializeField]
        private static int categoryListPosition = -1;
        [SerializeField]
        private static Vector2 scrollPosition;

        internal void OnEnable()
        {
            categoryListPosition = categoryListLookup2.IndexOf(CSVEditor.makerListFile.Category);
        }

        internal void OnGUI()
        {
            GUILayout.BeginHorizontal(GUI.skin.box);
            {
                GUILayout.Label("List file category", GUILayout.ExpandWidth(false));
                GUI.changed = false;
                categoryListPosition = EditorGUILayout.Popup(categoryListPosition, categoryListLookup);
                if (GUI.changed)
                {
                    CSVEditor.makerListFile.Category = categoryListLookup2[categoryListPosition];
                    CSVEditor.makerListFile.Save();
                }
            }
            GUILayout.EndHorizontal();

            if (CSVEditor.makerListFile.CategoryKeys == null)
            {
                GUILayout.Label("The selected listfile type is not supported");
                return;
            }

            var totalW = position.width;
            var hashW = 12;
            var spaceW = 20;
            var columnW = (int)((totalW - hashW) / CSVEditor.makerListFile.CategoryKeys.Length) - spaceW;

            GUILayout.BeginVertical(GUI.skin.box);
            {
                GUILayout.Label("Columns (contents of the listfile)");
                GUILayout.BeginHorizontal();
                {
                    GUILayout.Label("#", GUILayout.Width(hashW));
                    foreach (var column in CSVEditor.makerListFile.CategoryKeys)
                        GUILayout.Label(column.ToString(), GUILayout.Width(columnW));
                }
                GUILayout.EndHorizontal();
            }
            GUILayout.EndVertical();

            scrollPosition = GUILayout.BeginScrollView(scrollPosition, false, true);
            {
                for (var rowIndex = 0; rowIndex < CSVEditor.makerListFile.Data.Count; rowIndex++)
                {
                    var row = CSVEditor.makerListFile.Data[rowIndex];
                    GUILayout.BeginHorizontal(GUI.skin.box);
                    {
                        GUILayout.Label((rowIndex + 1).ToString(), GUILayout.Width(hashW));

                        foreach (var key in CSVEditor.makerListFile.CategoryKeys)
                        {
                            GUI.changed = false;
                            string data;
                            if (!row.TryGetValue(key, out data))
                                data = "";
                            var value = GUILayout.TextField(data, GUILayout.Width(columnW));
                            if (GUI.changed)
                            {
                                row[key] = value;
                                CSVEditor.instance.Repaint();
                                CSVEditor.makerListFile.Save();
                            }
                        }
                    }
                    GUILayout.EndHorizontal();
                }

                GUILayout.BeginHorizontal(GUI.skin.box);
                {
                    if (GUILayout.Button("Add row"))
                    {
                        CSVEditor.makerListFile.AddDataRow();
                        CSVEditor.instance.Repaint();
                    }

                    GUI.enabled = CSVEditor.makerListFile.Data.Count > 0;
                    if (GUILayout.Button("Remove last row"))
                    {
                        CSVEditor.makerListFile.Data.RemoveAt(CSVEditor.makerListFile.Data.Count - 1);
                        CSVEditor.instance.Repaint();
                        CSVEditor.makerListFile.Save();
                    }
                    GUI.enabled = true;
                }
                GUILayout.EndHorizontal();
            }
            GUILayout.EndScrollView();
        }
    }
}
