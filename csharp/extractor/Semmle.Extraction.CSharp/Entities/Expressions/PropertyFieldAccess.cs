using System.IO;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class PropertyFieldAccess : Expression<FieldExpressionSyntax>
    {
        private PropertyFieldAccess(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.FIELD_ACCESS)) { }

        public static Expression Create(ExpressionNodeInfo info) => new PropertyFieldAccess(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            var symbolInfo = Context.GetSymbolInfo(Syntax);
            if (symbolInfo.Symbol is IFieldSymbol field)
            {
                var target = PropertyField.Create(Context, field);
                trapFile.expr_access(this, target);
                if (!field.IsStatic)
                {
                    This.CreateImplicit(Context, field.ContainingType, Location, this, -1);
                }
            }
        }
    }
}
