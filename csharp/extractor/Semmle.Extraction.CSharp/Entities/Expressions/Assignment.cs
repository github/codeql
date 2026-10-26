using System.IO;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Assignment : Expression<AssignmentExpressionSyntax>
    {
        private Assignment(ExpressionNodeInfo info)
            : base(info.SetKind(GetKind(info.Context, (AssignmentExpressionSyntax)info.Node)))
        {
        }

        public static Assignment Create(ExpressionNodeInfo info)
        {
            var ret = new Assignment(info);
            ret.TryPopulate();
            return ret;
        }

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Context, Syntax.Left, this, 0);
            Create(Context, Syntax.Right, this, 1);
            if (Kind != ExprKind.SIMPLE_ASSIGN && Kind != ExprKind.ASSIGN_COALESCE)
            {
                AddOperatorCall(trapFile, Syntax);
            }
        }

        private static ExprKind GetAssignmentOperation(Context cx, AssignmentExpressionSyntax syntax)
        {
            switch (syntax.OperatorToken.Kind())
            {
                case SyntaxKind.PlusEqualsToken:
                    return ExprKind.ASSIGN_ADD;
                case SyntaxKind.MinusEqualsToken:
                    return ExprKind.ASSIGN_SUB;
                case SyntaxKind.EqualsToken:
                    return ExprKind.SIMPLE_ASSIGN;
                case SyntaxKind.BarEqualsToken:
                    return ExprKind.ASSIGN_OR;
                case SyntaxKind.AmpersandEqualsToken:
                    return ExprKind.ASSIGN_AND;
                case SyntaxKind.CaretEqualsToken:
                    return ExprKind.ASSIGN_XOR;
                case SyntaxKind.AsteriskEqualsToken:
                    return ExprKind.ASSIGN_MUL;
                case SyntaxKind.PercentEqualsToken:
                    return ExprKind.ASSIGN_REM;
                case SyntaxKind.SlashEqualsToken:
                    return ExprKind.ASSIGN_DIV;
                case SyntaxKind.LessThanLessThanEqualsToken:
                    return ExprKind.ASSIGN_LSHIFT;
                case SyntaxKind.GreaterThanGreaterThanEqualsToken:
                    return ExprKind.ASSIGN_RSHIFT;
                case SyntaxKind.GreaterThanGreaterThanGreaterThanEqualsToken:
                    return ExprKind.ASSIGN_URSHIFT;
                case SyntaxKind.QuestionQuestionEqualsToken:
                    return ExprKind.ASSIGN_COALESCE;
                default:
                    cx.ModelError(syntax, $"Unrecognised assignment type {GetKind(cx, syntax)}");
                    return ExprKind.UNKNOWN;
            }
        }

        private static ExprKind GetKind(Context cx, AssignmentExpressionSyntax syntax)
        {
            var kind = GetAssignmentOperation(cx, syntax);
            var leftType = cx.GetType(syntax.Left);

            if (leftType.Symbol is not null && leftType.Symbol.SpecialType != SpecialType.None)
            {
                // In Mono, the builtin types did not specify their operator invocation
                // even though EVERY operator has an invocation in C#. (This is a flaw in the dbscheme and should be fixed).
                return kind;
            }

            var leftSymbol = cx.GetSymbolInfo(syntax.Left);
            var assignEvent = leftSymbol.Symbol is IEventSymbol;

            if (kind == ExprKind.ASSIGN_ADD && assignEvent)
            {
                return ExprKind.ADD_EVENT;
            }

            if (kind == ExprKind.ASSIGN_SUB && assignEvent)
            {
                return ExprKind.REMOVE_EVENT;
            }

            return kind;
        }
    }
}
