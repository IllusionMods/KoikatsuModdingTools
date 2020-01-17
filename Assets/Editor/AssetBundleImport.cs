using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using UnityEditor;
using UnityEngine;
using YamlDotNet.RepresentationModel;

namespace IllusionMods.KoikatuModdingTools
{
    static class AssetBundleImport
    {
        private static string ImportFolder = "";

        public static void Import(string importFolder)
        {
            ImportFolder = importFolder;
            ReplaceReferences(".cs", "Script", Constants.ScriptsPath, ".prefab");
            ReplaceReferences(".shader", "Shader", Constants.ShadersPath, ".mat");

            Debug.Log("Finished replacing references in files.");
        }

        private static void ReplaceReferences(string fileType, string objectType, string fileFolder, string targetFileType)
        {
            Dictionary<string, string> fileGUIDDictionary = new Dictionary<string, string>();
            foreach (var assetguid in AssetDatabase.FindAssets("t:" + objectType, new string[] { fileFolder }))
            {
                var assetPath = AssetDatabase.GUIDToAssetPath(assetguid);
                FileInfo fi = new FileInfo(assetPath);
                string fileName = fi.Name.Replace("_", "").Replace(" ", "");
                fileGUIDDictionary[fileName] = assetguid;
            }


            Dictionary<string, string> importDictionary = new Dictionary<string, string>();
            DirectoryInfo di = new DirectoryInfo(ImportFolder);
            foreach (var file in di.GetFiles("*" + fileType + ".meta", SearchOption.AllDirectories))
            {
                var reader = new StreamReader(file.FullName);
                YamlStream yaml = new YamlStream();
                yaml.Load(reader);
                string guid = FindGUID(yaml);

                if (guid != "")
                {
                    string fileName = file.Name;
                    Debug.Log(fileName);
                    fileName = Regex.Replace(fileName, @"_[0-9]+", "");
                    Debug.Log(fileName);
                    fileName = fileName.Replace(".meta", "").Replace("_", "").Replace(" ", "");
                    string newGUID;
                    if (fileGUIDDictionary.TryGetValue(fileName, out newGUID))
                        importDictionary[guid] = newGUID;
                }
            }

            foreach (var file in di.GetFiles("*" + targetFileType, SearchOption.AllDirectories))
            {
                string fileName = file.FullName;

                using (StreamReader reader = new StreamReader(File.OpenRead(file.FullName)))
                using (StreamWriter writer = new StreamWriter(File.Open(file.FullName + "2", FileMode.Create)))
                {
                    string line;
                    while ((line = reader.ReadLine()) != null)
                    {
                        foreach (var kvp in importDictionary)
                            line = line.Replace(kvp.Key, kvp.Value);
                        writer.WriteLine(line);
                    }
                }

                File.Delete(fileName);
                File.Move(fileName + "2", fileName);
            }
        }


        private static string FindGUID(YamlStream stream)
        {
            foreach (YamlDocument doc in stream.Documents)
            {
                var node = (YamlMappingNode)doc.RootNode;
                foreach (var child in node.Children)
                    if (child.Key.ToString() == "guid")
                        return child.Value.ToString();
            }
            return "";
        }
    }
}
