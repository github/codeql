using System.Collections.Generic;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A parameter entity.
    /// </summary>
    interface IParameter : ILabelledEntity
    {
    }

    /// <summary>
    /// A parameter entity.
    /// </summary>
    class Parameter : LabelledEntity, IParameter
    {
        readonly Method method;
        readonly int index;
        readonly Type type;

        public Parameter(Context cx, Method m, int i, Type t) : base(cx)
        {
            method = m;
            index = i;
            type = t;
            ShortId = openCurly + method.Label.Value + closeCurly + index;
        }

        static readonly Id parameterSuffix = CIL.Id.Create(";cil-parameter");
        static readonly Id openCurly = CIL.Id.Create("{#");
        static readonly Id closeCurly = CIL.Id.Create("}_");

        public override Id IdSuffix => parameterSuffix;

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.cil_parameter(this, method, index, type);
            }
        }
    }
}
