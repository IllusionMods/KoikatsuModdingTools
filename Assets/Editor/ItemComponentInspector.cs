using Studio;
using UnityEditor;
using UnityEngine;

namespace Assets.Editor
{
    [CustomEditor(typeof(ItemComponent))]
    public class LevelScriptEditor : UnityEditor.Editor
    {
        public override void OnInspectorGUI()
        {
            ItemComponent itemComponent = (ItemComponent)target;

            if (GUILayout.Button("Populate Rend Normal Array"))
                itemComponent.PopulateRendNormalArray();
            base.OnInspectorGUI();
        }
    }
}
