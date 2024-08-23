using System.Collections.Generic;

namespace Semmle.Util
{
    public static class Enumerators
    {
        /// <summary>
        /// Create an enumerable with a single element.
        /// </summary>
        ///
        /// <typeparam name="T">The type of the enumerble/element.</typeparam>
        /// <param name="t">The element.</param>
        /// <returns>An enumerable containing a single element.</returns>
        public static IEnumerable<T> Singleton<T>(T t)
        {
            yield return t;
        }
    }
}
