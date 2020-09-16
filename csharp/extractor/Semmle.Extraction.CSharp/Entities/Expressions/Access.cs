using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class Access : Expression
    {
        static ExprKind AccessKind(Context cx, ISymbol symbol)
        {
            switch (symbol.Kind)
            {
                case SymbolKind.TypeParameter:
                case SymbolKind.NamedType:
                    return ExprKind.TYPE_ACCESS;

                case SymbolKind.Field:
                    return ExprKind.FIELD_ACCESS;

                case SymbolKind.Property:
                    return symbol is IPropertySymbol prop && prop.IsIndexer ?
                         ExprKind.INDEXER_ACCESS : ExprKind.PROPERTY_ACCESS;

                case SymbolKind.Event:
                    return ExprKind.EVENT_ACCESS;

                case SymbolKind.Method:
                    return ExprKind.METHOD_ACCESS;

                case SymbolKind.Local:
                case SymbolKind.RangeVariable:
                    return ExprKind.LOCAL_VARIABLE_ACCESS;

                case SymbolKind.Parameter:
                    return ExprKind.PARAMETER_ACCESS;

                case SymbolKind.Namespace:
                    return ExprKind.NAMESPACE_ACCESS;

                default:
                    cx.ModelError(symbol, $"Unhandled access kind '{symbol.Kind}'");
                    return ExprKind.UNKNOWN;
            }
        }

        Access(ExpressionNodeInfo info, ISymbol symbol, bool implicitThis, IEntity target)
            : base(info.SetKind(AccessKind(info.Context, symbol)))
        {
            if (!(target is null))
            {
                Cx.TrapWriter.Writer.expr_access(this, target);
            }

            if (implicitThis && !symbol.IsStatic)
            {
                This.CreateImplicit(Cx, Entities.Type.Create(Cx, symbol.ContainingType), Location, this, -1);
            }
        }

        public static Expression Create(ExpressionNodeInfo info, ISymbol symbol, bool implicitThis, IEntity target) => new Access(info, symbol, implicitThis, target);
    }
}
