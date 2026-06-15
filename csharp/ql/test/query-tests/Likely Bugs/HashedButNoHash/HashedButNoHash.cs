using System.Collections;
using System.Collections.Generic;

public class Test
{
    public void M()
    {
        var h = new Hashtable();
        h.Add(this, null); // $ Alert
        h.Contains(this); // $ Alert
        h.ContainsKey(this); // $ Alert
        h[this] = null; // $ Alert
        h.Remove(this); // $ Alert

        var l = new List<Test>();
        l.Add(this); // Good

        var d = new Dictionary<Test, bool>();
        d.Add(this, false); // $ Alert
        d.ContainsKey(this); // $ Alert
        d[this] = false; // $ Alert
        d.Remove(this); // $ Alert
        d.TryAdd(this, false); // $ Alert
        d.TryGetValue(this, out bool _); // $ Alert

        var hs = new HashSet<Test>();
        hs.Add(this); // $ Alert
        hs.Contains(this); // $ Alert
        hs.Remove(this); // $ Alert
    }

    public override bool Equals(object other)
    {
        return false;
    }
}
