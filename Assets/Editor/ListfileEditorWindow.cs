using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using UnityEditor;
using UnityEngine;

namespace IllusionMods.KoikatuModdingTools
{
    public class ListfileEditorWindow : EditorWindow
    {
        public enum CategoryNo
        {
            cha_sample_f,
            cha_sample_m,
            cha_eyeset,
            bodypaint_layout,
            cha_default_cos_f,
            cha_default_cos_m,
            cha_sample_voice,
            facepaint_layout,
            mole_layout,
            cha_sample_m_ex,
            bo_head = 100,
            bo_hair_b,
            bo_hair_f,
            bo_hair_s,
            bo_hair_o,
            co_top,
            co_bot,
            co_bra,
            co_shorts,
            co_gloves,
            co_panst,
            co_socks,
            co_shoes,
            ao_none = 120,
            ao_hair,
            ao_head,
            ao_face,
            ao_neck,
            ao_body,
            ao_waist,
            ao_leg,
            ao_arm,
            ao_hand,
            ao_kokan,
            cpo_sailor_a = 200,
            cpo_sailor_b,
            cpo_sailor_c,
            cpo_jacket_a = 210,
            cpo_jacket_b,
            cpo_jacket_c,
            mt_face_detail = 400,
            mt_eyeshadow,
            mt_cheek,
            mt_lip,
            mt_lipline,
            mt_face_paint,
            mt_eyebrow,
            mt_eye_white,
            mt_eye,
            mt_eye_gradation,
            mt_eye_hi_up,
            mt_eye_hi_down,
            mt_eyeline_up,
            mt_eyeline_down,
            mt_nose,
            mt_mole,
            face_preset,
            mt_body_detail = 420,
            mt_body_paint,
            mt_sunburn,
            mt_nip,
            mt_underhair,
            mt_pattern = 430,
            mt_emblem,
            mt_ramp,
            mt_hairgloss,
            ex_bo_body = 500,
            ex_bo_head,
            ex_bo_hair,
            ex_co_clothes,
            ex_co_shoes
        }

        private static readonly Dictionary<CategoryNo, CategoryDefinition> categoryColumnDefinitions = new Dictionary<CategoryNo, CategoryDefinition>
        {
            {CategoryNo.cha_sample_f, new CategoryDefinition(new[] {"0", "0"}, new[] {new ColumnInfo("IntTest", IntSanitizer), new ColumnInfo("StringTest", StringSanitizer)})},
            {CategoryNo.cha_sample_m, new CategoryDefinition(new[] {"0"}, new[] {new ColumnInfo("IntTest2", IntSanitizer), new ColumnInfo("StringTest2", StringSanitizer) })}
        };

        private static readonly string[] categoryListLookup = Enum.GetValues(typeof(CategoryNo)).Cast<CategoryNo>().Select(x => (int)x + " - " + x.ToString()).ToArray();
        private static readonly List<CategoryNo> categoryListLookup2 = Enum.GetValues(typeof(CategoryNo)).Cast<CategoryNo>().ToList();

        [SerializeField]
        private int categoryListPosition = -1;
        [SerializeField]
        private Vector2 scrollPosition;
        [SerializeField]
        private CategoryNo currentCategory = CategoryNo.cha_sample_m;
        [SerializeField]
        private CategoryDefinition currentDefinition;
        [SerializeField]
        private List<Row> currentRows = new List<Row>();
        [SerializeField]
        private List<string> currentMagicRows = new List<string>();

        [MenuItem("Window/ListFile Editor")]
        public static void ShowWindow()
        {
            GetWindow(typeof(ListfileEditorWindow));
        }

        // Use this for initialization
        private void Awake()
        {
            titleContent = new GUIContent("ListFile Editor");
            SetCategory(currentCategory);
        }

        private void OnGUI()
        {
            //GUILayout.BeginHorizontal(EditorStyles.toolbar);

            //todo a way to chose a file

            GUILayout.BeginHorizontal(GUI.skin.box);
            {
                GUILayout.Label("List file category", GUILayout.ExpandWidth(false));
                GUI.changed = false;
                categoryListPosition = EditorGUILayout.Popup(categoryListPosition, categoryListLookup);
                if (GUI.changed)
                    SetCategory(categoryListLookup2[categoryListPosition]);
            }
            GUILayout.EndHorizontal();

            if (currentDefinition == null)
            {
                GUILayout.Label("The selected listfile type is not supported");
                return;
            }

            var totalW = position.width;
            var hashW = 12;
            var spaceW = 20;
            var columnW = (int)((totalW - hashW) / currentDefinition.Columns.Length) - spaceW;

            GUILayout.BeginVertical(GUI.skin.box);
            {
                GUILayout.Label("Columns (contents of the listfile)");
                GUILayout.BeginHorizontal();
                {
                    GUILayout.Label("#", GUILayout.Width(hashW));
                    foreach (var column in currentDefinition.Columns)
                        GUILayout.Label(column.Name, GUILayout.Width(columnW));
                }
                GUILayout.EndHorizontal();
            }
            GUILayout.EndVertical();

            scrollPosition = GUILayout.BeginScrollView(scrollPosition, false, true);
            {
                for (var rowIndex = 0; rowIndex < currentRows.Count; rowIndex++)
                {
                    var row = currentRows[rowIndex];
                    GUILayout.BeginHorizontal(GUI.skin.box);
                    {
                        GUILayout.Label(rowIndex.ToString(), GUILayout.Width(hashW));
                        for (var rowContentIndex = 0; rowContentIndex < row.Contents.Count; rowContentIndex++)
                        {
                            GUI.changed = false;
                            var value = GUILayout.TextField(row.Contents[rowContentIndex], GUILayout.Width(columnW));
                            if (GUI.changed)
                            {
                                var valueSanitizer = currentDefinition.Columns[rowContentIndex].ValueSanitizer;
                                if (valueSanitizer != null)
                                    value = valueSanitizer(value);
                                row.Contents[rowContentIndex] = value;
                            }
                        }
                    }
                    GUILayout.EndHorizontal();
                }

                GUILayout.BeginHorizontal(GUI.skin.box);
                {
                    if (GUILayout.Button("Add row"))
                    {
                        var newRow = new Row();
                        SanitizeRow(newRow);
                        currentRows.Add(newRow);
                    }

                    GUI.enabled = currentRows.Count > 0;
                    if (GUILayout.Button("Remove last row"))
                        currentRows.RemoveAt(currentRows.Count - 1);
                    GUI.enabled = true;
                }
                GUILayout.EndHorizontal();
            }
            GUILayout.EndScrollView();

            GUILayout.Label(".csv contents:");
            GUI.changed = false;
            var csv = ToCsv();
            csv = GUILayout.TextArea(csv, GUILayout.ExpandHeight(true), GUILayout.ExpandWidth(true), GUILayout.MinHeight(70), GUILayout.MaxHeight(250));
            if (GUI.changed)
                FromCsv(csv);
        }

