using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;
using YamlDotNet.RepresentationModel;

namespace IllusionMods.KoikatuModdingTools
{
    /// <summary>
    /// For use on assets dumped by uTinyRipper. Replaces references to the imported scripts and shaders with the matching ones in KoikatuModdingTools and then removes them.
    /// </summary>
    internal class AssetBundleImport : AssetPostprocessor
    {
        //FileName/GUID
        private static readonly Dictionary<string, string> Scripts = new Dictionary<string, string>();
        private static readonly Dictionary<string, string> Shaders = new Dictionary<string, string>();

        static AssetBundleImport()
        {
            PopulateDictionaries("Script", Constants.ScriptsPath, Scripts);
            PopulateDictionaries("Shader", Constants.ShadersPath, Shaders);
        }

        private static void PopulateDictionaries(string objectType, string fileFolder, Dictionary<string, string> fileDictionary)
        {
            foreach (var assetguid in AssetDatabase.FindAssets("t:" + objectType, new string[] { fileFolder }))
                fileDictionary[FormatFileName(AssetDatabase.GUIDToAssetPath(assetguid))] = assetguid;
        }

        private static string FormatFileName(string fileName)
        {
            return Path.GetFileName(fileName).Replace("_", "").Replace(" ", "");
        }

        private static void OnPostprocessAllAssets(string[] importedAssets, string[] deletedAssets, string[] movedAssets, string[] movedFromAssetPaths)
        {
            //FileName/GUID
            Dictionary<string, string> importedScripts = new Dictionary<string, string>();
            Dictionary<string, string> importedShaders = new Dictionary<string, string>();
            List<string> importedPrefabs = new List<string>();
            List<string> importedMaterials = new List<string>();

            foreach (var importedAsset in importedAssets)
            {
                //Parse the imported script or shader's .meta file to find the GUID
                if (importedAsset.EndsWith(".cs") || importedAsset.EndsWith(".shader"))
                {
                    var file = new FileInfo(importedAsset + ".meta");
                    using (var reader = new StreamReader(file.FullName))
                    {
                        YamlStream yaml = new YamlStream();
                        yaml.Load(reader);
                        string guid = FindGUID(yaml);

                        if (guid != "")
                        {
                            if (importedAsset.EndsWith(".cs"))
                                importedScripts[importedAsset] = guid;
                            else if (importedAsset.EndsWith(".shader"))
                                importedShaders[importedAsset] = guid;
                        }
                    }
                }
                else if (importedAsset.EndsWith(".prefab"))
                    importedPrefabs.Add(importedAsset);
                else if (importedAsset.EndsWith(".mat"))
                    importedMaterials.Add(importedAsset);
            }

            bool replacedScripts = ReplaceReferences(importedScripts, importedPrefabs, Scripts);
            bool replacedShaders = ReplaceReferences(importedShaders, importedMaterials, Shaders);
            if (replacedScripts || replacedShaders)
                Debug.Log("Replaced references and removed duplicates for imported assets.");
        }

        /// <summary>
        /// Replace references in imported files
        /// </summary>
        /// <param name="importedAssets">Dictionary of file path, GUID of assets that were imported</param>
        /// <param name="importedFiles">Imported files that should be have their references replaced</param>
        /// <param name="existingAssets">Dictionary of file path, GUID of existing assets</param>
        private static bool ReplaceReferences(Dictionary<string, string> importedAssets, List<string> importedFiles, Dictionary<string, string> existingAssets)
        {
            List<string> matchedFiles = new List<string>();
            Dictionary<string, string> importDictionary = new Dictionary<string, string>();

            //Match the imported GUIDs to existing GUIDs based on file name
            foreach (var importedAsset in importedAssets)
            {
                string importedFile = importedAsset.Key;
                string importedGUID = importedAsset.Value;
                string existingGUID;
                if (importedFile.Replace("/", @"\").Contains(Constants.ModsPath) || importedFile.Replace("/", @"\").Contains(Constants.ExamplesPath))
                {
                    if (existingAssets.TryGetValue(FormatFileName(importedFile), out existingGUID))
                    {
                        importDictionary[importedGUID] = existingGUID;
                        if (!matchedFiles.Contains(importedFile))
                            matchedFiles.Add(importedFile);
                    }
                }
            }

            if (importDictionary.Count > 0)
            {
                foreach (var file in importedFiles)
                {
                    using (StreamReader reader = new StreamReader(File.OpenRead(file)))
                    using (StreamWriter writer = new StreamWriter(File.Open(file + "2", FileMode.Create)))
                    {
                        string line;
                        while ((line = reader.ReadLine()) != null)
                        {
                            foreach (var kvp in importDictionary)
                                line = line.Replace(kvp.Key, kvp.Value);
                            writer.WriteLine(line);
                        }
                    }

                    File.Delete(file);
                    File.Move(file + "2", file);
                }
            }

            //Remove any assets that have an existing version now that the references have been replaced
            foreach (var file in matchedFiles)
            {
                if (File.Exists(file))
                    File.Delete(file);
                if (File.Exists(file + ".meta"))
                    File.Delete(file + ".meta");

                //Delete the Scripts or Shader folder if it is now empty
                if (file.Contains("Scripts/"))
                    CheckDeleteDirectory(file, "Scripts");
                if (file.Contains("Shader/"))
                    CheckDeleteDirectory(file, "Shader");
            }

            if (matchedFiles.Count > 0)
                return true;
            return false;
        }

        /// <summary>
        /// Check if the folder is empty of all but .meta files and delete it if so
        /// </summary>
        /// <param name="file">File to parse to get the directory</param>
        /// <param name="folder">Folder to delete, which contains the file</param>
        private static void CheckDeleteDirectory(string file, string folder)
        {
            string dir = file.Substring(0, file.IndexOf(folder + "/") + folder.Length);
            DirectoryInfo di = new DirectoryInfo(dir);

            int fileCount = 0;
            foreach (var fi in di.GetFiles("*", SearchOption.AllDirectories))
                if (!fi.FullName.EndsWith(".meta"))
                    fileCount++;

            if (fileCount == 0)
            {
                if (File.Exists(di.FullName + ".meta"))
                    File.Delete(di.FullName + ".meta");
                if (di.Exists)
                    di.Delete(true);
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
