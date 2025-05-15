using System.Collections;
using System.Collections.Generic;

public class Test
{
    public void M()
    {
        var h = new Hashtable();
        h.Add(this, null); // $ Alert

        var d = new Dictionary<Test, bool>();
        d.Add(this, false); // $ Alert
    }

    public override bool Equals(object other)
    {
        return false;
    }
}
