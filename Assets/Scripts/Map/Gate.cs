using UnityEngine;

namespace ActionGame.Point
{
    public class Gate : MonoBehaviour
    {
        [SerializeField]
        private Transform _playerTrans;

        // Token: 0x040011BC RID: 4540
        [SerializeField]
        private BoxCollider _playerHitBox;

        // Token: 0x040011BD RID: 4541
        [SerializeField]
        private BoxCollider _heroineHitBox;

        // Token: 0x040011C0 RID: 4544
        [Header("Icon")]
        [SerializeField]
        private Canvas _canvas;

        // Token: 0x040011C1 RID: 4545
        [SerializeField]
        private BoxCollider _iconHitBox;

        // Token: 0x040011C2 RID: 4546
        [SerializeField]
        private bl_MiniMapItem miniMapIcon;
    }
}
