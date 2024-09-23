using System;
using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class FunctionMemberEntity : CachedEntity<(FunctionMemberAst, FunctionMemberAst)>
    {
        private FunctionMemberEntity(PowerShellContext cx, FunctionMemberAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public FunctionMemberAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.function_member(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Body), Fragment.IsConstructor, Fragment.IsHidden, Fragment.IsPrivate, Fragment.IsPublic, Fragment.IsStatic, Fragment.Name, Fragment.MethodAttributes);
            trapFile.function_member_location(this, TrapSuitableLocation);
            for(int index = 0; index < Fragment.Parameters.Count; index++)
            {
                trapFile.function_member_parameter(this, index, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parameters[index]));
            }
            for(int index = 0; index < Fragment.Attributes.Count; index++)
            {
                trapFile.function_member_attribute(this, index, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Attributes[index]));
            }
            if (Fragment.ReturnType is not null)
            {
                trapFile.function_member_return_type(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.ReturnType));
            }
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";function_member");
        }

        internal static FunctionMemberEntity Create(PowerShellContext cx, FunctionMemberAst fragment)
        {
            var init = (fragment, fragment);
            return FunctionMemberEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class FunctionMemberEntityFactory : CachedEntityFactory<(FunctionMemberAst, FunctionMemberAst), FunctionMemberEntity>
        {
            public static FunctionMemberEntityFactory Instance { get; } = new FunctionMemberEntityFactory();

            public override FunctionMemberEntity Create(PowerShellContext cx, (FunctionMemberAst, FunctionMemberAst) init) =>
                new FunctionMemberEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}