using Semmle.Extraction.Kinds; // lgtm[cs/similar-file]
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class RefType : Expression<RefTypeExpressionSyntax>
    {
        RefType(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.UNKNOWN)) { }

        public static Expression Create(ExpressionNodeInfo info) => new RefType(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(cx, Syntax.Expression, this, 0);
        }
    }
}
