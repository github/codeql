using Semmle.Extraction.Kinds; // lgtm[cs/similar-file]
using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class MakeRef : Expression<MakeRefExpressionSyntax>
    {
        private MakeRef(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.REF)) { }

        public static Expression Create(ExpressionNodeInfo info) => new MakeRef(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            Create(cx, Syntax.Expression, this, 0);
        }
    }
}
