using System.IO;
using System.Xml.Linq;
using UnityEditor;
using Debug = UnityEngine.Debug;

namespace IllusionMods.KoikatuModdingTools
{
    /// <summary>
    /// Create a manifest.xml template in the current folder
    /// </summary>
    class ManifestCreate
    {
        [MenuItem("Assets/Create/Manifest.xml")]
        public static void CreateManifest()
        {
            string projectPath = Shared.GetProjectPath();
            string manifestPath;

            if (projectPath == "Assets/Mods" || !projectPath.Contains("Mods"))
            {
                Debug.Log("manifest.xml can only be created in a folder within the Assets/Mods folder.");
                return;
            }
            else if (File.Exists(Path.Combine(projectPath, "manifest.xml")))
            {
                Debug.Log("manifest.xml already exists at this location.");
                return;
            }
            else
            {
                //Check if manifest.xml exists in a parent folder
                manifestPath = Shared.GetManifestPath(projectPath);
                if (manifestPath != null)
                {
                    Debug.Log("manifest.xml cannot be created, one exists in a parent folder: " + manifestPath);
                    return;
                }
            }

            manifestPath = Path.Combine(projectPath, "manifest.xml");

            XDocument manifestDocument = new XDocument();
            XElement manifestElement = new XElement("manifest");
            manifestElement.Add(new XAttribute("schema-ver", "1"));

            var manifestGUID = new XElement("guid");
            var manifestName = new XElement("name");
            var manifestVersion = new XElement("version");
            var manifestAuthor = new XElement("author");
            var manifestDescription = new XElement("description");
            var manifestWebsite = new XElement("website");

            manifestGUID.Value = "";
            manifestName.Value = "";
            manifestVersion.Value = "";
            manifestAuthor.Value = "";
            manifestDescription.Value = "";
            manifestWebsite.Value = "";

            manifestElement.Add(manifestGUID);
            manifestElement.Add(manifestName);
            manifestElement.Add(manifestVersion);
            manifestElement.Add(manifestAuthor);
            manifestElement.Add(manifestDescription);
            manifestElement.Add(manifestWebsite);
            manifestDocument.Add(manifestElement);
            manifestDocument.Save(manifestPath);

            AssetDatabase.Refresh();
        }
    }
}
