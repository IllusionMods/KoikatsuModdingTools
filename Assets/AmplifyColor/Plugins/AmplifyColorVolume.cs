// Amplify Color - Advanced Color Grading for Unity
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>

using UnityEngine;

[RequireComponent(typeof(BoxCollider))]
[AddComponentMenu("Image Effects/Amplify Color Volume")]
public class AmplifyColorVolume : AmplifyColorVolumeBase
{
    private void OnTriggerEnter(Collider other)
    {
        AmplifyColorTriggerProxy tp = other.GetComponent<AmplifyColorTriggerProxy>();
        if (tp != null && tp.OwnerEffect.UseVolumes && (tp.OwnerEffect.VolumeCollisionMask & (1 << gameObject.layer)) != 0)
            tp.OwnerEffect.EnterVolume(this);
    }

    private void OnTriggerExit(Collider other)
    {
        AmplifyColorTriggerProxy tp = other.GetComponent<AmplifyColorTriggerProxy>();
        if (tp != null && tp.OwnerEffect.UseVolumes && (tp.OwnerEffect.VolumeCollisionMask & (1 << gameObject.layer)) != 0)
            tp.OwnerEffect.ExitVolume(this);
    }
}
