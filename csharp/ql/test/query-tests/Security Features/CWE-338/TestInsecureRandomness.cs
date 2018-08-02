using System;
using System.Security.Cryptography;
using Microsoft.VisualStudio.TestTools.UnitTesting;

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

[TestClass]
public class InsecureRandomnessTest
{

    [TestMethod]
    public void TestUnsafe()
    {
        // ACCEPTABLE: Using insecure random, but this is a test
        Random r = new Random();
    }
}
