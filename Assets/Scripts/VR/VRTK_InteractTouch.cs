using System.Collections.Generic;
using UnityEngine;

namespace VRTK
{
    [AddComponentMenu("VRTK/Scripts/Interactions/VRTK_InteractTouch")]
    public class VRTK_InteractTouch : MonoBehaviour
    {
        [Tooltip("An optional GameObject that contains the compound colliders to represent the touching object. If this is empty then the collider will be auto generated at runtime to match the SDK default controller.")]
        public GameObject customColliderContainer;

        protected GameObject touchedObject;

        protected List<Collider> touchedObjectColliders = new List<Collider>();

        protected List<Collider> touchedObjectActiveColliders = new List<Collider>();

        protected GameObject controllerCollisionDetector;

        protected bool triggerRumble;

        protected bool destroyColliderOnDisable;

        protected bool triggerIsColliding;

        protected bool triggerWasColliding;

        protected bool rigidBodyForcedActive;

        protected Rigidbody touchRigidBody;

        protected UnityEngine.Object defaultColliderPrefab;
    }
}
