using System.Collections.Generic;

namespace Semmle.Util
{
    public static class DictionaryExtensions
    {
        /// <summary>
        /// Adds another element to the list for the given key in this
        /// dictionary. If a list does not already exist, a new list is
        /// created.
        /// </summary>
        public static void AddAnother<T1, T2>(this Dictionary<T1, List<T2>> dict, T1 key, T2 element) where T1 : notnull
        {
            if (!dict.TryGetValue(key, out var list))
            {
                list = new List<T2>();
                dict[key] = list;
            }
            list.Add(element);
        }
    }
}
