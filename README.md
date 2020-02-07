# KoikatsuModdingTools
This is a set of tools for creating Koikatsu mods in Unity Editor.

## How to use it
1. Download Unity 5.6.2f1 which is the version that Koikatsu uses.
2. Download the repository by clicking the green "Clone or download" button on Github, up in the top right.
3. Open the project in Unity.
4. Try the example projects.

## Example projects
Included in this set of modding tools are some examples that should illustrate how to create your own mods. Each example comes with a readme file explaining how it works and how to create your own.

#### Body Paint Example
How to create a body paint mod. Creating any type of 2D texture mod such as suntans, eyeliners, etc. is a similar process.

#### Accessory Example
How to create an accessory mod.

#### Accessory Hair Example
How to create hair as an accessory with KK_HairAccessoryCustomizer compatibility.

#### Clothes Example
How to create a clothes mod.

#### MaterialEditor Shader Example
How to compile a shader and configure it for use with KK_MaterialEditor.

#### Asset Override Example
How to override a vanilla asset, for example when fixing or improving an asset from the base game.

#### Studio Item Example
How to create an item for Studio.

#### Studio Filter Example
How to create a color filter for Studio.

#### Map Example
How to create a map for use in Free H and Studio, complete with H Points, map masking, lighting, etc.

## Creating your own mod
To create your own mod, you can use an example project as a base. Copy an example project to the Mods folder, then edit the manifest.xml and insert your own information. Add your textures, select them, and set a path inside the chara folder, such as chara\[your_name]\[mod_name].unity3d. Do the same for your thumbnails. Edit the list file with the correct category number, fields, and content.

Once you have assets assigned to the asset bundles, click Window->AssetBundle Browser to bring up the build menu. Click Build All Assets and then Build All Zipmods. Only mods within the Mods folder will be built this way to keep your stuff separate from the example projects.

## Work in progress
Koikatsu Modding Tools is a work in progress, please report any bugs you may find. If you are interested in contributing to development, these are the things that need to be done.

* ~Create dummy shaders for all vanilla shaders~
* Create a pretty UI for creating list files (Marco)
* ~Create a UI for generating manifest.xml files~
* ~Add example projects for all types of items such as clothes, accessories, hair, and Studio items~
* ~Add an example project for creating maps for use in Free H and Studio~
* Load vanilla shaders for objects in the scene so that previews are more accurate OR edit the dummy shaders to be closer to the original
* Make a pretty readme file
* Write instructions and tutorials for all types of mods with pictures and explanations of all parts of the mod
* ~Generate hard mods for testing purposes so that asset bundles can be replaced while the game is running and reloaded with RuntimeUnityEditor~
* ~Asset bundle extractor which can dump assets from exist asset bundles in to a KKModTools project~
* Automatically apply color correction to textures

## Credits
Enimaroah for SB3UGS and updating it to support shader replacement.
