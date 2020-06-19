using UnityEngine;

namespace VRTK
{
    [AddComponentMenu("VRTK/Scripts/Interactions/VRTK_InteractGrab")]
    public class VRTK_InteractGrab : MonoBehaviour
    {
        [Tooltip("The button used to grab/release a touched object.")]
        [Header("Grab Settings")]
        public VRTK_ControllerEvents.ButtonAlias grabButton = VRTK_ControllerEvents.ButtonAlias.GripPress;

        [Tooltip("An amount of time between when the grab button is pressed to when the controller is touching something to grab it. For example, if an object is falling at a fast rate, then it is very hard to press the grab button in time to catch the object due to human reaction times. A higher number here will mean the grab button can be pressed before the controller touches the object and when the collision takes place, if the grab button is still being held down then the grab action will be successful.")]
        public float grabPrecognition;

        [Tooltip("An amount to multiply the velocity of any objects being thrown. This can be useful when scaling up the play area to simulate being able to throw items further.")]
        public float throwMultiplier = 1f;

        [Tooltip("If this is checked and the controller is not touching an Interactable Object when the grab button is pressed then a rigid body is added to the controller to allow the controller to push other rigid body objects around.")]
        public bool createRigidBodyWhenNotTouching;

        [Tooltip("The rigidbody point on the controller model to snap the grabbed object to. If blank it will be set to the SDK default.")]
        [Header("Custom Settings")]
        public Rigidbody controllerAttachPoint;

        [Tooltip("The controller to listen for the events on. If the script is being applied onto a controller then this parameter can be left blank as it will be auto populated by the controller the script is on at runtime.")]
        public VRTK_ControllerEvents controllerEvents;

        [Tooltip("The Interact Touch to listen for touches on. If the script is being applied onto a controller then this parameter can be left blank as it will be auto populated by the controller the script is on at runtime.")]
        public VRTK_InteractTouch interactTouch;

        protected VRTK_ControllerEvents.ButtonAlias subscribedGrabButton;

        protected VRTK_ControllerEvents.ButtonAlias savedGrabButton;

        protected bool grabPressed;

        protected GameObject grabbedObject;

        protected bool influencingGrabbedObject;

        protected int grabEnabledState;

        protected float grabPrecognitionTimer;

        protected GameObject undroppableGrabbedObject;

        protected Rigidbody originalControllerAttachPoint;

        protected Coroutine attemptSetCurrentControllerAttachPoint;
    }
}
