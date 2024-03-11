using System;

namespace My.TypeBased
{
    public class Test
    {
        public void M1()
        {
            var s1 = Source<string>(1);
            MyApi.Api1(s1);
            Sink(s1); // $ hasTaintFlow=1
        }

        public void M2()
        {
            var s2 = Source<string>(2);
            var r = MyApi.Api2(s2);
            Sink(r); // $ hasTaintFlow=2
        }

        public void M31()
        {
            var s3 = Source<string>(3);
            var r = MyApi.Api3(s3, "hello");
            Sink(r); // $ hasTaintFlow=3
        }

        public void M32()
        {
            var s3 = Source<string>(3);
            var r = MyApi.Api3("hello", s3);
            Sink(r); // $ hasTaintFlow=3
        }

        public void M41()
        {
            var s4 = Source<string>(4);
            var o4 = new object();
            var r = MyApi.Api4(s4, o4);
            Sink(r); // $ hasTaintFlow=4
        }

        public void M42()
        {
            var o4 = Source<object>(4);
            var r = MyApi.Api4("hello", o4);
            Sink(r); // No flow
        }

        public void M51()
        {
            var s5 = Source<string>(5);
            var o5 = new object();
            var r = MyApi.Api5(s5, o5);
            Sink(r); // No flow
        }

        public void M52()
        {
            var o5 = Source<object>(5);
            var r = MyApi.Api5("hello", o5);
            Sink(r); // $ hasTaintFlow=5
        }

        public void M6()
        {
            var s6 = Source<string>(6);
            MyApi.Api6(s6, out var r);
            Sink(r); // $ hasTaintFlow=6
        }

        public void M7()
        {
            var s7 = Source<string>(7);
            var r2 = MyApi.Api7(s7, out var r1);
            Sink(r1); // $ hasTaintFlow=7
            Sink(r2); // $ hasTaintFlow=7
        }

        public void M8()
        {
            var o8 = Source<object>(8);
            var i8 = Source<int>(8);
            var r = MyApi.Api8(o8, i8);
            Sink(r); // $ No flow
        }

        public void M9()
        {
            var d9 = Source<DateTime>(9);
            var t9 = Source<TimeSpan>(9);
            var r = MyApi.Api9(d9, t9);
            Sink(r); // No flow
        }

        public void M10()
        {
            var b10 = Source<bool>(10);
            var i10 = Source<int>(10);
            var r = MyApi.Api10(b10, i10);
            Sink(r); // No flow
        }

        public void M11()
        {
            var c = new MyClass("hello", 42);
            var r = c.Api1(42);
            Sink(r); // No flow
        }

        public void M12()
        {
            var s12 = Source<string>(12);
            var c = new MyClass(s12, 0);
            var r = c.Api1(0);
            Sink(r); // $ hasTaintFlow=12
        }

        public void M13()
        {
            var s131 = Source<string>(131);
            var s132 = Source<string>(132);
            var c = new MyClass(s131, 0);
            var r = c.Api2(s132);
            Sink(r); // $ hasTaintFlow=131 hasTaintFlow=132
        }

        public void M14()
        {
            var s14 = Source<string>(14);
            var c = new MyClass(s14, 0);
            c.Api3(out var r);
            Sink(r); // $ hasTaintFlow=14
        }

        public static void Sink(object o) { }

        public static T Source<T>(object source) => throw null;
    }
}
