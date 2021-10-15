using System;

class Bad1
{
    string GenerateEmptyClass(string c)
    {
        return string.Format("class {0} { }", "C");
    }
}
