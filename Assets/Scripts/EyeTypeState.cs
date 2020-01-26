using System;

[Serializable]
public class EyeTypeState
{
	public string comment;
	public float thresholdAngleDifference;
	public float bendingMultiplier;
	public float maxAngleDifference;
	public float upBendingAngle;
	public float downBendingAngle;
	public float minBendingAngle;
	public float maxBendingAngle;
	public float leapSpeed;
	public float forntTagDis;
	public float nearDis;
	public float hAngleLimit;
	public float vAngleLimit;
	public EYE_LOOK_TYPE lookType;
}
