using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Binary : Expression<BinaryExpressionSyntax>
    {
        private Binary(ExpressionNodeInfo info)
            : base(info.SetKind(GetKind(info.Context, (BinaryExpressionSyntax)info.Node)))
        {
        }

        public static Expression Create(ExpressionNodeInfo info) => new Binary(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            OperatorCall(trapFile, Syntax);
            CreateDeferred(Context, Syntax.Left, this, 0);
            CreateDeferred(Context, Syntax.Right, this, 1);
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
