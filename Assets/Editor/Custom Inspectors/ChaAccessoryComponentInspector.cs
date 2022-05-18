using Studio;
using UnityEditor;
using UnityEngine;

namespace Assets.Editor
{
    [CustomEditor(typeof(ChaAccessoryComponent))]
    public class ChaAccessoryComponentEditor : UnityEditor.Editor
    {
        public override void OnInspectorGUI()
        {
            ChaAccessoryComponent comp = (ChaAccessoryComponent)target;

            if (GUILayout.Button("Fill Rend Normal"))
                comp.PopulateRendNormalArray();
            base.OnInspectorGUI();
        }
    }
}
