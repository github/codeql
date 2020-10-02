using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    class Base : Expression
    {
        Base(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.BASE_ACCESS)) { }

        public static Base Create(ExpressionNodeInfo info) => new Base(info);
    }
}
