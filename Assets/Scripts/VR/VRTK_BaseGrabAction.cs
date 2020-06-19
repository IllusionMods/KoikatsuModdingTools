using UnityEngine;

namespace VRTK.SecondaryControllerGrabActions
{
    public abstract class VRTK_BaseGrabAction : MonoBehaviour
    {
        protected VRTK_InteractableObject grabbedObject;

        protected VRTK_InteractGrab primaryGrabbingObject;

        protected VRTK_InteractGrab secondaryGrabbingObject;

        protected Transform primaryInitialGrabPoint;

        protected Transform secondaryInitialGrabPoint;

        protected bool initialised;

        protected bool isActionable = true;

        protected bool isSwappable;
    }
}
