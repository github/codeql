namespace TestNamespace
{
    public class SimpleClass
    {
        public void SimpleMethod()
        {
            var x = 5;
            if (x > 0)
            {
                Console.WriteLine("positive");
            }
            else
            {
                Console.WriteLine("negative");
            }
        }
        
        public void CallsOtherMethod()
        {
            SimpleMethod();
        }
        
        public int Add(int a, int b)
        {
            return a + b;
        }
        
        public void LoopExample()
        {
            for (int i = 0; i < 10; i++)
            {
                Console.WriteLine(i);
            }
        }

        // Test float and double constants (ldc.r4, ldc.r8)
        public float GetPi()
        {
            return 3.14159f;
        }

        public double GetE()
        {
            return 2.71828;
        }

        public double FloatArithmetic(float a, double b)
        {
            float localFloat = 1.5f;
            double localDouble = 2.5;
            return (a + localFloat) * (b + localDouble);
        }

        // Test more local variable operations
        public int LocalVariableTest()
        {
            int a = 1;
            int b = 2;
            int c = 3;
            int d = 4;
            int e = 5;  // Forces use of ldloc.s/stloc.s for indices >= 4
            return a + b + c + d + e;
        }

        // Test array operations (ldelem, stelem)
        public int ArrayTest()
        {
            int[] arr = new int[5];
            arr[0] = 10;
            arr[1] = 20;
            arr[2] = 30;
            return arr[0] + arr[1] + arr[2];
        }

        public float[] FloatArrayTest()
        {
            float[] arr = new float[3];
            arr[0] = 1.1f;
            arr[1] = 2.2f;
            arr[2] = 3.3f;
            return arr;
        }

        // Test indirect load/store (ldind, stind)
        public unsafe void PointerTest()
        {
            int value = 42;
            int* ptr = &value;
            *ptr = 100;
            int result = *ptr;
        }

        // Test field operations (ldfld, stfld, ldsfld, stsfld)
        private int _instanceField = 0;
        private static int _staticField = 0;

        public void FieldTest()
        {
            _instanceField = 10;
            int x = _instanceField;
            _staticField = 20;
            int y = _staticField;
        }

        // Test conversions (conv.*)
        public void ConversionTest()
        {
            int i = 42;
            long l = (long)i;       // conv.i8
            float f = (float)i;     // conv.r4
            double d = (double)i;   // conv.r8
            byte b = (byte)i;       // conv.u1
            short s = (short)i;     // conv.i2
        }

        // Test boxing/unboxing
        public void BoxingTest()
        {
            int value = 42;
            object boxed = value;       // box
            int unboxed = (int)boxed;   // unbox.any
        }

        // Test exception handling
        public void ExceptionTest()
        {
            try
            {
                throw new InvalidOperationException("test");
            }
            catch (InvalidOperationException ex)
            {
                Console.WriteLine(ex.Message);
            }
            finally
            {
                Console.WriteLine("finally");
            }
        }

        // Test type checking (isinst, castclass)
        public void TypeCheckTest(object obj)
        {
            if (obj is string str)      // isinst
            {
                Console.WriteLine(str);
            }
            
            var cast = (SimpleClass)obj;  // castclass
        }

        // Test bitwise operations
        public int BitwiseTest(int a, int b)
        {
            int andResult = a & b;
            int orResult = a | b;
            int xorResult = a ^ b;
            int notResult = ~a;
            int shlResult = a << 2;
            int shrResult = a >> 2;
            return andResult + orResult + xorResult + notResult + shlResult + shrResult;
        }

        // Test comparison operations (ceq, clt, cgt)
        public bool ComparisonTest(int a, int b)
        {
            bool eq = a == b;
            bool lt = a < b;
            bool gt = a > b;
            return eq || lt || gt;
        }

        // Test switch statement
        public string SwitchTest(int value)
        {
            switch (value)
            {
                case 0: return "zero";
                case 1: return "one";
                case 2: return "two";
                default: return "other";
            }
        }
    }

    public class WriteToField
    {
        public int value;
        public WriteToField(int x)
        {
            value = x;
        }
    }

    public class B
    {
        public static int LoadFromField()
        {
            WriteToField a = new WriteToField(5);
            return a.value;
        }
    }
}
