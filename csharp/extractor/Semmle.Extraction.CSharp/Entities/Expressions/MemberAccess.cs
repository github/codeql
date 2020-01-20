using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.CSharp.Populators;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class MemberAccess : Expression
    {
        readonly IEntity Target;

        private MemberAccess(ExpressionNodeInfo info, ExpressionSyntax qualifier, ISymbol target) : base(info)
        {
            var trapFile = info.Context.TrapWriter.Writer;
            Qualifier = Create(cx, qualifier, this, -1);

            if (target == null)
            {
                if (info.Kind != ExprKind.DYNAMIC_MEMBER_ACCESS)
                    cx.ModelError(info.Node, "Could not determine target for member access");
            }
            else
            {
                Target = cx.CreateEntity(target);
                trapFile.expr_access(this, Target);
            }
        }

        public static Expression Create(ExpressionNodeInfo info, ConditionalAccessExpressionSyntax node) =>
            // The qualifier is located by walking the syntax tree.
            // `node.WhenNotNull` will contain a MemberBindingExpressionSyntax, calling the method below.
            CreateFromNode(new ExpressionNodeInfo(info.Context, node.WhenNotNull, info.Parent, info.Child, info.TypeInfo));

        public static Expression Create(ExpressionNodeInfo info, MemberBindingExpressionSyntax node)
        {
            var expr = Create(info, FindConditionalQualifier(node), node.Name);
            expr.MakeConditional(info.Context.TrapWriter.Writer);
            return expr;
        }

        public static Expression Create(ExpressionNodeInfo info, MemberAccessExpressionSyntax node) =>
            Create(info, node.Expression, node.Name);

        static Expression Create(ExpressionNodeInfo info, ExpressionSyntax expression, SimpleNameSyntax name)
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

            if (symbol == null && target.CandidateSymbols.Length >= 1)
            {
                // Pick the first symbol. This could occur for something like `nameof(Foo.Bar)`
                // where `Bar` is a method group. Technically, we don't know which symbol is accessed.
                symbol = target.CandidateSymbols[0];
            }

            if (symbol == null)
            {
                info.Context.ModelError(info.Node, "Failed to determine symbol for member access");
                return new MemberAccess(info.SetKind(ExprKind.UNKNOWN), expression, symbol);
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
                    info.Context.ModelError(info.Node, "Unhandled symbol for member access");
                    kind = ExprKind.UNKNOWN;
                    break;
            }
            return new MemberAccess(info.SetKind(kind), expression, symbol);
        }

        public Expression Qualifier { get; private set; }
    }
}
