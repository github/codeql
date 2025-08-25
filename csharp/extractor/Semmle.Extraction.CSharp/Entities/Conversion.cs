using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Conversion : UserOperator
    {
        private Conversion(Context cx, IMethodSymbol init)
            : base(cx, init) { }

        protected override MethodKind ExplicitlyImplementsKind => MethodKind.Conversion;

        public static new Conversion Create(Context cx, IMethodSymbol symbol) =>
            ConversionFactory.Instance.CreateEntityFromSymbol(cx, symbol);

        public override Microsoft.CodeAnalysis.Location? ReportingLocation
        {
            get
            {
                return Symbol.DeclaringSyntaxReferences
                    .Select(r => r.GetSyntax())
                    .OfType<ConversionOperatorDeclarationSyntax>()
                    .Select(s => s.FixedLocation())
                    .Concat(Symbol.Locations)
                    .BestOrDefault();
            }
        }

        private class ConversionFactory : CachedEntityFactory<IMethodSymbol, Conversion>
        {
            public static ConversionFactory Instance { get; } = new ConversionFactory();

            public override Conversion Create(Context cx, IMethodSymbol init) => new Conversion(cx, init);
        }
    }
}
