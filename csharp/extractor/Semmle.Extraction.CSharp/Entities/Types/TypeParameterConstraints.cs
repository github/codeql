using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class TypeParameterConstraints : FreshEntity
    {
        public TypeParameterConstraints(Context cx)
            : base(cx) { }

        protected override void Populate(TextWriter trapFile)
        {
        }
    }
}
