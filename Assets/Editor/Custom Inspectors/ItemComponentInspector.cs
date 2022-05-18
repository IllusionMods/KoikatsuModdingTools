using Studio;
using UnityEditor;
using UnityEngine;

namespace Assets.Editor
{
    [CustomEditor(typeof(ItemComponent))]
    public class ItemComponentEditor : UnityEditor.Editor
    {
        public override void OnInspectorGUI()
        {
            ItemComponent comp = (ItemComponent)target;

            if (GUILayout.Button("Fill Rend Normal"))
                comp.PopulateRendNormalArray();
            base.OnInspectorGUI();
        }
    }
}
