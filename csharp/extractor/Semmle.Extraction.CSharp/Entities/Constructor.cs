using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Util;
using System.Linq;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Entities;
using System.IO;
using System.Diagnostics.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Constructor : Method
    {
        private Constructor(Context cx, IMethodSymbol init)
            : base(cx, init) { }

        public override void Populate(TextWriter trapFile)
        {
            PopulateMethod(trapFile);
            PopulateModifiers(trapFile);
            ContainingType!.PopulateGenerics();

            trapFile.constructors(this, Symbol.ContainingType.Name, ContainingType, (Constructor)OriginalDefinition);
            trapFile.constructor_location(this, Location);

            if (Symbol.IsImplicitlyDeclared)
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

            if (initializer is null)
            {
                if (Symbol.MethodKind is MethodKind.Constructor)
                {
                    var baseType = Symbol.ContainingType.BaseType;
                    if (baseType is null)
                    {
                        if (Symbol.ContainingType.SpecialType != SpecialType.System_Object)
                        {
                            Context.ModelError(Symbol, "Unable to resolve base type in implicit constructor initializer");
                        }
                        return;
                    }

                    var baseConstructor = baseType.InstanceConstructors.FirstOrDefault(c => c.Arity is 0);

                    if (baseConstructor is null)
                    {
                        Context.ModelError(Symbol, "Unable to resolve implicit constructor initializer call");
                        return;
                    }

                    var baseConstructorTarget = Create(Context, baseConstructor);
                    var info = new ExpressionInfo(Context,
                        AnnotatedTypeSymbol.CreateNotAnnotated(baseType),
                        Location,
                        Kinds.ExprKind.CONSTRUCTOR_INIT,
                        this,
                        -1,
                        isCompilerGenerated: true,
                        null);

                    trapFile.expr_call(new Expression(info), baseConstructorTarget);
                }
                return;
            }

            ITypeSymbol initializerType;
            var symbolInfo = Context.GetSymbolInfo(initializer);

            switch (initializer.Kind())
            {
                case SyntaxKind.BaseConstructorInitializer:
                    initializerType = Symbol.ContainingType.BaseType!;
                    break;
                case SyntaxKind.ThisConstructorInitializer:
                    initializerType = Symbol.ContainingType;
                    break;
                default:
                    Context.ModelError(initializer, "Unknown initializer");
                    return;
            }

            var initInfo = new ExpressionInfo(Context,
                AnnotatedTypeSymbol.CreateNotAnnotated(initializerType),
                Context.CreateLocation(initializer.ThisOrBaseKeyword.GetLocation()),
                Kinds.ExprKind.CONSTRUCTOR_INIT,
                this,
                -1,
                false,
                null);

            var init = new Expression(initInfo);

            var target = Constructor.Create(Context, (IMethodSymbol?)symbolInfo.Symbol);
            if (target is null)
            {
                Context.ModelError(Symbol, "Unable to resolve call");
                return;
            }

            trapFile.expr_call(init, target);

            var child = 0;
            foreach (var arg in initializer.ArgumentList.Arguments)
            {
                Expression.Create(Context, arg.Expression, init, child++);
            }
        }

        private ConstructorDeclarationSyntax? Syntax
        {
            get
            {
                return Symbol.DeclaringSyntaxReferences
                    .Select(r => r.GetSyntax())
                    .OfType<ConstructorDeclarationSyntax>()
                    .FirstOrDefault();
            }
        }

        [return: NotNullIfNotNull("constructor")]
        public static new Constructor? Create(Context cx, IMethodSymbol? constructor)
        {
            if (constructor is null)
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

        public override void WriteId(EscapingTextWriter trapFile)
        {
            if (!SymbolEqualityComparer.Default.Equals(Symbol, Symbol.OriginalDefinition))
            {
                trapFile.WriteSubId(ContainingType!);
                trapFile.Write(".");
                trapFile.WriteSubId(OriginalDefinition);
                trapFile.Write(";constructor");
                return;
            }

            if (Symbol.IsStatic)
                trapFile.Write("static");
            trapFile.WriteSubId(ContainingType!);
            AddParametersToId(Context, trapFile, Symbol);
            trapFile.Write(";constructor");
        }

        private ConstructorDeclarationSyntax? GetSyntax() =>
            Symbol.DeclaringSyntaxReferences.Select(r => r.GetSyntax()).OfType<ConstructorDeclarationSyntax>().FirstOrDefault();

        public override Microsoft.CodeAnalysis.Location? FullLocation => ReportingLocation;

        public override Microsoft.CodeAnalysis.Location? ReportingLocation
        {
            get
            {
                var syn = GetSyntax();
                if (syn is not null)
                {
                    return syn.Identifier.GetLocation();
                }

                if (Symbol.IsImplicitlyDeclared)
                {
                    return ContainingType!.ReportingLocation;
                }

                return Symbol.ContainingType.Locations.FirstOrDefault();
            }
        }

        private class ConstructorFactory : CachedEntityFactory<IMethodSymbol, Constructor>
        {
            public static ConstructorFactory Instance { get; } = new ConstructorFactory();

            public override Constructor Create(Context cx, IMethodSymbol init) => new Constructor(cx, init);
        }
    }
}
