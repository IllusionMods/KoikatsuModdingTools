using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace IllusionMods.KoikatuModdingTools.Lists
{
    public class StudioItemListFile
    {
        public string FileName;
        public string Header = "ID,Group Number,Category Number,Name,Manifest,Bundle Path,File Name,Child Attachment Transform,Animation,Color 1,Pattern 1,Color 2,Pattern 2,Color 3,Pattern 3,Scaling,Emission,Glass";
        public Dictionary<int, StudioItemListData> Lines = new Dictionary<int, StudioItemListData>();

        public StudioItemListFile(FileInfo file)
        {
            FileName = file.Name;
            Init(file);
        }

        public StudioItemListFile(string file)
        {
            FileInfo fileInfo = new FileInfo(file);
            FileName = fileInfo.Name;
            Init(fileInfo);
        }

        private void Init(FileInfo file)
        {
            using (FileStream fs = file.OpenRead())
            {
                using (StreamReader sr = new StreamReader(fs))
                {
                    int counter = 0;
                    bool skippedHeader = false;
                    while (!sr.EndOfStream)
                    {
                        counter++;
                        if (!skippedHeader)
                        {
                            skippedHeader = true;
                            sr.ReadLine();
                            continue;
                        }

                        string line = sr.ReadLine();
                        StudioItemListData itemListInfo = new StudioItemListData(line, counter);
                        Lines[itemListInfo.ID] = itemListInfo;
                    }
                }
            }
        }

        public void WriteBoneList(string path, bool smrOnly = true)
        {
            string[] fileNameSplit = FileName.Replace(".csv", "").Split('_');
            string fileName = "ItemBoneList_" + fileNameSplit[2] + "_" + fileNameSplit[3] + ".csv";

            StringBuilder sb = new StringBuilder();
            sb.AppendLine("ID,Bones");

            foreach (var data in Lines.Values.OrderBy(x => x.Order))
            {
                List<string> list;
                if (smrOnly)
                    list = data.BoneList;
                else
                    list = data.TransformList;

                if (list.Count > 0)
                {
                    List<string> boneList = new List<string>();
                    boneList.Add(data.ID.ToString());
                    foreach (var bone in list)
                    {
                        if (!boneList.Contains(bone))
                            boneList.Add(bone);
                    }
                    string csv = string.Join(",", boneList.ToArray());
                    sb.AppendLine(csv);
                }
            }

            if (File.Exists(Path.Combine(path, fileName)))
                fileName = fileName.Replace(".csv", "_generated.csv");
            using (StreamWriter writer = new StreamWriter(Path.Combine(path, fileName)))
                writer.Write(sb.ToString());
        }
    }

    public class StudioItemListData
    {
        public int Order;
        public int ID;
        public int Group;
        public int Category;
        public string Name;
        public string Manifest;
        public string BundlePath;
        public string FileName;
        public string ChildRoot;
        public bool Animation;
        public bool[] Color;
        public bool[] Pattern;
        public bool Scale;
        public bool Emission;
        public bool Glass;
        public List<string> BoneList = new List<string>();
        public List<string> TransformList = new List<string>();

        public StudioItemListData() { }

        public StudioItemListData(string line, int order = 0)
        {
            Order = order;
            Init(line.Split(',').ToList());
        }

        public StudioItemListData(List<string> line, int order = 0)
        {
            Order = order;
            Init(line);
        }

        private void Init(List<string> line)
        {
            ID = int.Parse(line[0]);
            Group = int.Parse(line[1]);
            Category = int.Parse(line[2]);
            Name = line[3];
            Manifest = "";
            BundlePath = line[5];
            FileName = line[6];
            ChildRoot = line[7];
            Animation = bool.Parse(line[8]);
            Color = new bool[3]
            {
                    bool.Parse(line[9]),
                    bool.Parse(line[11]),
                    bool.Parse(line[13])
            };
            Pattern = new bool[3]
            {
                    bool.Parse(line[10]),
                    bool.Parse(line[12]),
                    bool.Parse(line[14])
            };
            Scale = bool.Parse(line[15]);
            bool.TryParse(line.SafeGet(16), out Emission);
            bool.TryParse(line.SafeGet(17), out Glass);
        }
    }
}
