using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class TypeOf : Expression<TypeOfExpressionSyntax>
    {
        TypeOf(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.TYPEOF)) { }

        public static Expression Create(ExpressionNodeInfo info) => new TypeOf(info).TryPopulate();

        protected override void Populate()
        {
            TypeAccess.Create(cx, Syntax.Type, this, 0);
        }
    }
}
