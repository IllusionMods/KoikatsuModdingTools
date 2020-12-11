# KoikatsuModdingTools
This is a set of tools for creating Koikatsu mods in Unity Editor.

## How to use it
1. Download [Unity 5.6.2](https://unity3d.com/get-unity/download/archive) which is the version that Koikatsu uses.
2. Download the repository by clicking the green "Clone or download" button on Github, up in the top right.
3. Open the project in Unity.
4. Try the example projects.

## How to update
1. Download the repository
2. Copy your Mods folder from your old project to the newly extracted project

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

## Features
#### Shaders
Included in this project are a set of placeholder shaders with all the properties of a vanilla game shader. These shaders are replaced in edit mode by the functional game shaders, and after asset bundles are built the placeholders are replaced by a copy of the original game shaders by an SB3UGS script.

#### Meshes
When .fbx files are imported by placing them within the project structure scripts run which:
* Automatically remove excess bones (improved Blender compatiblity)
* Automatically set the layer to Chara, the layer most items need to use

#### Textures
Normal map textures are converted to the transparent-red style instead of the transparent-grey style typically created by Unity 5.6.2. This improves compatiblity with EmotionCreators for all mods built using KoikatsuModdingTools.

Note: Generally, using High Quality compression for textures is prefered, except where textures extract from game files already used Normal Quality compression (DXT5, DXT1).

#### Importing Asset Bundles
It is possible with the use of uTinyRipper to import the contents of asset bundles you've created in the past, in case you would like to convert your existing mods to a format KoikatsuModdingTools can use. [See the guide](https://github.com/IllusionMods/KoikatsuModdingTools/wiki/Importing-Contents-Of-AssetBundles) on how to do so.

## Work in progress
Koikatsu Modding Tools is a work in progress, please report any bugs you may find. If you are interested in contributing to development, these are the things that need to be done.

* Create a pretty UI for creating list files
* Write instructions and tutorials for all types of mods with pictures and explanations of all parts of the mod
* Option to apply color correction to textures
* Automatically generate textures for low poly

## Credits
Enimaroah: [SB3UGS](https://github.com/enimaroah/SB3Utility) and updating it to support shader replacement, and also for the script which removes excess bones from imported .fbx files (for Blender .fbx compatibility)<br/>
Marco: List file editor UI which I still have yet to finish<br/>
Essu: Coding help and advice<br/>
[AmplifyColor](https://github.com/AmplifyCreations/AmplifyColor)<br/>
[Unity Asset Bundle Browser](https://github.com/Unity-Technologies/AssetBundles-Browser)<br/>
