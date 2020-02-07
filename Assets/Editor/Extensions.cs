using System.Collections.Generic;

namespace IllusionMods.KoikatuModdingTools
{
    static class Extensions
    {
        public static T SafeGet<T>(this List<T> list, int index)
        {
            if (list == null)
            {
                return default(T);
            }
            return ((uint)index >= list.Count) ? default(T) : list[index];
        }
    }
}
