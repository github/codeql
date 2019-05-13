using System;
using System.Linq;
using Microsoft.CodeAnalysis;
using Semmle.Extraction.CSharp.Entities;

namespace Semmle.Extraction.CSharp.Populators
{
    class Symbols : SymbolVisitor<IEntity>
    {
        readonly Context cx;

        public Symbols(Context cx)
        {
            this.cx = cx;
        }

        public override IEntity DefaultVisit(ISymbol symbol) => throw new InternalError(symbol, $"Unhandled symbol '{symbol}' of kind '{symbol.Kind}'");

        public override IEntity VisitArrayType(IArrayTypeSymbol array) => ArrayType.Create(cx, array);

        public override IEntity VisitMethod(IMethodSymbol methodDecl)
        {
            return Method.Create(cx, methodDecl);
        }

        public override IEntity VisitField(IFieldSymbol field) => Field.Create(cx, field);

        public override IEntity VisitNamedType(INamedTypeSymbol type) =>
            type.IsTupleType ? TupleType.Create(cx, type) : (IEntity)NamedType.Create(cx, type);

        public override IEntity VisitNamespace(INamespaceSymbol ns) => Namespace.Create(cx, ns);

        public override IEntity VisitParameter(IParameterSymbol param) => Parameter.GetAlreadyCreated(cx, param);

        public override IEntity VisitProperty(IPropertySymbol symbol) => Property.Create(cx, symbol);

        public override IEntity VisitEvent(IEventSymbol symbol) => Event.Create(cx, symbol);

        public override IEntity VisitTypeParameter(ITypeParameterSymbol param) => TypeParameter.Create(cx, param);

        public override IEntity VisitPointerType(IPointerTypeSymbol symbol) => PointerType.Create(cx, symbol);

        public override IEntity VisitDynamicType(IDynamicTypeSymbol symbol) => DynamicType.Create(cx, symbol);
    }

    public static class SymbolsExtensions
    {
        public static IEntity CreateEntity(this Context cx, ISymbol symbol)
        {
            if (symbol == null) return null;

            using (cx.StackGuard)
            {
                try
                {
                    return symbol.Accept(new Symbols(cx));
                }
                catch (Exception ex)  // lgtm[cs/catch-of-all-exceptions]
                {
                    cx.ModelError(symbol, $"Exception processing symbol '{symbol.Kind}' of type '{ex}': {symbol}");
                    return null;
                }
            }
        }

        /// <summary>
        /// Tries to recover from an ErrorType.
        /// </summary>
        ///
        /// <param name="cx">Extraction context.</param>
        /// <param name="type">The type to disambiguate.</param>
        /// <returns></returns>
        public static ITypeSymbol DisambiguateType(this Context cx, ITypeSymbol type)
        {
            /* A type could not be determined.
             * Sometimes this happens due to a missing reference,
             * or sometimes because the same type is defined in multiple places.
             *
             * In the case that a symbol is multiply-defined, Roslyn tells you which
             * symbols are candidates. It usually resolves to the same DB entity,
             * so it's reasonably safe to just pick a candidate.
             *
             * The conservative option would be to resolve all error types as null.
             */

            var errorType = type as IErrorTypeSymbol;

            return errorType != null && errorType.CandidateSymbols.Any() ?
                errorType.CandidateSymbols.First() as ITypeSymbol :
                type;
        }

        public static TypeInfo GetTypeInfo(this Context cx, Microsoft.CodeAnalysis.CSharp.CSharpSyntaxNode node) =>
            cx.Model(node).GetTypeInfo(node);

        public static SymbolInfo GetSymbolInfo(this Context cx, Microsoft.CodeAnalysis.CSharp.CSharpSyntaxNode node) =>
            cx.Model(node).GetSymbolInfo(node);

        /// <summary>
        /// Gets the symbol for a particular syntax node.
        /// Throws an exception if the symbol is not found.
        /// </summary>
        ///
        /// <remarks>
        /// This gives a nicer message than a "null pointer exception",
        /// and should be used where we require a symbol to be resolved.
        /// </remarks>
        ///
        /// <param name="cx">The extraction context.</param>
        /// <param name="node">The syntax node.</param>
        /// <returns>The resolved symbol.</returns>
        public static ISymbol GetSymbol(this Context cx, Microsoft.CodeAnalysis.CSharp.CSharpSyntaxNode node)
        {
            var info = GetSymbolInfo(cx, node);
            if (info.Symbol == null)
            {
                throw new InternalError(node, "Could not resolve symbol");
            }

            return info.Symbol;
        }

        /// <summary>
        /// Determines the type of a node, or null
        /// if the type could not be determined.
        /// </summary>
        /// <param name="cx">Extractor context.</param>
        /// <param name="node">The node to determine.</param>
        /// <returns>The type symbol of the node, or null.</returns>
        public static ITypeSymbol GetType(this Context cx, Microsoft.CodeAnalysis.CSharp.CSharpSyntaxNode node)
        {
            var info = GetTypeInfo(cx, node);
            return cx.DisambiguateType(info.Type);
        }
    }
}
