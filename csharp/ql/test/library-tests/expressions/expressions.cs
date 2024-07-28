using System;
using System.IO;
using System.Collections.Generic;

namespace Expressions
{
    class Class
    {

        void MainLiterals()
        {
            bool b;
            b = true; // bool literals
            b = false; // bool literals
            b = !b;
            char c = '@'; // char literal
            int i;
            i = 1; // int literal
            i = -i;
            long l;
            l = 8989898l; // long literal
            uint ui;
            ui = 3u; // uint literal
            ulong ul;
            ul = 89898787897ul; // ulong literal
            float f = 4.5f; // float literal
            double d;
            d = 4.565d;  // double literal
            decimal m;
            m = 123.456M;  // decimal literal
            string s;
            s = "test"; // string literal
            object o;
            o = null;  // null literal
        }

        bool LogicalOperators(bool a, bool b)
        {
            int x = a ? 0 : 42;
            bool c = b || x > 3;
            return a && b && !c;
        }

        protected const string constant = "constant"; // constant
        public int f = 0; // field
        public static string name; // static field

        static Class()
        { // static constructor
          // static accesses
            Expressions.Class.name = ""; // accesses to namespace, type and field
            Class.Foo(); // acces to type and call to method
            Foo(); // call to method with implicit qualifier
        }

        Class() : this(0) { }

        protected Class(int i) { }

        static void Foo() { } // static method

        int Bar(int x, string s)
        {  // instance method with parameters
            return s.Length + x; // access to assembly property and binary operation
        }

        string Name
        { // property
            get { return name; } // property getter
            set { name = value; } // property setter with access to implicit parameter 'value'
        }

        public bool this[int i, string s]
        { // indexer with two parameters
            get { return i > 2 && s.Equals(""); } // access to parameters and call to assembly method
            set { if (value) f++; } // access to special variable value and post-increment on field
        }

        void MainAccesses(Class other, params object[] args) // instance method with value parameter and params parameter
        {
            Name = "aName"; // write access to property
            string n = this.Name; // read access to property
            int i = (new Class().Bar(4 + 2, Name)); // class instantiation and call to Method with binary operation and read acces to property
            other.Name = constant; // write access to property of a parameter
            other[i, Nested.constant] = this[0, ""]; // indexer write and read access, and access to constant through static type reference
            int[] array = { (int)4ul, (int)3l }; // array creation
            array[1] = 5; // array element access
            MyInlineArray inlinearray = new MyInlineArray();
            inlinearray[2] = 7; // inline array element access
        }

        void MainIsAsCast(string s, object o, object p)
        {
            if (o is Class) // is
            {
                Class c = o as Class; // as
                Class d = (Class)p; // explicit cast
            }
            var x = (Class)((Class)o as object); // mixed
            int i = default(int); // default value
            s = s + " " + i; // implicit cast
        }

        class Y<T, U>
        {
        }

        class X<T>
        {

            public static void PrintTypes()
            {
                Type[] t = { // array creation
          typeof(void), // typeof
          typeof(int),
          typeof(System.Int32),
          typeof(string),
          typeof(double[]),
          typeof(void),
          typeof(T),
          typeof(X<T>),
          typeof(X<X<T>>), // generic typeof
          typeof(Y<,>)
        };
                T e = default(T); // default value
            }

        }

        class Nested : Class
        {
            static Nested() { }
            Nested(bool b) { }
            Nested(int i) : base(i + 1) { }

            void OtherAccesses()
            {
                this.f = 0; // explicit this qualifier
                base.MainAccesses(this, 1, 2, 3, 4, ""); // base qualifier and call to method with this and params arguments
            }

        }

        void MainLocalVarDecl()
        {
            int a;
            int b = 2, c = 3;
            a = 1;
            Console.WriteLine(a + b + c);
            var x = 45;
            var y = "test";
        }

        void MainLocalConstDecl()
        {
            const float pi = 3.1415927f;
            const int r = 10 + 15;
            Console.WriteLine(pi * r * r);
        }

        void MainChecked()
        {
            string s = checked(Name);
            int t = unchecked(f + 20);
        }

        void MainElementAccess(int i)
        {
            object[] os = new object[] { i };
        }

