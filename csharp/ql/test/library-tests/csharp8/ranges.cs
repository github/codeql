// semmle-extractor-options: /langversion:8.0

using System;

class Ranges
{
    void F()
    {
        var array = new int[] { 1, 2, 3, 4 };
        var array2 = new int[2, 3];

        var slice1 = array[1..3];
        var slice2 = array[0..^1];
        int x=2, y=3;
        var slice3 = array[x..y];
        var slice4 = array[..y];
        var slice5 = array[x..];
        var slice6 = array[..];
        var slice7 = array[^10..^5];
        var slice8 = array2[1..2, ..];
    }
}

// These are temporary until qltest uses .NET Core 3.0.
namespace System
{
    public readonly struct Index
    {
        public Index(int value, bool fromEnd = false) { }
        public static implicit operator Index(int value) => default(Index);
    }

    public readonly struct Range
    {
        public Range(Index start, Index end) => throw null;
        public static Range StartAt(System.Index start) => throw null;
        public static Range EndAt(System.Index end) => throw null;
        public static Range All => throw null;
        public static Range Create(Index start, Index end) => throw null;
        public static implicit operator int(Range r) => throw null;
    }
}
