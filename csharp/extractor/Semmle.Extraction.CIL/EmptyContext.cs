using System.Collections.Generic;

namespace Semmle.Extraction.CIL
{
    /// <summary>
    /// A generic context which does not contain any type parameters.
    /// </summary>
    public class EmptyContext : GenericContext
    {
        public EmptyContext(Context cx) : base(cx)
        {
        }

        public override IEnumerable<Entities.Type> TypeParameters { get { yield break; } }

        public override IEnumerable<Entities.Type> MethodParameters { get { yield break; } }
    }
}
