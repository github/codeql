using System.IO;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Util;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class UserOperator : Method
    {
        protected UserOperator(Context cx, IMethodSymbol init)
            : base(cx, init) { }

        protected override MethodKind ExplicitlyImplementsKind => MethodKind.UserDefinedOperator;

        public override void Populate(TextWriter trapFile)
        {
            PopulateMethod(trapFile);
            PopulateModifiers(trapFile);

            var returnType = Type.Create(Context, Symbol.ReturnType);
            trapFile.operators(this,
                Symbol.Name,
                OperatorSymbol(Context, Symbol),
                ContainingType,
                returnType.TypeRef,
                (UserOperator)OriginalDefinition);

            foreach (var l in Locations)
                trapFile.operator_location(this, l);

            if (IsSourceDeclaration)
            {
                var declSyntaxReferences = Symbol.DeclaringSyntaxReferences.Select(s => s.GetSyntax()).ToArray();
                foreach (var declaration in declSyntaxReferences.OfType<OperatorDeclarationSyntax>())
                    TypeMention.Create(Context, declaration.ReturnType, this, returnType);
                foreach (var declaration in declSyntaxReferences.OfType<ConversionOperatorDeclarationSyntax>())
                    TypeMention.Create(Context, declaration.Type, this, returnType);
            }

            ContainingType.PopulateGenerics();
            Overrides(trapFile);
        }

        public override bool NeedsPopulation => Context.Defines(Symbol) || IsImplicitOperator(out _);

        public override Type ContainingType
        {
            get
            {
                IsImplicitOperator(out var containingType);
                return Type.Create(Context, containingType);
            }
        }

        /// <summary>
        /// For some reason, some operators are missing from the Roslyn database of mscorlib.
        /// This method returns <code>true</code> for such operators.
        /// </summary>
        /// <param name="containingType">The type containing this operator.</param>
        /// <returns></returns>
        private bool IsImplicitOperator(out ITypeSymbol containingType)
        {
            containingType = Symbol.ContainingType;
            if (containingType is not null)
            {
                return containingType is not INamedTypeSymbol containingNamedType ||
                    !containingNamedType.GetMembers(Symbol.Name).Contains(Symbol);
            }

            var pointerType = Symbol.Parameters.Select(p => p.Type).OfType<IPointerTypeSymbol>().FirstOrDefault();
            if (pointerType is not null)
            {
                containingType = pointerType;
                return true;
            }

            Context.ModelError(Symbol, "Unexpected implicit operator");
            return true;
        }



        /// <summary>
        /// Converts a method name into a symbolic name.
        /// Logs an error if the name is not found.
        /// </summary>
        /// <param name="cx">Extractor context.</param>
        /// <param name="method">The method symbol.</param>
        /// <returns>The converted name.</returns>
        private static string OperatorSymbol(Context cx, IMethodSymbol method)
        {
            if (!method.TryGetOperatorSymbol(out var result))
                cx.ModelError(method, $"Unhandled operator name in OperatorSymbol(): '{method.Name}'");
            return result;
        }

        public static new UserOperator Create(Context cx, IMethodSymbol symbol) => UserOperatorFactory.Instance.CreateEntityFromSymbol(cx, symbol);

        private class UserOperatorFactory : CachedEntityFactory<IMethodSymbol, UserOperator>
        {
            public static UserOperatorFactory Instance { get; } = new UserOperatorFactory();

            public override UserOperator Create(Context cx, IMethodSymbol init) => new UserOperator(cx, init);
        }
    }
}
