using System;

namespace Microsoft.VisualStudio.TestTools.UnitTesting
{
    public static class Assert
    {
        public static void IsNull(object o) { }
        public static void IsNotNull(object o) { }
        public static void IsTrue(bool b) { }
        public static void IsFalse(bool b) { }
    }

    public class AssertFailedException : Exception  { }

    public class TestClassAttribute : Attribute
    {
        public TestClassAttribute() { }
    }

    public class TestMethodAttribute : Attribute
    {
        public TestMethodAttribute() { }
    }

    public class TestInitializeAttribute : Attribute
    {
        public TestInitializeAttribute() { }
    }
}
