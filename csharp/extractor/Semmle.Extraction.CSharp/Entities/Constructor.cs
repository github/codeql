using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Util;
using System.Linq;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Entities;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    public class Constructor : Method
    {
        private Constructor(Context cx, IMethodSymbol init)
            : base(cx, init) { }

        public override void Populate(TextWriter trapFile)
        {
            PopulateMethod(trapFile);
            PopulateModifiers(trapFile);
            ContainingType.PopulateGenerics();

            trapFile.constructors(this, symbol.ContainingType.Name, ContainingType, (Constructor)OriginalDefinition);
            trapFile.constructor_location(this, Location);

            if (symbol.IsImplicitlyDeclared)
            {
                var lineCounts = new LineCounts() { Total = 2, Code = 1, Comment = 0 };
                trapFile.numlines(this, lineCounts);
            }
            ExtractCompilerGenerated(trapFile);
        }

        protected override void ExtractInitializers(TextWriter trapFile)
        {
            // Do not extract initializers for constructed types.
            if (!IsSourceDeclaration)
                return;

            var syntax = Syntax;
            var initializer = syntax?.Initializer;

            if (initializer == null)
                return;

            Type initializerType;
            var symbolInfo = Context.GetSymbolInfo(initializer);

            switch (initializer.Kind())
            {
                case SyntaxKind.BaseConstructorInitializer:
                    initializerType = Type.Create(Context, symbol.ContainingType.BaseType);
                    break;
                case SyntaxKind.ThisConstructorInitializer:
                    initializerType = ContainingType;
                    break;
                default:
                    Context.ModelError(initializer, "Unknown initializer");
                    return;
            }

            var initInfo = new ExpressionInfo(Context,
                new AnnotatedType(initializerType, NullableAnnotation.None),
                Context.Create(initializer.ThisOrBaseKeyword.GetLocation()),
                Kinds.ExprKind.CONSTRUCTOR_INIT,
                this,
                -1,
                false,
                null);

            var init = new Expression(initInfo);

            var target = Constructor.Create(Context, (IMethodSymbol)symbolInfo.Symbol);

            if (target == null)
            {
                Context.ModelError(symbol, "Unable to resolve call");
                return;
            }

            trapFile.expr_call(init, target);

            var child = 0;
            foreach (var arg in initializer.ArgumentList.Arguments)
            {
                Expression.Create(Context, arg.Expression, init, child++);
            }
        }

        private ConstructorDeclarationSyntax Syntax
        {
            get
            {
                return symbol.DeclaringSyntaxReferences
                    .Select(r => r.GetSyntax())
                    .OfType<ConstructorDeclarationSyntax>()
                    .FirstOrDefault();
            }
        }

        public static new Constructor Create(Context cx, IMethodSymbol constructor)
        {
            if (constructor == null)
                return null;

            switch (constructor.MethodKind)
            {
                case MethodKind.StaticConstructor:
                case MethodKind.Constructor:
                    return ConstructorFactory.Instance.CreateEntityFromSymbol(cx, constructor);
                default:
                    throw new InternalError(constructor, "Attempt to create a Constructor from a symbol that isn't a constructor");
            }
        }

        public override void WriteId(TextWriter trapFile)
        {
            if (symbol.IsStatic)
                trapFile.Write("static");
            trapFile.WriteSubId(ContainingType);
            AddParametersToId(Context, trapFile, symbol);
            trapFile.Write(";constructor");
        }

        private ConstructorDeclarationSyntax GetSyntax() =>
            symbol.DeclaringSyntaxReferences.Select(r => r.GetSyntax()).OfType<ConstructorDeclarationSyntax>().FirstOrDefault();

        public override Microsoft.CodeAnalysis.Location FullLocation => ReportingLocation;

        public override Microsoft.CodeAnalysis.Location ReportingLocation
        {
            get
            {
                var syn = GetSyntax();
                if (syn != null)
                {
                    return syn.Identifier.GetLocation();
                }

                if (symbol.IsImplicitlyDeclared)
                {
                    return ContainingType.ReportingLocation;
                }

                return symbol.ContainingType.Locations.FirstOrDefault();
            }
        }

        private class ConstructorFactory : ICachedEntityFactory<IMethodSymbol, Constructor>
        {
            public static ConstructorFactory Instance { get; } = new ConstructorFactory();

            public Constructor Create(Context cx, IMethodSymbol init) => new Constructor(cx, init);
        }
    }
}