        private string ToCsv()
        {
            var sb = new StringBuilder();
            sb.AppendLine(((int)currentCategory).ToString(CultureInfo.InvariantCulture));

            while (currentMagicRows.Count > currentDefinition.MagicRows.Length) currentMagicRows.RemoveAt(currentMagicRows.Count - 1);
            while (currentMagicRows.Count < currentDefinition.MagicRows.Length) currentMagicRows.Add(currentDefinition.MagicRows[currentMagicRows.Count]);
            foreach (var magicRow in currentMagicRows)
                sb.AppendLine(magicRow);

            sb.AppendLine(string.Join(",", currentDefinition.Columns.Select(x => x.Name).ToArray()));

            foreach (var row in currentRows)
                sb.AppendLine(string.Join(",", row.Contents.ToArray()));

            return sb.ToString().Replace("\r\n", "\n");
        }

        private void FromCsv(string csv)
        {
            CategoryNo cat = 0;
            var magicRows = new List<string>();
            var rows = new List<Row>();

            var lines = csv.Trim().Split();
            Debug.LogWarning(lines.Length);
            for (var index = 0; index < lines.Length; index++)
            {
                var line = lines[index];

                if (index == 0)
                    cat = (CategoryNo)int.Parse(line);
                else if (index <= currentDefinition.MagicRows.Length)
                    magicRows.Add(line);
                // Category names
                else if (index == currentDefinition.MagicRows.Length + 1)
                    continue;
                else
                {
                    if (line.Trim().Length == 0) continue;

                    var row = new Row();
                    row.Contents.AddRange(line.Split(','));
                    SanitizeRow(row);
                    rows.Add(row);
                }
            }

            if (currentCategory != cat) SetCategory(cat);
            currentMagicRows = magicRows;
            currentRows = rows;
        }

        private void SetCategory(CategoryNo categoryNo)
        {
            currentCategory = categoryNo;
            categoryListPosition = categoryListLookup2.IndexOf(categoryNo);

            CategoryDefinition categoryDefinition;
            categoryColumnDefinitions.TryGetValue(categoryNo, out categoryDefinition);
            currentDefinition = categoryDefinition;

            if (currentDefinition != null)
            {
                foreach (var row in currentRows)
                    SanitizeRow(row);

                currentMagicRows = currentDefinition.MagicRows.ToList();
            }
            else
            {
                currentRows.Clear();
                currentMagicRows.Clear();
            }
        }

        private void SanitizeRow(Row row)
        {
            while (row.Contents.Count > currentDefinition.Columns.Length) row.Contents.RemoveAt(row.Contents.Count - 1);
            while (row.Contents.Count < currentDefinition.Columns.Length) row.Contents.Add(string.Empty);
            for (var index = 0; index < row.Contents.Count; index++)
            {
                var valueSanitizer = currentDefinition.Columns[index].ValueSanitizer;
                if (valueSanitizer != null)
                    row.Contents[index] = valueSanitizer(row.Contents[index]);
            }
        }

        private static string IntSanitizer(string value)
        {
            int result;
            int.TryParse(value, out result);
            return result.ToString(CultureInfo.InvariantCulture);
        }
        private static string StringSanitizer(string value)
        {
            return value != null ? value.Trim() : string.Empty;
        }

        public sealed class CategoryDefinition
        {
            public string[] MagicRows;
            public ColumnInfo[] Columns;

            public CategoryDefinition(string[] magicRows, ColumnInfo[] columns)
            {
                MagicRows = magicRows;
                Columns = columns;
            }
        }

        public sealed class ColumnInfo
        {
            public string Name;
            public Func<string, string> ValueSanitizer;

            public ColumnInfo(string name, Func<string, string> valueSanitizer)
            {
                Name = name;
                ValueSanitizer = valueSanitizer;
            }
        }

        [Serializable]
        public sealed class Row
        {
            [SerializeField]
            public List<string> Contents = new List<string>();
        }
    }
}
