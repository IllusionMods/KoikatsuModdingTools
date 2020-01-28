This is an example of how to create a head mod for use with the head selector that comes with the Darkness DLC. Koikatsu Party users will not have access to it.

Head mods can be a challenging type of mod to create due to the blend shapes. Select the cf_O_face mesh and you will see that it has 81 blend shapes and the other meshes have many blend shapes as well. Modifying the head mesh means modifying all of the blend shapes to match.

To properly compile the asset bundles, assign both of the prefabs to an asset bundle as well as the following:
Material:
cf_m_face_00

TextAsset:
cf_anmShapeHead_00

Texture:
cf_face_00_mc, cf_face_00_mc_low, cf_face_00_t, cf_face_00_t_low

Everything else is assigned to a material which is part of the prefab and will be compiled to the asset bundle automatically. The material, textures, and text asset are part of the list file and not attached to anything directly, the game loads these in code from the list.