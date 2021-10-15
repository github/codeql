using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal class Unknown : Expression
    {
        public Unknown(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.UNKNOWN)) { }
    }
}
