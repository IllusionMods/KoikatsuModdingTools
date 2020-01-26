using UnityEngine;

public class EyeLookCalc : MonoBehaviour
{
	public bool correct;
	public Transform rootNode;
	[SerializeField]
	private Transform trfCenter;
	[SerializeField]
	private float closeEyeLength;
	[SerializeField]
	private float centerEyeLength;
	public EyeObject[] eyeObjs;
	public Vector3 headLookVector;
	public Vector3 headUpVector;
	public EyeTypeState[] eyeTypeStates;
	public float[] angleHRate;
	public float angleVRate;
	public float sorasiRate;
	public GameObject targetObj;
	public float targetObjMaxDir;
	public Quaternion[] fixAngle;
}
