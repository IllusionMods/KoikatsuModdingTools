using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//for usage, see https://github.com/Wogrim/Wogrim-Misc-Unity

[ExecuteInEditMode]
public class DeleteExtraBones : MonoBehaviour {

	//list of bones with bone weights
	//TODO: change to a more efficient container
	private List<Transform> weightedBones;

	//list of bones to delete
	private List<Transform> deletableBones;

	void Start () {
		//run the thing
		Execute();

		//remove this script from the item
		DestroyImmediate(this);
	}

	private void Execute()
	{
		//make list of bones with bone weights
		weightedBones = new List<Transform>();
		foreach (SkinnedMeshRenderer rend in gameObject.GetComponentsInChildren<SkinnedMeshRenderer>(true)) {
			foreach (Transform bone in rend.bones) {
				//add bone to weighted bones if not already in the list
				if (!weightedBones.Contains (bone))
					weightedBones.Add (bone);
			}
		}

		//make list of deletable bones by recursively going through hierarchy, depth-first
		deletableBones = new List<Transform>();
		deleteBone(transform);

		//delete the deletable bones, which were put in the list depth-first
		//so going through the list in order they will not have any children
		int count = deletableBones.Count;
		foreach (Transform t in deletableBones) {
			//Debug.Log ("Deleting " + t.name); // DEBUG
			DestroyImmediate (t.gameObject);
		}
		Debug.Log("DeleteExtraBones deleted " + count + " extra bones.");
		deletableBones.Clear();
		weightedBones.Clear();
	}

	private bool deleteBone(Transform t)
	{
		//whether or not we will delete this bone
		bool deletable = true;

		//if there are bone weights for this bone, don't delete
		if (weightedBones.Contains(t)) {
			deletable = false;
			//Debug.Log (t.name + " not deletable because bone weights."); //DEBUG
		}

		//if there are any components besides transform, don't delete
		Component[] components = t.gameObject.GetComponents<Component>();
		foreach(Component c in components)
		{
			if(c.GetType() != typeof(Transform))
			{
				deletable = false;
				//Debug.Log (t.name + " not deletable because " + c.GetType().ToString() + " component."); //DEBUG
				//if you break the loop, the debug message will only print the first component found instead of all
				break;
			}
		}

		//see if children are deletable (the depth-first recursive part)
		//if any child isn't deletable, don't delete
		for (int i = 0; i < t.childCount; i++) {
			if (!deleteBone(t.GetChild(i))) {
				deletable = false;
				//Debug.Log (t.name + " not deletable because child " + t.GetChild(i).name + " not deletable."); //DEBUG
				//must not break the loop, we still need to run it on all children
			}
		}

		//delete this bone if deletable (added to list, deleted later)
		if (deletable)
			deletableBones.Add(t);

		//tell parent if deletable
		return deletable;
	}

}
