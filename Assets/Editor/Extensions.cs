using System.Collections.Generic;
using UnityEngine;

namespace IllusionMods.KoikatuModdingTools
{
    static class Extensions
    {
        public static T SafeGet<T>(this List<T> list, int index)
        {
            if (list == null)
                return default(T);
            return ((uint)index >= list.Count) ? default(T) : list[index];
        }

        public static T GetOrAddComponent<T>(this GameObject gameObject) where T : Component
        {
            if (gameObject == null)
                return null;
            T val = gameObject.GetComponent<T>();
            if (val == null)
                val = gameObject.AddComponent<T>();
            return val;
        }
    }
}
