using System.IO;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class UnaryExpressionEntity : CachedEntity<(UnaryExpressionAst, UnaryExpressionAst)>
    {
        private UnaryExpressionEntity(PowerShellContext cx, UnaryExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public UnaryExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.unary_expression(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Child), Fragment.TokenKind, Fragment.StaticType.Name);
            trapFile.unary_expression_location(this, TrapSuitableLocation);
            trapFile.parent(this, EntityConstructor.ConstructAppropriateEntity(PowerShellContext, Fragment.Parent));
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";unary_expression");
        }

        internal static UnaryExpressionEntity Create(PowerShellContext cx, UnaryExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return UnaryExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class UnaryExpressionEntityFactory : CachedEntityFactory<(UnaryExpressionAst, UnaryExpressionAst), UnaryExpressionEntity>
        {
            public static UnaryExpressionEntityFactory Instance { get; } = new UnaryExpressionEntityFactory();

            public override UnaryExpressionEntity Create(PowerShellContext cx, (UnaryExpressionAst, UnaryExpressionAst) init) =>
                new UnaryExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;
    }
}