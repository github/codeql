using System;
using System.Collections.Generic;

namespace Semmle.Util
{
    /// <summary>
    /// A dictionary which performs an action when items are added to the dictionary.
    /// The order in which keys and actions are added does not matter.
    /// </summary>
    /// <typeparam name="TKey"></typeparam>
    /// <typeparam name="TValue"></typeparam>
    public class ActionMap<TKey, TValue> where TKey : notnull
    {
        public void Add(TKey key, TValue value)
        {

            if (actions.TryGetValue(key, out var a))
                a(value);
            values[key] = value;
        }

        public void OnAdd(TKey key, Action<TValue> action)
        {
            if (actions.TryGetValue(key, out var a))
            {
                actions[key] = a + action;
            }
            else
            {
                actions.Add(key, action);
            }

            if (values.TryGetValue(key, out var val))
            {
                action(val);
            }
        }

        // Action associated with each key.
        private readonly Dictionary<TKey, Action<TValue>> actions = new Dictionary<TKey, Action<TValue>>();

        // Values associated with each key.
        private readonly Dictionary<TKey, TValue> values = new Dictionary<TKey, TValue>();
    }
}
