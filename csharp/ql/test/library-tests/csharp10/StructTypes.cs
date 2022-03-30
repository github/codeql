using System;

// Struct with user declared parameterless constructor.
public struct MyStructParameterlessConstructor
{
    public int X;
    public readonly int Y;
    public int Z { get; }

    public MyStructParameterlessConstructor()
    {
        X = 1;
        Y = 2;
        Z = 3;
    }
}

// Struct with compiler generated parameterless constructor.
public struct MyDefaultStruct { }