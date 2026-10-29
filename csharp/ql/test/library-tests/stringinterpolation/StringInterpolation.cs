using System;

public class MyStringInterpolationClass
{

    public void M()
    {
        float i = 3.14159f;
        const int align = 5;
        var x1 = $"Hello, Pi {i}";
        var x2 = $"Hello, Pi {i:F1}";
        var x3 = $"Hello, Pi {i,6}";
        var x4 = $"Hello, Pi {i,6:F3}";
        var x5 = $"Hello, Pi {i,align}";
        var x6 = $"Hello, Pi {i,align:F2}";
    }
}
