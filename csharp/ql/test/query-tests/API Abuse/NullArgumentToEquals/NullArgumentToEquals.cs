class NullArgumentToEquals
{
    void M()
    {
        int i = 0;
        i.Equals(null); // $ Alert // BAD

        int? i2 = null;
        i2.Equals(null); // GOOD

        C<int> c = null;
        c.Equals(null); // $ Alert // BAD

        object o = null;
        o.Equals(null); // $ Alert // BAD
    }

    class C<T>
    {
        public override bool Equals(object other)
        {
            return false;
        }
    }
}
