// This file contains auto-generated code.
// Generated from `Remotion.Linq.EagerFetching, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`.
namespace Remotion
{
    namespace Linq
    {
        namespace EagerFetching
        {
            public class FetchFilteringQueryModelVisitor : Remotion.Linq.QueryModelVisitorBase
            {
                protected FetchFilteringQueryModelVisitor() => throw null;
                protected System.Collections.ObjectModel.ReadOnlyCollection<Remotion.Linq.EagerFetching.FetchQueryModelBuilder> FetchQueryModelBuilders { get => throw null; }
                public static Remotion.Linq.EagerFetching.FetchQueryModelBuilder[] RemoveFetchRequestsFromQueryModel(Remotion.Linq.QueryModel queryModel) => throw null;
                public override void VisitResultOperator(Remotion.Linq.Clauses.ResultOperatorBase resultOperator, Remotion.Linq.QueryModel queryModel, int index) => throw null;
            }
            public class FetchManyRequest : Remotion.Linq.EagerFetching.FetchRequestBase
            {
                public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public FetchManyRequest(System.Reflection.MemberInfo relationMember) : base(default(System.Reflection.MemberInfo)) => throw null;
                protected override void ModifyFetchQueryModel(Remotion.Linq.QueryModel fetchQueryModel) => throw null;
                public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
            }
            public class FetchOneRequest : Remotion.Linq.EagerFetching.FetchRequestBase
            {
                public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public FetchOneRequest(System.Reflection.MemberInfo relationMember) : base(default(System.Reflection.MemberInfo)) => throw null;
                protected override void ModifyFetchQueryModel(Remotion.Linq.QueryModel fetchQueryModel) => throw null;
                public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
            }
            public sealed class FetchQueryModelBuilder
            {
                public Remotion.Linq.EagerFetching.FetchQueryModelBuilder[] CreateInnerBuilders() => throw null;
                public FetchQueryModelBuilder(Remotion.Linq.EagerFetching.FetchRequestBase fetchRequest, Remotion.Linq.QueryModel queryModel, int resultOperatorPosition) => throw null;
                public Remotion.Linq.EagerFetching.FetchRequestBase FetchRequest { get => throw null; }
                public Remotion.Linq.QueryModel GetOrCreateFetchQueryModel() => throw null;
                public int ResultOperatorPosition { get => throw null; }
                public Remotion.Linq.QueryModel SourceItemQueryModel { get => throw null; }
            }
            public abstract class FetchRequestBase : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
            {
                public virtual Remotion.Linq.QueryModel CreateFetchQueryModel(Remotion.Linq.QueryModel sourceItemQueryModel) => throw null;
                protected FetchRequestBase(System.Reflection.MemberInfo relationMember) => throw null;
                public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                protected System.Linq.Expressions.Expression GetFetchedMemberExpression(System.Linq.Expressions.Expression source) => throw null;
                public Remotion.Linq.EagerFetching.FetchRequestBase GetOrAddInnerFetchRequest(Remotion.Linq.EagerFetching.FetchRequestBase fetchRequest) => throw null;
                public System.Collections.Generic.IEnumerable<Remotion.Linq.EagerFetching.FetchRequestBase> InnerFetchRequests { get => throw null; }
                protected abstract void ModifyFetchQueryModel(Remotion.Linq.QueryModel fetchQueryModel);
                public System.Reflection.MemberInfo RelationMember { get => throw null; set { } }
                public override string ToString() => throw null;
            }
            public sealed class FetchRequestCollection
            {
                public FetchRequestCollection() => throw null;
                public System.Collections.Generic.IEnumerable<Remotion.Linq.EagerFetching.FetchRequestBase> FetchRequests { get => throw null; }
                public Remotion.Linq.EagerFetching.FetchRequestBase GetOrAddFetchRequest(Remotion.Linq.EagerFetching.FetchRequestBase fetchRequest) => throw null;
            }
            namespace Parsing
            {
                public abstract class FetchExpressionNodeBase : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                {
                    protected FetchExpressionNodeBase(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression relatedObjectSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                    public System.Reflection.MemberInfo RelationMember { get => throw null; }
                    public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                }
                public class FetchManyExpressionNode : Remotion.Linq.EagerFetching.Parsing.OuterFetchExpressionNodeBase
                {
                    protected override Remotion.Linq.EagerFetching.FetchRequestBase CreateFetchRequest() => throw null;
                    public FetchManyExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression relatedObjectSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                }
                public class FetchOneExpressionNode : Remotion.Linq.EagerFetching.Parsing.OuterFetchExpressionNodeBase
                {
                    protected override Remotion.Linq.EagerFetching.FetchRequestBase CreateFetchRequest() => throw null;
                    public FetchOneExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression relatedObjectSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                }
                public abstract class OuterFetchExpressionNodeBase : Remotion.Linq.EagerFetching.Parsing.FetchExpressionNodeBase
                {
                    protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    protected abstract Remotion.Linq.EagerFetching.FetchRequestBase CreateFetchRequest();
                    protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    protected OuterFetchExpressionNodeBase(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression relatedObjectSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                }
                public abstract class ThenFetchExpressionNodeBase : Remotion.Linq.EagerFetching.Parsing.FetchExpressionNodeBase
                {
                    protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    protected abstract Remotion.Linq.EagerFetching.FetchRequestBase CreateFetchRequest();
                    protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    protected ThenFetchExpressionNodeBase(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression relatedObjectSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                }
                public class ThenFetchManyExpressionNode : Remotion.Linq.EagerFetching.Parsing.ThenFetchExpressionNodeBase
                {
                    protected override Remotion.Linq.EagerFetching.FetchRequestBase CreateFetchRequest() => throw null;
                    public ThenFetchManyExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression relatedObjectSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                }
                public class ThenFetchOneExpressionNode : Remotion.Linq.EagerFetching.Parsing.ThenFetchExpressionNodeBase
                {
                    protected override Remotion.Linq.EagerFetching.FetchRequestBase CreateFetchRequest() => throw null;
                    public ThenFetchOneExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression relatedObjectSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                }
            }
        }
    }
}
