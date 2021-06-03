//using System;
//using System.Collections.Generic;
//using System.Globalization;
//using System.IO;
//using System.Linq;
//using System.Text;

//namespace IllusionMods.KoikatuModdingTools.Lists
//{
//    public class MakerListFile
//    {
//        public CategoryNo Category;
//        public List<Dictionary<KeyType, string>> Data = new List<Dictionary<KeyType, string>>();
//        public FileInfo CSVFileInfo;

//        public MakerListFile(FileInfo file)
//        {
//            CSVFileInfo = file;
//            List<KeyType> keys = new List<KeyType>();

//            using (FileStream fs = file.OpenRead())
//            {
//                using (StreamReader sr = new StreamReader(fs))
//                {
//                    int counter = 0;
//                    while (!sr.EndOfStream)
//                    {
//                        string line = sr.ReadLine();

//                        if (counter == 0) //Category line
//                        {
//                            Category = (CategoryNo)int.Parse(line);
//                        }
//                        else if (counter == 1 || counter == 2) { }//Pointless lines
//                        else if (counter == 3) //Header line
//                        {
//                            foreach (string key in line.Trim().Split(','))
//                                keys.Add((KeyType)Enum.Parse(typeof(KeyType), key));
//                        }
//                        else //Data lines
//                        {
//                            if (string.IsNullOrEmpty(line)) continue;

//                            Dictionary<KeyType, string> lineData = new Dictionary<KeyType, string>();

//                            var lineSplit = line.Trim().Split(',');
//                            for (int i = 0; i < lineSplit.Length; i++)
//                                lineData[keys[i]] = lineSplit[i];

//                            Data.Add(lineData);
//                        }
//                        counter++;
//                    }
//                }
//            }
//        }

//        public void Save()
//        {
//            using (StreamWriter writer = new StreamWriter(CSVFileInfo.FullName))
//                writer.Write(GetCSVText());
//        }

//        public string GetCSVText()
//        {
//            var sb = new StringBuilder();
//            sb.AppendLine(((int)Category).ToString(CultureInfo.InvariantCulture));
//            sb.AppendLine("0");
//            sb.AppendLine("0");

//            List<string> keys = new List<string>();
//            foreach (var key in CategoryKeys)
//                keys.Add(key.ToString());
//            sb.AppendLine(string.Join(",", keys.ToArray()));

//            foreach (var line in Data)
//            {
//                List<string> lineData = new List<string>();
//                foreach (var category in CategoryKeys)
//                {
//                    string columnData;
//                    if (line.TryGetValue(category, out columnData))
//                        lineData.Add(Sanitize(category, columnData));
//                    else
//                        lineData.Add(Sanitize(category, ""));
//                }
//                sb.AppendLine(string.Join(",", lineData.ToArray()));
//            }

//            return sb.ToString().Replace("\r\n", "\n");
//        }

//        public void AddDataRow()
//        {
//            var newRow = new Dictionary<KeyType, string>();

//            foreach (var key in CategoryKeys)
//            {
//                DataType dataType;
//                if (KeyTypes.TryGetValue(key, out dataType))
//                    newRow[key] = Sanitize(dataType, "");
//            }
//            Data.Add(newRow);
//        }

//        public string GetNextID()
//        {
//            List<int> ids = new List<int> { 0 };

//            foreach (var x in Data)
//            {
//                var idString = x.Where(y => y.Key == KeyType.ID).Select(y => y.Value).FirstOrDefault();
//                int id;
//                if (int.TryParse(idString, out id))
//                    ids.Add(id);

//            }

//            return (ids.Max() + 1).ToString();
//        }

//        private string Sanitize(KeyType keyType, string input)
//        {
//            DataType dataType;
//            if (KeyTypes.TryGetValue(keyType, out dataType))
//                return Sanitize(dataType, input);
//            else
//                return Sanitize(DataType.String, input);
//        }

//        private string Sanitize(DataType dataType, string input)
//        {
//            if (dataType == DataType.Int)
//                return IntSanitizer(input);
//            else if (dataType == DataType.ID)
//                return IDSanitizer(input);
//            else if (dataType == DataType.Float)
//                return FloatSanitizer(input);
//            else if (dataType == DataType.Manifest)
//                return "";
//            else
//                return StringSanitizer(input);
//        }

