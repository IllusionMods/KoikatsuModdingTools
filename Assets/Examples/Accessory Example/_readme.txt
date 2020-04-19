This mod is an example of how to create an accessory.

Accessories have a mesh, a material for the mesh, a shader assigned to the material, and textures assigned to the material. All of these are put together in the prefab.

To create an accessory from scratch, right click in the Hierarchy window and Create Empty. Rename this to whatever you like, this will be the name of the game object for your accessory and what will appear in your list file. Create a new empty and add it as a child of the previous one, name this one N_move. All accessories must have a transform named N_move or they cannot be adjusted in the character maker. Next, drag and drop your mesh in to the scene view. In the Inspector window, click the gear icon next to Transform and click Reset to return it to position 0,0,0. In the Hierarchy, drag and drop the mesh to make it a child of the N_move transform. Note: 3D editors let you create a transform hierarchy just like this and will be preserved when you import them from FBX files. You can do this step in your 3D editor instead.

Your Hierarchy should look like this:
->(Accessory transform)
  ->N_move - Required for accessories to be adjustable in the character maker
    ->(Any number of transforms) - Apply rotation and position adjustments here, not to N_move or parent.
      ->(Mesh)

An accessory requires a ChaAccessoryComponent MonoBehavior in order to function properly. Select your root transform and click Add Component in the Inspector window and select the ChaAccessoryComponent script. Expand the Rend Normal section and change the size to 1. Click the circle next to Element 0 and select your mesh from the list, it should be the only thing available. If your accessory has multiple meshes, create an element for each one and add them as well, all meshes must be in this array.

To make the acccessory colorable in the character maker, check the Use Color 01, 02, and/or 03 checkboxes. You can select a default color for the accessory which will be how the accessory is colored when added to a character in the character maker.

Under Transparent Parts, you can configure parts of the accessory to be transparent for things like glasses or gems. Add a mesh to the Rend Alpha array instead of the Rend Normal array.

Hair Parts lets you configure a mesh to function like hair to an extent. Add the mesh to the Rend Hair array instead of the Rend Normal and the mesh will match hair color to the character's base hair color. Because it only matches one hair color it is less than ideal for making accessory hair, see the Accessory Hair Example for how to do that.

Now that the ChaAccessoryComponent MonoBehavior is properly configured, drag the root transform from the Hierarchy in to your Prefabs folder. In the inspector, assign the prefab to an asset bundle within the chara folder, such as chara/(modder name)/example.unity3d. The name of the root transform will be the name of your prefab, and it is what you will put for MainData in your list file. The asset bundle is what you will put for MainAB in the list file.