using System;
using System.Threading;

/// <summary>
///   A minimal threadsafe counter.
/// </summary>
class AtomicCounter
{
    /// <summary>
    ///   The current value of the counter.
    /// </summary>
    int currentValue = 0;

    /// <summary>
    ///   Increments the value of the counter.
    /// </summary>
    ///
    /// <param name="incrementBy">The amount to increment.</param>
    /// <exception cref="System.OverflowException">If the counter would overflow.</exception>
    /// <returns>The new value of the counter.</returns>
    ///
    /// <remarks>This method is threadsafe.</remarks>
    public int Increment(int incrementBy = 1)
    {
        int oldValue, newValue;
        do
        {
            oldValue = currentValue;
            newValue = oldValue + incrementBy;
            if (newValue < 0) throw new OverflowException("Counter value is out of range");
        }
        while (oldValue != Interlocked.CompareExchange(ref currentValue, newValue, oldValue));
        return newValue;
    }
}
