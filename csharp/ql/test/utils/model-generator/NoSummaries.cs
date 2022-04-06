using System;

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