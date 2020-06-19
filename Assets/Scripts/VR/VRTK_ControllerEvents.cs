using System;
using UnityEngine;

namespace VRTK
{
    [AddComponentMenu("VRTK/Scripts/Interactions/VRTK_ControllerEvents")]
    public class VRTK_ControllerEvents : MonoBehaviour
    {
        [Header("Action Alias Buttons")]
        [Tooltip("**OBSOLETE [use VRTK_Pointer.activationButton]** The button to use for the action of turning a laser pointer on / off.")]
        [Obsolete("`VRTK_ControllerEvents.pointerToggleButton` is no longer used in the new `VRTK_Pointer` class, use `VRTK_Pointer.activationButton` instead. This parameter will be removed in a future version of VRTK.")]
        public ButtonAlias pointerToggleButton = ButtonAlias.TouchpadPress;

        [Obsolete("`VRTK_ControllerEvents.pointerSetButton` is no longer used in the new `VRTK_Pointer` class, use `VRTK_Pointer.selectionButton` instead. This parameter will be removed in a future version of VRTK.")]
        [Tooltip("**OBSOLETE [use VRTK_Pointer.selectionButton]** The button to use for the action of setting a destination marker from the cursor position of the pointer.")]
        public ButtonAlias pointerSetButton = ButtonAlias.TouchpadPress;

        [Tooltip("**OBSOLETE [use VRTK_InteractGrab.grabButton]** The button to use for the action of grabbing game objects.")]
        [Obsolete("`VRTK_ControllerEvents.grabToggleButton` is no longer used in the `VRTK_InteractGrab` class, use `VRTK_InteractGrab.grabButton` instead. This parameter will be removed in a future version of VRTK.")]
        public ButtonAlias grabToggleButton = ButtonAlias.GripPress;

        [Obsolete("`VRTK_ControllerEvents.useToggleButton` is no longer used in the `VRTK_InteractUse` class, use `VRTK_InteractUse.useButton` instead. This parameter will be removed in a future version of VRTK.")]
        [Tooltip("**OBSOLETE [use VRTK_InteractUse.useButton]** The button to use for the action of using game objects.")]
        public ButtonAlias useToggleButton = ButtonAlias.TriggerPress;

        [Obsolete("`VRTK_ControllerEvents.uiClickButton` is no longer used in the `VRTK_UIPointer` class, use `VRTK_UIPointer.selectionButton` instead. This parameter will be removed in a future version of VRTK.")]
        [Tooltip("**OBSOLETE [use VRTK_UIPointer.selectionButton]** The button to use for the action of clicking a UI element.")]
        public ButtonAlias uiClickButton = ButtonAlias.TriggerPress;

        [Obsolete("`VRTK_ControllerEvents.menuToggleButton` is no longer used, use `VRTK_ControllerEvents.buttonTwoPressed` instead. This parameter will be removed in a future version of VRTK.")]
        [Tooltip("**OBSOLETE [use VRTK_ControllerEvents.buttonTwoPressed]** The button to use for the action of bringing up an in-game menu.")]
        public ButtonAlias menuToggleButton = ButtonAlias.ButtonTwoPress;

        [Tooltip("The amount of fidelity in the changes on the axis, which is defaulted to 1. Any number higher than 2 will probably give too sensitive results.")]
        [Header("Axis Refinement")]
        public int axisFidelity = 1;

        [Tooltip("The level on the trigger axis to reach before a click is registered.")]
        public float triggerClickThreshold = 1f;

        [Tooltip("The level on the trigger axis to reach before the axis is forced to 0f.")]
        public float triggerForceZeroThreshold = 0.01f;

        [Tooltip("If this is checked then the trigger axis will be forced to 0f when the trigger button reports an untouch event.")]
        public bool triggerAxisZeroOnUntouch;

        [Tooltip("The level on the grip axis to reach before a click is registered.")]
        public float gripClickThreshold = 1f;

        [Tooltip("The level on the grip axis to reach before the axis is forced to 0f.")]
        public float gripForceZeroThreshold = 0.01f;

        [Tooltip("If this is checked then the grip axis will be forced to 0f when the grip button reports an untouch event.")]
        public bool gripAxisZeroOnUntouch;

        [HideInInspector]
        public bool triggerPressed;

        [HideInInspector]
        public bool triggerTouched;

        [HideInInspector]
        public bool triggerHairlinePressed;

        [HideInInspector]
        public bool triggerClicked;

        [HideInInspector]
        public bool triggerAxisChanged;

        [HideInInspector]
        public bool gripPressed;

        [HideInInspector]
        public bool gripTouched;

        [HideInInspector]
        public bool gripHairlinePressed;

        [HideInInspector]
        public bool gripClicked;

        [HideInInspector]
        public bool gripAxisChanged;

        [HideInInspector]
        public bool touchpadPressed;

        [HideInInspector]
        public bool touchpadTouched;

        [HideInInspector]
        public bool touchpadAxisChanged;

        [HideInInspector]
        public bool buttonOnePressed;

        [HideInInspector]
        public bool buttonOneTouched;

        [HideInInspector]
        public bool buttonTwoPressed;

        [HideInInspector]
        public bool buttonTwoTouched;

        [HideInInspector]
        public bool startMenuPressed;

        [HideInInspector]
        [Obsolete("`VRTK_ControllerEvents.pointerPressed` is no longer used, use `VRTK_Pointer.IsActivationButtonPressed()` instead. This parameter will be removed in a future version of VRTK.")]
        public bool pointerPressed;

        [HideInInspector]
        [Obsolete("`VRTK_ControllerEvents.grabPressed` is no longer used, use `VRTK_InteractGrab.IsGrabButtonPressed()` instead. This parameter will be removed in a future version of VRTK.")]
        public bool grabPressed;

        [Obsolete("`VRTK_ControllerEvents.usePressed` is no longer used, use `VRTK_InteractUse.IsUseButtonPressed()` instead. This parameter will be removed in a future version of VRTK.")]
        [HideInInspector]
        public bool usePressed;

        [Obsolete("`VRTK_ControllerEvents.uiClickPressed` is no longer used, use `VRTK_UIPointer.IsSelectionButtonPressed()` instead. This parameter will be removed in a future version of VRTK.")]
        [HideInInspector]
        public bool uiClickPressed;

        [Obsolete("`VRTK_ControllerEvents.menuPressed` is no longer used, use `VRTK_ControllerEvents.buttonTwoPressed` instead. This parameter will be removed in a future version of VRTK.")]
        [HideInInspector]
        public bool menuPressed;

        [HideInInspector]
        public bool controllerVisible = true;

        protected Vector2 touchpadAxis = Vector2.zero;

        protected Vector2 triggerAxis = Vector2.zero;

        protected Vector2 gripAxis = Vector2.zero;

        protected float hairTriggerDelta;

        protected float hairGripDelta;

        public enum ButtonAlias
        {
            Undefined,
            TriggerHairline,
            TriggerTouch,
            TriggerPress,
            TriggerClick,
            GripHairline,
            GripTouch,
            GripPress,
            GripClick,
            TouchpadTouch,
            TouchpadPress,
            ButtonOneTouch,
            ButtonOnePress,
            ButtonTwoTouch,
            ButtonTwoPress,
            StartMenuPress
        }
    }
}
