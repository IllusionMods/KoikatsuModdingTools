using UnityEngine;

namespace VRTK.GrabAttachMechanics
{
    public abstract class VRTK_BaseGrabAttach : MonoBehaviour
    {
        [Tooltip("If this is checked then when the controller grabs the object, it will grab it with precision and pick it up at the particular point on the object the controller is touching.")]
        [Header("Base Options", order = 1)]
        public bool precisionGrab;

        [Tooltip("A Transform provided as an empty game object which must be the child of the item being grabbed and serves as an orientation point to rotate and position the grabbed item in relation to the right handed controller. If no Right Snap Handle is provided but a Left Snap Handle is provided, then the Left Snap Handle will be used in place. If no Snap Handle is provided then the object will be grabbed at its central point. Not required for `Precision Snap`.")]
        public Transform rightSnapHandle;

        [Tooltip("A Transform provided as an empty game object which must be the child of the item being grabbed and serves as an orientation point to rotate and position the grabbed item in relation to the left handed controller. If no Left Snap Handle is provided but a Right Snap Handle is provided, then the Right Snap Handle will be used in place. If no Snap Handle is provided then the object will be grabbed at its central point. Not required for `Precision Snap`.")]
        public Transform leftSnapHandle;

        [Tooltip("If checked then when the object is thrown, the distance between the object's attach point and the controller's attach point will be used to calculate a faster throwing velocity.")]
        public bool throwVelocityWithAttachDistance;

        [Tooltip("An amount to multiply the velocity of the given object when it is thrown. This can also be used in conjunction with the Interact Grab Throw Multiplier to have certain objects be thrown even further than normal (or thrown a shorter distance if a number below 1 is entered).")]
        public float throwMultiplier = 1f;

        [Tooltip("The amount of time to delay collisions affecting the object when it is first grabbed. This is useful if a game object may get stuck inside another object when it is being grabbed.")]
        public float onGrabCollisionDelay;

        protected bool tracked;

        protected bool climbable;

        protected bool kinematic;

        protected GameObject grabbedObject;

        protected Rigidbody grabbedObjectRigidBody;

        protected VRTK_InteractableObject grabbedObjectScript;

        protected Transform trackPoint;

        protected Transform grabbedSnapHandle;

        protected Transform initialAttachPoint;

        protected Rigidbody controllerAttachPoint;
    }
}
