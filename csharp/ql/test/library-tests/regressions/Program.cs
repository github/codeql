

using System;
using System.Threading.Tasks;

namespace TestCsharpProject
{
    static class Program
    {
        public static void Create(Func<string, IDisposable> subscribe) { return; }
        public static void Create(Func<string, Task<Action>> subscribeAsync) { return; }
        public static void Create(Func<string, Task<IDisposable>> subscribeAsync) { return; }

        static void Main(string[] args)
        {
            Create(obs => (IDisposable)null);
        }
    }
}

namespace LabelRegression
{
    class Container<T>
    {
        public class Builder
        {
        }
    }

    class Use
    {
        void First<T>(Container<T>.Builder b)
        {
        }
    }
}

namespace EnumConstants
{
    enum E { A = 0, B = 1 };
}

class TypeMentions
{
    ValueTuple<int, TypeMentions> f;

    interface I<T> { }
    interface I<T, U> { }

    class C : I<int>, I<string, string>, I<string>
    {
    }
}

class NameOfMethodGroups
{
    int MethodGroup() => 0;
    int MethodGroup(int x) => x;

    void Test()
    {
        var x = nameof(MethodGroup);
        x = nameof(NameOfMethodGroups.MethodGroup);
    }
}

class Designations
{
    bool f(out int x)
    {
        x = 0;
        return true;
    }

    int Test()
    {
        if (f(out var x) && f(out var _))
        {
            return x;
        }
        return 0;
    }
}

class WhileIs
{
    void Test()
    {
        object x = null;
        while(x is string s)
        {
            var y = s;
        }
    }
}

class ObjectInitializerType
{
    struct Point
    {
        public object Name;
    }

    void F()
    {
        new Point() { Name = "Bob" };
    }
}
