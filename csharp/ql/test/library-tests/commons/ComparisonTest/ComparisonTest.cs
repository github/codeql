using System;

class ComparisonTest
{
    public void M()
    {
        // Operators
        var i = 42;
        if (i == 32) ;
        if (i != 32) ;
        if (i > 32) ;
        if (i < 32) ;
        if (i >= 32) ;
        if (i <= 32) ;

        // Qualified method calls
        var o = (object)i;
        var s = "abc";
        this.Equals(32); // Equals
        if (o.Equals(32)) ; // Equals
        if (s.Equals("32")) ; // IEquatable<T>.Equals

        // Unqualified method calls
        Equals(32);
        Equals(o, 32);
        object.Equals(0, 32);
        ReferenceEquals(0, 32);
        object.ReferenceEquals(0, 32);

        // User-defined operators
        C c1 = null, c2 = null;
        if (c1 == c2) ;
        if (c1 != c2) ;
        if (c1 > c2) ;
        if (c1 < c2) ;
        if (c1 >= c2) ;
        if (c1 <= c2) ;

        // IComparer.Compare
        var comparer = new Comparer();
        comparer.Compare(i, "32");

        // IComparer<T>.Compare
        var intComparer = new IntComparer();
        intComparer.Compare(i, 32);

        // IComparable.Compare
        c1.CompareTo("c2");

        // IComparable<T>.Compare
        c1.CompareTo(c2);
    }

    class C : IComparable, IComparable<C>
    {
        public static bool operator ==(C x, C y) { return true; }
        public static bool operator !=(C x, C y) { return true; }
        public static bool operator >(C x, C y) { return true; }
        public static bool operator <(C x, C y) { return true; }
        public static bool operator <=(C x, C y) { return true; }
        public static bool operator >=(C x, C y) { return true; }

        public int CompareTo(object other) { return 0; }

        public int CompareTo(C other) { return 0; }
    }

    class Comparer : System.Collections.IComparer
    {
        public int Compare(object x, object y) { return 0; }
    }

    class IntComparer : System.Collections.Generic.IComparer<int>
    {
        public int Compare(int x, int y) { return 0; }
    }

    class CompareWithConstant
    {
        void M(int x, int y)
        {
            // x = y
            var b = x.CompareTo(y) == 0;
            // y < x
            b = x.CompareTo(y) == 1;
            // x < y
            b = x.CompareTo(y) == -1;
            // x <= y
            b = x.CompareTo(y) < 1;
            // x < y
            b = x.CompareTo(y) < 0;
            // y <= x
            b = x.CompareTo(y) > -1;
            // y < x
            b = x.CompareTo(y) > 0;
            // x <= y
            b = x.CompareTo(y) <= 0;
            // x < y
            b = x.CompareTo(y) <= -1;
            // y <= x
            b = x.CompareTo(y) >= 0;
            // y < x
            b = x.CompareTo(y) >= 1;

            // y < x, 0 < x.CompareTo(y)
            b = x.CompareTo(y).CompareTo(0).CompareTo(1) == 0;
        }
    }

    void DynamicComparisons(object o1, object o2)
    {
        dynamic d1 = o1;
        dynamic d2 = o2;
        var b = d1 == d2;
        b = d1 != d2;
        b = d1 > d2;
        b = d1 < d2;
        b = d1 >= d2;
        b = d1 <= d2;
    }
}
