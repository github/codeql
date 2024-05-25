using System;
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

        /// <summary>
        /// Adds a new value or replaces the existing value (if the new value is greater than the existing) 
        /// in this dictionary for the given key.
        /// </summary>
        public static void AddOrUpdateToLatest<T1, T2>(this Dictionary<T1, T2> dict, T1 key, T2 value) where T1 : notnull where T2 : IComparable<T2>
        {
            if (!dict.TryGetValue(key, out var existing) || existing.CompareTo(value) < 0)
            {
                dict[key] = value;
            }
        }
    }
}
