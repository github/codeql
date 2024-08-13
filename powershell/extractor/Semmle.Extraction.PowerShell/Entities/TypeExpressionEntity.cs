using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class TypeExpressionEntity : CachedEntity<(TypeExpressionAst, TypeExpressionAst)>
    {
        private TypeExpressionEntity(PowerShellContext cx, TypeExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public TypeExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.type_expression(this, Fragment.TypeName.Name, Fragment.TypeName.FullName);
            trapFile.type_expression_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";type_expression");
        }

        internal static TypeExpressionEntity Create(PowerShellContext cx, TypeExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return TypeExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class TypeExpressionEntityFactory : CachedEntityFactory<(TypeExpressionAst, TypeExpressionAst), TypeExpressionEntity>
        {
            public static TypeExpressionEntityFactory Instance { get; } = new TypeExpressionEntityFactory();

            public override TypeExpressionEntity Create(PowerShellContext cx, (TypeExpressionAst, TypeExpressionAst) init) =>
                new TypeExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}