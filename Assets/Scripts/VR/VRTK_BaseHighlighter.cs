using UnityEngine;

namespace VRTK.Highlighters
{
    public abstract class VRTK_BaseHighlighter : MonoBehaviour
    {
        [Tooltip("Determines if this highlighter is the active highlighter for the object the component is attached to. Only 1 active highlighter can be applied to a game object.")]
        public bool active = true;

        [Tooltip("Determines if the highlighted object should be unhighlighted when it is disabled.")]
        public bool unhighlightOnDisable = true;

        protected bool usesClonedObject;
    }
}
