using System.Collections.Generic;
using UnityEngine;

namespace VRTK
{
    [AddComponentMenu("VRTK/Scripts/Utilities/VRTK_PolicyList")]
    public class VRTK_PolicyList : MonoBehaviour
    {
        [Tooltip("The operation to apply on the list of identifiers.")]
        public OperationTypes operation;

        [Tooltip("The element type on the game object to check against.")]
        public CheckTypes checkType = CheckTypes.Tag;

        [Tooltip("A list of identifiers to check for against the given check type (either tag or script).")]
        public List<string> identifiers = new List<string>
        {
            string.Empty
        };

        public enum OperationTypes
        {
            Ignore,
            Include
        }

        public enum CheckTypes
        {
            Tag = 1,
            Script,
            Layer = 4
        }
    }
}
