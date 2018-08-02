using System;

class IdAttribute : Attribute
{
    public IdAttribute(int x = 0) { }

    public int id;
}

class IntAttributes
{
    // GOOD: Constants in attributes shouldn't be flagged, and shouldn't contribute to the count.
    [Id(id = 555)]
    void f1()
    {
    }

    // GOOD: Constants in attributes shouldn't be flagged, and shouldn't contribute to the count.
    [Id(555 + 555)]
    void f2()
    {
        // BAD
        var x = 555 +
            555 + 555 + 555 + 555 + 555 + 555 + 555 + 555 + 555 + 555 +
            555 + 555 + 555 + 555 + 555 + 555 + 555 + 555 + 555 + 555;
    }

}

// semmle-extractor-options: /r:System.ComponentModel.Primitives.dll
