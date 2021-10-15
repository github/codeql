using Microsoft.CodeAnalysis;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities
{
    /// <summary>
    /// Holds all information required to create an Expression entity.
    /// </summary>
    internal interface IExpressionInfo
    {
        Context Context { get; }

        /// <summary>
        /// The type of the expression.
        /// </summary>
        AnnotatedTypeSymbol? Type { get; }

        /// <summary>
        /// The location of the expression.
        /// </summary>
        Extraction.Entities.Location Location { get; }

        /// <summary>
        /// The kind of the expression.
        /// </summary>
        ExprKind Kind { get; }

        /// <summary>
        /// The parent of the expression.
        /// </summary>
        IExpressionParentEntity Parent { get; }

        /// <summary>
        /// The child index of the expression.
        /// </summary>
        int Child { get; }

        /// <summary>
        /// Holds if this is an implicit expression.
        /// </summary>
        bool IsCompilerGenerated { get; }

        /// <summary>
        /// Gets a string representation of the value.
        /// null is encoded as the string "null".
        /// If the expression does not have a value, then this
        /// is null.
        /// </summary>
        string? ExprValue { get; }

        NullableFlowState FlowState { get; }
    }
}
