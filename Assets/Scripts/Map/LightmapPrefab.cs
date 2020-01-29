using UnityEngine;
using System;

public class LightmapPrefab : MonoBehaviour
{
	[Serializable]
    public class LightmapParameter
	{
		public int lightmapIndex;
		public Vector4 scaleOffset;
		public Renderer renderer;
	}

	[SerializeField]
	private LightmapParameter[] lightmapParameters;
}
