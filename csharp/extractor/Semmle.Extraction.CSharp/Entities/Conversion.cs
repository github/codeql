using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Conversion : UserOperator
    {
        private Conversion(Context cx, IMethodSymbol init)
            : base(cx, init) { }

        public new static Conversion Create(Context cx, IMethodSymbol symbol) =>
            ConversionFactory.Instance.CreateEntityFromSymbol(cx, symbol);

        public override Microsoft.CodeAnalysis.Location ReportingLocation
        {
            get
            {
                return symbol.DeclaringSyntaxReferences
                    .Select(r => r.GetSyntax())
                    .OfType<ConversionOperatorDeclarationSyntax>()
                    .Select(s => s.FixedLocation())
                    .Concat(symbol.Locations)
                    .FirstOrDefault();
            }
        }

        private class ConversionFactory : ICachedEntityFactory<IMethodSymbol, Conversion>
        {
            public static readonly ConversionFactory Instance = new ConversionFactory();

            public Conversion Create(Context cx, IMethodSymbol init) => new Conversion(cx, init);
        }
    }
}
