using H;
using System.Collections.Generic;
using UnityEngine;

namespace ActionGame
{
    public class MapVisibleList : MonoBehaviour
    {
        [SerializeField]
        public List<GameObject> _list = new List<GameObject>();

        [SerializeField]
        public int onButton;

        [SerializeField]
        public int offButton;
    }
}
