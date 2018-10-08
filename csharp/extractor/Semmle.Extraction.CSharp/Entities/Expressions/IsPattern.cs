using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Kinds;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class IsPattern : Expression<IsPatternExpressionSyntax>
    {
        IsPattern(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.IS))
        {
        }

        protected override void Populate()
        {
            var constantPattern = Syntax.Pattern as ConstantPatternSyntax;
            if (constantPattern != null)
            {
                Create(cx, Syntax.Expression, this, 0);
                Create(cx, constantPattern.Expression, this, 3);
                return;
            }

            var pattern = Syntax.Pattern as DeclarationPatternSyntax;

            if (pattern == null)
            {
                throw new InternalError(Syntax, "Is-pattern not handled");
            }

            Create(cx, Syntax.Expression, this, 0);
            TypeAccess.Create(cx, pattern.Type, this, 1);

            var symbol = cx.Model(Syntax).GetDeclaredSymbol(pattern.Designation) as ILocalSymbol;
            if (symbol != null)
            {
                var type = Type.Create(cx, symbol.Type);
                var isVar = pattern.Type.IsVar;
                VariableDeclaration.Create(cx, symbol, type, cx.Create(pattern.GetLocation()), cx.Create(pattern.Designation.GetLocation()), isVar, this, 2);
            }
        }

        public static Expression Create(ExpressionNodeInfo info) => new IsPattern(info).TryPopulate();
    }
}
