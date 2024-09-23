using System;
using System.IO;
using System.Management.Automation.Language;
using System.Reflection;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class MemberExpressionEntity : CachedEntity<(MemberExpressionAst, MemberExpressionAst)>
    {
        private MemberExpressionEntity(PowerShellContext cx, MemberExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public MemberExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            var expression = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Expression);
            var member = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Member);
            trapFile.member_expression(this, expression, member, Fragment.NullConditional, Fragment.Static);
            trapFile.member_expression_location(this, TrapSuitableLocation);
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";member_expression");
        }

        internal static MemberExpressionEntity Create(PowerShellContext cx, MemberExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return MemberExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class MemberExpressionEntityFactory : CachedEntityFactory<(MemberExpressionAst, MemberExpressionAst), MemberExpressionEntity>
        {
            public static MemberExpressionEntityFactory Instance { get; } = new MemberExpressionEntityFactory();

            public override MemberExpressionEntity Create(PowerShellContext cx, (MemberExpressionAst, MemberExpressionAst) init) =>
                new MemberExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}