        static void MainDelegateAndMethodAccesses()
        {
            D cd1 = new D(C.M1); // instantiation with a static method
            D cd2 = C.M2; // direct assignment
            D cd3 = cd1 + cd2; // combination
            D cd4 = cd3 + cd1;
            D cd5 = cd4 - cd3; // removal
            cd4 += cd5; // another style for combination
            cd4 -= cd1; // another style for removal

            C c = new C();
            D cd6 = new D(c.M3); // instantiation with an instance method
            D cd7 = new D(cd6); // instantiation with an existing delegate variable

            cd1(-40); // invocation
            int x = 0;
            cd7(34 + x);

            Predicate<int> pi = new Predicate<int>(X.F); // generic instantiation
            Predicate<string> ps = X.G; // direct generic assignment

            bool b = pi(3) & ps(""); // generic invocation

            System.Threading.ContextCallback d; // assembly delegate

            void LocalFunction(int i) { };
            cd1 = new D(LocalFunction);
            cd1 = LocalFunction;
        }
    }

    delegate bool Predicate<T>(T value);

    delegate void D(int x);

    class C
    {

        public static void M1(int i) { }
        public static void M2(int i) { }
        public void M3(int i) { }

    }

    public class X
    {

        public static bool F(int i) { return i < 2; }

        public static bool G(string s) { return false; }

    }

    public delegate void EventHandler(object sender, object e);

    public class Button
    {

        public event EventHandler Click;

        protected void OnClick(object e)
        {
            if (Click != null) // access to an event
                Click(this, e); // delegate call to event
        }

        public void Reset()
        {
            Click = null;
        }
    }

    public class LoginDialog
    {

        Button OkButton;
        Button CancelButton;

        public LoginDialog()
        {
            OkButton = new Button();
            OkButton.Click += new EventHandler(OkButtonClick); // add event handler
            CancelButton = new Button();
            CancelButton.Click -= new EventHandler(CancelButtonClick); // remove event handler
        }

        void OkButtonClick(object sender, object e)
        { // Handle OkButton.Click event
        }

        void CancelButtonClick(object sender, object e)
        { // Handle CancelButton.Click event
        }

    }

    public class IntVector
    {

        public IntVector(int length) { }

        public int Length { get { return 4; } }

        public int this[int index] { get { return 0; } set { } }

        public static IntVector operator ++(IntVector iv)
        {
            IntVector temp = new IntVector(iv.Length);
            for (int i = 0; i < iv.Length; i++)
                temp[i] = iv[i] + 1;
            return temp;
        }

        public static IntVector operator +(IntVector iv1, IntVector iv2)
        {
            return iv1;
        }

    }

    class TestUnaryOperator
    {

        void MainUnaryOperator()
        {
            IntVector iv1 = new IntVector(4); // vector of 4 x 0
            IntVector iv2;
            iv2 = iv1++;  // iv2 contains 4 x 0, iv1 contains 4 x 1
            iv2 = ++iv1;  // iv2 contains 4 x 2, iv1 contains 4 x 2
            IntVector iv3 = iv1 + iv2;
        }

    }

    public struct Digit
    {

        byte value;

        public Digit(byte value)
        {
            if (value < 0 || value > 9)
                throw new ArgumentException();
            this.value = value;
        }

        public static implicit operator byte(Digit d)
        {
            return d.value;
        }

        public static explicit operator Digit(byte b)
        {
            return new Digit(b);
        }

    }

    class TestConversionOperator
    {

        void MainConversionOperator()
        {
            Digit d = (Digit)8;
            byte b = d;
        }

    }

    public class Point
    {

        int x, y;

        public int X { get { return x; } set { x = value; } }
        public int Y { get { return y; } set { y = value; } }

    }

    public class Rectangle
    {

        Point p1, p2;

        public Point P1 { get { return p1; } set { p1 = value; } }
        public Point P2 { get { return p2; } set { p2 = value; } }

    }

    public class Rectangle2
    {

        Point p1 = new Point();
        Point p2 = new Point();

        public Point P1 { get { return p1; } }
        public Point P2 { get { return p2; } }

    }

    public class Contact
    {

        string name;
        List<string> phoneNumbers = new List<string>();

        public string Name { get { return name; } set { name = value; } }
        public List<string> PhoneNumbers { get { return phoneNumbers; } }

    }

    public class TestCreations
    {

