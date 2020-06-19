using System.Collections.Generic;
using UnityEngine;
using VRTK.Highlighters;

namespace VRTK
{
    [ExecuteInEditMode]
    public class VRTK_SnapDropZone : MonoBehaviour
    {
        [Tooltip("A game object that is used to draw the highlighted destination for within the drop zone. This object will also be created in the Editor for easy placement.")]
        public GameObject highlightObjectPrefab;

        [Tooltip("The Snap Type to apply when a valid interactable object is dropped within the snap zone.")]
        public SnapTypes snapType;

        [Tooltip("The amount of time it takes for the object being snapped to move into the new snapped position, rotation and scale.")]
        public float snapDuration;

        [Tooltip("If this is checked then the scaled size of the snap drop zone will be applied to the object that is snapped to it.")]
        public bool applyScalingOnSnap;

        [Tooltip("If this is checked then when the snapped object is unsnapped from the drop zone, a clone of the unsnapped object will be snapped back into the drop zone.")]
        public bool cloneNewOnUnsnap;

        [Tooltip("The colour to use when showing the snap zone is active.")]
        public Color highlightColor;

        [Tooltip("The highlight object will always be displayed when the snap drop zone is available even if a valid item isn't being hovered over.")]
        public bool highlightAlwaysActive;

        [Tooltip("A specified VRTK_PolicyList to use to determine which interactable objects will be snapped to the snap drop zone on release.")]
        public VRTK_PolicyList validObjectListPolicy;

        [Tooltip("If this is checked then the drop zone highlight section will be displayed in the scene editor window.")]
        public bool displayDropZoneInEditor = true;

        [Tooltip("The game object to snap into the dropzone when the drop zone is enabled. The game object must be valid in any given policy list to snap.")]
        public GameObject defaultSnappedObject;

        protected GameObject previousPrefab;

        protected GameObject highlightContainer;

        protected GameObject highlightObject;

        protected GameObject highlightEditorObject;

        protected List<GameObject> currentValidSnapObjects = new List<GameObject>();

        protected GameObject currentSnappedObject;

        protected GameObject objectToClone;

        protected bool[] clonedObjectColliderStates = new bool[0];

        protected VRTK_BaseHighlighter objectHighlighter;

        protected bool willSnap;

        protected bool isSnapped;

        protected bool wasSnapped;

        protected bool isHighlighted;

        protected Coroutine transitionInPlace;

        protected bool originalJointCollisionState;

        protected const string HIGHLIGHT_CONTAINER_NAME = "HighlightContainer";

        protected const string HIGHLIGHT_OBJECT_NAME = "HighlightObject";

        protected const string HIGHLIGHT_EDITOR_OBJECT_NAME = "EditorHighlightObject";

        public enum SnapTypes
        {
            UseKinematic,
            UseJoint,
            UseParenting
        }
    }
}
