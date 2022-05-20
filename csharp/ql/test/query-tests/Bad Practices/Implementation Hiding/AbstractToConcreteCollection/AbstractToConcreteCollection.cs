using System.Collections.Generic;

class AbstractToConcreteCollection
{
    void M(IEnumerable<string> strings)
    {
        var list = (List<string>) strings; // BAD
        var o = (object) strings; // GOOD
    }
}
