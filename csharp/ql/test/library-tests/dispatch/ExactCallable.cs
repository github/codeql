using System;

namespace Test
{
    public class MainClass
    {
        public static void Main(string[] args)
        {
            var test = new Tests<ImplBeta>();
            test.Run<Tests<ImplBeta>, ImplBeta>(null);
        }

        public class Tests<T1> : ImplAlpha where T1 : ImplBeta, new()
        {
            public void Run<T2, T3>(T2 arg) where T2 : Tests<T3> where T3 : ImplBeta, new()
            {
                // Expect call to ImplAlpha.M().
                Interface int_alpha = new ImplAlpha();
                int_alpha.M();

                // Expect call to ImplBeta.M().
                Interface int_beta = new ImplBeta();
                int_beta.M();

                // Expect call to ImplAlpha.M().
                ImplAlpha alpha_alpha = new ImplAlpha();
                alpha_alpha.M();

                // Expect call to ImplBeta.M().
                Interface int_both = new ImplAlpha();
                int_both = new ImplBeta();
                int_both.M();

                // Expect call to ImplBeta.M().
                Interface int_beta_inheriter = new Inheriter();
                int_beta_inheriter.M();

                // Expect call to UnqualifiedM().
                UnqualifiedM();

                // Expect call to SecondLevelImpl.M().
                Interface int_secondlevelimpl = new SecondLevelImpl();
                int_secondlevelimpl.M();

                // Expect call to OnlyStaticClass.M().
                OnlyStaticClass.M();

                // Expect no detected calls as correct implementation cannot be determined (could be ImplAlpha or SecondLevelImpl).
                AlphaFactory().M();

                // Expect call to ImplBeta.M().
                BetaFactory().M();

                // Expect no detected calls as correct implementation cannot be determined.
                InterfaceFactory().M();

                // Expect call to ImplAlpha.M()
                base.M();

                // Expect call to Tests.M()
                this.M();

                // Expect call to Tests.M()
                M();

                // Expect call to ImplAlpha.M2()
                M2();

                // Expect call to ImplAlpha.M3()
                M3();

                // Expect call to ImplAlpha.M().
                typeof(ImplAlpha).InvokeMember("M", System.Reflection.BindingFlags.Public, null, alpha_alpha, new object[0]);

                var methodInfo = typeof(ImplAlpha).GetMethod("M");

                // Expect call to ImplAlpha.M().
                var args = new object[] { 42 };
                methodInfo.Invoke(alpha_alpha, args);

                // Expect call to ImplAlpha.M().
                methodInfo.Invoke(alpha_alpha, System.Reflection.BindingFlags.InvokeMethod, null, new object[0], System.Globalization.CultureInfo.CurrentCulture);

                // Expect call to UnqualifiedM().
                typeof(MainClass).InvokeMember("UnqualifiedM", System.Reflection.BindingFlags.Public, null, null, new object[0]);

                // Expect call to UnqualifiedM().
                var methodInfo2 = new MainClass().GetType().GetMethod("UnqualifiedM");

                // Expect call to UnqualifiedM().
                methodInfo2.Invoke(null, new object[0]);

                // Expect call to UnqualifiedM.M().
                methodInfo2.Invoke(null, System.Reflection.BindingFlags.InvokeMethod, null, new object[0], System.Globalization.CultureInfo.CurrentCulture);

                // Expect call to MainClass.MethodWithOut
                args = new object[] { 42, null };
                typeof(MainClass).InvokeMember("MethodWithOut", System.Reflection.BindingFlags.Public, null, null, args);

                // Expect call to MainClass.MethodWithOut2
                typeof(MainClass).InvokeMember("MethodWithOut2", System.Reflection.BindingFlags.Public, null, null, args);

                // Expect call to Tests.M()
                arg.M();

                // Expect call to ImplBeta.M()
                new T1().M();
            }

            public override void M() { }
        }

        public interface Interface
        {
            void M();
        }

        public class ImplAlpha : Interface
        {
            public virtual void M() { }

            public void M(int i, int j = 42) { }

            public void M(string s) { }

            public virtual void M2() { }

            public void M3() { }
        }

        public class ImplBeta : Interface
        {
            public void M() { }
        }

        public class Inheriter : ImplBeta
        {

        }

        public class SecondLevelImpl : ImplAlpha
        {
            public override void M() { }

            public override void M2() { }

            new public void M3() { }
        }

        static void UnqualifiedM() { }

        static class OnlyStaticClass
        {
            public static void M() { }
        }

        static ImplAlpha AlphaFactory()
        {
            return new ImplAlpha();
        }

        static ImplBeta BetaFactory()
        {
            return new ImplBeta();
        }

        static Interface InterfaceFactory()
        {
            return new ImplAlpha();
        }

        static void MethodWithOut(int x, out bool positive)
        {
            positive = x >= 0;
        }

        static void MethodWithOut2(int x, out object boxed)
        {
            boxed = x;
        }

        public void M1()
        {
            M2();
        }

        public void M2()
        {
            if (true)
                return;
            M1();
        }
    }
}
