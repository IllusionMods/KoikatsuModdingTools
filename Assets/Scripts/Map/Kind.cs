using UnityEngine;

namespace ActionGame.MapObject
{
    public class Kind : MonoBehaviour
    {
        [SerializeField]
        [Header("Hカテゴリー")]
        private int[] _categoryes;

        [Header("対")]
        [SerializeField]
        private Transform[] _targets;

        [SerializeField]
        [Header("グループ")]
        private Transform[] _groups;

        [Header("オフセット位置")]
        [SerializeField]
        internal Vector3 _offsetPos;

        [SerializeField]
        [Header("オフセット回転")]
        internal Vector3 _offsetAngle;

        private Vector3 backupPos;
        private Vector3 backupAngle;
    }
}
