using System;

public class Example : Attribute
{
    public Example(int x) { }
}

public class LambdaAttributes
{

    public void M1()
    {
        // Examples needed for attributes.
        var f7 = ([Example(1)] int x) => x.ToString(); // Parameter attribute
        var f8 =[Example(2)] (int x) => x.ToString(); // Lambda attribute
        var f9 =[return: Example(3)] (int x) => x.ToString(); // Return value attribute
    }
}