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

    class Assert
    {
        public void True(bool condition) { }
        public void True(bool condition, string message, params object[] parms) { }

        public void IsTrue(bool condition) { }
        public void IsTrue(bool condition, string message, params object[] parms) { }

        public void False(bool condition) { }
        public void False(bool condition, string message, params object[] parms) { }

        public void IsFalse(bool condition) { }
        public void IsFalse(bool condition, string message, params object[] parms) { }

        public void Null(object anObject) { }
        public void Null(object anObject, string message, params object[] parms) { }

        public void IsNull(object anObject) { }
        public void IsNull(object anObject, string message, params object[] parms) { }

        public void NotNull(object anObject) { }
        public void NotNull(object anObject, string message, params object[] parms) { }

        public void IsNotNull(object anObject) { }
        public void IsNotNull(object anObject, string message, params object[] parms) { }

        public void That(bool condition) { }
        public void That(bool condition, string message, params object[] parms) { }
        public void That(bool condition, Func<string> getExceptionMessage) { }
    }

    public class AssertionException : Exception { }
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
