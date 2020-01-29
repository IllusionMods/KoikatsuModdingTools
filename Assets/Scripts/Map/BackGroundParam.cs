using UnityEngine;
using UnityEngine.UI;

namespace Illusion.Component.UI
{
    public class BackGroundParam : MonoBehaviour
    {
        [SerializeField]
        private Canvas _canvas;

        [SerializeField]
        private Camera _camera;

        [SerializeField]
        private Image _image;

        private string assetBundleNameChache;
    }
}
