using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class TypeConstraintEntity : CachedEntity<(TypeConstraintAst, TypeConstraintAst)>
    {
        private TypeConstraintEntity(PowerShellContext cx, TypeConstraintAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public TypeConstraintAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.type_constraint(this, Fragment.TypeName.Name ?? string.Empty, Fragment.TypeName.FullName ?? string.Empty);
            trapFile.type_constraint_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";type_constraint");
        }

        internal static TypeConstraintEntity Create(PowerShellContext cx, TypeConstraintAst fragment)
        {
            var init = (fragment, fragment);
            return TypeConstraintEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class TypeConstraintEntityFactory : CachedEntityFactory<(TypeConstraintAst, TypeConstraintAst), TypeConstraintEntity>
        {
            public static TypeConstraintEntityFactory Instance { get; } = new TypeConstraintEntityFactory();

            public override TypeConstraintEntity Create(PowerShellContext cx, (TypeConstraintAst, TypeConstraintAst) init) =>
                new TypeConstraintEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}