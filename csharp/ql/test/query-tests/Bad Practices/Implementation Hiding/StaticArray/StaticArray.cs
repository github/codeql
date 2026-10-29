using System;

class Program
{
    public static readonly int[] EmptyArray1 = new int[0]; // GOOD: empty

    public static readonly int[] EmptyArray2 = new int[] { }; // GOOD: empty

    public static readonly int[,,,] EmptyArray3 = new int[3, 3, 0, 2]; // GOOD: empty

    public static readonly int[] EmptyArray4; // GOOD: empty

    public static readonly int[] NonEmptyArray1 = new int[] { 42 }; // $ Alert // BAD

    static readonly int[] NonEmptyArray2 = new int[] { 42 }; // GOOD: private

    public static readonly int[] NonEmptyArray3; // $ Alert // BAD

    public static readonly int[] Array = new int[new Random().Next()]; // $ Alert // BAD

    static Program()
    {
        EmptyArray4 = new int[0];
        NonEmptyArray3 = new int[4];
    }
}
