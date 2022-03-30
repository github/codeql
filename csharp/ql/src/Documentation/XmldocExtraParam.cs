/// <summary>
///   Increments the value of the counter.
/// </summary>
///
/// <param name="amount">The amount to increment.</param>
/// <exception cref="System.OverflowException">If the counter would overflow.</exception>
/// <returns>The new value of the counter.</returns>
///
/// <remarks>This method is threadsafe.</remarks>
public int Increment(int incrementBy = 1)
