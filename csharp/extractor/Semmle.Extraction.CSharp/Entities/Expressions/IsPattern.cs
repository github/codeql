using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Microsoft.CodeAnalysis.CSharp;
using Semmle.Extraction.Kinds;
using Semmle.Extraction.Entities;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class IsPattern : Expression<IsPatternExpressionSyntax>
    {
        private IsPattern(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.IS))
        {
        }

        private void PopulatePattern(PatternSyntax pattern, TypeSyntax optionalType, SyntaxToken varKeyword, VariableDesignationSyntax designation)
        {
            bool isVar = optionalType is null;
            if (!isVar)
                Expressions.TypeAccess.Create(cx, optionalType, this, 1);

            if (cx.Model(pattern).GetDeclaredSymbol(designation) is ILocalSymbol symbol)
            {
                var type = Type.Create(cx, symbol.Type);

                if (isVar)
                    new Expression(new ExpressionInfo(cx, type, cx.Create(varKeyword.GetLocation()), ExprKind.TYPE_ACCESS, this, 1, false, null));

                VariableDeclaration.Create(cx, symbol, type, cx.Create(pattern.GetLocation()), cx.Create(designation.GetLocation()), isVar, this, 2);
            }
        }

        protected override void Populate()
        {
            Create(cx, Syntax.Expression, this, 0);
            switch (Syntax.Pattern)
            {
                case ConstantPatternSyntax constantPattern:
                    Create(cx, constantPattern.Expression, this, 3);
                    return;
                case VarPatternSyntax varPattern:
                    PopulatePattern(varPattern, null, varPattern.VarKeyword, varPattern.Designation);
                    return;
                case DeclarationPatternSyntax declPattern:
                    PopulatePattern(declPattern, declPattern.Type, default(SyntaxToken), declPattern.Designation);
                    return;
                default:
                    throw new InternalError(Syntax, "Is pattern not handled");
            }
        }

        public static Expression Create(ExpressionNodeInfo info) => new IsPattern(info).TryPopulate();
    }
}
