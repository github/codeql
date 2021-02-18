using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class IfDirective : PreprocessorDirective<IfDirectiveTriviaSyntax>, IExpressionParentEntity
    {
        public IfDirective(Context cx, IfDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        public bool IsTopLevelParent => true;

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_ifs(this, trivia.BranchTaken, trivia.ConditionValue);

            Expression.Create(Context, trivia.Condition, this, 0);
        }
    }
}
