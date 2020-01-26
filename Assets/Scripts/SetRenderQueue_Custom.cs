using UnityEngine;
using System;

public class SetRenderQueue_Custom : MonoBehaviour
{
	[Serializable]
	public class QueueData
	{
		public int id;
		public int m_queues;
		public int m_queuesBackup;
	}

	[SerializeField]
	protected QueueData[] m_queueDatas;
	public bool isSetQueue;
}
