using System.Collections.Generic;
using System.Linq;

namespace Semmle.Extraction.CIL
{
    /// <summary>
    /// When we decode a type/method signature, we need access to
    /// generic parameters.
    /// </summary>
    public abstract class GenericContext
    {
        public Context Cx { get; }

        protected GenericContext(Context cx)
        {
            this.Cx = cx;
        }

        /// <summary>
        /// The list of generic type parameters/arguments, including type parameters/arguments of
        /// containing types.
        /// </summary>
        public abstract IEnumerable<Entities.Type> TypeParameters { get; }

        /// <summary>
        /// The list of generic method parameters/arguments.
        /// </summary>
        public abstract IEnumerable<Entities.Type> MethodParameters { get; }
    }
}
