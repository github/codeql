using System;

class Bad
{
    interface IsPrintable { } // $ Alert
    class Form1 : IsPrintable { }
}
