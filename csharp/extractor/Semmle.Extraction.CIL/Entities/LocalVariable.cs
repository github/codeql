using System.Collections.Generic;

namespace Semmle.Extraction.CIL.Entities
{
    interface ILocal : ILabelledEntity
    {
    }

    class LocalVariable : LabelledEntity, ILocal
    {
        readonly MethodImplementation method;
        readonly int index;
        readonly Type type;

        public LocalVariable(Context cx, MethodImplementation m, int i, Type t) : base(cx)
        {
            method = m;
            index = i;
            type = t;
            ShortId = CIL.Id.Create(method.Label) + underscore + index;
        }

        static readonly Id underscore = CIL.Id.Create("_");
        static readonly Id suffix = CIL.Id.Create(";cil-local");
        public override Id IdSuffix => suffix;

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return type;
                yield return Tuples.cil_local_variable(this, method, index, type);
            }
        }
    }
}
