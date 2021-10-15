using System.Collections.Generic;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A method implementation entity.
    /// In the database, the same method could in principle have multiple implementations.
    /// </summary>
    internal class MethodImplementation : UnlabelledEntity
    {
        private readonly Method m;

        public MethodImplementation(Method m) : base(m.Context)
        {
            this.m = m;
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.cil_method_implementation(this, m, Context.Assembly);
            }
        }
    }
}
