using System;
using System.Collections.Generic;

namespace Xunit
{
    class FactAttribute : Attribute
    {
        public FactAttribute() { }
    }

    class TheoryAttribute : Attribute
    {
        public TheoryAttribute() { }
    }
}

namespace XunitTests
{
    class FactAttribute : Attribute { } // fake
    class TheoryAttribute : Attribute { } // fake

    class MyTestSuite
    {
        [Xunit.Fact]
        public void Test1()
        {
        }

        [Xunit.Theory]
        public void Test2()
        {
        }

        [Fact]
        public void NonTest1()
        {
        }

        [Theory]
        public void NonTest2()
        {
        }
    }
}
