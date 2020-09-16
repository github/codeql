using Microsoft.CodeAnalysis.CSharp.Syntax; // lgtm[cs/similar-file]
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class Ref : Expression<RefExpressionSyntax>
    {
        Ref(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.REF)) { }

        public static Expression Create(ExpressionNodeInfo info) => new Ref(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(Cx, Syntax.Expression, this, 0);
        }
    }
}
