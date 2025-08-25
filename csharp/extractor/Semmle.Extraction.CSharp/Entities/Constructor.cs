using System.Collections.Generic;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Util;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class Constructor : Method
    {
        private readonly List<SyntaxNode> declaringReferenceSyntax;

        private Constructor(Context cx, IMethodSymbol init)
            : base(cx, init)
        {
            declaringReferenceSyntax =
                Symbol.DeclaringSyntaxReferences
                    .Select(r => r.GetSyntax())
                    .ToList();
        }

        public override void Populate(TextWriter trapFile)
        {
            PopulateMethod(trapFile);
            PopulateModifiers(trapFile);
            ContainingType!.PopulateGenerics();

            trapFile.constructors(this, Symbol.ContainingType.Name, ContainingType, (Constructor)OriginalDefinition);
            trapFile.constructor_location(this, Location);

            if (MakeSynthetic)
            {
                // Create a synthetic empty body for primary and default constructors.
                Statements.SyntheticEmptyBlock.Create(Context, this, 0, Location);
            }

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
            // Extract initializers for constructors with a body, primary constructors
            // and default constructors for classes and structs declared in source code.
            if (Block is null && ExpressionBody is null && !MakeSynthetic)
            {
                return;
            }

            if (OrdinaryConstructorSyntax?.Initializer is ConstructorInitializerSyntax initializer)
            {
                ITypeSymbol initializerType;
                var initializerInfo = Context.GetSymbolInfo(initializer);

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

                ExtractSourceInitializer(trapFile, initializerType, (IMethodSymbol?)initializerInfo.Symbol, initializer.ArgumentList, initializer.ThisOrBaseKeyword.GetLocation());
            }
            else if (PrimaryBase is PrimaryConstructorBaseTypeSyntax primaryInitializer)
            {
                var primaryInfo = Context.GetSymbolInfo(primaryInitializer);
                var primarySymbol = primaryInfo.Symbol;

                ExtractSourceInitializer(trapFile, primarySymbol?.ContainingType, (IMethodSymbol?)primarySymbol, primaryInitializer.ArgumentList, primaryInitializer.GetLocation());
            }
            else if (Symbol.MethodKind is MethodKind.Constructor)
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
        }

        private void ExtractSourceInitializer(TextWriter trapFile, ITypeSymbol? type, IMethodSymbol? symbol, ArgumentListSyntax arguments, Microsoft.CodeAnalysis.Location location)
        {
            var initInfo = new ExpressionInfo(Context,
                AnnotatedTypeSymbol.CreateNotAnnotated(type),
                Context.CreateLocation(location),
                Kinds.ExprKind.CONSTRUCTOR_INIT,
                this,
                -1,
                false,
                null);

            var init = new Expression(initInfo);

            var target = Constructor.Create(Context, symbol);
            if (target is null)
            {
                Context.ModelError(Symbol, "Unable to resolve call");
                return;
            }

            trapFile.expr_call(init, target);

            init.PopulateArguments(trapFile, arguments, 0);
        }

        private ConstructorDeclarationSyntax? OrdinaryConstructorSyntax =>
            declaringReferenceSyntax
                .OfType<ConstructorDeclarationSyntax>()
                .FirstOrDefault();

        private TypeDeclarationSyntax? PrimaryConstructorSyntax =>
            declaringReferenceSyntax
                    .OfType<TypeDeclarationSyntax>()
                    .FirstOrDefault(t => t is ClassDeclarationSyntax or StructDeclarationSyntax or RecordDeclarationSyntax);

        private PrimaryConstructorBaseTypeSyntax? PrimaryBase =>
            PrimaryConstructorSyntax?
                .BaseList?
                .Types
                .OfType<PrimaryConstructorBaseTypeSyntax>()
                .FirstOrDefault();

        private bool IsPrimary => PrimaryConstructorSyntax is not null;

        // This is a default constructor in a class or struct declared in source.
        private bool IsDefault =>
            Symbol.IsImplicitlyDeclared &&
            Symbol.ContainingType.FromSource() &&
            Symbol.ContainingType.TypeKind is TypeKind.Class or TypeKind.Struct &&
            Symbol.ContainingType.IsSourceDeclaration() &&
            !Symbol.ContainingType.IsAnonymousType;

        private bool MakeSynthetic => IsPrimary || IsDefault;

        [return: NotNullIfNotNull(nameof(constructor))]
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

        public override Microsoft.CodeAnalysis.Location? FullLocation => ReportingLocation;

        public override Microsoft.CodeAnalysis.Location? ReportingLocation
        {
            get
            {
                if (OrdinaryConstructorSyntax is not null)
                {
                    return OrdinaryConstructorSyntax.Identifier.GetLocation();
                }

                if (PrimaryConstructorSyntax is not null)
                {
                    return PrimaryConstructorSyntax.Identifier.GetLocation();
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
