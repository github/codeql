using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class ElifDirective : PreprocessorDirective<ElifDirectiveTriviaSyntax>, IIfSiblingDirective, IExpressionParentEntity
    {
        public ElifDirective(Context cx, ElifDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        public bool IsTopLevelParent => true;

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_elifs(this, trivia.BranchTaken, trivia.ConditionValue);

            Expression.Create(cx, trivia.Condition, this, 0);
        }
    }
}
