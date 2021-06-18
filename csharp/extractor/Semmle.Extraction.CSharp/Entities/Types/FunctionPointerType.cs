using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class FunctionPointerType : Type<IFunctionPointerTypeSymbol>
    {
        private FunctionPointerType(Context cx, IFunctionPointerTypeSymbol init)
            : base(cx, init)
        {
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            Symbol.BuildTypeId(Context, trapFile, Symbol, constructUnderlyingTupleType: false);
            trapFile.Write(";functionpointertype");
        }

        public override bool NeedsPopulation => true;

        public override void Populate(TextWriter trapFile)
        {
            trapFile.function_pointer_calling_conventions(this, (int)Symbol.Signature.CallingConvention);
            foreach (var (conv, i) in Symbol.Signature.UnmanagedCallingConventionTypes.Select((nt, i) => (Create(Context, nt), i)))
            {
                trapFile.has_unmanaged_calling_conventions(this, i, conv.TypeRef);
            }

            PopulateType(trapFile);
        }

        public static FunctionPointerType Create(Context cx, IFunctionPointerTypeSymbol symbol) => FunctionPointerTypeFactory.Instance.CreateEntityFromSymbol(cx, symbol);

        private class FunctionPointerTypeFactory : CachedEntityFactory<IFunctionPointerTypeSymbol, FunctionPointerType>
        {
            public static FunctionPointerTypeFactory Instance { get; } = new FunctionPointerTypeFactory();

            public override FunctionPointerType Create(Context cx, IFunctionPointerTypeSymbol init) => new FunctionPointerType(cx, init);
        }
    }
}
