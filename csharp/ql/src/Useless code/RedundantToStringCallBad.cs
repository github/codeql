using System;

class Bad
{
    static string Hello(object o)
    {
        return string.Format("Hello, {0}!", o.ToString());
    }
}
