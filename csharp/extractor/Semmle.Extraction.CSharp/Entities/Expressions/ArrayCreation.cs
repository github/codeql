using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Kinds;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal abstract class ArrayCreation<TSyntaxNode> : Expression<TSyntaxNode>
        where TSyntaxNode : ExpressionSyntax
    {
        protected ArrayCreation(ExpressionNodeInfo info) : base(info) { }
    }

    internal abstract class ExplicitArrayCreation<TSyntaxNode> : ArrayCreation<TSyntaxNode>
        where TSyntaxNode : ExpressionSyntax
    {
        protected ExplicitArrayCreation(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.ARRAY_CREATION)) { }

        protected abstract ArrayTypeSyntax TypeSyntax { get; }

        public abstract InitializerExpressionSyntax Initializer { get; }

        protected override void PopulateExpression(TextWriter trapFile)
        {

            var explicitlySized = false;

            if (TypeSyntax is null)
            {
                cx.ModelError(Syntax, "Array has unexpected type syntax");
            }

            var firstLevelSizes = TypeSyntax.RankSpecifiers.First()?.Sizes ?? SyntaxFactory.SeparatedList<ExpressionSyntax>();

            if (firstLevelSizes.OfType<ExpressionSyntax>().Any(s => s is OmittedArraySizeExpressionSyntax))
            {
                SetArraySizes(Initializer, firstLevelSizes.Count);
            }
            else
            {
                for (var sizeIndex = 0; sizeIndex < firstLevelSizes.Count; sizeIndex++)
                {
                    Create(cx, firstLevelSizes[sizeIndex], this, sizeIndex);
                }
                explicitlySized = true;
            }

            if (!(Initializer is null))
            {
                ArrayInitializer.Create(new ExpressionNodeInfo(cx, Initializer, this, -1));
            }

            if (explicitlySized)
                trapFile.explicitly_sized_array_creation(this);
        }

        private void SetArraySizes(InitializerExpressionSyntax initializer, int rank)
        {
            for (var level = 0; level < rank; level++)
            {
                if (initializer is null)
                {
                    return;
                }

                var info = new ExpressionInfo(
                    cx,
                    new AnnotatedType(Entities.Type.Create(cx, cx.Compilation.GetSpecialType(Microsoft.CodeAnalysis.SpecialType.System_Int32)), NullableAnnotation.None),
                    Location,
                    ExprKind.INT_LITERAL,
                    this,
                    level,
                    true,
                    initializer.Expressions.Count.ToString());

                new Expression(info);

                initializer = initializer.Expressions.FirstOrDefault() as InitializerExpressionSyntax;
            }
        }
    }

    internal class NormalArrayCreation : ExplicitArrayCreation<ArrayCreationExpressionSyntax>
    {
        private NormalArrayCreation(ExpressionNodeInfo info) : base(info) { }

        protected override ArrayTypeSyntax TypeSyntax => Syntax.Type;

        public override InitializerExpressionSyntax Initializer => Syntax.Initializer;

        public static Expression Create(ExpressionNodeInfo info) => new NormalArrayCreation(info).TryPopulate();
    }

    internal class StackAllocArrayCreation : ExplicitArrayCreation<StackAllocArrayCreationExpressionSyntax>
    {
        private StackAllocArrayCreation(ExpressionNodeInfo info) : base(info) { }

        protected override ArrayTypeSyntax TypeSyntax => Syntax.Type as ArrayTypeSyntax;

        public override InitializerExpressionSyntax Initializer => Syntax.Initializer;

        protected override void PopulateExpression(TextWriter trapFile)
        {
            base.PopulateExpression(trapFile);
            trapFile.stackalloc_array_creation(this);
        }

        public static Expression Create(ExpressionNodeInfo info) => new StackAllocArrayCreation(info).TryPopulate();
    }

    internal class ImplicitStackAllocArrayCreation : ArrayCreation<ImplicitStackAllocArrayCreationExpressionSyntax>
    {
        private ImplicitStackAllocArrayCreation(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.ARRAY_CREATION)) { }

        public static Expression Create(ExpressionNodeInfo info) => new ImplicitStackAllocArrayCreation(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            ArrayInitializer.Create(new ExpressionNodeInfo(cx, Syntax.Initializer, this, -1));
            trapFile.implicitly_typed_array_creation(this);
            trapFile.stackalloc_array_creation(this);
        }
    }

    internal class ImplicitArrayCreation : ArrayCreation<ImplicitArrayCreationExpressionSyntax>
    {
        private ImplicitArrayCreation(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.ARRAY_CREATION)) { }

        public static Expression Create(ExpressionNodeInfo info) => new ImplicitArrayCreation(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            if (Syntax.Initializer != null)
            {
                ArrayInitializer.Create(new ExpressionNodeInfo(cx, Syntax.Initializer, this, -1));
            }

            trapFile.implicitly_typed_array_creation(this);
        }
    }
}
