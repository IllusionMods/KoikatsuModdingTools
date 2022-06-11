using Studio;
using UnityEditor;
using UnityEngine;

namespace Assets.Editor
{
    [CustomEditor(typeof(ChaClothesComponent))]
    public class ChaClothesComponentEditor : UnityEditor.Editor
    {
        public override void OnInspectorGUI()
        {
            ChaClothesComponent comp = (ChaClothesComponent)target;

            if (GUILayout.Button("Fill Rend Normal 01"))
                comp.PopulateRendNormal01Array();
            base.OnInspectorGUI();
        }
    }
}
