# KoikatsuModdingTools
This is a set of tools for creating Koikatsu mods in Unity Editor.

## How to use it
1. Download Unity 5.6.2f1 which is the version that Koikatsu uses.
2. Download the repository by clicking the green "Clone or download" button on Github, up in the top right.
3. Open the project in Unity.
4. Try the example projects.

## Example projects
Included in this set of modding tools are some examples that should illustrate how to create your own mods.

#### Body Paint Example
This mod shows how to create a body paint mod.

The manifest.xml is inside the root folder. Inside the List\Maker folder is the list file for the mod. Thumbnails are inside the Thumbnail folder. The Texture2D folder holds the body paint textures. They appear as solid white, but they are actually white on a transparent background. These files are .psd files, however Unity allows you to use a variety of file types. Use whatever suits your workflow the best. Select these files and you will see in the bottom left the AssetBundle path. This is where Unity will compile the asset bundles and the list file should match.

For more detailed descriptions of what all parts of a mod to, see the [wiki entries for Sideloader](https://github.com/IllusionMods/BepisPlugins/wiki).

#### Asset Override Example
This mod shows how to override a vanilla asset.

## Creating your own mod
Currently the only types of mods that can be created are 2D texture mods such as body paints, irises, suntans, etc. More types coming soon.

To create your own mod, you can use an example project as a base. Copy an example project to the Mods folder, then edit the manifest.xml and insert your own information. Add your textures, select them, and set a path inside the chara folder, such as chara\[your_name]\[mod_name].unity3d. Do the same for your thumbnails. Edit the list file with the correct category number, fields, and content. Then click Build->Build All Asset Bundles and then Build->Build All Mods. Only mods within the Mods folder will be built this way to keep your stuff separate from the example projects.

## Work in progress
Koikatsu Modding Tools is a work in progress, please report any bugs you may find. If you are interested in contributing to development, these are the things that need to be done.

* Create dummy shaders for all vanilla shaders
* Create a pretty UI for creating list files (Marco)
* Create a UI for generating manifest.xml files
* Upgrade Sideloader to support external dependecies (Anon11)
* Add example projects for all types of items such as clothes, accessories, hair, and Studio items
* Add an example project for creating maps for use in Free H and Studio
* Load vanilla shaders for objects in the scene so that previews are more accurate OR edit the dummy shaders to be closer to the original
* Make a pretty readme file
* Write instructions and tutorials for all types of mods with pictures and explanations of all parts of the mod
* Generate hard mods for testing purposes so that asset bundles can be replaced while the game is running and reloaded with RuntimeUnityEditor
