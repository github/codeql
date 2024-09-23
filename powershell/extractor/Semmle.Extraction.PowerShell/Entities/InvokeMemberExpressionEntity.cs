using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class InvokeMemberExpressionEntity : CachedEntity<(InvokeMemberExpressionAst, InvokeMemberExpressionAst)>
    {
        private InvokeMemberExpressionEntity(PowerShellContext cx, InvokeMemberExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public InvokeMemberExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            var expression = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Expression);
            var member = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Member);
            trapFile.invoke_member_expression(this, expression, member);
            trapFile.invoke_member_expression_location(this, TrapSuitableLocation);
            if (Fragment.Arguments is not null)
            {
                for (int index = 0; index < Fragment.Arguments.Count; index++)
                {
                    var entity = EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Arguments[index]);
                    trapFile.invoke_member_expression_argument(this, index, entity);
                }
            }
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";invoke_member_expression");
        }

        internal static InvokeMemberExpressionEntity Create(PowerShellContext cx, InvokeMemberExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return InvokeMemberExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class InvokeMemberExpressionEntityFactory : CachedEntityFactory<(InvokeMemberExpressionAst, InvokeMemberExpressionAst), InvokeMemberExpressionEntity>
        {
            public static InvokeMemberExpressionEntityFactory Instance { get; } = new InvokeMemberExpressionEntityFactory();

            public override InvokeMemberExpressionEntity Create(PowerShellContext cx, (InvokeMemberExpressionAst, InvokeMemberExpressionAst) init) =>
                new InvokeMemberExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}