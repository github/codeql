using System;
using System.IO;
using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class LocalFunction : Method
    {
        private LocalFunction(Context cx, IMethodSymbol init) : base(cx, init)
        {
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            throw new InvalidOperationException();
        }

        public sealed override void WriteQuotedId(EscapingTextWriter trapFile)
        {
            trapFile.Write('*');
        }

        public static new LocalFunction Create(Context cx, IMethodSymbol field) => LocalFunctionFactory.Instance.CreateEntityFromSymbol(cx, field);

        private class LocalFunctionFactory : CachedEntityFactory<IMethodSymbol, LocalFunction>
        {
            public static LocalFunctionFactory Instance { get; } = new LocalFunctionFactory();

            public override LocalFunction Create(Context cx, IMethodSymbol init) => new LocalFunction(cx, init);
        }

        public override void Populate(TextWriter trapFile)
        {
            PopulateMethod(trapFile);
            PopulateModifiers(trapFile);

            var originalDefinition = IsSourceDeclaration ? this : Create(Context, Symbol.OriginalDefinition);
            var returnType = Type.Create(Context, Symbol.ReturnType);
            trapFile.local_functions(this, Symbol.Name, returnType, originalDefinition);
            ExtractRefReturn(trapFile, Symbol, this);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.NeedsLabel;
    }
}
