using System;

namespace NoSummaries;

// Single class with a method that produces a flow summary.
// Just to prove that, if a method like this is correctly exposed, a flow summary will be captured.
public class PublicClassFlow
{
    public int PublicReturn(int input)
    {
        return input;
    }
}

public sealed class PublicClassNoFlow
{
    private int PrivateReturn(int input)
    {
        return input;
    }

    internal int InternalReturn(int input)
    {
        return input;
    }

    private class PrivateClassNoFlow
    {
        public int ReturnParam(int input)
        {
            return input;
        }
    }

    private class PrivateClassNestedPublicClassNoFlow
    {
        public class NestedPublicClassFlow
        {
            public int ReturnParam(int input)
            {
                return input;
            }
        }
    }
}