using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class UnaryPattern : Expression
    {
        public UnaryPattern(Context cx, UnaryPatternSyntax syntax, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, null, cx.CreateLocation(syntax.GetLocation()), ExprKind.NOT_PATTERN, parent, child, isCompilerGenerated: false, null))
        {
            Pattern.Create(cx, syntax.Pattern, this, 0);
        }
    }
}