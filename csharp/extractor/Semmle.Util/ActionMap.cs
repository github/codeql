using System;
using System.Collections.Generic;

namespace Semmle.Util
{
    /// <summary>
    /// A dictionary which performs an action when items are added to the dictionary.
    /// The order in which keys and actions are added does not matter.
    /// </summary>
    /// <typeparam name="Key"></typeparam>
    /// <typeparam name="Value"></typeparam>
    public class ActionMap<Key, Value> where Key : notnull
    {
        public void Add(Key key, Value value)
        {

            if (actions.TryGetValue(key, out var a))
                a(value);
            values[key] = value;
        }

        public void OnAdd(Key key, Action<Value> action)
        {
            if (actions.TryGetValue(key, out var a))
            {
                actions[key] = a + action;
            }
            else
            {
                actions.Add(key, action);
            }

            Value val;
            if (values.TryGetValue(key, out val))
            {
                action(val);
            }
        }

        // Action associated with each key.
        readonly Dictionary<Key, Action<Value>> actions = new Dictionary<Key, Action<Value>>();

        // Values associated with each key.
        readonly Dictionary<Key, Value> values = new Dictionary<Key, Value>();
    }
}
