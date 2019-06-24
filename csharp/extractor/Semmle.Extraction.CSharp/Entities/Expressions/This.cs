using Semmle.Extraction.Entities;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class This : Expression
    {
        This(IExpressionInfo info) : base(info) { }

        public static This CreateImplicit(Context cx, Type @class, Location loc, IExpressionParentEntity parent, int child) =>
            new This(new ExpressionInfo(cx, new AnnotatedType(@class, Kinds.TypeAnnotation.NotAnnotated), loc, Kinds.ExprKind.THIS_ACCESS, parent, child, true, null));

        public static This CreateExplicit(ExpressionNodeInfo info) => new This(info.SetKind(ExprKind.THIS_ACCESS));
    }
}
