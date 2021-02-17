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
            Cx = cx;
        }

        public Context Cx { get; }

        public IEnumerable<Entities.Type> TypeParameters { get { yield break; } }

        public IEnumerable<Entities.Type> MethodParameters { get { yield break; } }

    }
}
