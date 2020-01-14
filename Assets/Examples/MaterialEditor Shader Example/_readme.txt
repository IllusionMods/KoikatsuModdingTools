This mod is an example of how to package shaders for use with KK_MaterialEditor.

Included are four different prefabs, each with a different material and each material with a different shader. MaterialEditor will load the object and copy the shader from it.

The manifest.xml needs to be configured properly for these shaders to work with MaterialEditor. Open the manifest.xml and you will see that each shader has its own entry. These are configured as follows:

Name="SuperSystems/Wireframe" - This is the name of the shader and it should match what is configured for the shader itself. Open the .shader file with a text editor and you will see the first line of it is `Shader "SuperSystems/Wireframe"`. Copy the part in double quotes to this line.
AssetBundle="chara/shaders/wireframe.unity3d" - This is the asset bundle containing the assets. Select the prefab in Unity and you should see the asset bundle it is assigned to in the Inspector window. Copy that to this line.
Asset="asset_Wireframe" - This is the prefab containing the mesh, material, and shader. The prefab in Unity will have this same name.

Each property you want the user to be able to edit should be listed here. You can find all of the properties of a shader by opening the .shader file with a text editor. There are three types of properties accepted by MaterialEditor:
Texture
Color - Vector4 should also be listed as a Color type
Float - Toggles, ints, sliders, values and most other types are listed as a Float type. Float types can have an optional Range attribute which will create a slider in the MaterialEditor UI.

Note: The GUID listed in the manifest.xml is not used by MaterialEditor. Shaders are matched based on the name. As such, changing the name in a later version of a shader mod will break compatibility with previous versions. GUID must still be unique in order for Sideloader to load the mod.

Wireframe shader credits: https://github.com/Chaser324/unity-wireframe