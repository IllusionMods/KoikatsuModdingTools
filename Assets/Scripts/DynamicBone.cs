using System.Collections.Generic;
using UnityEngine;

[AddComponentMenu("Dynamic Bone/Dynamic Bone")]
public class DynamicBone : MonoBehaviour
{
    public enum FreezeAxis { None, X, Y, Z }

    public Transform m_Root;
    public float m_UpdateRate = 60f;
    [Range(0f, 1f)]
    public float m_Damping = 0.1f;
    public AnimationCurve m_DampingDistrib;
    [Range(0f, 1f)]
    public float m_Elasticity = 0.1f;
    public AnimationCurve m_ElasticityDistrib;
    [Range(0f, 1f)]
    public float m_Stiffness = 0.1f;
    public AnimationCurve m_StiffnessDistrib;
    [Range(0f, 1f)]
    public float m_Inert;
    public AnimationCurve m_InertDistrib;
    public float m_Radius;
    public AnimationCurve m_RadiusDistrib;
    public float m_EndLength;
    public Vector3 m_EndOffset = Vector3.zero;
    public Vector3 m_Gravity = Vector3.zero;
    public Vector3 m_Force = Vector3.zero;
    public List<DynamicBoneCollider> m_Colliders;
    public List<Transform> m_Exclusions;
    public FreezeAxis m_FreezeAxis;
    public bool m_DistantDisable;
    public Transform m_ReferenceObject;
    public float m_DistanceToObject = 20f;
    public List<Transform> m_notRolls;
}