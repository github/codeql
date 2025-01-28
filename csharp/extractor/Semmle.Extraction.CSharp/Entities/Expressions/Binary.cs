using System.IO;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Binary : Expression<BinaryExpressionSyntax>
    {
        private Binary(ExpressionNodeInfo info)
            : base(info.SetKind(GetKind(info.Context, (BinaryExpressionSyntax)info.Node)))
        {
        }

        public static Expression Create(ExpressionNodeInfo info) => new Binary(info).TryPopulate();

        private Expression CreateChild(Context cx, ExpressionSyntax node, int child)
        {
            // If this is a "+" expression we might need to wrap the child expressions
            // in ToString calls
            return Kind == ExprKind.ADD
                ? ImplicitToString.Create(cx, node, this, child)
                : Create(cx, node, this, child);
        }

        /// <summary>
        /// Creates an expression from a syntax node.
        /// Inserts type conversion as required.
        /// Population is deferred to avoid overflowing the stack.
        /// </summary>
        private void CreateDeferred(Context cx, ExpressionSyntax node, int child)
        {
            if (ContainsPattern(node))
                // Expressions with patterns should be created right away, as they may introduce
                // local variables referenced in `LocalVariable::GetAlreadyCreated()`
                CreateChild(cx, node, child);
            else
                cx.PopulateLater(() => CreateChild(cx, node, child));
        }

        protected override void PopulateExpression(TextWriter trapFile)
        {
            OperatorCall(trapFile, Syntax);
            CreateDeferred(Context, Syntax.Left, 0);
            CreateDeferred(Context, Syntax.Right, 1);
        }

        private static ExprKind GetKind(Context cx, BinaryExpressionSyntax node)
        {
            var k = GetBinaryTokenKind(cx, node);
            return GetCallType(cx, node).AdjustKind(k);
        }

        private static ExprKind GetBinaryTokenKind(Context cx, BinaryExpressionSyntax node)
        {
            var kind = node.OperatorToken.Kind();
            switch (kind)
            {
                case SyntaxKind.LessThanToken: return ExprKind.LT;
                case SyntaxKind.PlusToken: return ExprKind.ADD;
                case SyntaxKind.LessThanEqualsToken: return ExprKind.LE;
                case SyntaxKind.GreaterThanToken: return ExprKind.GT;
                case SyntaxKind.AsteriskToken: return ExprKind.MUL;
                case SyntaxKind.AmpersandAmpersandToken: return ExprKind.LOG_AND;
                case SyntaxKind.EqualsEqualsToken: return ExprKind.EQ;
                case SyntaxKind.PercentToken: return ExprKind.REM;
                case SyntaxKind.MinusToken: return ExprKind.SUB;
                case SyntaxKind.AmpersandToken: return ExprKind.BIT_AND;
                case SyntaxKind.BarToken: return ExprKind.BIT_OR;
                case SyntaxKind.SlashToken: return ExprKind.DIV;
                case SyntaxKind.ExclamationEqualsToken: return ExprKind.NE;
                case SyntaxKind.AsKeyword: return ExprKind.AS;
                case SyntaxKind.IsKeyword: return ExprKind.IS;
                case SyntaxKind.BarBarToken: return ExprKind.LOG_OR;
                case SyntaxKind.GreaterThanEqualsToken: return ExprKind.GE;
                case SyntaxKind.GreaterThanGreaterThanToken: return ExprKind.RSHIFT;
                case SyntaxKind.GreaterThanGreaterThanGreaterThanToken: return ExprKind.URSHIFT;
                case SyntaxKind.LessThanLessThanToken: return ExprKind.LSHIFT;
                case SyntaxKind.CaretToken: return ExprKind.BIT_XOR;
                case SyntaxKind.QuestionQuestionToken: return ExprKind.NULL_COALESCING;
                // !! And the rest
                default:
                    cx.ModelError(node, $"Unhandled operator type {kind}");
                    return ExprKind.UNKNOWN;
            }
        }
    }
}
