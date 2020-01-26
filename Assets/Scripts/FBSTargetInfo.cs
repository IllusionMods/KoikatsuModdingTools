using System;
using UnityEngine;

[Serializable]
public class FBSTargetInfo
{
	[Serializable]
	public class CloseOpen
	{
		public int Close;
		public int Open;
	}

	public GameObject ObjTarget;
	public CloseOpen[] PtnSet;
}
