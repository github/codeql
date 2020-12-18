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
        /// The list of generic method parameters.
        /// </summary>
        public abstract IEnumerable<Entities.Type> MethodParameters { get; }

        /// <summary>
        /// Gets the `p`th type parameter.
        /// </summary>
        /// <param name="p">The index of the parameter.</param>
        /// <returns>
        /// For constructed types, the supplied type.
        /// For unbound types, the type parameter.
        /// </returns>
        public Entities.Type GetGenericTypeParameter(int p)
        {
            return TypeParameters.ElementAt(p);
        }

        /// <summary>
        /// Gets the `p`th method type parameter.
        /// </summary>
        /// <param name="p">The index of the parameter.</param>
        /// <returns>
        /// For constructed types, the supplied type.
        /// For unbound types, the type parameter.
        /// </returns>
        public Entities.Type GetGenericMethodParameter(int p)
        {
            return MethodParameters.ElementAt(p);
        }
    }
}
