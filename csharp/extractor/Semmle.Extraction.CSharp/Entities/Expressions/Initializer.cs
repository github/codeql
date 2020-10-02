using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Extraction.Entities;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal abstract class Initializer : Expression<InitializerExpressionSyntax>
    {
        protected Initializer(ExpressionNodeInfo info) : base(info) { }
    }

    internal class ArrayInitializer : Expression<InitializerExpressionSyntax>
    {
        private ArrayInitializer(ExpressionNodeInfo info) : base(info.SetType(NullType.Create(info.Context)).SetKind(ExprKind.ARRAY_INIT)) { }

        public static Expression Create(ExpressionNodeInfo info) => new ArrayInitializer(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            var child = 0;
            foreach (var e in Syntax.Expressions)
            {
                if (e.Kind() == SyntaxKind.ArrayInitializerExpression)
                {
                    // Recursively create another array initializer
                    Create(new ExpressionNodeInfo(cx, (InitializerExpressionSyntax)e, this, child++));
                }
                else
                {
                    // Create the expression normally.
                    Create(cx, e, this, child++);
                }
            }
        }
    }

    // Array initializer { ..., ... }.
    internal class ImplicitArrayInitializer : Initializer
    {
        private ImplicitArrayInitializer(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.ARRAY_CREATION)) { }

        public static Expression Create(ExpressionNodeInfo info) => new ImplicitArrayInitializer(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            ArrayInitializer.Create(new ExpressionNodeInfo(cx, Syntax, this, -1));
            trapFile.implicitly_typed_array_creation(this);
        }
    }

    internal class ObjectInitializer : Initializer
    {
        private ObjectInitializer(ExpressionNodeInfo info)
            : base(info.SetKind(ExprKind.OBJECT_INIT)) { }

        public static Expression Create(ExpressionNodeInfo info) => new ObjectInitializer(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            var child = 0;

            foreach (var init in Syntax.Expressions)
            {
                if (init is AssignmentExpressionSyntax assignment)
                {
                    var assignmentInfo = new ExpressionNodeInfo(cx, init, this, child++).SetKind(ExprKind.SIMPLE_ASSIGN);
                    var assignmentEntity = new Expression(assignmentInfo);
                    var typeInfoRight = cx.GetTypeInfo(assignment.Right);
                    if (typeInfoRight.Type is null)
                        // The type may be null for nested initializers such as
                        // ```csharp
                        // new ClassWithArrayField() { As = { [0] = a } }
                        // ```
                        // In this case we take the type from the assignment
                        // `As = { [0] = a }` instead
                        typeInfoRight = assignmentInfo.TypeInfo;
                    CreateFromNode(new ExpressionNodeInfo(cx, assignment.Right, assignmentEntity, 0, typeInfoRight));

                    var target = cx.GetSymbolInfo(assignment.Left);

                    // If the target is null, then assume that this is an array initializer (of the form `[...] = ...`)

                    var access = target.Symbol is null ?
                        new Expression(new ExpressionNodeInfo(cx, assignment.Left, assignmentEntity, 1).SetKind(ExprKind.ARRAY_ACCESS)) :
                        Access.Create(new ExpressionNodeInfo(cx, assignment.Left, assignmentEntity, 1), target.Symbol, false, cx.CreateEntity(target.Symbol));

                    if (assignment.Left is ImplicitElementAccessSyntax iea)
                    {
                        // An array/indexer initializer of the form `[...] = ...`

                        var indexChild = 0;
                        foreach (var arg in iea.ArgumentList.Arguments)
                        {
                            Expression.Create(cx, arg.Expression, access, indexChild++);
                        }
                    }
                }
                else
                {
                    cx.ModelError(init, "Unexpected object initialization");
                    Create(cx, init, this, child++);
                }
            }
        }
    }

    internal class CollectionInitializer : Initializer
    {
        private CollectionInitializer(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.COLLECTION_INIT)) { }

        public static Expression Create(ExpressionNodeInfo info) => new CollectionInitializer(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            var child = 0;
            foreach (var i in Syntax.Expressions)
            {
                var collectionInfo = cx.GetModel(Syntax).GetCollectionInitializerSymbolInfo(i);
                var addMethod = Method.Create(cx, collectionInfo.Symbol as IMethodSymbol);
                var voidType = Entities.Type.Create(cx, new AnnotatedTypeSymbol(cx.Compilation.GetSpecialType(SpecialType.System_Void), NullableAnnotation.None));

                var invocation = new Expression(new ExpressionInfo(cx, voidType, cx.Create(i.GetLocation()), ExprKind.METHOD_INVOCATION, this, child++, false, null));

                if (addMethod != null)
                    trapFile.expr_call(invocation, addMethod);
                else
                    cx.ModelError(Syntax, "Unable to find an Add() method for collection initializer");

                if (i.Kind() == SyntaxKind.ComplexElementInitializerExpression)
                {
                    // Arrays of the form new Foo { { 1,2 }, { 3, 4 } }
                    // where the arguments { 1, 2 } are passed to the Add() method.

                    var init = (InitializerExpressionSyntax)i;

                    var addChild = 0;
                    foreach (var arg in init.Expressions)
                    {
                        Create(cx, arg, invocation, addChild++);
                    }
                }
                else
                {
                    Create(cx, i, invocation, 0);
                }
            }
        }
    }
}
