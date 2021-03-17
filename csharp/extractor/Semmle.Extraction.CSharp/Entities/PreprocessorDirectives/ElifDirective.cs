using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class ElifDirective : PreprocessorDirective<ElifDirectiveTriviaSyntax>, IIfSiblingDirective, IExpressionParentEntity
    {
        private readonly IfDirective start;
        private readonly int index;

        public ElifDirective(Context cx, ElifDirectiveTriviaSyntax trivia, IfDirective start, int index)
            : base(cx, trivia, populateFromBase: false)
        {
            this.start = start;
            this.index = index;
            TryPopulate();
        }

        public bool IsTopLevelParent => true;

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_elifs(this, trivia.BranchTaken, trivia.ConditionValue, start, index);

            Expression.Create(Context, trivia.Condition, this, 0);
        }
    }
}
