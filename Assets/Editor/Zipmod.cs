using Ionic.Zip;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Xml.Linq;
using UnityEditor;
using Debug = UnityEngine.Debug;

namespace IllusionMods.KoikatuModdingTools
{
    public static class Zipmod
    {
        private static string KoikatsuPath;
        private static bool CopyMods;

        public static void BuildSingleMod(string koikatsuPath, bool copyMods, bool testMod = false)
        {
            KoikatsuPath = koikatsuPath;
            CopyMods = copyMods;

            var manifestPath = Shared.GetManifestFilePath();
            if (manifestPath == null)
            {
                Debug.Log("manifest.xml does not exist in the directory, mod creation aborted.");
                return;
            }

            string projectPath = manifestPath.Replace(@"\manifest.xml", "");
            if (BuildSingleModInternal(projectPath, testMod))
                Debug.Log("Mod built successfully.");
        }

        public static void CleanUpTestMod(string koikatsuPath)
        {
            KoikatsuPath = koikatsuPath;

            var manifestPath = Shared.GetManifestFilePath();
            if (manifestPath == null)
            {
                Debug.Log("manifest.xml does not exist in the directory, mod clean up aborted.");
                return;
            }

            string projectPath = manifestPath.Replace(@"\manifest.xml", "");
            CleanUpTestModInternal(projectPath);
        }

        /// <summary>
        /// Pack up all mods including their manifest.xml, list files, and asset bundles.
        /// </summary>
        /// <param name="buildPath"></param>
        public static void BuildAllMods(string koikatsuPath, bool copyMods)
        {
            KoikatsuPath = koikatsuPath;
            CopyMods = copyMods;

            bool success = true;
            int count = 0;
            var di = new DirectoryInfo(Constants.ModsPath);
            foreach (var file in di.GetFiles("manifest.xml", SearchOption.AllDirectories))
            {
                string projectPath = file.Directory.FullName;
                projectPath = projectPath.Substring(projectPath.IndexOf(Constants.ModsPath));
                bool built = BuildSingleModInternal(projectPath);
                if (built)
                    count++;
                else
                    success = false;
            }

            if (count == 0)
                Debug.Log("No mods were built.");
            else if (success)
            {
                string s = " was";
                if (count > 1)
                    s = "s were";

                Debug.Log(count + " mod" + s + " built successfully.");
            }
        }

