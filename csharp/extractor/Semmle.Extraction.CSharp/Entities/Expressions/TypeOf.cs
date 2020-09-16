using Microsoft.CodeAnalysis.CSharp.Syntax; // lgtm[cs/similar-file]
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class TypeOf : Expression<TypeOfExpressionSyntax>
    {
        TypeOf(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.TYPEOF)) { }

        public static Expression Create(ExpressionNodeInfo info) => new TypeOf(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            TypeAccess.Create(Cx, Syntax.Type, this, 0);
        }
    }
}