//        /// <summary>
//        /// Get all the keys for the current category
//        /// </summary>
//        public KeyType[] CategoryKeys
//        {
//            get
//            {
//                KeyType[] categoryDefinition;
//                CategoryColumnDefinitions.TryGetValue(Category, out categoryDefinition);
//                return categoryDefinition;
//            }
//        }

//        private string IDSanitizer(string value)
//        {
//            int result;
//            if (int.TryParse(value, out result))
//                return result.ToString(CultureInfo.InvariantCulture);
//            else
//                return GetNextID();

//        }

//        private string IntSanitizer(string value)
//        {
//            int result;
//            int.TryParse(value, out result);
//            return result.ToString(CultureInfo.InvariantCulture);
//        }

//        private string FloatSanitizer(string value)
//        {
//            float result;
//            float.TryParse(value, out result);
//            return result.ToString(CultureInfo.InvariantCulture);
//        }

//        private string StringSanitizer(string value)
//        {
//            return value != null ? value.Trim() : string.Empty;
//        }

//        private static readonly Dictionary<CategoryNo, KeyType[]> CategoryColumnDefinitions = new Dictionary<CategoryNo, KeyType[]>
//        {
//            {CategoryNo.bodypaint_layout, new[] {KeyType.ID, KeyType.Kind, KeyType.Name, KeyType.PosX, KeyType.PosY, KeyType.Rot, KeyType.Scale, KeyType.CenterX, KeyType.MoveX, KeyType.CenterY, KeyType.MoveY, KeyType.CenterScale, KeyType.AddScale, KeyType.ThumbAB, KeyType.ThumbTex}},
//            {CategoryNo.facepaint_layout, new[] {KeyType.ID, KeyType.Kind, KeyType.Name, KeyType.PosX, KeyType.PosY, KeyType.Rot, KeyType.Scale, KeyType.ThumbAB, KeyType.ThumbTex}},
//            {CategoryNo.mole_layout, new[] {KeyType.ID, KeyType.Kind, KeyType.Name, KeyType.PosX, KeyType.PosY, KeyType.Rot, KeyType.Scale, KeyType.ThumbAB, KeyType.ThumbTex}},
//            {CategoryNo.bo_head, new[] {KeyType.ID, KeyType.Kind, KeyType.Possess, KeyType.Name, KeyType.MainManifest, KeyType.MainAB, KeyType.MainData, KeyType.ShapeAnime, KeyType.MatManifest, KeyType.MatData, KeyType.MainTexAB, KeyType.MainTex, KeyType.ColorMaskAB, KeyType.ColorMaskTex, KeyType.ThumbAB, KeyType.ThumbTex}},
//            {CategoryNo.bo_hair_b, new[] {KeyType.ID, KeyType.Kind, KeyType.Possess, KeyType.Name, KeyType.MainManifest, KeyType.MainAB, KeyType.MainData, KeyType.ThumbAB, KeyType.ThumbTex}},
//            {CategoryNo.bo_hair_f, new[] {KeyType.ID, KeyType.Kind, KeyType.Possess, KeyType.Name, KeyType.MainManifest, KeyType.MainAB, KeyType.MainData, KeyType.ThumbAB, KeyType.ThumbTex}},
//            {CategoryNo.bo_hair_s, new[] {KeyType.ID, KeyType.Kind, KeyType.Possess, KeyType.Name, KeyType.MainManifest, KeyType.MainAB, KeyType.MainData, KeyType.ThumbAB, KeyType.ThumbTex}},
//            {CategoryNo.bo_hair_o, new[] {KeyType.ID, KeyType.Kind, KeyType.Possess, KeyType.Name, KeyType.MainManifest, KeyType.MainAB, KeyType.MainData, KeyType.ThumbAB, KeyType.ThumbTex}},
//            {CategoryNo.co_top, new[] {KeyType.ID, KeyType.Kind, KeyType.Possess, KeyType.Name, KeyType.MainManifest, KeyType.MainAB, KeyType.MainData, KeyType.NormalData, KeyType.StateType, KeyType.Coordinate, KeyType.NotBra, KeyType.Sex, KeyType.OverBodyMaskAB, KeyType.OverBodyMask, KeyType.OverBraMaskAB, KeyType.OverBraMask, KeyType.MainTexAB, KeyType.MainTex, KeyType.ColorMaskAB, KeyType.ColorMaskTex, KeyType.MainTex02AB, KeyType.MainTex02, KeyType.ColorMask02AB, KeyType.ColorMask02Tex, KeyType.KokanHide, KeyType.ThumbAB, KeyType.ThumbTex}},

