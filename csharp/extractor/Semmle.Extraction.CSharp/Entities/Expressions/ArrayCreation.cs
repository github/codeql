using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    abstract class ArrayCreation<SyntaxNode> : Expression<SyntaxNode> where SyntaxNode : ExpressionSyntax
    {
        protected ArrayCreation(ExpressionNodeInfo info) : base(info) { }
    }

    class StackAllocArrayCreation : ArrayCreation<StackAllocArrayCreationExpressionSyntax>
    {
        StackAllocArrayCreation(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.ARRAY_CREATION)) { }

        public static Expression Create(ExpressionNodeInfo info) => new StackAllocArrayCreation(info).TryPopulate();

        protected override void Populate()
        {
            var arrayType = Syntax.Type as ArrayTypeSyntax;

            if (arrayType == null)
            {
                cx.ModelError(Syntax, "Unexpected array type");
                return;
            }

            var child = 0;

            foreach (var rank in arrayType.RankSpecifiers.SelectMany(rs => rs.Sizes))
            {
                Create(cx, rank, this, child++);
            }

            cx.Emit(Tuples.explicitly_sized_array_creation(this));
        }
    }

    class ExplicitArrayCreation : ArrayCreation<ArrayCreationExpressionSyntax>
    {
        ExplicitArrayCreation(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.ARRAY_CREATION)) { }

        public static Expression Create(ExpressionNodeInfo info) => new ExplicitArrayCreation(info).TryPopulate();

        protected override void Populate()
        {
            var child = 0;
            bool explicitlySized = false;

            foreach (var rank in Syntax.Type.RankSpecifiers.SelectMany(rs => rs.Sizes))
            {
                if (rank is OmittedArraySizeExpressionSyntax)
                {
                    // Create an expression which simulates the explicit size of the array

                    if (Syntax.Initializer != null)
                    {
                        // An implicitly-sized array must have an initializer.
                        // Guard it just in case.
                        var size = Syntax.Initializer.Expressions.Count;

                        var info = new ExpressionInfo(
                            cx,
                            Type.Create(cx, cx.Compilation.GetSpecialType(Microsoft.CodeAnalysis.SpecialType.System_Int32)),
                            Location,
                            ExprKind.INT_LITERAL,
                            this,
                            child,
                            false,
                            size.ToString());

                        new Expression(info);
                    }
                }
                else
                {
                    Create(cx, rank, this, child);
                    explicitlySized = true;
                }
                child++;
            }
            if (Syntax.Initializer != null)
            {
                ArrayInitializer.Create(new ExpressionNodeInfo(cx, Syntax.Initializer, this, -1));
            }

            if (explicitlySized)
                cx.Emit(Tuples.explicitly_sized_array_creation(this));
        }
    }

    class ImplicitArrayCreation : ArrayCreation<ImplicitArrayCreationExpressionSyntax>
    {
        ImplicitArrayCreation(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.ARRAY_CREATION)) { }

        public static Expression Create(ExpressionNodeInfo info) => new ImplicitArrayCreation(info).TryPopulate();

        protected override void Populate()
        {
            if (Syntax.Initializer != null)
            {
                ArrayInitializer.Create(new ExpressionNodeInfo(cx, Syntax.Initializer, this, -1));
            }

            cx.Emit(Tuples.implicitly_typed_array_creation(this));
        }
    }
}
