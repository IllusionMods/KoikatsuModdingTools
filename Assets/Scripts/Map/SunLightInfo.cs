using Illusion.Component.UI;
using System;
using System.Collections.Generic;
using UnityEngine;

public class SunLightInfo : MonoBehaviour
{
    [SerializeField]
    private Light _targetLight;
    [SerializeField]
    private BackGroundParam _bgParam;
    [SerializeField]
    private SunLightInfo.Info[] _infos;

    public enum Type
    {
        DayTime = 0,
        Evening = 1,
        Night = 2,
    }

    [Serializable]
    public class Info
    {
        public Type type;
        public Texture2D backTexture;
        public List<GameObject> visibleList = new List<GameObject>();
        public Vector3 angle;
        public Color color = Color.white;
        public float intensity = 1f;
        public bool fogUse;
        public Color fogColor = Color.white;
        public float fogStart = 0f;
        public float fogEnd = 80f;
        public Color sunShaftsColor;
        public Transform sunShaftsTransform;
        public Texture aceLutTexture;
        public Texture aceLutBlendTexture;
        public float aceBlendAmount;
    }
}