//            {CategoryNo.mt_face_paint, new[] {KeyType.ID, KeyType.Kind, KeyType.Possess, KeyType.Name, KeyType.MainAB, KeyType.PaintTex, KeyType.ThumbAB, KeyType.ThumbTex}},
//            {CategoryNo.mt_body_paint, new[] {KeyType.ID, KeyType.Kind, KeyType.Possess, KeyType.Name, KeyType.MainAB, KeyType.PaintTex, KeyType.ThumbAB, KeyType.ThumbTex}},
//            {CategoryNo.mt_emblem, new[] {KeyType.ID, KeyType.Kind, KeyType.Possess, KeyType.Name, KeyType.MainTexAB, KeyType.MainTex, KeyType.ThumbAB, KeyType.ThumbTex}},
//        };

//        private static readonly Dictionary<KeyType, DataType> KeyTypes = new Dictionary<KeyType, DataType>
//        {
//            {KeyType.AddScale, DataType.Float },
//            {KeyType.CenterScale, DataType.Float },
//            {KeyType.CenterX, DataType.Float },
//            {KeyType.CenterY, DataType.Float },
//            {KeyType.ID, DataType.ID },
//            {KeyType.ColorMaskTex, DataType.TextureAsset },
//            {KeyType.ColorMaskAB, DataType.AssetBundle },
//            {KeyType.ColorMask02Tex, DataType.TextureAsset },
//            {KeyType.ColorMask02AB, DataType.AssetBundle },
//            {KeyType.ColorMask03Tex, DataType.TextureAsset },
//            {KeyType.ColorMask03AB, DataType.AssetBundle },
//            {KeyType.Coordinate, DataType.Int },
//            {KeyType.Kind, DataType.Int },
//            {KeyType.KokanHide, DataType.Int },
//            {KeyType.MainAB, DataType.AssetBundle },
//            {KeyType.MainData, DataType.PrefabAsset },
//            {KeyType.MainManifest, DataType.Manifest },
//            {KeyType.MainTex, DataType.TextureAsset },
//            {KeyType.MainTexAB, DataType.AssetBundle },
//            {KeyType.MainTex02, DataType.TextureAsset },
//            {KeyType.MainTex02AB, DataType.AssetBundle },
//            {KeyType.MainTex03, DataType.TextureAsset },
//            {KeyType.MainTex03AB, DataType.AssetBundle },
//            {KeyType.MatData, DataType.MaterialAsset },
//            {KeyType.MatManifest, DataType.Manifest },
//            {KeyType.MoveX, DataType.Float },
//            {KeyType.MoveY, DataType.Float },
//            {KeyType.Name, DataType.String },
//            {KeyType.NormalData, DataType.String },
//            {KeyType.NotBra, DataType.Int },
//            {KeyType.OverBraMask, DataType.TextureAsset },
//            {KeyType.OverBraMaskAB, DataType.AssetBundle },
//            {KeyType.OverBodyMask, DataType.TextureAsset },
//            {KeyType.OverBodyMaskAB, DataType.AssetBundle },
//            {KeyType.Possess, DataType.Int },
//            {KeyType.PosX, DataType.Float },
//            {KeyType.PosY, DataType.Float },
//            {KeyType.Rot, DataType.Float },
//            {KeyType.Sex, DataType.Int },
//            {KeyType.ShapeAnime, DataType.Asset },
//            {KeyType.Scale, DataType.Float },
//            {KeyType.StateType, DataType.Int },
//            {KeyType.ThumbAB, DataType.AssetBundle },
//            {KeyType.ThumbTex, DataType.TextureAsset },
//        };

//        private enum DataType
//        {
//            ID,
//            Int,
//            String,
//            Float,
//            AssetBundle,
//            Asset,
//            PrefabAsset,
//            TextureAsset,
//            MaterialAsset,
//            Manifest,
//        }
//    }
//}