        /// <summary>
        /// Packs up a mod including its manifest.xml, list files, and asset bundles. Copies the mod to the user's install folder.
        /// </summary>
        /// <param name="projectPath">Path of the project containing the mod, manifest.xml should be in the root.</param>
        /// <param name="testMod">Whether the asset bundles will be included in the zipmod. If false, zipmod will be build with no asset bundles and asset bundles will be copied to the game folder.</param>
        private static bool BuildSingleModInternal(string projectPath, bool testMod = false)
        {
            string manifestPath = Path.Combine(projectPath, "manifest.xml");
            string makerListPath = Path.Combine(projectPath, @"List\Maker");
            string studioListPath = Path.Combine(projectPath, @"List\Studio");
            string mapListPath = Path.Combine(projectPath, @"List\Map");
            bool exampleMod = manifestPath.Contains("Examples");

            HashSet<string> modABs = new HashSet<string>();
            HashSet<string> makerListFiles = new HashSet<string>();
            HashSet<string> studioListFiles = new HashSet<string>();
            HashSet<string> mapListFiles = new HashSet<string>();

            if (!File.Exists(manifestPath))
            {
                Debug.Log("manifest.xml does not exist in the directory, mod creation aborted.");
                return false;
            }

            //Read the manifest.xml
            XDocument manifestDocument = XDocument.Load(manifestPath);
            string modGUID = manifestDocument.Root.Element("guid").Value;
            string modName = "";
            string modVersion = "";
            string modAuthor = "";
            string modGame = "";
            if (manifestDocument.Root.Element("name") != null)
                modName = manifestDocument.Root.Element("name").Value;
            if (manifestDocument.Root.Element("version") != null)
                modVersion = manifestDocument.Root.Element("version").Value;
            if (manifestDocument.Root.Element("author") != null)
                modAuthor = manifestDocument.Root.Element("author").Value;
            if (manifestDocument.Root.Element("game") != null)
                modGame = manifestDocument.Root.Element("game").Value;

            if (modGame != "")
            {
                if (!Constants.GameNameList.Contains(modGame.ToLower().Replace("!", "")))
                {
                    Debug.Log("The manifest.xml lists a game other than Koikatsu, this mod will not be built.");
                    return false;
                }
                else
                    modGame = "KK";
            }

            //Create a name for the .zipmod based on manifest.xml
            string zipFileName = "";
            if (modAuthor != "" && modName != "")
            {
                if (modAuthor != "")
                    zipFileName += "[" + modAuthor + "]";
                if (modGame != "")
                    zipFileName += "[" + modGame + "]";
                if (modName != "")
                    zipFileName += modName;
            }
            else
                zipFileName = modGUID;
            string zipFileNamePrexix = zipFileName;
            if (modVersion != "")
                zipFileName += " v" + modVersion;
            zipFileName += ".zipmod";
            string zipPath = Path.Combine(Constants.BuildPath, zipFileName);

            //Find all the asset bundles for this mod
            foreach (var assetguid in AssetDatabase.FindAssets("", new string[] { projectPath }))
            {
                string assetPath = AssetDatabase.GUIDToAssetPath(assetguid);
                string modAB = AssetDatabase.GetImplicitAssetBundleName(assetPath);
                if (modAB != string.Empty)
                    modABs.Add(Path.Combine(Constants.BuildPath, modAB));
            }

            var di = new DirectoryInfo(makerListPath);
            if (di.Exists)
                foreach (var file in di.GetFiles("*.csv", SearchOption.AllDirectories))
                    makerListFiles.Add(file.FullName);

            di = new DirectoryInfo(studioListPath);
            if (di.Exists)
                foreach (var file in di.GetFiles("*.csv", SearchOption.AllDirectories))
                    studioListFiles.Add(file.FullName);

            di = new DirectoryInfo(mapListPath);
            if (di.Exists)
                foreach (var file in di.GetFiles("*.csv", SearchOption.AllDirectories))
                    mapListFiles.Add(file.FullName);

            //Build the zip file
            File.Delete(zipPath);
            ZipFile zipFile = new ZipFile(zipPath, Encoding.UTF8);
            zipFile.CompressionLevel = Ionic.Zlib.CompressionLevel.None;

            //Add the manifest
            zipFile.AddFile(manifestPath, "");

            //Add asset bundles
            if (!testMod)
            {
                foreach (var modAB in modABs)
                {
                    string folderAB = modAB.Replace("/", @"\").Replace(@"Build\", "");
                    folderAB = folderAB.Remove(folderAB.LastIndexOf(@"\")); //Remove the .unity3d filename
                    zipFile.AddFile(modAB, folderAB);
                }
            }

            //Add list files
            foreach (var listFile in makerListFiles)
                zipFile.AddFile(listFile, @"abdata\list\characustom\" + modAuthor.ToLower() + @"\");

            //Add Studio list files
            foreach (var listFile in studioListFiles)
            {
                FileInfo listFileInfo = new FileInfo(listFile);
                string listFolder = @"abdata\studio\info\" + ReplaceInvalidChars(modGUID.ToLower().Replace(".", "_")) + @"\" + listFileInfo.Directory.Name;
                zipFile.AddFile(listFile, listFolder);
            }

            //Add map list files
            foreach (var listFile in mapListFiles)
                zipFile.AddFile(listFile, @"abdata\map\list\mapinfo\");

            zipFile.Save();
            zipFile.Dispose();

            if (CopyMods)
            {
                var modsFolder = Path.Combine(KoikatsuPath, "mods");
                var examplesFolder = Path.Combine(modsFolder, "KoikatsuModdingTools Examples");
                string copyPath;
                if (exampleMod)
                    copyPath = Path.Combine(examplesFolder, zipFileName);
                else
                    copyPath = Path.Combine(modsFolder, zipFileName);

                di = new DirectoryInfo(modsFolder);
                if (di.Exists)
                {
                    foreach (var file in di.GetFiles("*.zipmod"))
                        if (file.Name.StartsWith(zipFileNamePrexix))
                            try
                            {
                                file.Delete();
                            }
                            catch (IOException)
                            {
                                if (!testMod)
                                {
                                    Debug.Log("Could not copy mod, likely file is in use. Close the game before copying.");
                                    return false;
                                }
                            }

                    if (exampleMod)
                    {
                        var examplesFolderDirectory = new DirectoryInfo(examplesFolder);
                        examplesFolderDirectory.Create();
                        foreach (var file in examplesFolderDirectory.GetFiles("*.zipmod"))
                            if (file.Name.StartsWith(zipFileNamePrexix))
                                try
                                {
                                    file.Delete();
                                }
                                catch (IOException)
                                {
                                    if (!testMod)
                                    {
                                        Debug.Log("Could not copy mod, likely file is in use. Close the game before copying.");
                                        return false;
                                    }
                                }
                    }
                    try
                    {
                        File.Copy(zipPath, copyPath);
                    }
                    catch (IOException)
                    {
                        if (!testMod)
                        {
                            Debug.Log("Could not copy mod, likely file is in use. Close the game before copying.");
                            return false;
                        }
                    }
                }
                else
                {
                    Debug.Log("Mods folder not found, could not copy .zipmod files to game install.");
                    return false;
                }

                //Copy asset bundles
                if (testMod)
                {
                    foreach (var modAB in modABs)
                    {
                        FileInfo sourceFileInfo = new FileInfo(modAB);
                        FileInfo destinationFileInfo = new FileInfo(Path.Combine(KoikatsuPath, modAB.Replace(Constants.BuildPath, "abdata")));

                        destinationFileInfo.Directory.Create();
                        File.Copy(sourceFileInfo.FullName, destinationFileInfo.FullName, true);
                    }
                }
            }
            return true;
        }

        private static void CleanUpTestModInternal(string projectPath)
        {
            HashSet<string> modABs = new HashSet<string>();

            //Find all the asset bundles for this mod
            foreach (var assetguid in AssetDatabase.FindAssets("", new string[] { projectPath }))
            {
                string assetPath = AssetDatabase.GUIDToAssetPath(assetguid);
                string modAB = AssetDatabase.GetImplicitAssetBundleName(assetPath);
                if (modAB != string.Empty)
                    modABs.Add(Path.Combine(Constants.BuildPath, modAB));
            }

            //Copy asset bundles
            foreach (var modAB in modABs)
            {
                FileInfo destinationFileInfo = new FileInfo(Path.Combine(KoikatsuPath, modAB.Replace(Constants.BuildPath, "abdata")));
                Debug.Log("Removing " + destinationFileInfo.FullName);
                File.Delete(destinationFileInfo.FullName);
            }
        }

        public static string ReplaceInvalidChars(string filename)
        {
            return string.Join("_", filename.Split(Path.GetInvalidFileNameChars()));
        }
    }
}