        void MainCreations()
        {
            Point a = new Point { X = 0, Y = 1 };
            Rectangle r = new Rectangle
            {
                P1 = new Point() { X = 0, Y = 1 },
                P2 = new Point() { X = 2, Y = 3 }
            };
            Rectangle2 r2 = new Rectangle2
            {
                P1 = { X = 0, Y = 1 },
                P2 = { X = 2, Y = 3 }
            };
            List<int> digits = new List<int> { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
            var contacts = new List<Contact> {
        new Contact {
          Name = "Chris Smith",
          PhoneNumbers = { "206-555-0101", "425-882-8080" }
        },
        new Contact {
          Name = "Bob Harris",
          PhoneNumbers = { "650-555-0199" }
        }
      };
            var is1 = new int[,] { { 0, 1 }, { 2, 3 }, { 4, 5 } };
            var is2 = new int[3, 2] { { 0, 1 }, { 2, 3 }, { 4, 5 } };
            int[][] is3 = new int[100][];
            int[,] is4 = new int[100, 5];
            var is5 = new[] { 1, 10, 100, 1000 }; // int[]
            var is6 = new[] { 1, 1.5, 2, 2.5 }; // double[]
            var is7 = new[,] { { "hello", null }, { "world", "!" } }; // string[,]
            var contacts2 = new[] {
        new {
          Name = "Chris Smith",
          PhoneNumbers = new[] { "206-555-0101", "425-882-8080" }
        },
        new {
          Name = "Bob Harris",
          PhoneNumbers = new[] { "650-555-0199" }
        }
      };
            int i = 1;
            var list1 = new List<int> { { i = 2 } };
            var list2 = new List<object> { new { i = 2 } };
            var list3 = new List<bool> { { i == 2 } };
        }

        delegate int S(int x, int y);
        delegate void Unit();

        void MultiDimensionalArrayCreations()
        {
            object o = new int[,] { { 1, 2 }, { 3, 4 }, { 5, 6 } };
            o = new int[,,] { { { 1, 2, 3 }, { 4, 5, 6 } }, { { 7, 8, 9 }, { 10, 11, 12 } } };
            o = new int[,][,]
            {
                { new int[,] { {1,3}, {5,7} }, new int[,] { {0,2}, {4,6}, {8,10} }, new int[,] { {11,22}, {99,88}, {0,9} } },
                { new int[,] { {1,3}, {5,7} }, new int[,] { {0,2}, {4,6}, {8,10} }, new int[,] { {11,22}, {99,88}, {0,9} } }
            };
            o = new int[][,] { new int[,] { { 1, 2 } }, new int[,] { { 1, 2, 3 }, { 1, 2, 3 }, { 1, 2, 3 }, { 1, 2, 3 } } };
        }

        void MainAnonymousFunctions()
        {
            Func<Int16, Byte> f1 = x => (byte)(x + 1); // Implicitly typed, expression body
            Func<Int32, Double> f2 = x => { return x + 1; }; // Implicitly typed, statement body
            Func<int, int> f3 = (int x) => x + 1; // Explicitly typed, expression body
            Func<int, string> f4 = (int x) => { return x + ""; }; // Explicitly typed, statement body
            S f5 = (x, y) => x * y; // Multiple parameters
            Unit f6 = () => Console.WriteLine(); // No parameters
            Func<int, int> f7 = delegate (int x) { return x + 1; }; // Anonymous method expression
            int j = 0;
            Func<int> f8 = delegate { return j + 1; };  // Parameter list omitted
        }

    }

    class OperatorCalls
    {
        public void delegateCombine(MyDelegate fun)
        {
            MyDelegate PropertyChanged = null;
            PropertyChanged += fun;
        }

        public Num addition(Num a, Num b, Num c)
        {
            Num result = a + b;
            result += c;
            return result;
        }
        public class Num
        {
            int value;

            public Num(int value)
            {
                this.value = value;
            }

            public static Num operator +(Num c1, Num c2)
            {
                return new Num(c1.value + c2.value);
            }
        }

        public delegate void MyDelegate(string e);
    }

    class ExpressionDepth
    {
        const int d = 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 +
                      1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1;
    }

    class TupleExprs
    {
        void Test()
        {
            var a = default((int, string));
            var b = default((bool, int[], object));
            var x = typeof((int, string));
            var y = typeof((bool, int[], dynamic));
        }
    }

    [System.Runtime.CompilerServices.InlineArray(10)]
    struct MyInlineArray
    {
        private int myInlineArrayElements;
    }

    class ClassC1(object oc1) { }

    class ClassC2(object oc2) : ClassC1(oc2) { }

    class SuppressNullableWarning
    {

        public object? Api() => new object();

        public void Test(object? arg0)
        {
            var x = arg0!;
            var y = Api()!;
        }
    }
}
