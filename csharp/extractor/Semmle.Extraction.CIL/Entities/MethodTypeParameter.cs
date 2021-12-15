using System;
using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    internal sealed class MethodTypeParameter : TypeParameter
    {
        private readonly Method method;
        private readonly int index;

        public override void WriteId(EscapingTextWriter trapFile, bool inContext)
        {
            if (!(inContext && method == gc))
            {
                trapFile.WriteSubId(method);
            }
            trapFile.Write("!");
            trapFile.Write(index);
        }

        public override string Name => "!" + index;

        public MethodTypeParameter(IGenericContext gc, Method m, int index) : base(gc)
        {
            method = m;
            this.index = index;
        }

        public override bool Equals(object? obj)
        {
            return obj is MethodTypeParameter tp && method.Equals(tp.method) && index == tp.index;
        }

        public override int GetHashCode()
        {
            return method.GetHashCode() * 29 + index;
        }

        public override TypeContainer Parent => method;

        public override IEnumerable<Type> TypeParameters => throw new NotImplementedException();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.cil_type(this, Name, Kind, method, SourceDeclaration);
                yield return Tuples.cil_type_parameter(method, index, this);
            }
        }
    }
}
