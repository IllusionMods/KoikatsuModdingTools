This is an example of how to create an item mod for Studio.

Studio Items normally do not have thumbnails, but they can in the QuickAccessBox plugin
	https://github.com/ManlyMarco/QuickAccessBox/blob/master/README.md#how-to-add-thumbnails-for-your-items
KK Modding Tools will copy any .png files in the "Studio_Thumbs" folder when you build the zipmod.
They must be named correctly; there are 3 parts to the name
	8-digit group number
	8-digit category number
	Name (the display name of the item in the list file, not the prefab name)
If you use the plugin to generate thumbnails, just drag them into the "Studio_Thumbs" folder and build the zipmod again.

Studio Items usually use ItemComponent, but particle systems need ParticleComponent to be colorable.  See the examples.

Studio items are 3D objects which are added to the Studio scene by selecting Add->Items. Studio items can be organized in to Groups and Categories for organization. You can add items to existing categories or create your own by creating the appropriate list files. These categories are organized Group->Category->Item.

The list files for items must be placed within a folder inside the List\Studio folder.


ItemGroup list:
ItemGroup list files must contain the name of the folder. In this example, the list file is placed inside List\Studio\example_item and so the file name must be ItemGroup_example_item.csv

Note: If you add an item to a custom ItemGroup be sure to include the list file with your mod or the item will not be accessable. If multiple mods use the same ItemGroup then the same ItemGroup must be added to each mod.

ItemGroup list files consist of two fields:
Group Number - The number of the group. Any categories with this group number will end up inside this group, even across multiple mods.
Name - The name of the group which will appear in Add->Items->(Group Name)


ItemCategory list:
ItemGroup list files are named in the format ItemCategory_(Unique Number)_(Group Number).csv. The (Unique Number) part can be any number, typically just 00. It is used to differentiate categories for the same group. With three separate categories you could use the numbers 00, 01, 02 in the three separate list files. (Group Number) is the Group Number of the group as configured in the ItemGroup list file.

ItemCategory list files consist of two fields:
Category Number - The number of the category. Any items with this category number will end up inside this category, even across multiple mods.
Name - The name of the category which will appear in Add->Items->(Group Name)->(Category Name)


ItemList list:
ItemList list files are named in the format ItemList_(Unique Number)_(Group Number)_(Category Number).csv. The (Unique Number) part can be any number, typically just 00. (Group Number) is the Group Number of the group as configured in the ItemGroup list file. (Category Number) is the Category Number as configured in the ItemCategory list file.

ItemList list files consist of many fields:
ID - ID of the item. Can be any number but must not be the same as another item within the same mod. Other mods can use the same ID without conflict due to Sideloader.
Group Number - Group Number as configured in the ItemGroup list file
Category Number - Category Number as configured in the ItemCategory list file
Name - The name of the item which will appear in Add->Items->(Group Name)->(Category Name)->(Item Name)
Manifest - Sideloader mods never have a ManifestAssetBundle. You can put abdata here or leave it blank. Any other value will break the game.
Bundle Path - Asset bundle of the item.
File Name - Name of the prefab item.
Child Attachment Transform - Used by gimmicks such as pistons. This is the name of transform that items will be attached to when set as a child object. Typically left blank for every item that isn't a gimmick.
Animation - Whether the item has animations. 
Color 1 - Whether to show Color 1 in the Anim menu.
Pattern 1 - Whether to show the Pattern 1 section in the Anim menu. The main_item_studio shader allows patterns, other shaders do not and should set this to FALSE.
Color 2 - Whether to show Color 2 in the Anim menu.
Pattern 2 - Whether to show the Pattern 2 section in the Anim menu.
Color 3 - Whether to show Color 3 in the Anim menu.
Pattern 3 - Whether to show the Pattern 3 section in the Anim menu.
Scaling - Whether the user is allowed to scale the item. Typically set to TRUE unless scaling breaks your item.
Emission - Whether to show emission settings in the Anim menu. The item should use the main_StandardMDK_studio shader and have EmissionMap texture property that must be properly set up for this to have any effect.
