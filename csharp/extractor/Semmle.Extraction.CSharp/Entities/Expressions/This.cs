using Microsoft.CodeAnalysis;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class This : Expression
    {
        private This(IExpressionInfo info) : base(info) { }

        public static This CreateImplicit(Context cx, ITypeSymbol @class, Location loc, IExpressionParentEntity parent, int child) =>
            new This(new ExpressionInfo(cx, AnnotatedTypeSymbol.CreateNotAnnotated(@class), loc, Kinds.ExprKind.THIS_ACCESS, parent, child, isCompilerGenerated: true, null));

        public static This CreateExplicit(ExpressionNodeInfo info) => new This(info.SetKind(ExprKind.THIS_ACCESS));
    }
}
