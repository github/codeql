/// <summary>
///   BAD: An example of a class that lacks documentation
///   for a type parameter.
/// </summary>
class Stack<T>
{
}

/// <summary>
///   BAD: An example of a class that has incorrect documentation
///   for the type parameter.
/// </summary>
/// <typeparam name="X">The type of each stack element.</typeparam>
class Stack<T>
{
}

/// <summary>
///   GOOD: An example of a class whose type parameters are
///   correctly documented.
/// </summary>
/// <typeparam name="T">The type of each stack element.</typeparam>
class Stack<T>
{
}
