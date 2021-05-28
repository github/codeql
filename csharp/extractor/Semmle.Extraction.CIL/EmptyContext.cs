using System.Collections.Generic;

namespace Semmle.Extraction.CIL
{
    /// <summary>
    /// A generic context which does not contain any type parameters.
    /// </summary>
    internal class EmptyContext : IGenericContext
    {
        public EmptyContext(Context cx)
        {
            Context = cx;
        }

        public Context Context { get; }

        public IEnumerable<Entities.Type> TypeParameters { get { yield break; } }

        public IEnumerable<Entities.Type> MethodParameters { get { yield break; } }

    }
}
