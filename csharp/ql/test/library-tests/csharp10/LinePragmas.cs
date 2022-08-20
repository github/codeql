using System;

public class MyLineDirective
{
    public static void M1()
    {
#line (1, 1) - (1, 30) 5 "LinePragmasRef1.cs"
        int i = 0;
#line (2, 1) - (5, 32) "LinePragmasRef2.cs"
        int j = 0;
    }
}