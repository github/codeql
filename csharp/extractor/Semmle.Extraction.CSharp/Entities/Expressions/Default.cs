using Microsoft.CodeAnalysis.CSharp.Syntax; // lgtm[cs/similar-file]
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class Default : Expression<DefaultExpressionSyntax>
    {
        Default(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.DEFAULT)) { }

        public static Expression Create(ExpressionNodeInfo info) => new Default(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            TypeAccess.Create(Cx, Syntax.Type, this, 0);
        }
    }
}
