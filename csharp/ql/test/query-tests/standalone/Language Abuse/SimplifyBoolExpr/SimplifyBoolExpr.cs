using System;

// The missing matching operators deliberately model an incompletely compiled database.
class IncompleteOperatorTest
{
    // GOOD: Rewriting this as `left != right` could recursively call this operator.
    public static bool operator !=(IncompleteOperatorTest left, IncompleteOperatorTest right)
    {
        // BAD: Rewriting this built-in comparison cannot call the enclosing operator.
        bool valuesDiffer = !(left.Value == right.Value); // $ Alert

        // BAD: Explicitly converting both operands prevents a call to the enclosing operator.
        bool referencesDiffer = !((object)left == (object)right); // $ Alert

        return valuesDiffer && referencesDiffer && !(left == right);
    }

    // GOOD: Rewriting this as `left >= right` could recursively call this operator.
    public static bool operator >=(IncompleteOperatorTest left, IncompleteOperatorTest right) => !(left < right);

    int Value { get; }
}

class IncompleteReverseOperatorTest
{
    // GOOD: Rewriting this as `left == right` could recursively call this operator.
    public static bool operator ==(IncompleteReverseOperatorTest left, IncompleteReverseOperatorTest right) => !(left != right);

    // GOOD: Rewriting this as `left < right` could recursively call this operator.
    public static bool operator <(IncompleteReverseOperatorTest left, IncompleteReverseOperatorTest right) => !(left >= right);
}

class IncompleteGreaterOperatorTest
{
    // GOOD: Rewriting this as `left <= right` could recursively call this operator.
    public static bool operator <=(IncompleteGreaterOperatorTest left, IncompleteGreaterOperatorTest right) => !(left > right);

    // GOOD: Rewriting this as `left > right` could recursively call this operator.
    public static bool operator >(IncompleteGreaterOperatorTest left, IncompleteGreaterOperatorTest right) => !(left <= right);
}

class IncompleteDifferentOperatorTest
{
    // BAD: The suggested operator differs from the enclosing operator.
    public static bool operator >(IncompleteDifferentOperatorTest left, IncompleteDifferentOperatorTest right) => !(left == right); // $ Alert
}

class IncompleteNestedOperatorTest
{
    public static bool operator !=(IncompleteNestedOperatorTest left, IncompleteNestedOperatorTest right)
    {
        // GOOD: The replacement could call the enclosing operator from this lambda.
        Func<bool> lambda = () => !(left == right);

        // GOOD: The replacement could call the enclosing operator from this local function.
        bool Local() => !(left == right);

        return lambda() || Local();
    }
}
