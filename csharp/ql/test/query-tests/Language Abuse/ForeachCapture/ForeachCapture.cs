using System;
using System.Collections.Generic;
class Test
{
    delegate string Del();

    static event Del event1;

    static void Main(string[] args)
    {
        foreach (var arg in args)
        {
            // BAD: Storing a delegate in an event.
            event1 += () => arg;

            // GOOD: Make a copy of the loop variable.
            var argCopy = arg;
            event1 += () => argCopy;

            // GOOD: Calling a function which does not store the delegate
            goodUseOfDelegate(() => arg);

            // BAD: Calling a function which stores the delegate
            badUseOfDelegate(() => arg);

            // GOOD: The delegate does not escape the loop
            Del d = () => arg;
        }
    }

    static void goodUseOfDelegate(Del d)
    {
        Console.Out.WriteLine(d());
    }

    static void badUseOfDelegate(Del d)
    {
        actions.Add(d);
    }

    static List<Del> actions;
}
