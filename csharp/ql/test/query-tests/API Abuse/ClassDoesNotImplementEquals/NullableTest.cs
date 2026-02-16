using System;

#nullable enable

namespace Test
{
    class TestClass1 : IEquatable<TestClass1>
    {
        private int field1;

        public bool Equals(TestClass1? param1)
        {
            return param1 != null && field1 == param1.field1;
        }

        public override bool Equals(object? param2)
        {
            return param2 is TestClass1 tc && Equals(tc);
        }

        public override int GetHashCode()
        {
            return field1;
        }
    }

    class TestClass2
    {
        private string field2;

        public TestClass2(string s)
        {
            field2 = s;
        }

        public override bool Equals(object? param3)
        {
            return param3 is TestClass2 tc && field2 == tc.field2;
        }

        public override int GetHashCode()
        {
            return field2?.GetHashCode() ?? 0;
        }
    }
}
