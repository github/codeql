using System.IO;
using Microsoft.CodeAnalysis.CSharp.Syntax;

namespace Semmle.Extraction.CSharp.Entities
{
    internal class IfDirective : PreprocessorDirective<IfDirectiveTriviaSyntax>, IExpressionParentEntity
    {
        private IfDirective(Context cx, IfDirectiveTriviaSyntax trivia)
            : base(cx, trivia)
        {
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
            trapFile.directive_ifs(this, Symbol.BranchTaken, Symbol.ConditionValue);

            Expression.Create(Context, Symbol.Condition, this, 0);
        }

        public static IfDirective Create(Context cx, IfDirectiveTriviaSyntax @if) =>
            IfDirectiveFactory.Instance.CreateEntity(cx, @if, @if);

        private class IfDirectiveFactory : CachedEntityFactory<IfDirectiveTriviaSyntax, IfDirective>
        {
            public static IfDirectiveFactory Instance { get; } = new IfDirectiveFactory();

            public override IfDirective Create(Context cx, IfDirectiveTriviaSyntax init) => new(cx, init);
        }
    }
}
