using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A parameter entity.
    /// </summary>
    internal sealed class Parameter : LabelledEntity
    {
        private readonly IParameterizable parameterizable;
        private readonly int index;
        private readonly Type type;

        public Parameter(Context cx, IParameterizable p, int i, Type t) : base(cx)
        {
            parameterizable = p;
            index = i;
            type = t;
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(parameterizable);
            trapFile.Write('_');
            trapFile.Write(index);
            trapFile.Write(";cil-parameter");
        }

        public override bool Equals(object? obj)
        {
            return obj is Parameter param && parameterizable.Equals(param.parameterizable) && index == param.index;
        }

        public override int GetHashCode()
        {
            return 23 * parameterizable.GetHashCode() + index;
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.cil_parameter(this, parameterizable, index, type);
            }
        }
    }
}
