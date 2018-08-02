// semmle-extractor-options: --standalone

class C1
{
    void QualifierAccess()
    {
        var x = new UnknownType();
        x.y = 12;
        var y = x.y;
    }

    void UnknownConstCase()
    {
        switch (new object())
        {
            case UnknownEnum.Option1:
                break;
            case UnknownEnum.Option2:
                break;
            case int x:
                break;
            default:
                break;
        }
    }
}

[assembly: System.Reflection.AssemblyTitle("C# attributes test in standalone mode")]
