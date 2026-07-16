using System.Collections.Generic;

class AbstractToConcreteCollection
{
    void M(IEnumerable<string> strings)
    {
        var list = (List<string>) strings; // $ Alert // BAD
        var o = (object) strings; // GOOD
    }
}
