using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;

using Semmle.Extraction.Entities;
using Semmle.Extraction.Kinds;
using System.IO;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    abstract class Initializer : Expression<InitializerExpressionSyntax>
    {
        protected Initializer(ExpressionNodeInfo info) : base(info) { }
    }

    class ArrayInitializer : Expression<InitializerExpressionSyntax>
    {
        ArrayInitializer(ExpressionNodeInfo info) : base(info.SetType(NullType.Create(info.Context)).SetKind(ExprKind.ARRAY_INIT)) { }

        public static Expression Create(ExpressionNodeInfo info) => new ArrayInitializer(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            var child = 0;
            foreach (var e in Syntax.Expressions)
            {
                if (e.Kind() == SyntaxKind.ArrayInitializerExpression)
                {
                    // Recursively create another array initializer
                    Create(new ExpressionNodeInfo(Cx, (InitializerExpressionSyntax)e, this, child++));
                }
                else
                {
                    // Create the expression normally.
                    Create(Cx, e, this, child++);
                }
            }
        }
    }

    // Array initializer { ..., ... }.
    class ImplicitArrayInitializer : Initializer
    {
        ImplicitArrayInitializer(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.ARRAY_CREATION)) { }

        public static Expression Create(ExpressionNodeInfo info) => new ImplicitArrayInitializer(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            ArrayInitializer.Create(new ExpressionNodeInfo(Cx, Syntax, this, -1));
            trapFile.implicitly_typed_array_creation(this);
        }
    }

    class ObjectInitializer : Initializer
    {
        ObjectInitializer(ExpressionNodeInfo info)
            : base(info.SetKind(ExprKind.OBJECT_INIT)) { }

        public static Expression Create(ExpressionNodeInfo info) => new ObjectInitializer(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            var child = 0;

            foreach (var init in Syntax.Expressions)
            {
                if (init is AssignmentExpressionSyntax assignment)
                {
                    var assignmentInfo = new ExpressionNodeInfo(Cx, init, this, child++).SetKind(ExprKind.SIMPLE_ASSIGN);
                    var assignmentEntity = new Expression(assignmentInfo);
                    var typeInfoRight = Cx.GetTypeInfo(assignment.Right);
                    if (typeInfoRight.Type is null)
                        // The type may be null for nested initializers such as
                        // ```csharp
                        // new ClassWithArrayField() { As = { [0] = a } }
                        // ```
                        // In this case we take the type from the assignment
                        // `As = { [0] = a }` instead
                        typeInfoRight = assignmentInfo.TypeInfo;
                    CreateFromNode(new ExpressionNodeInfo(Cx, assignment.Right, assignmentEntity, 0, typeInfoRight));

                    var target = Cx.GetSymbolInfo(assignment.Left);

                    // If the target is null, then assume that this is an array initializer (of the form `[...] = ...`)

                    var access = target.Symbol is null ?
                        new Expression(new ExpressionNodeInfo(Cx, assignment.Left, assignmentEntity, 1).SetKind(ExprKind.ARRAY_ACCESS)) :
                        Access.Create(new ExpressionNodeInfo(Cx, assignment.Left, assignmentEntity, 1), target.Symbol, false, Cx.CreateEntity(target.Symbol));

                    if (assignment.Left is ImplicitElementAccessSyntax iea)
                    {
                        // An array/indexer initializer of the form `[...] = ...`

                        var indexChild = 0;
                        foreach (var arg in iea.ArgumentList.Arguments)
                        {
                            Expression.Create(Cx, arg.Expression, access, indexChild++);
                        }
                    }
                }
                else
                {
                    Cx.ModelError(init, "Unexpected object initialization");
                    Create(Cx, init, this, child++);
                }
            }
        }
    }

    class CollectionInitializer : Initializer
    {
        CollectionInitializer(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.COLLECTION_INIT)) { }

        public static Expression Create(ExpressionNodeInfo info) => new CollectionInitializer(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            var child = 0;
            foreach (var i in Syntax.Expressions)
            {
                var collectionInfo = Cx.GetModel(Syntax).GetCollectionInitializerSymbolInfo(i);
                var addMethod = Method.Create(Cx, collectionInfo.Symbol as IMethodSymbol);
                var voidType = Entities.Type.Create(Cx, new AnnotatedTypeSymbol(Cx.Compilation.GetSpecialType(SpecialType.System_Void), NullableAnnotation.None));

                var invocation = new Expression(new ExpressionInfo(Cx, voidType, Cx.Create(i.GetLocation()), ExprKind.METHOD_INVOCATION, this, child++, false, null));

                if (addMethod != null)
                    trapFile.expr_call(invocation, addMethod);
                else
                    Cx.ModelError(Syntax, "Unable to find an Add() method for collection initializer");

                if (i.Kind() == SyntaxKind.ComplexElementInitializerExpression)
                {
                    // Arrays of the form new Foo { { 1,2 }, { 3, 4 } }
                    // where the arguments { 1, 2 } are passed to the Add() method.

                    var init = (InitializerExpressionSyntax)i;

                    var addChild = 0;
                    foreach (var arg in init.Expressions)
                    {
                        Create(Cx, arg, invocation, addChild++);
                    }
                }
                else
                {
                    Create(Cx, i, invocation, 0);
                }
            }
        }
    }
}
