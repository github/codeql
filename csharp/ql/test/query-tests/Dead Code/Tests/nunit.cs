using System;
using System.Collections.Generic;

namespace NUnit.Framework
{
    public class ValueSourceAttribute : Attribute
    {
        public ValueSourceAttribute(string name) { }
        public ValueSourceAttribute(Type t, string name) { }
    }

    public class TestCaseSourceAttribute : Attribute
    {
        public TestCaseSourceAttribute(string name) { }
        public TestCaseSourceAttribute(Type t, string name) { }
    }

    public class TestFixtureAttribute : Attribute
    {
    }

    public class TestAttribute : Attribute
    {
    }
}

namespace NUnitTests
{
    using NUnit.Framework;

    [TestFixture]
    class MyTestSuite
    {
        // GOOD: Called from Source
        void F()
        {
        }

        // GOOD: Used as a ValueSource
        IEnumerable<int> Source()
        {
            F();
            yield return 1;
        }

        // GOOD: Used as a TestCaseSource
        object[] TestCases = { 1 };

        // GOOD: Public
        [Test]
        public void Test1([ValueSource("Source")] int n)
        {
        }

        // GOOD: Public
        [Test, TestCaseSource("TestCases")]
        public void Test3(int n)
        {
        }
    }
}
