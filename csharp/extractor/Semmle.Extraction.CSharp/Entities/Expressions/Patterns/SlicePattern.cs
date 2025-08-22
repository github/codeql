using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class SlicePattern : Expression
    {
        public SlicePattern(Context cx, SlicePatternSyntax syntax, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, null, cx.CreateLocation(syntax.GetLocation()), ExprKind.SLICE_PATTERN, parent, child, isCompilerGenerated: false, null))
        {
            if (syntax.Pattern is not null)
            {
                Pattern.Create(cx, syntax.Pattern, this, 0);
            }
        }
    }
}