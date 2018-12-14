using Semmle.Extraction.Kinds;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class MakeRef : Expression<MakeRefExpressionSyntax>
    {
        MakeRef(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.REF)) { }

        public static Expression Create(ExpressionNodeInfo info) => new MakeRef(info).TryPopulate();

        protected override void Populate()
        {
            Create(cx, Syntax.Expression, this, 0);
        }
    }
}
