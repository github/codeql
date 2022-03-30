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
        while (x is string s)
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

class LiteralConversions
{
    struct Point
    {
        public int? x, y;
    }

    void F()
    {
        new Point { x = 1, y = 2 };
    }
}

class DynamicType
{
    void F()
    {
        dynamic t = (dynamic)null;
    }
}

class LocalVariableTags
{
    Func<int, int> F = x => { int y = x; return y; };

    private static Func<object, string, object> _getter => (o, n) =>
    {
        object x = o;
        return x;
    };
}

partial class C1<T> where T : DynamicType
{
}

partial class C1<T> where T : DynamicType
{
}

namespace NoPia
{
    class EmbeddedTypesManager<
        TEmbeddedTypesManager,
        TEmbeddedType
        >
        where TEmbeddedTypesManager : EmbeddedTypesManager<TEmbeddedTypesManager, TEmbeddedType>
        where TEmbeddedType : EmbeddedTypesManager<TEmbeddedTypesManager, TEmbeddedType>
    {
    }
}

unsafe class ArrayTypesTest
{
    int*[][] field;
}

class NameofNamespace
{
    string s = nameof(System) + nameof(System.Threading.Tasks);
}

class UsingDiscard
{
    void F()
    {
        foreach (var _ in new IDisposable[] { })
            using (_)
            {
            }
    }
}

class TupleMatching
{
    (int, object) G(object o1, object o2)
    {
        (object, object)? pair = (o1, o2);
        return (0, pair is var (x, y) ? x : null);
    }
}

class C2<T> { }

class C3<T> : C2<C4<T>> { }

class C4<T> : C2<C3<T>> { }

class C5 : C4<C5> { }
