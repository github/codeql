using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class Discard : Expression<NameSyntax>
    {
        public Discard(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.DISCARD))
        {
        }

        protected override void Populate()
        {
        }
    }
}
