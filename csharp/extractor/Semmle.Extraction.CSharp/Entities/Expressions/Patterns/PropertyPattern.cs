using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class PropertyPattern : Expression
    {
        internal PropertyPattern(Context cx, PropertyPatternClauseSyntax pp, IExpressionParentEntity parent, int child) :
            base(new ExpressionInfo(cx, null, cx.CreateLocation(pp.GetLocation()), ExprKind.PROPERTY_PATTERN, parent, child, false, null))
        {
            child = 0;
            var trapFile = cx.TrapWriter.Writer;
            foreach (var sub in pp.Subpatterns)
            {
                var p = Expressions.Pattern.Create(cx, sub.Pattern, this, child++);
                if (sub.NameColon is null)
                {
                    Context.ModelError(sub, "Expected to find 'Name:' in pattern.");
                    continue;
                }
                trapFile.exprorstmt_name(p, sub.NameColon.Name.ToString());
            }
        }
    }
}
