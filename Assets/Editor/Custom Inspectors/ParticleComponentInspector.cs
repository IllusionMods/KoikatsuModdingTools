using Studio;
using UnityEditor;
using UnityEngine;

namespace Assets.Editor
{
    [CustomEditor(typeof(ParticleComponent))]
    public class ParticleComponentEditor : UnityEditor.Editor
    {
        public override void OnInspectorGUI()
        {
            ParticleComponent comp = (ParticleComponent)target;

            if (GUILayout.Button("Fill Colored Particles"))
                comp.PopulateParticleArray();
            base.OnInspectorGUI();
        }
    }
}
