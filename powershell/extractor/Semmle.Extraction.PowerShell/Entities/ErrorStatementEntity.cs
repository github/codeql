using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ErrorStatementEntity : CachedEntity<(ErrorStatementAst, ErrorStatementAst)>
    {
        private ErrorStatementEntity(PowerShellContext cx, ErrorStatementAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ErrorStatementAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.error_statement(this, TokenEntity.Create(PowerShellContext, Fragment.Kind));
            if (Fragment.Flags is not null)
            {
                int index = 0;
                foreach (var flag in Fragment.Flags)
                {
                    trapFile.error_statement_flag(this, index++, flag.Key, TokenEntity.Create(PowerShellContext,flag.Value.Item1), EntityConstructor.ConstructAppropriateEntity(PowerShellContext, flag.Value.Item2));
                }
            }
            if (Fragment.NestedAst is not null)
            {
                for(int index = 0; index < Fragment.NestedAst.Count; index++)
                {
                    trapFile.error_statement_nested_ast(this, index, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.NestedAst[index]));
                }
            }
            for(int index = 0; index < Fragment.Conditions.Count; index++)
            {
                trapFile.error_statement_conditions(this, index, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Conditions[index]));
            }
            for(int index = 0; index < Fragment.Bodies.Count; index++)
            {
                trapFile.error_statement_bodies(this, index, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Bodies[index]));
            }
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
            trapFile.error_statement_location(this, TrapSuitableLocation);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";error_statement");
        }

        internal static ErrorStatementEntity Create(PowerShellContext cx, ErrorStatementAst fragment)
        {
            var init = (fragment, fragment);
            return ErrorStatementEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ErrorStatementEntityFactory : CachedEntityFactory<(ErrorStatementAst, ErrorStatementAst), ErrorStatementEntity>
        {
            public static ErrorStatementEntityFactory Instance { get; } = new ErrorStatementEntityFactory();

            public override ErrorStatementEntity Create(PowerShellContext cx, (ErrorStatementAst, ErrorStatementAst) init) =>
                new ErrorStatementEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}