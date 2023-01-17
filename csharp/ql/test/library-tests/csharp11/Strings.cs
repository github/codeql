using System;

public class MyTestClass
{
    public string M1(int x)
    {
        // Use an expression that spans across multiple lines in a string interpolation.
        return $"This is my int {x switch
        {
            42 => "forty two",
            _ => "something else"
        }}.";
    }
}