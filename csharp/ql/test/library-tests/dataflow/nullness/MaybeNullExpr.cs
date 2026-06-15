using System;

public class C
{
    string Prop { get; set; }

    void M(object o, bool b)
    {
        // Conditional expr might be null.
        var conditionalExpr = b ? new object() : null;

        // Null-coalescing expr might be null as the right operand is null.
        var nullCoalescing = o ?? null;

        // Cast might be null.
        var c = o as C;

        // Conditional access might be null as the qualifier might be null.
        var s1 = (o as C)?.Prop;

        // Conditional access might be null as the qualifier might be null.
        var i = o?.GetHashCode();
    }
}
