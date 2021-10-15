using Microsoft.CodeAnalysis;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities
{
    /// <summary>
    /// Explicitly constructed expression information.
    /// </summary>
    internal class ExpressionInfo : IExpressionInfo
    {
        public Context Context { get; }
        public AnnotatedTypeSymbol? Type { get; }
        public Extraction.Entities.Location Location { get; }
        public ExprKind Kind { get; }
        public IExpressionParentEntity Parent { get; }
        public int Child { get; }
        public bool IsCompilerGenerated { get; }
        public string? ExprValue { get; }

        public ExpressionInfo(Context cx, AnnotatedTypeSymbol? type, Extraction.Entities.Location location, ExprKind kind,
            IExpressionParentEntity parent, int child, bool isCompilerGenerated, string? value)
        {
            Context = cx;
            Type = type;
            Location = location;
            Kind = kind;
            Parent = parent;
            Child = child;
            ExprValue = value;
            IsCompilerGenerated = isCompilerGenerated;
        }

        // Synthetic expressions don't have a flow state.
        public NullableFlowState FlowState => NullableFlowState.None;
    }
}
