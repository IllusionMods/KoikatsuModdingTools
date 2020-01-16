using UnityEngine;

[AddComponentMenu("Dynamic Bone/Dynamic Bone Collider")]
public class DynamicBoneCollider : MonoBehaviour
{
    public enum Direction { X, Y, Z }
    public enum Bound { Outside, Inside }

    public Vector3 m_Center = Vector3.zero;
    public float m_Radius = 0.5f;
    public float m_Height;
    public Direction m_Direction;
    public Bound m_Bound;
}
