// semmle-extractor-options: /langversion:8.0

using System;

class Ranges
{
    void F()
    {
        var array = new int[] { 1, 2, 3, 4 };

        var slice1 = array[1..3];
        var slice2 = array[0..^1];
        int x = 2, y = 3;
        var slice3 = array[x..y];
        var slice4 = array[..y];
        var slice5 = array[x..];
        var slice6 = array[..];
        var slice7 = array[^10..^5];
    }
}
