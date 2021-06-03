//using IllusionMods.KoikatuModdingTools.Lists;
//using System;
//using System.Collections.Generic;
//using System.IO;
//using System.Linq;
//using UnityEditor;
//using UnityEngine;

//namespace IllusionMods.KoikatuModdingTools
//{
//    public static class MakerListfileEditor
//    {
//        public static MakerListFile makerListFile;
//        public static TextAssetEditor TextAssetEditorInstance;

//        public static void OnEnable(string path, TextAssetEditor instance)
//        {
//            TextAssetEditorInstance = instance;

//            makerListFile = new MakerListFile(new FileInfo(path));
//        }

//        public static void OnInspectorGUI()
//        {
//            GUI.enabled = true;

//            if (GUILayout.Button("Open List File Editor"))
//            {
//                ListfileEditorWindow window = (ListfileEditorWindow)EditorWindow.GetWindow(typeof(ListfileEditorWindow), false, "List File Editor");
//                window.Show();
//            }

//            GUILayout.Label(makerListFile.CSVFileInfo.Name);
//            GUI.enabled = false;
//            GUILayout.TextArea(makerListFile.GetCSVText(), GUILayout.ExpandHeight(true), GUILayout.ExpandWidth(true), GUILayout.MinHeight(70), GUILayout.MaxHeight(250));
//            GUI.enabled = true;
//        }
//    }

//    public class ListfileEditorWindow : EditorWindow
//    {
//        private static readonly string[] categoryListLookup = Enum.GetValues(typeof(CategoryNo)).Cast<CategoryNo>().Select(x => (int)x + " - " + x.ToString()).ToArray();
//        private static readonly List<CategoryNo> categoryListLookup2 = Enum.GetValues(typeof(CategoryNo)).Cast<CategoryNo>().ToList();

//        [SerializeField]
//        private static int categoryListPosition = -1;
//        [SerializeField]
//        private static Vector2 scrollPosition;

//        internal void OnEnable()
//        {
//            categoryListPosition = categoryListLookup2.IndexOf(MakerListfileEditor.makerListFile.Category);
//        }

//        internal void OnGUI()
//        {
//            GUILayout.BeginHorizontal(GUI.skin.box);
//            {
//                GUILayout.Label("List file category", GUILayout.ExpandWidth(false));
//                GUI.changed = false;
//                categoryListPosition = EditorGUILayout.Popup(categoryListPosition, categoryListLookup);
//                if (GUI.changed)
//                {
//                    MakerListfileEditor.makerListFile.Category = categoryListLookup2[categoryListPosition];
//                    MakerListfileEditor.makerListFile.Save();
//                }
//            }
//            GUILayout.EndHorizontal();

//            if (MakerListfileEditor.makerListFile.CategoryKeys == null)
//            {
//                GUILayout.Label("The selected listfile type is not supported");
//                return;
//            }

//            var totalW = position.width;
//            var hashW = 12;
//            var spaceW = 20;
//            var columnW = (int)((totalW - hashW) / MakerListfileEditor.makerListFile.CategoryKeys.Length) - spaceW;

//            GUILayout.BeginVertical(GUI.skin.box);
//            {
//                GUILayout.Label("Columns (contents of the listfile)");
//                GUILayout.BeginHorizontal();
//                {
//                    GUILayout.Label("#", GUILayout.Width(hashW));
//                    foreach (var column in MakerListfileEditor.makerListFile.CategoryKeys)
//                        GUILayout.Label(column.ToString(), GUILayout.Width(columnW));
//                }
//                GUILayout.EndHorizontal();
//            }
//            GUILayout.EndVertical();

//            scrollPosition = GUILayout.BeginScrollView(scrollPosition, false, true);
//            {
//                for (var rowIndex = 0; rowIndex < MakerListfileEditor.makerListFile.Data.Count; rowIndex++)
//                {
//                    var row = MakerListfileEditor.makerListFile.Data[rowIndex];
//                    GUILayout.BeginHorizontal(GUI.skin.box);
//                    {
//                        GUILayout.Label((rowIndex + 1).ToString(), GUILayout.Width(hashW));

//                        foreach (var key in MakerListfileEditor.makerListFile.CategoryKeys)
//                        {
//                            GUI.changed = false;
//                            string data;
//                            if (!row.TryGetValue(key, out data))
//                                data = "";
//                            var value = GUILayout.TextField(data, GUILayout.Width(columnW));
//                            if (GUI.changed)
//                            {
//                                row[key] = value;
//                                MakerListfileEditor.TextAssetEditorInstance.Repaint();
//                                MakerListfileEditor.makerListFile.Save();
//                            }
//                        }
//                    }
//                    GUILayout.EndHorizontal();
//                }

//                GUILayout.BeginHorizontal(GUI.skin.box);
//                {
//                    if (GUILayout.Button("Add row"))
//                    {
//                        MakerListfileEditor.makerListFile.AddDataRow();
//                        MakerListfileEditor.TextAssetEditorInstance.Repaint();
//                    }

//                    GUI.enabled = MakerListfileEditor.makerListFile.Data.Count > 0;
//                    if (GUILayout.Button("Remove last row"))
//                    {
//                        MakerListfileEditor.makerListFile.Data.RemoveAt(MakerListfileEditor.makerListFile.Data.Count - 1);
//                        MakerListfileEditor.TextAssetEditorInstance.Repaint();
//                        MakerListfileEditor.makerListFile.Save();
//                    }
//                    GUI.enabled = true;
//                }
//                GUILayout.EndHorizontal();
//            }
//            GUILayout.EndScrollView();
//        }
//    }
//}
