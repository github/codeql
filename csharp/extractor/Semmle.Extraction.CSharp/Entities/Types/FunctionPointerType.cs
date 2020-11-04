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

        public override void WriteId(TextWriter trapFile)
        {
            symbol.BuildTypeId(Context, trapFile, symbol);
            trapFile.Write(";functionpointertype");
        }

        public override bool NeedsPopulation => true;

        public override void Populate(TextWriter trapFile)
        {
            var unmanagedCallingConventionTypes = symbol.Signature.UnmanagedCallingConventionTypes.Select(nt => Create(Context, nt)).ToArray();

            trapFile.function_pointer_calling_conventions(this, (int)symbol.Signature.CallingConvention);
            for (var i = 0; i < unmanagedCallingConventionTypes.Length; i++)
            {
                trapFile.has_unmanaged_calling_conventions(this, i, unmanagedCallingConventionTypes[i].TypeRef);
            }

            PopulateType(trapFile);
        }

        public static FunctionPointerType Create(Context cx, IFunctionPointerTypeSymbol symbol) => FunctionPointerTypeFactory.Instance.CreateEntityFromSymbol(cx, symbol);

        private class FunctionPointerTypeFactory : ICachedEntityFactory<IFunctionPointerTypeSymbol, FunctionPointerType>
        {
            public static FunctionPointerTypeFactory Instance { get; } = new FunctionPointerTypeFactory();

            public FunctionPointerType Create(Context cx, IFunctionPointerTypeSymbol init) => new FunctionPointerType(cx, init);
        }
    }
}
