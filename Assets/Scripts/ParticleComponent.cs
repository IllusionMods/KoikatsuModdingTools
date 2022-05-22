using UnityEngine;

namespace Studio{
	[ExecuteInEditMode]
	public class ParticleComponent : MonoBehaviour
	{
	    [Tooltip("Particle Systems To Set Colors For")]
	    public ParticleSystem[] particleColor1;

	    [Tooltip("Default color")]
	    public Color defColor01 = Color.white;

	    [HideInInspector]
	    public int setcolor;

	#if UNITY_EDITOR
	    private void Awake()
	    {
	        SetColors();
	    }

		// having Start() gives Inspector enable/disable checkbox for the script
		// needed because an exception in Awake() will disable the script
		void Start()
		{
		}

	    private void SetColors()
	    {
			if (particleColor1 == null)
				return;
			foreach (ParticleSystem p in particleColor1)
	        {
				if (p != null) {
					var pm = p.main;
					pm.startColor = defColor01;
				}
	        }
	    }

		/// <summary>
		/// Add all renderers to the rendNormal array
		/// </summary>
		public void PopulateParticleArray()
		{
			particleColor1 = gameObject.GetComponentsInChildren<ParticleSystem>();
			SetColors ();
		}
	#endif
	}
}