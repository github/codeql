using System;
using System.Security.Cryptography;
using Microsoft.VisualStudio.TestTools.UnitTesting;

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

// semmle-extractor-options: ${testdir}/../../../resources/stubs/Microsoft.VisualStudio.TestTools.UnitTesting.cs
