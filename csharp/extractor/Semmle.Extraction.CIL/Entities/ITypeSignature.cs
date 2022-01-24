using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    internal interface ITypeSignature
    {
        void WriteId(EscapingTextWriter trapFile, IGenericContext gc);
    }
}
