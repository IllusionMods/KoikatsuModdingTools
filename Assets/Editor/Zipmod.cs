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
        private static string BuildPath;
        private static string KoikatsuPath;
        private static bool CopyMods;

        public static void BuildSingleMod(string buildPath, string koikatsuPath, bool copyMods)
        {
            BuildPath = buildPath;
            KoikatsuPath = koikatsuPath;
            CopyMods = copyMods;

            string projectPath = Shared.GetProjectPath();
            if (BuildSingleModInternal(projectPath))
                Debug.Log("Mod built sucessfully.");
        }

        /// <summary>
        /// Pack up all mods including their manifest.xml, list files, and asset bundles.
        /// </summary>
        /// <param name="buildPath"></param>
        public static void BuildAllMods(string buildPath, string koikatsuPath, bool copyMods)
        {
            BuildPath = buildPath;
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

                Debug.Log(count + " mod" + s + " built sucessfully.");
            }
        }

        /// <summary>
        /// Packs up a mod including its manifest.xml, list files, and asset bundles. Copies the mod to the user's install folder.
        /// </summary>
        /// <param name="projectPath">Path of the project containing the mod, manifest.xml should be in the root.</param>
        private static bool BuildSingleModInternal(string projectPath)
        {
            string manifestPath = Path.Combine(projectPath, "manifest.xml");
            string makerListPath = Path.Combine(projectPath, @"List\Maker");
            string studioListPath = Path.Combine(projectPath, @"List\Studio");

            HashSet<string> modABs = new HashSet<string>();
            HashSet<string> makerListFiles = new HashSet<string>();
            HashSet<string> studioListFiles = new HashSet<string>();

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
            string zipPath = Path.Combine("Build", zipFileName);

            //Find all the asset bundles for this mod
            foreach (var assetguid in AssetDatabase.FindAssets("", new string[] { projectPath }))
            {
                string assetPath = AssetDatabase.GUIDToAssetPath(assetguid);
                string modAB = AssetDatabase.GetImplicitAssetBundleName(assetPath);
                if (modAB != string.Empty)
                    modABs.Add(Path.Combine(BuildPath, modAB));
            }

            var di = new DirectoryInfo(makerListPath);
            if (di.Exists)
                foreach (var file in di.GetFiles("*.csv", SearchOption.AllDirectories))
                    makerListFiles.Add(file.FullName);

            di = new DirectoryInfo(studioListPath);
            if (di.Exists)
                foreach (var file in di.GetFiles("*.csv", SearchOption.AllDirectories))
                    studioListFiles.Add(file.FullName);

            //Build the zip file
            File.Delete(zipPath);
            ZipFile zipFile = new ZipFile(zipPath, Encoding.UTF8);
            zipFile.CompressionLevel = Ionic.Zlib.CompressionLevel.None;

            //Add the manifest
            zipFile.AddFile(manifestPath, "");

            //Add asset bundles
            foreach (var modAB in modABs)
            {
                string folderAB = modAB.Replace("/", @"\").Replace(@"Build\", "");
                folderAB = folderAB.Remove(folderAB.LastIndexOf(@"\")); //Remove the .unity3d filename
                zipFile.AddFile(modAB, folderAB);
            }

            //Add list files
            foreach (var listFile in makerListFiles)
                zipFile.AddFile(listFile, @"abdata\list\characustom\" + modAuthor.ToLower() + @"\");

            zipFile.Save();
            zipFile.Dispose();

            if (CopyMods)
            {
                var modsFolder = Path.Combine(KoikatsuPath, "mods");
                var copyPath = Path.Combine(modsFolder, zipFileName);
                di = new DirectoryInfo(modsFolder);
                if (di.Exists)
                {
                    foreach (var file in di.GetFiles("*.zipmod"))
                    {
                        if (file.Name.StartsWith(zipFileNamePrexix))
                            file.Delete();
                    }
                    File.Copy(zipPath, copyPath);
                }
                else
                    Debug.Log("Mods folder not found, could not copy .zipmod files to game install.");
            }
            return true;
        }
    }
}
