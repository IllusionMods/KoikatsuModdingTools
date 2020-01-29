using UnityEngine;

public class MirrorReflection : MonoBehaviour
{
	public bool m_DisablePixelLights;
	public int m_TextureSize;
	public float m_ClipPlaneOffset;
	public LayerMask m_ReflectLayers;
	public Camera cameraOriginal;
}
