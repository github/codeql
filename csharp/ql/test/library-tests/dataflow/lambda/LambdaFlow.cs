using System;

public class LambdaFlow
{
    /// <summary>
    /// Flow into a normal method
    /// </summary>
    class Ex1
    {
        void M1(string s)
        {
            Sink(s); // $ hasValueFlow=1
        }

        public void M2()
        {
            var source = Source(1);
            M1(source);
        }
    }







    /// <summary>
    /// Flow into a lambda
    /// </summary>
    class Ex2
    {
        void M1(Action<string> lambda)
        {
            var source = Source(2);
            lambda(source);
        }

        void M2()
        {
            Action<string> lambda = x => Sink(x); // $ hasValueFlow=2
            M1(lambda);
        }
    }







    /// <summary>
    /// Flow out of a lambda
    /// </summary>
    class Ex3
    {
        Func<string> M1()
        {
            return () => Source(3);
        }

        void M2()
        {
            var lambda = M1();
            Sink(lambda()); // $ hasValueFlow=3
        }
    }







    /// <summary>
    /// Flow through a lambda
    /// </summary>
    class Ex4
    {
        string M1(Func<string, string> lambda, string input)
        {
            return lambda(input);
        }

        void M2()
        {
            Func<string, string> id = x => x;
            var source = Source(4);
            var output = M1(id, source);
            Sink(output); // $ hasValueFlow=4
        }
    }







    /// <summary>
    /// No flow into lambda (call context sensitivity)
    /// </summary>
    class Ex5
    {
        void M1(Action<string> lambda, string input)
        {
            lambda(input);
        }

        void M2(Action<string> lambda, string input)
        {
            M1(lambda, input);
        }

        void M3()
        {
            Action<string> lambda1 = arg => Sink(arg);
            Action<string> lambda2 = arg => { };

            var source = Source(5);
            var nonSource = "non-source";

            M1(lambda1, nonSource);
            M1(lambda2, source);

            M2(lambda1, nonSource);
            M2(lambda2, source);
        }
    }







    /// <summary>
    /// Flow into a returned lambda
    /// </summary>
    class Ex6
    {
        Action<string> M1()
        {
            return x => Sink(x); // $ hasValueFlow=6
        }

        void M2()
        {
            var source = Source(6);
            var lambda = M1();
            lambda(source);
        }
    }







    /// <summary>
    /// No flow through lambda
    /// </summary>
    class Ex7
    {
        void M1(Func<string, string> lambda)
        {
            var source = Source(7);
            lambda(source);
        }

        void M2(Func<string, string> lambda)
        {
            var nonSource = "non-source";
            var output = lambda(nonSource);
            Sink(output);
        }

        void M3()
        {
            Func<string, string> id = x => x;
            M1(id);
            M2(id);
        }
    }

    static string Source(int source) => source.ToString();

    static void Sink(string value) { }
}