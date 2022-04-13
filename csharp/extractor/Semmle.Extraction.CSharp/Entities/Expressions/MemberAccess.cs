using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal sealed class MemberAccess : Expression
    {
        private MemberAccess(ExpressionNodeInfo info, ExpressionSyntax qualifier, ISymbol? target) : base(info)
        {
            var trapFile = info.Context.TrapWriter.Writer;
            Qualifier = Create(Context, qualifier, this, -1);

            if (target is null)
            {
                if (info.Kind != ExprKind.DYNAMIC_MEMBER_ACCESS)
                    Context.ModelError(info.Node, "Could not determine target for member access");
            }
            else
            {
                var t = Context.CreateEntity(target);
                trapFile.expr_access(this, t);
            }
        }

        public static Expression Create(ExpressionNodeInfo info, ConditionalAccessExpressionSyntax node)
        {
            // The qualifier is located by walking the syntax tree.
            // `node.WhenNotNull` will contain a MemberBindingExpressionSyntax, calling the method below.
            return CreateFromNode(new ExpressionNodeInfo(info.Context, node.WhenNotNull, info.Parent, info.Child, info.TypeInfo));
        }

        public static Expression Create(ExpressionNodeInfo info, MemberBindingExpressionSyntax node)
        {
            var expr = Create(info, FindConditionalQualifier(node), node.Name);
            expr.MakeConditional(info.Context.TrapWriter.Writer);
            return expr;
        }

        public static Expression Create(ExpressionNodeInfo info, MemberAccessExpressionSyntax node) =>
            Create(info, node.Expression, node.Name);

        private static Expression Create(ExpressionNodeInfo info, ExpressionSyntax expression, SimpleNameSyntax name)
        {
            if (IsDynamic(info.Context, expression))
            {
                var expr = new MemberAccess(info.SetKind(ExprKind.DYNAMIC_MEMBER_ACCESS), expression, null);
                info.Context.TrapWriter.Writer.dynamic_member_name(expr, name.Identifier.Text);
                return expr;
            }

            var target = info.SymbolInfo;

            if (target.CandidateReason == CandidateReason.OverloadResolutionFailure)
            {
                // Roslyn workaround. Even if we can't resolve a method, we know it's a method.
                return Create(info.Context, expression, info.Parent, info.Child);
            }

            var symbol = target.Symbol ?? info.Context.GetSymbolInfo(name).Symbol;

            if (symbol is null && target.CandidateSymbols.Length >= 1)
            {
                // Pick the first symbol. This could occur for something like `nameof(Foo.Bar)`
                // where `Bar` is a method group. Technically, we don't know which symbol is accessed.
                symbol = target.CandidateSymbols[0];
            }

            if (symbol is null)
            {
                info.Context.ModelError(info.Node, "Failed to determine symbol for member access");
                // Default to property access - this can still give useful results but
                // the target of the expression should be checked in QL.
                return new MemberAccess(info.SetKind(ExprKind.PROPERTY_ACCESS), expression, symbol);
            }

            ExprKind kind;

            switch (symbol.Kind)
            {
                case SymbolKind.Property:
                    kind = ExprKind.PROPERTY_ACCESS;
                    break;
                case SymbolKind.Method:
                    kind = ExprKind.METHOD_ACCESS;
                    break;
                case SymbolKind.Field:
                    kind = ExprKind.FIELD_ACCESS;
                    break;
                case SymbolKind.NamedType:
                    return TypeAccess.Create(info);
                case SymbolKind.Event:
                    kind = ExprKind.EVENT_ACCESS;
                    break;
                case SymbolKind.Namespace:
                    kind = ExprKind.NAMESPACE_ACCESS;
                    break;
                default:
                    info.Context.ModelError(info.Node, $"Unhandled symbol for member access of kind {symbol.Kind}");
                    kind = ExprKind.UNKNOWN;
                    break;
            }
            return new MemberAccess(info.SetKind(kind), expression, symbol);
        }

        public Expression Qualifier { get; private set; }
    }
}
