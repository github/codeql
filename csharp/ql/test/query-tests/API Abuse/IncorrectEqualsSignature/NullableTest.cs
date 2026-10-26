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

    class TestClass2 : IEquatable<TestClass2>
    {
        private int field1;

        public bool Equals(TestClass2 param1)
        {
            return param1 != null && field1 == param1.field1;
        }

        public override bool Equals(object? param2)
        {
            return param2 is TestClass2 tc && Equals(tc);
        }

        public override int GetHashCode()
        {
            return field1;
        }
    }

    class TestClass3 : IEquatable<TestClass3>
    {
        private int field1;

        public bool Equals(TestClass3? param1)
        {
            return param1 != null && field1 == param1.field1;
        }

        public override bool Equals(object param2)
        {
            return param2 is TestClass3 tc && Equals(tc);
        }

        public override int GetHashCode()
        {
            return field1;
        }
    }

    class TestClass4 : IEquatable<TestClass4>
    {
        private int field1;

        public bool Equals(TestClass4 param1)
        {
            return param1 != null && field1 == param1.field1;
        }

        public override bool Equals(object param2)
        {
            return param2 is TestClass4 tc && Equals(tc);
        }

        public override int GetHashCode()
        {
            return field1;
        }
    }
}