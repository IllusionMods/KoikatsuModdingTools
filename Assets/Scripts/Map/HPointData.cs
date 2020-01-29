using System;
using UnityEngine;

namespace H
{
    // Token: 0x0200078A RID: 1930
    public class HPointData : MonoBehaviour
    {
        [SerializeField]
        [Header("Hシーンでのカテゴリー番号")]
        public int[] _categorys;

        private Transform _selfTransform;

        [SerializeField]
        [Header("対")]
        private string[] _targets;

        public Transform[] _objTargets = new Transform[0];

        [Header("グループ")]
        [SerializeField]
        private string[] _groups;

        public Transform[] _objGroups = new Transform[0];

        [Header("オフセット位置")]
        [SerializeField]
        internal Vector3 _offsetPos;

        [SerializeField]
        [Header("オフセット回転")]
        internal Vector3 _offsetAngle;

        [SerializeField]
        [Header("慣れ判断 0:判定しない 1:慣れ以上")]
        private int _experience;
    }
}
