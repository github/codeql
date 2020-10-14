using Microsoft.CodeAnalysis.CSharp.Syntax;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis;
using System.IO;

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
            var operatorKind = OperatorKind;
            if (operatorKind.HasValue)
            {
                // Convert assignment such as `a += b` into `a = a + b`.
                var simpleAssignExpr = new Expression(new ExpressionInfo(cx, Type, Location, ExprKind.SIMPLE_ASSIGN, this, 2, false, null));
                Create(cx, Syntax.Left, simpleAssignExpr, 1);
                var opexpr = new Expression(new ExpressionInfo(cx, Type, Location, operatorKind.Value, simpleAssignExpr, 0, false, null));
                Create(cx, Syntax.Left, opexpr, 0);
                Create(cx, Syntax.Right, opexpr, 1);
                opexpr.OperatorCall(trapFile, Syntax);
            }
            else
            {
                Create(cx, Syntax.Left, this, 1);
                Create(cx, Syntax.Right, this, 0);

                if (Kind == ExprKind.ADD_EVENT || Kind == ExprKind.REMOVE_EVENT)
                {
                    OperatorCall(trapFile, Syntax);
                }
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
                case SyntaxKind.QuestionQuestionEqualsToken:
                    return ExprKind.ASSIGN_COALESCE;
                default:
                    cx.ModelError(syntax, "Unrecognised assignment type " + GetKind(cx, syntax));
                    return ExprKind.UNKNOWN;
            }
        }

        private static ExprKind GetKind(Context cx, AssignmentExpressionSyntax syntax)
        {
            var kind = GetAssignmentOperation(cx, syntax);
            var leftType = cx.GetType(syntax.Left);

            if (leftType.Symbol != null && leftType.Symbol.SpecialType != SpecialType.None)
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

        /// <summary>
        /// Gets the kind of this assignment operator (<code>null</code> if the
        /// assignment is not an assignment operator). For example, the operator
        /// kind of `*=` is `*`.
        /// </summary>
        private ExprKind? OperatorKind
        {
            get
            {
                var kind = Kind;
                if (kind == ExprKind.REMOVE_EVENT || kind == ExprKind.ADD_EVENT || kind == ExprKind.SIMPLE_ASSIGN)
                    return null;

                if (CallType.AdjustKind(kind) == ExprKind.OPERATOR_INVOCATION)
                    return ExprKind.OPERATOR_INVOCATION;

                switch (kind)
                {
                    case ExprKind.ASSIGN_ADD:
                        return ExprKind.ADD;
                    case ExprKind.ASSIGN_AND:
                        return ExprKind.BIT_AND;
                    case ExprKind.ASSIGN_DIV:
                        return ExprKind.DIV;
                    case ExprKind.ASSIGN_LSHIFT:
                        return ExprKind.LSHIFT;
                    case ExprKind.ASSIGN_MUL:
                        return ExprKind.MUL;
                    case ExprKind.ASSIGN_OR:
                        return ExprKind.BIT_OR;
                    case ExprKind.ASSIGN_REM:
                        return ExprKind.REM;
                    case ExprKind.ASSIGN_RSHIFT:
                        return ExprKind.RSHIFT;
                    case ExprKind.ASSIGN_SUB:
                        return ExprKind.SUB;
                    case ExprKind.ASSIGN_XOR:
                        return ExprKind.BIT_XOR;
                    case ExprKind.ASSIGN_COALESCE:
                        return ExprKind.NULL_COALESCING;
                    default:
                        cx.ModelError(Syntax, "Couldn't unfold assignment of type " + kind);
                        return ExprKind.UNKNOWN;
                }
            }
        }

        public new CallType CallType => GetCallType(cx, Syntax);
    }
}
