using Studio;
using UnityEditor;
using UnityEngine;

namespace Assets.Editor
{
    [CustomEditor(typeof(ChaCustomHairComponent))]
    public class ChaCustomHairComponentEditor : UnityEditor.Editor
    {
        public override void OnInspectorGUI()
        {
            ChaCustomHairComponent comp = (ChaCustomHairComponent)target;

            if (GUILayout.Button("Fill Rend Hair"))
                comp.PopulateRendHairArray();
            base.OnInspectorGUI();
        }
    }
}
