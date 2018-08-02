using System.Collections;
using System.Collections.Generic;

public class Test
{
    public void M()
    {
        var h = new Hashtable();
        h.Add(this, null); // BAD
        var d = new Dictionary<Test, bool>();
        d.Add(this, false); // BAD
    }

    public override bool Equals(object other)
    {
        return false;
    }
}

// semmle-extractor-options: /r:System.Runtime.Extensions.dll
