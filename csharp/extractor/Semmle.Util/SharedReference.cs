namespace Semmle.Util
{
    /// <summary>
    /// An instance of this class maintains a shared reference to an object.
    /// This makes it possible for several different parts of the code to
    /// share access to an object that can change (that is, they all want
    /// to refer to the same object, but the object to which they jointly
    /// refer may vary over time).
    /// </summary>
    /// <typeparam name="T">The type of the shared object.</typeparam>
    public sealed class SharedReference<T> where T : class
    {
        /// <summary>
        /// The shared object to which different parts of the code want to refer.
        /// </summary>
        public T? Obj { get; set; }
    }
}
