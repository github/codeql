using Microsoft.CodeAnalysis.CSharp.Syntax;
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
            TypeAccess.Create(cx, Syntax.Type, this, 0);
        }
    }
}
