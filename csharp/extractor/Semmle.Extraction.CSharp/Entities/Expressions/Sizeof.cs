using System.IO; // lgtm[cs/similar-file]
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class SizeOf : Expression<SizeOfExpressionSyntax>
    {
        private SizeOf(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.SIZEOF)) { }

        public static Expression Create(ExpressionNodeInfo info) => new SizeOf(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            TypeAccess.Create(Context, Syntax.Type, this, 0);
        }
    }
}
