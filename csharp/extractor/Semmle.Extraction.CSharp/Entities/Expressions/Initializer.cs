using System.IO;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using Semmle.Util;
using Semmle.Extraction.Kinds;

namespace Semmle.Extraction.CSharp.Entities.Expressions
{
    internal abstract class Initializer : Expression<InitializerExpressionSyntax>
    {
        protected Initializer(ExpressionNodeInfo info) : base(info) { }
    }

    internal class ArrayInitializer : Initializer
    {
        private ArrayInitializer(ExpressionNodeInfo info) : base(info.SetType(null).SetKind(ExprKind.ARRAY_INIT)) { }

        public static Expression Create(ExpressionNodeInfo info) => new ArrayInitializer(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            var child = 0;
            foreach (var e in Syntax.Expressions)
            {
                if (e.Kind() == SyntaxKind.ArrayInitializerExpression)
                {
                    // Recursively create another array initializer
                    Create(new ExpressionNodeInfo(Context, (InitializerExpressionSyntax)e, this, child++));
                }
                else
                {
                    // Create the expression normally.
                    Create(Context, e, this, child++);
                }
            }
        }

        public static Expression CreateGenerated(Context cx, IExpressionParentEntity parent, int index, Location location)
        {
            var info = new ExpressionInfo(
                cx,
                null,
                location,
                ExprKind.ARRAY_INIT,
                parent,
                index,
                isCompilerGenerated: true,
                null);

            return new Expression(info);
        }
    }

    // Array initializer { ..., ... }.
    internal class ImplicitArrayInitializer : Initializer
    {
        private ImplicitArrayInitializer(ExpressionNodeInfo info) : base(info.SetKind(ExprKind.ARRAY_CREATION)) { }

        public static Expression Create(ExpressionNodeInfo info) => new ImplicitArrayInitializer(info).TryPopulate();

        protected override void PopulateExpression(TextWriter trapFile)
        {
            ArrayInitializer.Create(new ExpressionNodeInfo(Context, Syntax, this, -1));
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
                    var assignmentInfo = new ExpressionNodeInfo(Context, init, this, child++).SetKind(ExprKind.SIMPLE_ASSIGN);
                    var assignmentEntity = new Expression(assignmentInfo);
                    var typeInfoRight = Context.GetTypeInfo(assignment.Right);
                    if (typeInfoRight.Type is null)
                        // The type may be null for nested initializers such as
                        // ```csharp
                        // new ClassWithArrayField() { As = { [0] = a } }
                        // ```
                        // In this case we take the type from the assignment
                        // `As = { [0] = a }` instead
                        typeInfoRight = assignmentInfo.TypeInfo;
                    CreateFromNode(new ExpressionNodeInfo(Context, assignment.Right, assignmentEntity, 0, typeInfoRight));

                    var target = Context.GetSymbolInfo(assignment.Left);

                    // If the target is null, then assume that this is an array initializer (of the form `[...] = ...`)

                    var access = target.Symbol is null ?
                        new Expression(new ExpressionNodeInfo(Context, assignment.Left, assignmentEntity, 1).SetKind(ExprKind.ARRAY_ACCESS)) :
                        Access.Create(new ExpressionNodeInfo(Context, assignment.Left, assignmentEntity, 1), target.Symbol, false, Context.CreateEntity(target.Symbol));

                    if (assignment.Left is ImplicitElementAccessSyntax iea)
                    {
                        // An array/indexer initializer of the form `[...] = ...`
                        access.PopulateArguments(trapFile, iea.ArgumentList.Arguments, 0);
                    }
                }
                else
                {
                    Context.ModelError(init, "Unexpected object initialization");
                    Create(Context, init, this, child++);
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
                var collectionInfo = Context.GetModel(Syntax).GetCollectionInitializerSymbolInfo(i);
                var addMethod = Method.Create(Context, collectionInfo.Symbol as IMethodSymbol);
                var voidType = AnnotatedTypeSymbol.CreateNotAnnotated(Context.Compilation.GetSpecialType(SpecialType.System_Void));

                var invocation = new Expression(new ExpressionInfo(Context, voidType, Context.CreateLocation(i.GetLocation()), ExprKind.METHOD_INVOCATION, this, child++, isCompilerGenerated: true, null));

                if (addMethod is not null)
                    trapFile.expr_call(invocation, addMethod);
                else
                    Context.ModelError(Syntax, "Unable to find an Add() method for collection initializer");

                if (i.Kind() == SyntaxKind.ComplexElementInitializerExpression)
                {
                    // Arrays of the form new Foo { { 1,2 }, { 3, 4 } }
                    // where the arguments { 1, 2 } are passed to the Add() method.

                    var init = (InitializerExpressionSyntax)i;

                    init.Expressions.ForEach((arg, child) => Create(Context, arg, invocation, child));
                }
                else
                {
                    Create(Context, i, invocation, 0);
                }
            }
        }
    }
}
