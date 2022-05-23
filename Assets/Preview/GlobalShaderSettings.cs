using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// usage: put on a game object in scene for it to set global shader settings
// for more accurate game shader preview

[ExecuteInEditMode]
public class GlobalShaderSettings : MonoBehaviour {

	//TODO: find the game code and change this to match

	[Tooltip("color does little, alpha seems to be outline density inverted")]
	public Color line_color = new Color(0f,0f,0f,0.26f);

	[Range(0f,1f)]
	public float outline_size = 0.31f;

	[Tooltip("shaders use shadow color, but I don't know a way in game to change it, alpha seems to be shadow density inverted")]
	public Color ambient_shadow = Color.clear;

	[Tooltip("choose a ramp texture from Assets/Preview/ramp textures")]
	public Texture2D ramp;

	[Tooltip("the shaders use this, but I don't know a way in game to change it")]
	public Vector4 ramp_tiling = new Vector4(1f,1f,0f,0f);

	void Awake()
	{
		SetGlobals ();
	}

	//whenever a setting is changed
	void OnValidate()
	{
		SetGlobals ();
	}

	void SetGlobals()
	{
		Shader.SetGlobalColor ("_LineColorG", line_color);
		Shader.SetGlobalFloat ("_linewidthG", outline_size);
		Shader.SetGlobalColor ("_ambientshadowG", ambient_shadow);
		if(ramp == null)
			Shader.SetGlobalTexture ("_RampG", Texture2D.whiteTexture);
		else
			Shader.SetGlobalTexture ("_RampG", ramp);
		Shader.SetGlobalVector ("_RampG_ST", ramp_tiling);
	}
}
