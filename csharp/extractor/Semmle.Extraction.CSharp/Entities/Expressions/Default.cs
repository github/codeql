using System.IO; // lgtm[cs/similar-file]
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Default : Expression<DefaultExpressionSyntax>
    {
        private Default(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.DEFAULT)) { }

        public static Expression Create(ExpressionNodeInfo info) => new Default(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            TypeAccess.Create(Context, Syntax.Type, this, 0);
        }

        public static Expression CreateGenerated(Context cx, IExpressionParentEntity parent, int childIndex, Location location, string? value)
        {
            var info = new ExpressionInfo(
                cx,
                null,
                location,
                ExprKind.DEFAULT,
                parent,
                childIndex,
                isCompilerGenerated: true,
                value);

            return new Expression(info);
        }
    }
}
