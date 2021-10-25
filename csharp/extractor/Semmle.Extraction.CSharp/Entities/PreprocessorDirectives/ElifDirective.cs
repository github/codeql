using Microsoft.CodeAnalysis.CSharp.Syntax;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class ElifDirective : PreprocessorDirective<ElifDirectiveTriviaSyntax>, IIfSiblingDirective, IExpressionParentEntity
    {
        private readonly IfDirective start;
        private readonly int index;

        private ElifDirective(Context cx, ElifDirectiveTriviaSyntax trivia, IfDirective start, int index)
            : base(cx, trivia)
        {
            this.start = start;
            this.index = index;
        }

        public bool IsTopLevelParent => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(Context.CreateLocation(ReportingLocation));
            trapFile.Write(Symbol.IsActive);
            trapFile.Write(',');
            trapFile.Write(Symbol.BranchTaken);
            trapFile.Write(',');
            trapFile.Write(Symbol.ConditionValue);
            trapFile.Write(";trivia");
        }

        protected override void PopulatePreprocessor(TextWriter trapFile)
        {
            trapFile.directive_elifs(this, Symbol.BranchTaken, Symbol.ConditionValue, start, index);

            Expression.Create(Context, Symbol.Condition, this, 0);
        }

        public static ElifDirective Create(Context cx, ElifDirectiveTriviaSyntax elif, IfDirective start, int index) =>
            ElifDirectiveFactory.Instance.CreateEntity(cx, elif, (elif, start, index));

        private class ElifDirectiveFactory : CachedEntityFactory<(ElifDirectiveTriviaSyntax elif, IfDirective start, int index), ElifDirective>
        {
            public static ElifDirectiveFactory Instance { get; } = new ElifDirectiveFactory();

            public override ElifDirective Create(Context cx, (ElifDirectiveTriviaSyntax elif, IfDirective start, int index) init) => new(cx, init.elif, init.start, init.index);
        }
    }
}
