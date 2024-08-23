using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ErrorExpressionEntity : CachedEntity<(ErrorExpressionAst, ErrorExpressionAst)>
    {
        private ErrorExpressionEntity(PowerShellContext cx, ErrorExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ErrorExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.error_expression(this);
            trapFile.error_expression_location(this, TrapSuitableLocation);
            if (Fragment.NestedAst is not null)
            {
                for(int index = 0; index < Fragment.NestedAst.Count; index++)
                {
                    trapFile.error_expression_nested_ast(this, index, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.NestedAst[index]));
                }
            }
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";error_expression");
        }

        internal static ErrorExpressionEntity Create(PowerShellContext cx, ErrorExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return ErrorExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ErrorExpressionEntityFactory : CachedEntityFactory<(ErrorExpressionAst, ErrorExpressionAst), ErrorExpressionEntity>
        {
            public static ErrorExpressionEntityFactory Instance { get; } = new ErrorExpressionEntityFactory();

            public override ErrorExpressionEntity Create(PowerShellContext cx, (ErrorExpressionAst, ErrorExpressionAst) init) =>
                new ErrorExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}