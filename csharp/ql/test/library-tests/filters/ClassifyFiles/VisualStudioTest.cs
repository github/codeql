using System;
using System.Collections.Generic;

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
