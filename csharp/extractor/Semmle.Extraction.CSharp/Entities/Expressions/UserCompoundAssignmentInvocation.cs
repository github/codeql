using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    /// <summary>
    /// Represents a user-defined compound assignment operator such as `a += b` where `a` is of a type that defines an `operator +=`.
    /// In this case, we don't want to desugar it into `a = a + b`, but instead extract the operator call directly as it should
    /// be considered an instance method call on `a` with `b` as an argument.
    /// </summary>
    internal class UserCompoundAssignmentInvocation : Expression<AssignmentExpressionSyntax>
    {
        private readonly ExpressionNodeInfo info;

        protected UserCompoundAssignmentInvocation(ExpressionNodeInfo info)
            : base(info.SetKind(ExprKind.OPERATOR_INVOCATION))
        {
            this.info = info;
        }

        public static Expression Create(ExpressionNodeInfo info) => new UserCompoundAssignmentInvocation(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Context, Syntax.Left, this, -1);
            Create(Context, Syntax.Right, this, 0);

            var target = info.GetTargetSymbol(Context);
            if (target is null)
            {
                Context.ModelError(Syntax, "Unable to resolve target method for user-defined compound assignment operator");
                return;
            }

            var targetKey = Method.Create(Context, target);
            trapFile.expr_call(this, targetKey);
        }
    }
}
