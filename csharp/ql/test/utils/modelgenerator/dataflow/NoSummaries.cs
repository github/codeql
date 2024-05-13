using System;
using System.Collections.Generic;

namespace NoSummaries;

// Single class with a method that produces a flow summary.
// Just to prove that, if a method like this is correctly exposed, a flow summary will be captured.
public class PublicClassFlow
{
    // summary=NoSummaries;PublicClassFlow;false;PublicReturn;(System.Object);;Argument[0];ReturnValue;taint;df-generated
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

    // neutral=NoSummaries;EquatableBound;Equals;(System.Object);summary;df-generated
    public bool Equals(object other)
    {
        return tainted;
    }
}

public class EquatableUnBound<T> : IEquatable<T>
{
    public readonly bool tainted;

    // neutral=NoSummaries;EquatableUnBound<T>;Equals;(T);summary;df-generated
    public bool Equals(T? other)
    {
        return tainted;
    }
}

// No methods in this class will have generated flow summaries as
// simple types are used.
public class SimpleTypes
{
    // neutral=NoSummaries;SimpleTypes;M1;(System.Boolean);summary;df-generated
    public bool M1(bool b)
    {
        return b;
    }

    // neutral=NoSummaries;SimpleTypes;M2;(System.Boolean);summary;df-generated
    public Boolean M2(Boolean b)
    {
        return b;
    }

    // neutral=NoSummaries;SimpleTypes;M3;(System.Int32);summary;df-generated
    public int M3(int i)
    {
        return i;
    }

    // neutral=NoSummaries;SimpleTypes;M4;(System.Int32);summary;df-generated
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
    // neutral=NoSummaries;BaseClass;M1;(System.String);summary;df-generated
    public virtual string M1(string s)
    {
        return "";
    }

    // neutral=NoSummaries;BaseClass;M2;(System.String);summary;df-generated
    public abstract string M2(string s);
}

// No methods in this class will have generated flow as
// the simple types used in the collection are not bulk data types.
public class CollectionFlow
{
    // neutral=NoSummaries;CollectionFlow;ReturnSimpleTypeArray;(System.Int32[]);summary;df-generated
    public int[] ReturnSimpleTypeArray(int[] a)
    {
        return a;
    }

    // neutral=NoSummaries;CollectionFlow;ReturnSimpleTypeList;(System.Collections.Generic.List<System.Int32>);summary;df-generated
    public List<int> ReturnSimpleTypeList(List<int> a)
    {
        return a;
    }

    // neutral=NoSummaries;CollectionFlow;ReturnSimpleTypeDictionary;(System.Collections.Generic.Dictionary<System.Int32,System.Int32>);summary;df-generated
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

// No models should be created, if there exist either a manual summary or neutral summary.
public class ManuallyModelled
{
    public object HasSummary(object o)
    {
        return o;
    }

    public object HasNeutralSummary(object o)
    {
        return o;
    }

    public object HasNeutralSummaryNoFlow(object o)
    {
        return null;
    }
}

public class Properties
{
    public object backingField;
    public object Prop
    {
        get { return backingField; }
        set { backingField = value; }
    }
}
