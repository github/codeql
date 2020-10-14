using Microsoft.CodeAnalysis.CSharp.Syntax; // lgtm[cs/similar-file]
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class SizeOf : Expression<SizeOfExpressionSyntax>
    {
        private SizeOf(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.SIZEOF)) { }

        public static Expression Create(ExpressionNodeInfo info) => new SizeOf(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            TypeAccess.Create(cx, Syntax.Type, this, 0);
        }
    }
}
