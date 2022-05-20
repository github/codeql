using System;
using System.Collections.Generic;

namespace NUnit.Framework
{
    class ValueSourceAttribute : Attribute
    {
        public ValueSourceAttribute(string name) { }
        public ValueSourceAttribute(Type t, string name) { }
    }

    class TestCaseSourceAttribute : Attribute
    {
        public TestCaseSourceAttribute(string name) { }
        public TestCaseSourceAttribute(Type t, string name) { }
    }

    class TestFixtureAttribute : Attribute
    {
    }

    class TestAttribute : Attribute
    {
    }
}

namespace NUnitTests
{
    using NUnit.Framework;

    class MyTestSources
    {
        IEnumerable<int> Source()
        {
            yield return 1;
        }

        object[] TestCases = { 1 };
    }

    [TestFixture]
    class MyTestSuite
    {
        IEnumerable<int> Source()
        {
            yield return 1;
        }

        object[] TestCases = { 1 };

        [Test]
        public void Test1([ValueSource("Source")] int n)
        {
        }

        [Test]
        public void Test2([ValueSource(typeof(MyTestSources), "Source")] int n)
        {
        }

        [Test, TestCaseSource("TestCases")]
        public void Test3(int n)
        {
        }

        [Test, TestCaseSource(typeof(MyTestSources), "TestCases")]
        public void Test4(int n)
        {
        }

        [Test, TestCaseSource("PropertyTestCases")]
        public void Test5(int n)
        {
        }

        object[] PropertyTestCases { get; set; }
    }
}
