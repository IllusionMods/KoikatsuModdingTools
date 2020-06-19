using UnityEngine;

namespace VRTK
{
    [AddComponentMenu("VRTK/Scripts/Interactions/VRTK_InteractUse")]
    public class VRTK_InteractUse : MonoBehaviour
    {
        [Tooltip("The button used to use/unuse a touched object.")]
        [Header("Use Settings")]
        public VRTK_ControllerEvents.ButtonAlias useButton = VRTK_ControllerEvents.ButtonAlias.TriggerPress;

        [Tooltip("The controller to listen for the events on. If the script is being applied onto a controller then this parameter can be left blank as it will be auto populated by the controller the script is on at runtime.")]
        [Header("Custom Settings")]
        public VRTK_ControllerEvents controllerEvents;

        [Tooltip("The Interact Touch to listen for touches on. If the script is being applied onto a controller then this parameter can be left blank as it will be auto populated by the controller the script is on at runtime.")]
        public VRTK_InteractTouch interactTouch;

        [Tooltip("The Interact Grab to listen for grab actions on. If the script is being applied onto a controller then this parameter can be left blank as it will be auto populated by the controller the script is on at runtime.")]
        public VRTK_InteractGrab interactGrab;

        protected VRTK_ControllerEvents.ButtonAlias subscribedUseButton;

        protected VRTK_ControllerEvents.ButtonAlias savedUseButton;

        protected bool usePressed;

        protected GameObject usingObject;
    }
}
