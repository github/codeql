using System.Linq;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    internal class NamedTypeIdWriter
    {
        private readonly Type type;

        public NamedTypeIdWriter(Type type)
        {
            this.type = type;
        }

        public void WriteId(EscapingTextWriter trapFile, bool inContext)
        {
            if (type.IsPrimitiveType)
            {
                Type.WritePrimitiveTypeId(trapFile, type.Name);
                return;
            }

            var ct = type.ContainingType;
            if (ct is not null)
            {
                ct.WriteId(trapFile, inContext);
                trapFile.Write('.');
            }
            else
            {
                type.WriteAssemblyPrefix(trapFile);

                var ns = type.ContainingNamespace!;
                if (!ns.IsGlobalNamespace)
                {
                    ns.WriteId(trapFile);
                    trapFile.Write('.');
                }
            }

            trapFile.Write(type.Name);

            var thisTypeArguments = type.ThisTypeArguments;
            if (thisTypeArguments is not null && thisTypeArguments.Any())
            {
                trapFile.Write('<');
                var index = 0;
                foreach (var t in thisTypeArguments)
                {
                    trapFile.WriteSeparator(",", ref index);
                    t.WriteId(trapFile);
                }
                trapFile.Write('>');
            }
            else if (type.ThisTypeParameterCount > 0)
            {
                trapFile.Write('`');
                trapFile.Write(type.ThisTypeParameterCount);
            }
        }
    }
}
