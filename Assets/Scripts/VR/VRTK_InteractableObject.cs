using System;
using System.Collections;
using System.Collections.Generic;
using System.Diagnostics;
using UnityEngine;
using VRTK.GrabAttachMechanics;
using VRTK.Highlighters;
using VRTK.SecondaryControllerGrabActions;

namespace VRTK
{
    [AddComponentMenu("VRTK/Scripts/Interactions/VRTK_InteractableObject")]
    public class VRTK_InteractableObject : MonoBehaviour
    {     
        [Tooltip("If this is checked then the interactable object script will be disabled when the object is not being interacted with. This will eliminate the potential number of calls the interactable objects make each frame.")]
        public bool disableWhenIdle = true;

        [Tooltip("The colour to highlight the object when it is touched. This colour will override any globally set colour (for instance on the `VRTK_InteractTouch` script).")]
        [Header("Touch Options", order = 1)]
        public Color touchHighlightColor = Color.clear;

        [Tooltip("Determines which controller can initiate a touch action.")]
        public AllowedController allowedTouchControllers;

        [Tooltip("An array of colliders on the object to ignore when being touched.")]
        public Collider[] ignoredColliders;

        [Header("Grab Options", order = 2)]
        [Tooltip("Determines if the object can be grabbed.")]
        public bool isGrabbable;

        [Tooltip("If this is checked then the grab button on the controller needs to be continually held down to keep grabbing. If this is unchecked the grab button toggles the grab action with one button press to grab and another to release.")]
        public bool holdButtonToGrab = true;

        [Tooltip("If this is checked then the object will stay grabbed to the controller when a teleport occurs. If it is unchecked then the object will be released when a teleport occurs.")]
        public bool stayGrabbedOnTeleport = true;

        [Tooltip("Determines in what situation the object can be dropped by the controller grab button.")]
        public ValidDropTypes validDrop = ValidDropTypes.DropAnywhere;

        [Tooltip("If this is set to `Undefined` then the global grab alias button will grab the object, setting it to any other button will ensure the override button is used to grab this specific interactable object.")]
        public VRTK_ControllerEvents.ButtonAlias grabOverrideButton;

        [Tooltip("Determines which controller can initiate a grab action.")]
        public AllowedController allowedGrabControllers;

        [Tooltip("This determines how the grabbed item will be attached to the controller when it is grabbed. If one isn't provided then the first Grab Attach script on the GameObject will be used, if one is not found and the object is grabbable then a Fixed Joint Grab Attach script will be created at runtime.")]
        public VRTK_BaseGrabAttach grabAttachMechanicScript;

        [Tooltip("The script to utilise when processing the secondary controller action on a secondary grab attempt. If one isn't provided then the first Secondary Controller Grab Action script on the GameObject will be used, if one is not found then no action will be taken on secondary grab.")]
        public VRTK_BaseGrabAction secondaryGrabActionScript;

        [Tooltip("Determines if the object can be used.")]
        [Header("Use Options", order = 3)]
        public bool isUsable;

        [Tooltip("If this is checked then the use button on the controller needs to be continually held down to keep using. If this is unchecked the the use button toggles the use action with one button press to start using and another to stop using.")]
        public bool holdButtonToUse = true;

        [Tooltip("If this is checked the object can be used only if it is currently being grabbed.")]
        public bool useOnlyIfGrabbed;

        [Tooltip("If this is checked then when a Base Pointer beam (projected from the controller) hits the interactable object, if the object has `Hold Button To Use` unchecked then whilst the pointer is over the object it will run it's `Using` method. If `Hold Button To Use` is unchecked then the `Using` method will be run when the pointer is deactivated. The world pointer will not throw the `Destination Set` event if it is affecting an interactable object with this setting checked as this prevents unwanted teleporting from happening when using an object with a pointer.")]
        public bool pointerActivatesUseAction;

        [Tooltip("If this is set to `Undefined` then the global use alias button will use the object, setting it to any other button will ensure the override button is used to use this specific interactable object.")]
        public VRTK_ControllerEvents.ButtonAlias useOverrideButton;

        [Tooltip("Determines which controller can initiate a use action.")]
        public AllowedController allowedUseControllers;

        [HideInInspector]
        public int usingState;

        protected Rigidbody interactableRigidbody;

        protected List<GameObject> touchingObjects = new List<GameObject>();

        protected List<GameObject> grabbingObjects = new List<GameObject>();

        protected List<GameObject> hoveredSnapObjects = new List<GameObject>();

        protected VRTK_InteractUse usingObject;

        protected Transform trackPoint;

        protected bool customTrackPoint;

        protected Transform primaryControllerAttachPoint;

        protected Transform secondaryControllerAttachPoint;

        protected Transform previousParent;

        protected bool previousKinematicState;

        protected bool previousIsGrabbable;

        protected bool forcedDropped;

        protected bool forceDisabled;

        protected VRTK_BaseHighlighter objectHighlighter;

        protected bool autoHighlighter;

        protected bool hoveredOverSnapDropZone;

        protected bool snappedInSnapDropZone;

        protected VRTK_SnapDropZone storedSnapDropZone;

        protected Vector3 previousLocalScale = Vector3.zero;

        protected List<GameObject> currentIgnoredColliders = new List<GameObject>();

        protected bool startDisabled;

        public enum AllowedController
        {
            Both,
            LeftOnly,
            RightOnly
        }

        public enum ValidDropTypes
        {
            NoDrop,
            DropAnywhere,
            DropValidSnapDropZone
        }
    }
}
