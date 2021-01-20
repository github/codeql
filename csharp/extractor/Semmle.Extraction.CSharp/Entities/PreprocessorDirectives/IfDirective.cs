using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class IfDirective : PreprocessorDirective<IfDirectiveTriviaSyntax>, IExpressionParentEntity
    {
        private readonly List<IIfSiblingDirective> branches = new List<IIfSiblingDirective>();

        public IfDirective(Context cx, IfDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
        }

        public bool IsTopLevelParent => true;

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_ifs(this, trivia.BranchTaken, trivia.ConditionValue);

            Expression.Create(cx, trivia.Condition, this, 0);
        }

        internal void Add(IIfSiblingDirective branch)
        {
            branches.Add(branch);
        }

        internal void WriteBranches(EndIfDirective endif)
        {
            cx.TrapWriter.Writer.directive_if_endif(this, endif);
            var siblings = 0;
            foreach (var branch in branches)
            {
                cx.TrapWriter.Writer.directive_if_siblings(this, branch, siblings++);
            }
        }
    }
}
