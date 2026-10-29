using System;

public class MyConstStringInterpolationClass
{
    public const string hello = "Hello";
    public const string helloWorld = $"{hello} World";
    public const string reallyHelloWorld = $"Really {helloWorld}";
}