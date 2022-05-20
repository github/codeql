using System.Collections.Generic;
using System.Linq;

class Foreach
{
    void M1(string[] args)
    {
        foreach (var arg in args)
            ;
    }

    void M2(string[] args)
    {
        foreach (var _ in args)
            ;
    }

    void M3(IEnumerable<string> e)
    {
        foreach (var x in e?.ToArray() ?? Enumerable.Empty<string>())
          ;
    }

    void M4(IEnumerable<(string, int)> args)
    {
        foreach ((var x, var y) in args)
          ;
    }

    void M5(IEnumerable<(string, int)> args)
    {
        foreach (var (x, y) in args)
          ;
    }

    void M6(IEnumerable<(string, int)> args)
    {
        foreach ((string x, int y) in args)
          ;
    }
}
