using Microsoft.CodeAnalysis;

namespace Semmle.Extraction.CSharp.Entities
{
    internal abstract class ExpressionParentEntity<TSymbol> : CachedSymbol<TSymbol>, IExpressionParentEntity where TSymbol : class, ISymbol
    {
        protected ExpressionParentEntity(Context context, TSymbol symbol) : base(context, symbol) { }

        bool IExpressionParentEntity.IsTopLevelParent => true;

        public override TrapStackBehaviour TrapStackBehaviour =>
            IsSourceDeclaration && Symbol.FromSource() ? TrapStackBehaviour.PushesLabel : TrapStackBehaviour.OptionalLabel;
    }
}
