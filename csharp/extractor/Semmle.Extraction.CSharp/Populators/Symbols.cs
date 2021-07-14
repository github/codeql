using Microsoft.CodeAnalysis;
using Semmle.Extraction.CSharp.Entities;

namespace Semmle.Extraction.CSharp.Populators
{
    internal class Symbols : SymbolVisitor<IEntity>
    {
        private readonly Context cx;

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

        public override IEntity VisitParameter(IParameterSymbol param) => Parameter.Create(cx, param);

        public override IEntity VisitProperty(IPropertySymbol symbol) => Property.Create(cx, symbol);

        public override IEntity VisitEvent(IEventSymbol symbol) => Event.Create(cx, symbol);

        public override IEntity VisitTypeParameter(ITypeParameterSymbol param) => TypeParameter.Create(cx, param);

        public override IEntity VisitPointerType(IPointerTypeSymbol symbol) => PointerType.Create(cx, symbol);

        public override IEntity VisitFunctionPointerType(IFunctionPointerTypeSymbol symbol) => FunctionPointerType.Create(cx, symbol);

        public override IEntity VisitDynamicType(IDynamicTypeSymbol symbol) => DynamicType.Create(cx, symbol);
    }
}
