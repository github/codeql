using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// Base class for all type containers (namespaces, types, methods).
    /// </summary>
    internal abstract class TypeContainer : LabelledEntity, IGenericContext
    {
        protected TypeContainer(Context cx) : base(cx)
        {
        }

        public abstract IEnumerable<Type> MethodParameters { get; }
        public abstract IEnumerable<Type> TypeParameters { get; }
    }
}
