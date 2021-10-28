using System;
using System.IO;
using System.Collections.Generic;

namespace Statements
{
    class Class
    {

        static void Main()
        {
            block:
            {
                {
                }
                {
                    {
                    }
                }
            }
        }

        static void MainEmpty()
        {
            Statements.Class c = new Class();
            ; ; ;
            if (true) ;
        }

        static void MainLocalVarDecl()
        {
            int a;
            int b = 2, c = 3;
            a = 1;
            Console.WriteLine(a + b + c);
            var x = 45;
            var y = "test";
        }

        static void MainLocalConstDecl()
        {
            const float pi = 3.1415927f;
            const int r = 5 + 20;
            Console.WriteLine(pi * r * r);
        }

        static void MainExpr()
        {
            int i;
            i = 123;
            Console.WriteLine(i);
            i++;
            Console.WriteLine(i);
        }

        static void MainIf(string[] args)
        {
            if (args.Length == 0)
            {
                Console.WriteLine("No arguments");
            }
            else
            {
                Console.WriteLine("One or more arguments");
            }
        }

        static void MainSwitch(string[] args)
        {
            int n = args.Length;
            switch (n)
            {
                case 0:
                    Console.WriteLine("No arguments");
                    break;
                case 1:
                    Console.WriteLine("One argument");
                    break;
                default:
                    Console.WriteLine("{0} arguments", n);
                    break;
            }
        }

        static int StringSwitch(string foo)
        {
            switch (foo)
            {
                case "black":
                    return 0;
                case "red":
                    return 1;
                case "green":
                    return 2;
                case "yellow":
                    return 3;
                case "blue":
                    return 4;
                case "magenta":
                    return 5;
                case "cyan":
                    return 6;
                case "grey":
                case "white":
                    return 7;
            }
            return 7;
        }

        static void MainWhile(string[] args)
        {
            int i = 0;
            while (i < args.Length)
            {
                Console.WriteLine(args[i]);
                i++;
            }
        }

        static void MainDo()
        {
            string s;
            do
            {
                s = Console.ReadLine();
                if (s != null) Console.WriteLine(s);
            } while (s != null);
        }

        static void MainFor(string[] args)
        {
            for (int i = 0; i < args.Length; i++)
            {
                Console.WriteLine(args[i]);
            }
        }

        static void MainForeach(string[] args)
        {
            foreach (string s in args)
            {
                Console.WriteLine(s);
            }
        }

        static void MainBreak()
        {
            while (true)
            {
                string s = Console.ReadLine();
                if (s == null) break;
                Console.WriteLine(s);
            }
        }

        static void MainContinue(string[] args)
        {
            for (int i = 0; i < args.Length; i++)
            {
                if (args[i].StartsWith("/")) continue;
                Console.WriteLine(args[i]);
            }
        }

        static void MainGoto(string[] args)
        {
            int i = 0;
            goto check;
            loop: Console.WriteLine(args[i++]);
            check: if (i < args.Length) goto loop;
        }

        static int Add(int a, int b)
        {
            return a + b;
        }
        static void MainReturn()
        {
            Console.WriteLine(Add(1, 2));
            return;
        }

        static IEnumerable<int> Range(int from, int to)
        {
            for (int i = from; i < to; i++)
            {
                yield return i;
            }
            yield break;
        }
        static void MainYield()
        {
            foreach (int x in Range(-10, 10))
            {
                Console.WriteLine(x);
            }
        }

        static double Divide(double x, double y)
        {
            if (y == 0) throw new DivideByZeroException();
            return x / y;
        }
        static void MainTryThrow(string[] args)
        {
            try
            {
                if (args.Length != 2)
                {
                    throw new Exception("Two numbers required");
                }
                double x = double.Parse(args[0]);
                double y = double.Parse(args[1]);
                Console.WriteLine(Divide(x, y));
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
            catch
            {
                Console.WriteLine("Exception");
            }
            finally
            {
                Console.WriteLine("Good bye!");
            }
        }

        static void MainCheckedUnchecked()
        {
            int i = int.MaxValue;
            checked
            { // Exception
                Console.WriteLine(i + 1);
            }
            unchecked
            { // Overflow
                Console.WriteLine(i + 1);
            }
        }

        class AccountLock
        {
            decimal balance;
            public void Withdraw(decimal amount)
            {
                lock (this)
                {
                    if (amount > balance)
                    {
                        throw new Exception("Insufficient funds");
                    }
                    balance -= amount;
                }
            }
        }

        static void MainUsing()
        {
            using (TextWriter w = File.CreateText("test.txt"))
            {
                w.WriteLine("Line one");
                w.WriteLine("Line two");
                w.WriteLine("Line three");
            }
            using (File.CreateText("test.txt"))
            {
            }
        }

        static void MainLabeled()
        {
            goto Label;
            Label:
            int x = 23;
            x = 9;
        }
    }
}
