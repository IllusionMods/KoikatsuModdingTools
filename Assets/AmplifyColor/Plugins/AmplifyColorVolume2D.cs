// Amplify Color - Advanced Color Grading for Unity
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using UnityEngine;

[RequireComponent(typeof(BoxCollider2D))]
[AddComponentMenu("Image Effects/Amplify Color Volume 2D")]
public class AmplifyColorVolume2D : AmplifyColorVolumeBase
{
    private void OnTriggerEnter2D(Collider2D other)
    {
        AmplifyColorTriggerProxy2D tp = other.GetComponent<AmplifyColorTriggerProxy2D>();
        if (tp != null && tp.OwnerEffect.UseVolumes && (tp.OwnerEffect.VolumeCollisionMask & (1 << gameObject.layer)) != 0)
            tp.OwnerEffect.EnterVolume(this);
    }

    private void OnTriggerExit2D(Collider2D other)
    {
        AmplifyColorTriggerProxy2D tp = other.GetComponent<AmplifyColorTriggerProxy2D>();
        if (tp != null && tp.OwnerEffect.UseVolumes && (tp.OwnerEffect.VolumeCollisionMask & (1 << gameObject.layer)) != 0)
            tp.OwnerEffect.ExitVolume(this);
    }
}
