using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class DefineSymbol : Expression<IdentifierNameSyntax>
    {
        private DefineSymbol(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.DEFINE_SYMBOL)) { }

        public static Expression Create(ExpressionNodeInfo info) => new DefineSymbol(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            trapFile.directive_define_symbols(this, Syntax.Identifier.Text);
        }
    }
}
