// Broken type without a name.
public class { }

// Legal declaration, but we want don't want to use it.
public class var { }

public class C
{
    public string Prop { get; set; }
}


public class Program
{
    public static void Main()
    {
        C x1 = new C();
        string y1 = x1.Prop;

        var x2 = new C(); // Has type `var` as this overrides the implicitly typed keyword `var`.
        var y2 = x2.Prop; // Unknown type as `x2` has type `var`.

        C2 x3 = new C2(); // Unknown type.
        var y3 = x3.Prop; // Unknown property of unknown type.

        string s = x1.Prop + x3.Prop;
    }
}
