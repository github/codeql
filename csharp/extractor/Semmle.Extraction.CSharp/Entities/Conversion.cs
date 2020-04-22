using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    class Conversion : UserOperator
    {
        Conversion(Context cx, IMethodSymbol init)
            : base(cx, init) { }

        public new static Conversion Create(Context cx, IMethodSymbol symbol) =>
            ConversionFactory.Instance.CreateEntity(cx, symbol);

        public override Microsoft.CodeAnalysis.Location ReportingLocation
        {
            get
            {
                return symbol.
                    DeclaringSyntaxReferences.
                    Select(r => r.GetSyntax()).
                    OfType<ConversionOperatorDeclarationSyntax>().
                    Select(s => s.FixedLocation()).
                    Concat(symbol.Locations).
                    FirstOrDefault();
            }
        }

        class ConversionFactory : ICachedEntityFactory<IMethodSymbol, Conversion>
        {
            public static readonly ConversionFactory Instance = new ConversionFactory();

            public Conversion Create(Context cx, IMethodSymbol init) => new Conversion(cx, init);
        }
    }
}
