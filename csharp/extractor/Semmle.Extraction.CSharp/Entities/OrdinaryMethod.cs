using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    class OrdinaryMethod : Method
    {
        OrdinaryMethod(Context cx, IMethodSymbol init)
            : base(cx, init) { }

        public override string Name => symbol.GetName();

        protected override IMethodSymbol BodyDeclaringSymbol => symbol.PartialImplementationPart ?? symbol;

        public IMethodSymbol SourceDeclaration
        {
            get
            {
                var reducedFrom = symbol.ReducedFrom ?? symbol;
                return reducedFrom.OriginalDefinition;
            }
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => symbol.GetSymbolLocation();

        public override void Populate(TextWriter trapFile)
        {
            PopulateMethod(trapFile);
            PopulateModifiers(trapFile);
            ContainingType.PopulateGenerics();

            var returnType = Type.Create(Context, symbol.ReturnType);
            trapFile.methods(this, Name, ContainingType, returnType.TypeRef, OriginalDefinition);

            if (IsSourceDeclaration)
                foreach (var declaration in symbol.DeclaringSyntaxReferences.Select(s => s.GetSyntax()).OfType<MethodDeclarationSyntax>())
                {
                    Context.BindComments(this, declaration.Identifier.GetLocation());
                    TypeMention.Create(Context, declaration.ReturnType, this, returnType);
                }

            foreach (var l in Locations)
                trapFile.method_location(this, l);

            PopulateGenerics(trapFile);
            Overrides(trapFile);
            ExtractRefReturn(trapFile);
            ExtractCompilerGenerated(trapFile);
        }

        public new static OrdinaryMethod Create(Context cx, IMethodSymbol method) => OrdinaryMethodFactory.Instance.CreateEntity(cx, method);

        class OrdinaryMethodFactory : ICachedEntityFactory<IMethodSymbol, OrdinaryMethod>
        {
            public static readonly OrdinaryMethodFactory Instance = new OrdinaryMethodFactory();

            public OrdinaryMethod Create(Context cx, IMethodSymbol init) => new OrdinaryMethod(cx, init);
        }
    }
}
