using System;
using System.IO;
using System.Management.Automation.Language;
using System.Reflection.Metadata;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class ConstantExpressionEntity : CachedEntity<(ConstantExpressionAst, ConstantExpressionAst)>
    {
        private ConstantExpressionEntity(PowerShellContext cx, ConstantExpressionAst fragment)
            : base(cx, (fragment, fragment))
        {
        }

        public override Microsoft.CodeAnalysis.Location ReportingLocation => PowerShellContext.CreateAnalysisLocation(Fragment);
        public ConstantExpressionAst Fragment => Symbol.Item1;
        public override void Populate(TextWriter trapFile)
        {
            trapFile.constant_expression(this, Fragment.StaticType.Name);
            if (Fragment.Value is not null && Fragment.Value.ToString() is {} strVal)
            {
                trapFile.constant_expression_value(this,
                    StringLiteralEntity.Create(PowerShellContext, ReportingLocation, strVal));
            }
            trapFile.parent(PowerShellContext, this, Fragment.Parent);
            trapFile.constant_expression_location(this, TrapSuitableLocation);
        }

        public override bool NeedsPopulation => true;

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(TrapSuitableLocation);
            trapFile.Write(";constant_expression");
        }

        internal static ConstantExpressionEntity Create(PowerShellContext cx, ConstantExpressionAst fragment)
        {
            var init = (fragment, fragment);
            return ConstantExpressionEntityFactory.Instance.CreateEntity(cx, init, init);
        }

        private class ConstantExpressionEntityFactory : CachedEntityFactory<(ConstantExpressionAst, ConstantExpressionAst), ConstantExpressionEntity>
        {
            public static ConstantExpressionEntityFactory Instance { get; } = new ConstantExpressionEntityFactory();

            public override ConstantExpressionEntity Create(PowerShellContext cx, (ConstantExpressionAst, ConstantExpressionAst) init) =>
                new ConstantExpressionEntity(cx, init.Item1);
        }

        public override TrapStackBehaviour TrapStackBehaviour => TrapStackBehaviour.OptionalLabel;

        /// <summary>
        /// Gets a string representation of a constant value.
        /// </summary>
        /// <param name="obj">The value.</param>
        /// <returns>The string representation.</returns>
        /// From https://github.com/github/codeql/blob/main/csharp/extractor/Semmle.Extraction.CSharp/Entities/Expression.cs
        public static string ValueAsString(object? value)
        {
            return value is null
                ? "null"
                : value.ToString()!;
        }
    }
}