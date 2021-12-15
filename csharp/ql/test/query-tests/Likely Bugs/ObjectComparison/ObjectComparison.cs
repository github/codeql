using System;
using Moq;

interface I { }

class ObjectComparisonTest : I
{
    public readonly ObjectComparisonTest Field1 = null;

    void M()
    {
        ObjectComparisonTest x = new ObjectComparisonTest();
        ObjectComparisonTest y = new ObjectComparisonTest();

        var b = x == y; // GOOD: but still reference equality
        b = (object)x == y; // BAD
        b = x == (object)y; // BAD
        b = (I)x == y; // BAD
        b = x == (I)y; // BAD
        b = (object)x == Field1; // GOOD
        b = Field1 == (object)x; // GOOD

        object o = "";
        b = o == ""; // GOOD

        Mock.Of<ObjectComparisonTest>(obj => obj.Field1 == (object)x); // GOOD
    }

    public override bool Equals(object other)
    {
        if (this == other) return true; // GOOD: short-cut optimization

        if (GetType() != other.GetType() || other == null) return false;

        return true;
    }
}

namespace Moq
{
    public class Mock
    {
        public static T Of<T>(Predicate<T> p) { throw new Exception(); }
    }
}
