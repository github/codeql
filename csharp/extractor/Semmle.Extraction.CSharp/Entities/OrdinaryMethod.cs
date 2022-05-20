using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class OrdinaryMethod : Method
    {
        private OrdinaryMethod(Context cx, IMethodSymbol init)
            : base(cx, init) { }

        public override string Name => Symbol.GetName();

        protected override IMethodSymbol BodyDeclaringSymbol => Symbol.PartialImplementationPart ?? Symbol;

        public IMethodSymbol SourceDeclaration => Symbol.OriginalDefinition;

        public override Microsoft.CodeAnalysis.Location ReportingLocation => Symbol.GetSymbolLocation();

        public override void Populate(TextWriter trapFile)
        {
            PopulateMethod(trapFile);
            PopulateModifiers(trapFile);
            ContainingType!.PopulateGenerics();

            var returnType = Type.Create(Context, Symbol.ReturnType);
            trapFile.methods(this, Name, ContainingType, returnType.TypeRef, OriginalDefinition);

            if (IsSourceDeclaration)
            {
                foreach (var declaration in Symbol.DeclaringSyntaxReferences.Select(s => s.GetSyntax()).OfType<MethodDeclarationSyntax>())
                {
                    Context.BindComments(this, declaration.Identifier.GetLocation());
                    TypeMention.Create(Context, declaration.ReturnType, this, returnType);
                }
            }

            foreach (var l in Locations)
                trapFile.method_location(this, l);

            PopulateGenerics(trapFile);
            Overrides(trapFile);
            ExtractRefReturn(trapFile, Symbol, this);
            ExtractCompilerGenerated(trapFile);
        }

        public static new OrdinaryMethod Create(Context cx, IMethodSymbol method)
        {
            if (method.MethodKind == MethodKind.ReducedExtension)
            {
                cx.Extractor.Logger.Log(Util.Logging.Severity.Warning, "Reduced extension method symbols should not be directly extracted.");
            }

            return OrdinaryMethodFactory.Instance.CreateEntityFromSymbol(cx, method);
        }

        private class OrdinaryMethodFactory : CachedEntityFactory<IMethodSymbol, OrdinaryMethod>
        {
            public static OrdinaryMethodFactory Instance { get; } = new OrdinaryMethodFactory();

            public override OrdinaryMethod Create(Context cx, IMethodSymbol init) => new OrdinaryMethod(cx, init);
        }
    }
}
