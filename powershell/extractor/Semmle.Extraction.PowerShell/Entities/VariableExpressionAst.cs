using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class VariableExpressionEntity : CachedEntity<(VariableExpressionAst, VariableExpressionAst)>
    {
        private VariableExpressionEntity(PowerShellContext cx, VariableExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public VariableExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.variable_expression(this, Fragment.VariablePath.UserPath, Fragment.VariablePath.DriveName ?? string.Empty, Fragment.IsConstantVariable(),
                Fragment.VariablePath.IsGlobal, Fragment.VariablePath.IsLocal, Fragment.VariablePath.IsPrivate,
                Fragment.VariablePath.IsScript, Fragment.VariablePath.IsUnqualified,
                Fragment.VariablePath.IsUnscopedVariable, Fragment.VariablePath.IsVariable,
                Fragment.VariablePath.IsDriveQualified);
            trapFile.variable_expression_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";variable_expression");
        }

        internal static VariableExpressionEntity Create(PowerShellContext cx, VariableExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return VariableExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class VariableExpressionEntityFactory : CachedEntityFactory<(VariableExpressionAst, VariableExpressionAst), VariableExpressionEntity>
        {
            public static VariableExpressionEntityFactory Instance { get; } = new VariableExpressionEntityFactory();

            public override VariableExpressionEntity Create(PowerShellContext cx, (VariableExpressionAst, VariableExpressionAst) init) =>
                new VariableExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}