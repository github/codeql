using System.Collections;
using System.Collections.Generic;

public class Test
{
    int[] numbers = { 1, 2, 3 };

    // NOT OK
    public bool AreTheseMyNumbers(int[] numbers)
    {
        return this.numbers.Equals(numbers);
    }

    // OK
    public bool HonestAreTheseMyNumbers(int[] numbers)
    {
        return this.numbers == numbers;
    }

    // NOT OK (string is also IEnumerable)
    public bool Incomparable(string s)
    {
        return numbers.Equals(s);
    }

    // NOT OK
    public bool CollectionEquals(IEnumerable<int> c1)
    {
        return c1.Equals(c1);
    }

    class CollectionImplementingIEnumerable1 : IEnumerable<int>
    {
        public IEnumerator<int> GetEnumerator()
        {
            return null;
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return null;
        }
    }

    class CollectionImplementingIEnumerable2 : IEnumerable<int>
    {
        public IEnumerator<int> GetEnumerator()
        {
            return null;
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return null;
        }
    }

    class CollectionImplementingIEnumerable3 : IEnumerable<int>
    {
        public IEnumerator<int> GetEnumerator()
        {
            return null;
        }

        IEnumerator IEnumerable.GetEnumerator()
        {
            return null;
        }

        public override bool Equals(object other)
        {
            return false;
        }
    }

    class ImplementsEquals : CollectionImplementingIEnumerable2
    {
        public override bool Equals(object other)
        {
            return false;
        }
    }

    // NOT OK: Nothing overrides Equals()
    bool OverriddenEquals(CollectionImplementingIEnumerable1 c)
    {
        return c.Equals(c);
    }

    // OK: ImplementEquals overrides Equals()
    bool OverriddenEquals(CollectionImplementingIEnumerable2 c)
    {
        return c.Equals(c);
    }

    // OK: This class overrides Equals()
    bool OverriddenEquals(CollectionImplementingIEnumerable3 c)
    {
        return c.Equals(c);
    }
}
