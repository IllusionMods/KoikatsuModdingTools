This is an example of how to create a filter mod for Studio.

Filters are selected in Studio in System->Scene Effects->Color Adjustment and will apply a color filter to the scene.

Filters are a type of image called Look-Up Tables (LUT). They are commonly used in image processing and you can find many examples online.

List files for filters must be placed inside a folder within the List\Studio folder. The file name for the filter must include the name of the folder. In this example the .csv list file is at List\Studio\ExampleLUT and so the filename of the list must be Filter_ExampleLUT.csv.

List files for filters consist of 4 fields: ID,Name,Bundle Path,File Name

ID: ID of the item. Can be any number but must not be the same as another filter within the same mod. Other mods can use the same ID without conflict due to Sideloader.
Name: Name of the item that will appear in the dropdown menu in game.
Bundle Path: Asset bundle of the filter texture.
File Name: File name of the filter texture.

Filter textures should use "None" for the compression type on the image due to very fine gradients these textures often use. The textures are typically small enough that having them uncompressed doesn't add much extra file size.