using System;

class Good
{
    [AttributeUsage(AttributeTargets.Class)]
    class PrintableAttribute : Attribute { }

    [Printable]
    class Form1 { }
}
