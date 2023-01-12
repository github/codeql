using System;
using System.Collections.Generic;

namespace NoSummaries;

// Single class with a method that produces a flow summary.
// Just to prove that, if a method like this is correctly exposed, a flow summary will be captured.
public class PublicClassFlow
{
    public object PublicReturn(object input)
    {
        return input;
    }
}

public sealed class PublicClassNoFlow
{
    private object PrivateReturn(object input)
    {
        return input;
    }

    internal object InternalReturn(object input)
    {
        return input;
    }

    private class PrivateClassNoFlow
    {
        public object ReturnParam(object input)
        {
            return input;
        }
    }

    private class PrivateClassNestedPublicClassNoFlow
    {
        public class NestedPublicClassFlow
        {
            public object ReturnParam(object input)
            {
                return input;
            }
        }
    }
}

public class EquatableBound : IEquatable<object>
{
    public readonly bool tainted;
    public bool Equals(object other)
    {
        return tainted;
    }
}

public class EquatableUnBound<T> : IEquatable<T>
{
    public readonly bool tainted;
    public bool Equals(T? other)
    {
        return tainted;
    }
}

// No methods in this class will have generated flow summaries as
// simple types are used.
public class SimpleTypes
{
    public bool M1(bool b)
    {
        return b;
    }

    public Boolean M2(Boolean b)
    {
        return b;
    }

    public int M3(int i)
    {
        return i;
    }

    public Int32 M4(Int32 i)
    {
        return i;
    }
}

public class HigherOrderParameters
{
    public string M1(string s, Func<string, string> map)
    {
        return s;
    }

    public object M2(Func<object, object> map, object o)
    {
        return map(o);
    }
}

public abstract class BaseClass
{
    // Negative summary.
    public virtual string M1(string s)
    {
        return "";
    }

    // Negative summary.
    public abstract string M2(string s);
}

// No methods in this class will have generated flow as
// the simple types used in the collection are not bulk data types.
public class CollectionFlow
{
    public int[] ReturnSimpleTypeArray(int[] a)
    {
        return a;
    }

    public List<int> ReturnSimpleTypeList(List<int> a)
    {
        return a;
    }

    public Dictionary<int, int> ReturnSimpleTypeDictionary(Dictionary<int, int> a)
    {
        return a;
    }
}

// A neutral model should not be created for a parameterless constructor.
public class ParameterlessConstructor
{
    public bool IsInitialized;

    public ParameterlessConstructor()
    {
        IsInitialized = true;
    }
}
