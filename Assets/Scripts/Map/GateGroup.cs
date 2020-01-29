using System.Collections.Generic;
using UnityEngine;

namespace ActionGame.Point
{
    public class GateGroup : MonoBehaviour
    {
        [SerializeField]
        public List<Gate> _gateList = new List<Gate>();
    }
}
