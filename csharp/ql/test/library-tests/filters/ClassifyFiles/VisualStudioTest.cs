using System;
using System.Collections.Generic;

namespace Microsoft.VisualStudio.TestTools.UnitTesting
{
    class TestClassAttribute : Attribute
    {
        public TestClassAttribute() { }
    }

    class TestMethodAttribute : Attribute
    {
        public TestMethodAttribute() { }
    }
}

namespace VisualStudioTests
{
    class TestMethodAttribute : Attribute { } // fake

    [Microsoft.VisualStudio.TestTools.UnitTesting.TestClass]
    class MyTestSuite
    {
        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethod]
        public void Test1()
        {
        }

        [Microsoft.VisualStudio.TestTools.UnitTesting.TestMethod]
        public void Test2()
        {
        }

        [TestMethod]
        public void NonTest()
        {
        }
    }
}
