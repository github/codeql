using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    /// <summary>
    /// A parameter entity.
    /// </summary>
    internal sealed class Parameter : LabelledEntity
    {
        private readonly IParameterizable method;
        private readonly int index;
        private readonly Type type;

        public Parameter(Context cx, IParameterizable m, int i, Type t) : base(cx)
        {
            method = m;
            index = i;
            type = t;
        }

        public override void WriteId(TextWriter trapFile)
        {
            trapFile.WriteSubId(method);
            trapFile.Write('_');
            trapFile.Write(index);
        }

        public override bool Equals(object? obj)
        {
            return obj is Parameter param && method.Equals(param.method) && index == param.index;
        }

        public override int GetHashCode()
        {
            return 23 * method.GetHashCode() + index;
        }

        public override string IdSuffix => ";cil-parameter";

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.cil_parameter(this, method, index, type);
            }
        }
    }
}
