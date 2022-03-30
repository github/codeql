using System.Linq;
using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    internal sealed class TypeTypeParameter : TypeParameter
    {
        private readonly Type type;
        private readonly int index;

        public TypeTypeParameter(Type t, int i) : base(t)
        {
            index = i;
            type = t;
        }

        public override bool Equals(object? obj)
        {
            return obj is TypeTypeParameter tp && type.Equals(tp.type) && index == tp.index;
        }

        public override int GetHashCode()
        {
            return type.GetHashCode() * 13 + index;
        }

        public override void WriteId(EscapingTextWriter trapFile, bool inContext)
        {
            type.WriteId(trapFile, inContext);
            trapFile.Write('!');
            trapFile.Write(index);
        }

        public override TypeContainer Parent => type;
        public override string Name => "!" + index;

        public override IEnumerable<Type> TypeParameters => Enumerable.Empty<Type>();

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return Tuples.cil_type(this, Name, Kind, type, SourceDeclaration);
                yield return Tuples.cil_type_parameter(type, index, this);
            }
        }
    }
}
