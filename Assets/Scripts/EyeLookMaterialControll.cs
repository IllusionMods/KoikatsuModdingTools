using UnityEngine;
using System;
using UnityEngine.UI;

public class EyeLookMaterialControll : MonoBehaviour
{
	[Serializable]
	public class TexState
	{
		public int texID;
		public string texName;
		public bool isYure;
	}

	public int initializeL;
	public int initializeR;
	public EyeLookCalc script;
	public Renderer _renderer;
	public int InsideWait;
	public int OutsideWait;
	public int UpWait;
	public int DownWait;
	public float InsideLimit;
	public float OutsideLimit;
	public float UpLimit;
	public float DownLimit;
	public EYE_LR eyeLR;
	public Rect Limit;
	public float power;
	[SerializeField]
	private Vector2 offset;
	[SerializeField]
	private float hlUpOffsetY;
	[SerializeField]
	private float hlDownOffsetY;
	[SerializeField]
	private Vector2 scale;
	public TexState[] texStates;
	public int YureInside;
	public int YureOutside;
	public int YureUp;
	public int YureDown;
	public float YureTime;
	public Text text;
}
