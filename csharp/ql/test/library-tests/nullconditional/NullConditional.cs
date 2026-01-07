using System;

public class C
{
    public int Field;

    public string Property { get; set; } = "";

    public void M(C c, int[] numbers, bool b)
    {
        // Get values.
        var fieldValue = c?.Field;
        var propertyValue = c?.Property;
        var n = numbers?[0];

        // Set values
        c?.Field = 42;
        c?.Property = "Hello";
        numbers?[0] = 7;

        // Set values using operators
        c?.Field -= 1;
        c?.Property += " World";

        // Using the return of an assignment
        var x = c?.Field = 10;

        // Using in a conditional expression
        int? maybenull = 0;
        maybenull = (b ? c : null)?.Field;
    }
}
