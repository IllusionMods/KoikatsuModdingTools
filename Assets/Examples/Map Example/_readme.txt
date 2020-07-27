This is an example of how to create a map mod that can be used in Free H and Studio. Map mods are very involved and not beginner friendly.

To begin, open the PurpleRoom file, this is a saved scene. Unlike all other types of mods, maps are not assets within an asset bundle but scenes within an asset bundle (scene asset bundle). Once opened, you should see a preview of the map in your Scene view with walls, floors, objects, lighting, H points, and more.

This map is made from basic shapes in Unity, but typically you would create a map in Blender or your 3D editor of choice and save the .obj, .fbx, .blend, etc file to your project folder. Unity will import the model and you can drag and drop it to the scene Hierarchy to add it to the scene. After saving the model again in Blender, Unity will reimport it an automatically update your scene with the changes. Therefore, the workflow for creating a map is to build the model in a 3D modelling program, import to Unity, then add MonoBehaviors, lighting, etc.

Select the root node (Map) and you will see two MonoBehaviors attached:
SunLightInfo: Data about the sunlight at various times of day. Should contain three elements (Day, Evening, Night) each with the color and angle of the light, fog color, LUT texture, etc.
VisualizeGizmos: Custom script for visualizing H points in the editor. Should be removed before building and releasing the final version of the map. To configure this for your own map, set the HPointContainer to the transform that contains your HPoints

Next select Sunlight. This is a directional light added to the scene which the game controls. Note that it has the tag "Sun" in the inspector, it will not function properly unless correctly tagged. Anything you set here will be overriden by the SunLightInfo setup but it can be useful for previewing the lighting in Unity.

Under Sunlight is the SunShaftSource transform. By itself it does nothing (just an empty transform) but the SunLightInfo is configured to use this transform as the position from which sun shafts originate.

h_free is an empty transform that indicates to the game the position and rotation of where Free H mode will start.

background is a large mesh surrounding the entire scene colored black. Necessary for fog to function properly.

shadowcaster is a mesh surrounding the scene which is responsible for casting shadows. Note that the walls of the scene have shadow casting mode set to Off and this mesh has shadow casting mode set to Shadows Only, meaning it is invisible but casts shadows.

Room is a bunch of meshes making up the entire scene. Note that all of the meshes use the layer "Map".


*H Points
Outside of the Map hierarchy you should see HPoint_Disabled. This is a disabled GameObject containing the prefabs for the HPoint data. H Points are the points in the game used to transition between positions. See the bottom of this readme for a list of IDs used in HPoints
HPoint: Contains data about H Points for normal H positions
HPoint_Add: Contains data about Lesbian and Masturbation positions
HPoint_3P: Contains 3P data

The starting positions for various H modes are calculated like so:
Free H: The h_free transform in the scene
Lesbian and Masturbation: The H Point closest to the center of the scene with the correct category
3P: The 3P_00 H Point
If these are not present, the center of the map (0,0,0) will be the starting point.

HPoints should be removed from the scene before building and releasing the map mod. They are only left in this scene for the purpose of visualizing them during development. The HPoint prefabs are compiled to an asset bundle separate from the scene.


*Map Masking
Map masking hides parts of the map when the camera goes behind them, so that entire sections of walls will disapear so as to not be in the way. Masking is controlled by a list file which is a .txt file named in the format map_col_(MapID). This should be compiled to an asset bundle within the h/list/ folder. The list file is a tab separated list where the first entry is the collider followed by any transforms that will be hidden by it. In this example, the two capsules are set to be masked.

Map masking triggers in game when the collider comes between the camera target and the camera. When triggered, the specified transforms are hidden.


*Lighting
Sunlight behavior is configured in the SunLightInfo MonoBehavior attached to the Map. Shadows are typically controlled by a shadowcaster mesh rather than the map objects since many map objects tend to be have only a single face and don't cast shadows from one direction. Because most of the indoors map will be in shadow, materials should be set to have some level of Emission to correct for this.

In addition to direction and color of lighting being affected by time of day, game objects can be made time specific as well. Within the Walls folder of the Room, you should see Window_d, Window_e, and Window_n. Two of them are disabled and one left enabled for previewing in Unity; the game controls the state of these objects at runtime. The SunLightInfo MB has a VisibleList element and within it are these three objects, one in each of the three times of day.

Note that changing the angle of the directional light is useful for previewing lighting, but the angle will not be preserved once in game. Angle set in the SunLightInfo MonoBehavior will be used to control the directional light.


*List Files and asset bundles
Maps and their data are compiled to six separate asset bundles:
map/list/mapinfo/purpleroom.unity3d - The PurpleRoom MapInfo asset goes here. It contains the information about the map which the game requires for adding the map to the Free H selection list.
map/scene/purpleroom.unity3d - The PurpleRoom scene is compiled to this asset bundle. Note that you can rename the scene to anything you like for your own map so long as this change is reflected in the list files.
map/thumbnail/purpleroom.unity3d - The three thumbnails go here. Thumbnails should be named with the postfixes _00, _01, and _02 for day, evening, and night thumbnails
h/list/purpleroom.unity3d - The map masking list goes here. It should be a .txt file named map_col_(MapID).
h/common/purpleroom.unity3d - H Point prefabs are compiled here.
vr/common/purpleroom.unity3d - H Points for VR are compiled here. Because maintaining two separate copies of H Ponts would be time consuming, a script exists to semi-automate this. Copy the three HPoint prefabs to the VRPoint folder, right click, and select "Configure VR HPoints". (Do not copy in the .meta files) Do this once before release after all the testing and configuration of HPoints is complete.
Replace purpleroom.unity3d with an asset bundle name of your choice for your own mod.

In addition, maps can easily be added to Studio by adding a .csv to the List/Studio folder. No additional changes need to be made for the map to function in Studio, if it works in Free H it will work in Studio just fine. As such, it's always a good idea to add your map to Studio.


*A note on ID conflicts
Sideloader does not resolve IDs for maps in the Free H menu. Coordinate with other modders to claim an ID range for your map mods. I expect not enough map mods will be made that ID conflicts become a problem and even if they do IDs can be modified without affecting the user since Free H stuff isn't saved to any cards or scenes. Studio map IDs are resolved by sideloader and should not have any ID conflicts.


*HPoint IDs
0-Floor
1-Stand
2-Chair
3-Backless Chair
4-Couch
5-Backless Couch
6-Class Desk
7-Desk
8-Wall
9-Pool
12-Bench Blowjob
1002-Bookshelf Caress
1003-Mischeivous Caress
1004-Pool Paizuri
1005-Pool Behind
1200-Chair Straddling Fellatio

HPoint_Add
1010-Corner Masturbation
1011-Chair Masturbation
1012-Standing Masturbation
1013, HPointGizmoType-Hurdle Masturbation
1100-Tribbing
1101-Chair Cunnilingus
1102-Mutual Groping

HPoint_3P
3000-3P