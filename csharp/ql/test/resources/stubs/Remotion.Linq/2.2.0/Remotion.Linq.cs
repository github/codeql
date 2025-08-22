// This file contains auto-generated code.
// Generated from `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`.
namespace Remotion
{
    namespace Linq
    {
        namespace Clauses
        {
            public sealed class AdditionalFromClause : Remotion.Linq.Clauses.FromClauseBase, Remotion.Linq.Clauses.IBodyClause, Remotion.Linq.Clauses.IClause
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, int index) => throw null;
                public Remotion.Linq.Clauses.AdditionalFromClause Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                Remotion.Linq.Clauses.IBodyClause Remotion.Linq.Clauses.IBodyClause.Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public AdditionalFromClause(string itemName, System.Type itemType, System.Linq.Expressions.Expression fromExpression) => throw null;
            }
            public sealed class CloneContext
            {
                public CloneContext(Remotion.Linq.Clauses.QuerySourceMapping querySourceMapping) => throw null;
                public Remotion.Linq.Clauses.QuerySourceMapping QuerySourceMapping { get => throw null; }
            }
            namespace Expressions
            {
                public interface IPartialEvaluationExceptionExpressionVisitor
                {
                    System.Linq.Expressions.Expression VisitPartialEvaluationException(Remotion.Linq.Clauses.Expressions.PartialEvaluationExceptionExpression partialEvaluationExceptionExpression);
                }
                public interface IVBSpecificExpressionVisitor
                {
                    System.Linq.Expressions.Expression VisitVBStringComparison(Remotion.Linq.Clauses.Expressions.VBStringComparisonExpression vbStringComparisonExpression);
                }
                public sealed class PartialEvaluationExceptionExpression : System.Linq.Expressions.Expression
                {
                    protected override System.Linq.Expressions.Expression Accept(System.Linq.Expressions.ExpressionVisitor visitor) => throw null;
                    public override bool CanReduce { get => throw null; }
                    public PartialEvaluationExceptionExpression(System.Exception exception, System.Linq.Expressions.Expression evaluatedExpression) => throw null;
                    public System.Linq.Expressions.Expression EvaluatedExpression { get => throw null; }
                    public System.Exception Exception { get => throw null; }
                    public override System.Linq.Expressions.ExpressionType NodeType { get => throw null; }
                    public override System.Linq.Expressions.Expression Reduce() => throw null;
                    public override string ToString() => throw null;
                    public override System.Type Type { get => throw null; }
                    protected override System.Linq.Expressions.Expression VisitChildren(System.Linq.Expressions.ExpressionVisitor visitor) => throw null;
                }
                public sealed class QuerySourceReferenceExpression : System.Linq.Expressions.Expression
                {
                    protected override System.Linq.Expressions.Expression Accept(System.Linq.Expressions.ExpressionVisitor visitor) => throw null;
                    public QuerySourceReferenceExpression(Remotion.Linq.Clauses.IQuerySource querySource) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public override System.Linq.Expressions.ExpressionType NodeType { get => throw null; }
                    public Remotion.Linq.Clauses.IQuerySource ReferencedQuerySource { get => throw null; }
                    public override string ToString() => throw null;
                    public override System.Type Type { get => throw null; }
                }
                public sealed class SubQueryExpression : System.Linq.Expressions.Expression
                {
                    protected override System.Linq.Expressions.Expression Accept(System.Linq.Expressions.ExpressionVisitor visitor) => throw null;
                    public SubQueryExpression(Remotion.Linq.QueryModel queryModel) => throw null;
                    public override System.Linq.Expressions.ExpressionType NodeType { get => throw null; }
                    public Remotion.Linq.QueryModel QueryModel { get => throw null; }
                    public override string ToString() => throw null;
                    public override System.Type Type { get => throw null; }
                }
                public sealed class VBStringComparisonExpression : System.Linq.Expressions.Expression
                {
                    protected override System.Linq.Expressions.Expression Accept(System.Linq.Expressions.ExpressionVisitor visitor) => throw null;
                    public override bool CanReduce { get => throw null; }
                    public System.Linq.Expressions.Expression Comparison { get => throw null; }
                    public VBStringComparisonExpression(System.Linq.Expressions.Expression comparison, bool textCompare) => throw null;
                    public override System.Linq.Expressions.ExpressionType NodeType { get => throw null; }
                    public override System.Linq.Expressions.Expression Reduce() => throw null;
                    public bool TextCompare { get => throw null; }
                    public override string ToString() => throw null;
                    public override System.Type Type { get => throw null; }
                    protected override System.Linq.Expressions.Expression VisitChildren(System.Linq.Expressions.ExpressionVisitor visitor) => throw null;
                }
            }
            namespace ExpressionVisitors
            {
                public sealed class AccessorFindingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.LambdaExpression FindAccessorLambda(System.Linq.Expressions.Expression searchedExpression, System.Linq.Expressions.Expression fullExpression, System.Linq.Expressions.ParameterExpression inputParameter) => throw null;
                    public override System.Linq.Expressions.Expression Visit(System.Linq.Expressions.Expression expression) => throw null;
                    protected override System.Linq.Expressions.MemberAssignment VisitMemberAssignment(System.Linq.Expressions.MemberAssignment memberAssigment) => throw null;
                    protected override System.Linq.Expressions.MemberBinding VisitMemberBinding(System.Linq.Expressions.MemberBinding memberBinding) => throw null;
                    protected override System.Linq.Expressions.Expression VisitNew(System.Linq.Expressions.NewExpression expression) => throw null;
                    protected override System.Linq.Expressions.Expression VisitUnary(System.Linq.Expressions.UnaryExpression expression) => throw null;
                }
                public sealed class CloningExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.Expression AdjustExpressionAfterCloning(System.Linq.Expressions.Expression expression, Remotion.Linq.Clauses.QuerySourceMapping querySourceMapping) => throw null;
                    protected override System.Linq.Expressions.Expression VisitQuerySourceReference(Remotion.Linq.Clauses.Expressions.QuerySourceReferenceExpression expression) => throw null;
                    protected override System.Linq.Expressions.Expression VisitSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression expression) => throw null;
                }
                public sealed class ReferenceReplacingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.Expression ReplaceClauseReferences(System.Linq.Expressions.Expression expression, Remotion.Linq.Clauses.QuerySourceMapping querySourceMapping, bool throwOnUnmappedReferences) => throw null;
                    protected override System.Linq.Expressions.Expression VisitQuerySourceReference(Remotion.Linq.Clauses.Expressions.QuerySourceReferenceExpression expression) => throw null;
                    protected override System.Linq.Expressions.Expression VisitSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression expression) => throw null;
                }
                public sealed class ReverseResolvingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.LambdaExpression ReverseResolve(System.Linq.Expressions.Expression itemExpression, System.Linq.Expressions.Expression resolvedExpression) => throw null;
                    public static System.Linq.Expressions.LambdaExpression ReverseResolveLambda(System.Linq.Expressions.Expression itemExpression, System.Linq.Expressions.LambdaExpression resolvedExpression, int parameterInsertionPosition) => throw null;
                    protected override System.Linq.Expressions.Expression VisitQuerySourceReference(Remotion.Linq.Clauses.Expressions.QuerySourceReferenceExpression expression) => throw null;
                }
            }
            public abstract class FromClauseBase : Remotion.Linq.Clauses.IClause, Remotion.Linq.Clauses.IFromClause, Remotion.Linq.Clauses.IQuerySource
            {
                public virtual void CopyFromSource(Remotion.Linq.Clauses.IFromClause source) => throw null;
                public System.Linq.Expressions.Expression FromExpression { get => throw null; set { } }
                public string ItemName { get => throw null; set { } }
                public System.Type ItemType { get => throw null; set { } }
                public override string ToString() => throw null;
                public virtual void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
            }
            public sealed class GroupJoinClause : Remotion.Linq.Clauses.IBodyClause, Remotion.Linq.Clauses.IClause, Remotion.Linq.Clauses.IQuerySource
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, int index) => throw null;
                public Remotion.Linq.Clauses.GroupJoinClause Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                Remotion.Linq.Clauses.IBodyClause Remotion.Linq.Clauses.IBodyClause.Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public GroupJoinClause(string itemName, System.Type itemType, Remotion.Linq.Clauses.JoinClause joinClause) => throw null;
                public string ItemName { get => throw null; set { } }
                public System.Type ItemType { get => throw null; set { } }
                public Remotion.Linq.Clauses.JoinClause JoinClause { get => throw null; set { } }
                public override string ToString() => throw null;
                public void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
            }
            public interface IBodyClause : Remotion.Linq.Clauses.IClause
            {
                void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, int index);
                Remotion.Linq.Clauses.IBodyClause Clone(Remotion.Linq.Clauses.CloneContext cloneContext);
            }
            public interface IClause
            {
                void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation);
            }
            public interface IFromClause : Remotion.Linq.Clauses.IClause, Remotion.Linq.Clauses.IQuerySource
            {
                void CopyFromSource(Remotion.Linq.Clauses.IFromClause source);
                System.Linq.Expressions.Expression FromExpression { get; }
            }
            public interface IQuerySource
            {
                string ItemName { get; }
                System.Type ItemType { get; }
            }
            public sealed class JoinClause : Remotion.Linq.Clauses.IBodyClause, Remotion.Linq.Clauses.IClause, Remotion.Linq.Clauses.IQuerySource
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, int index) => throw null;
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, Remotion.Linq.Clauses.GroupJoinClause groupJoinClause) => throw null;
                public Remotion.Linq.Clauses.JoinClause Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                Remotion.Linq.Clauses.IBodyClause Remotion.Linq.Clauses.IBodyClause.Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public JoinClause(string itemName, System.Type itemType, System.Linq.Expressions.Expression innerSequence, System.Linq.Expressions.Expression outerKeySelector, System.Linq.Expressions.Expression innerKeySelector) => throw null;
                public System.Linq.Expressions.Expression InnerKeySelector { get => throw null; set { } }
                public System.Linq.Expressions.Expression InnerSequence { get => throw null; set { } }
                public string ItemName { get => throw null; set { } }
                public System.Type ItemType { get => throw null; set { } }
                public System.Linq.Expressions.Expression OuterKeySelector { get => throw null; set { } }
                public override string ToString() => throw null;
                public void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
            }
            public sealed class MainFromClause : Remotion.Linq.Clauses.FromClauseBase
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel) => throw null;
                public Remotion.Linq.Clauses.MainFromClause Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public MainFromClause(string itemName, System.Type itemType, System.Linq.Expressions.Expression fromExpression) => throw null;
            }
            public sealed class OrderByClause : Remotion.Linq.Clauses.IBodyClause, Remotion.Linq.Clauses.IClause
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, int index) => throw null;
                public Remotion.Linq.Clauses.OrderByClause Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                Remotion.Linq.Clauses.IBodyClause Remotion.Linq.Clauses.IBodyClause.Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public OrderByClause() => throw null;
                public System.Collections.ObjectModel.ObservableCollection<Remotion.Linq.Clauses.Ordering> Orderings { get => throw null; }
                public override string ToString() => throw null;
                public void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
            }
            public sealed class Ordering
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, Remotion.Linq.Clauses.OrderByClause orderByClause, int index) => throw null;
                public Remotion.Linq.Clauses.Ordering Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public Ordering(System.Linq.Expressions.Expression expression, Remotion.Linq.Clauses.OrderingDirection direction) => throw null;
                public System.Linq.Expressions.Expression Expression { get => throw null; set { } }
                public Remotion.Linq.Clauses.OrderingDirection OrderingDirection { get => throw null; set { } }
                public override string ToString() => throw null;
                public void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
            }
            public enum OrderingDirection
            {
                Asc = 0,
                Desc = 1,
            }
            public sealed class QuerySourceMapping
            {
                public void AddMapping(Remotion.Linq.Clauses.IQuerySource querySource, System.Linq.Expressions.Expression expression) => throw null;
                public bool ContainsMapping(Remotion.Linq.Clauses.IQuerySource querySource) => throw null;
                public QuerySourceMapping() => throw null;
                public System.Linq.Expressions.Expression GetExpression(Remotion.Linq.Clauses.IQuerySource querySource) => throw null;
                public void RemoveMapping(Remotion.Linq.Clauses.IQuerySource querySource) => throw null;
                public void ReplaceMapping(Remotion.Linq.Clauses.IQuerySource querySource, System.Linq.Expressions.Expression expression) => throw null;
            }
            public abstract class ResultOperatorBase
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, int index) => throw null;
                protected void CheckSequenceItemType(Remotion.Linq.Clauses.StreamedData.StreamedSequenceInfo inputInfo, System.Type expectedItemType) => throw null;
                public abstract Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext);
                protected ResultOperatorBase() => throw null;
                public abstract Remotion.Linq.Clauses.StreamedData.IStreamedData ExecuteInMemory(Remotion.Linq.Clauses.StreamedData.IStreamedData input);
                protected T GetConstantValueFromExpression<T>(string expressionName, System.Linq.Expressions.Expression expression) => throw null;
                public abstract Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo);
                protected object InvokeExecuteMethod(System.Reflection.MethodInfo method, object input) => throw null;
                public abstract void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation);
            }
            namespace ResultOperators
            {
                public sealed class AggregateFromSeedResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public AggregateFromSeedResultOperator(System.Linq.Expressions.Expression seed, System.Linq.Expressions.LambdaExpression func, System.Linq.Expressions.LambdaExpression optionalResultSelector) => throw null;
                    public Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteAggregateInMemory<TInput, TAggregate, TResult>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<TInput>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public System.Linq.Expressions.LambdaExpression Func { get => throw null; set { } }
                    public T GetConstantSeed<T>() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public System.Linq.Expressions.LambdaExpression OptionalResultSelector { get => throw null; set { } }
                    public System.Linq.Expressions.Expression Seed { get => throw null; set { } }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class AggregateResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public AggregateResultOperator(System.Linq.Expressions.LambdaExpression func) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public System.Linq.Expressions.LambdaExpression Func { get => throw null; set { } }
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class AllResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public AllResultOperator(System.Linq.Expressions.Expression predicate) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public System.Linq.Expressions.Expression Predicate { get => throw null; set { } }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class AnyResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public AnyResultOperator() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class AsQueryableResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public AsQueryableResultOperator() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public interface ISupportedByIQueryModelVistor
                    {
                    }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class AverageResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public AverageResultOperator() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class CastResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceFromSequenceResultOperatorBase
                {
                    public System.Type CastItemType { get => throw null; set { } }
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public CastResultOperator(System.Type castItemType) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<TInput>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public abstract class ChoiceResultOperatorBase : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    protected ChoiceResultOperatorBase(bool returnDefaultWhenEmpty) => throw null;
                    public override sealed Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    protected Remotion.Linq.Clauses.StreamedData.StreamedValueInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.StreamedSequenceInfo inputSequenceInfo) => throw null;
                    public bool ReturnDefaultWhenEmpty { get => throw null; set { } }
                }
                public sealed class ConcatResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceFromSequenceResultOperatorBase, Remotion.Linq.Clauses.IQuerySource
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public ConcatResultOperator(string itemName, System.Type itemType, System.Linq.Expressions.Expression source2) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public System.Collections.IEnumerable GetConstantSource2() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public string ItemName { get => throw null; set { } }
                    public System.Type ItemType { get => throw null; set { } }
                    public System.Linq.Expressions.Expression Source2 { get => throw null; set { } }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class ContainsResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public ContainsResultOperator(System.Linq.Expressions.Expression item) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public T GetConstantItem<T>() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public System.Linq.Expressions.Expression Item { get => throw null; set { } }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class CountResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public CountResultOperator() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class DefaultIfEmptyResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public DefaultIfEmptyResultOperator(System.Linq.Expressions.Expression optionalDefaultValue) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public object GetConstantOptionalDefaultValue() => throw null;
                    public System.Linq.Expressions.Expression OptionalDefaultValue { get => throw null; set { } }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class DistinctResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public DistinctResultOperator() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class ExceptResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public ExceptResultOperator(System.Linq.Expressions.Expression source2) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public System.Collections.Generic.IEnumerable<T> GetConstantSource2<T>() => throw null;
                    public System.Linq.Expressions.Expression Source2 { get => throw null; set { } }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class FirstResultOperator : Remotion.Linq.Clauses.ResultOperators.ChoiceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public FirstResultOperator(bool returnDefaultWhenEmpty) : base(default(bool)) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class GroupResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceFromSequenceResultOperatorBase, Remotion.Linq.Clauses.IQuerySource
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public GroupResultOperator(string itemName, System.Linq.Expressions.Expression keySelector, System.Linq.Expressions.Expression elementSelector) => throw null;
                    public System.Linq.Expressions.Expression ElementSelector { get => throw null; set { } }
                    public Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteGroupingInMemory<TSource, TKey, TElement>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<TInput>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public string ItemName { get => throw null; set { } }
                    public System.Type ItemType { get => throw null; }
                    public System.Linq.Expressions.Expression KeySelector { get => throw null; set { } }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class IntersectResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public IntersectResultOperator(System.Linq.Expressions.Expression source2) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public System.Collections.Generic.IEnumerable<T> GetConstantSource2<T>() => throw null;
                    public System.Linq.Expressions.Expression Source2 { get => throw null; set { } }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class LastResultOperator : Remotion.Linq.Clauses.ResultOperators.ChoiceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public LastResultOperator(bool returnDefaultWhenEmpty) : base(default(bool)) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class LongCountResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public LongCountResultOperator() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class MaxResultOperator : Remotion.Linq.Clauses.ResultOperators.ChoiceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public MaxResultOperator() : base(default(bool)) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class MinResultOperator : Remotion.Linq.Clauses.ResultOperators.ChoiceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public MinResultOperator() : base(default(bool)) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class OfTypeResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceFromSequenceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public OfTypeResultOperator(System.Type searchedItemType) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<TInput>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public System.Type SearchedItemType { get => throw null; set { } }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class ReverseResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public ReverseResultOperator() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public abstract class SequenceFromSequenceResultOperatorBase : Remotion.Linq.Clauses.ResultOperatorBase
                {
                    protected SequenceFromSequenceResultOperatorBase() => throw null;
                    public abstract Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input);
                    public override sealed Remotion.Linq.Clauses.StreamedData.IStreamedData ExecuteInMemory(Remotion.Linq.Clauses.StreamedData.IStreamedData input) => throw null;
                }
                public abstract class SequenceTypePreservingResultOperatorBase : Remotion.Linq.Clauses.ResultOperators.SequenceFromSequenceResultOperatorBase
                {
                    protected SequenceTypePreservingResultOperatorBase() => throw null;
                    public override sealed Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    protected Remotion.Linq.Clauses.StreamedData.StreamedSequenceInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.StreamedSequenceInfo inputSequenceInfo) => throw null;
                }
                public sealed class SingleResultOperator : Remotion.Linq.Clauses.ResultOperators.ChoiceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public SingleResultOperator(bool returnDefaultWhenEmpty) : base(default(bool)) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class SkipResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public System.Linq.Expressions.Expression Count { get => throw null; set { } }
                    public SkipResultOperator(System.Linq.Expressions.Expression count) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public int GetConstantCount() => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class SumResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public SumResultOperator() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class TakeResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public System.Linq.Expressions.Expression Count { get => throw null; set { } }
                    public TakeResultOperator(System.Linq.Expressions.Expression count) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public int GetConstantCount() => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public sealed class UnionResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceFromSequenceResultOperatorBase, Remotion.Linq.Clauses.IQuerySource
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public UnionResultOperator(string itemName, System.Type itemType, System.Linq.Expressions.Expression source2) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public System.Collections.IEnumerable GetConstantSource2() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public string ItemName { get => throw null; set { } }
                    public System.Type ItemType { get => throw null; set { } }
                    public System.Linq.Expressions.Expression Source2 { get => throw null; set { } }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }
                public abstract class ValueFromSequenceResultOperatorBase : Remotion.Linq.Clauses.ResultOperatorBase
                {
                    protected ValueFromSequenceResultOperatorBase() => throw null;
                    public abstract Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence sequence);
                    public override sealed Remotion.Linq.Clauses.StreamedData.IStreamedData ExecuteInMemory(Remotion.Linq.Clauses.StreamedData.IStreamedData input) => throw null;
                }
            }
            public sealed class SelectClause : Remotion.Linq.Clauses.IClause
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel) => throw null;
                public Remotion.Linq.Clauses.SelectClause Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public SelectClause(System.Linq.Expressions.Expression selector) => throw null;
                public Remotion.Linq.Clauses.StreamedData.StreamedSequenceInfo GetOutputDataInfo() => throw null;
                public System.Linq.Expressions.Expression Selector { get => throw null; set { } }
                public override string ToString() => throw null;
                public void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
            }
            namespace StreamedData
            {
                public interface IStreamedData
                {
                    Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo DataInfo { get; }
                    object Value { get; }
                }
                public interface IStreamedDataInfo : System.IEquatable<Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo>
                {
                    Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo AdjustDataType(System.Type dataType);
                    System.Type DataType { get; }
                    Remotion.Linq.Clauses.StreamedData.IStreamedData ExecuteQueryModel(Remotion.Linq.QueryModel queryModel, Remotion.Linq.IQueryExecutor executor);
                }
                public sealed class StreamedScalarValueInfo : Remotion.Linq.Clauses.StreamedData.StreamedValueInfo
                {
                    protected override Remotion.Linq.Clauses.StreamedData.StreamedValueInfo CloneWithNewDataType(System.Type dataType) => throw null;
                    public StreamedScalarValueInfo(System.Type dataType) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedData ExecuteQueryModel(Remotion.Linq.QueryModel queryModel, Remotion.Linq.IQueryExecutor executor) => throw null;
                    public object ExecuteScalarQueryModel<T>(Remotion.Linq.QueryModel queryModel, Remotion.Linq.IQueryExecutor executor) => throw null;
                }
                public sealed class StreamedSequence : Remotion.Linq.Clauses.StreamedData.IStreamedData
                {
                    public StreamedSequence(System.Collections.IEnumerable sequence, Remotion.Linq.Clauses.StreamedData.StreamedSequenceInfo streamedSequenceInfo) => throw null;
                    public Remotion.Linq.Clauses.StreamedData.StreamedSequenceInfo DataInfo { get => throw null; }
                    Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo Remotion.Linq.Clauses.StreamedData.IStreamedData.DataInfo { get => throw null; }
                    public System.Collections.Generic.IEnumerable<T> GetTypedSequence<T>() => throw null;
                    public System.Collections.IEnumerable Sequence { get => throw null; }
                    object Remotion.Linq.Clauses.StreamedData.IStreamedData.Value { get => throw null; }
                }
                public sealed class StreamedSequenceInfo : System.IEquatable<Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo>, Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo
                {
                    public Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo AdjustDataType(System.Type dataType) => throw null;
                    public StreamedSequenceInfo(System.Type dataType, System.Linq.Expressions.Expression itemExpression) => throw null;
                    public System.Type DataType { get => throw null; }
                    public override sealed bool Equals(object obj) => throw null;
                    public bool Equals(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo obj) => throw null;
                    public System.Collections.IEnumerable ExecuteCollectionQueryModel<T>(Remotion.Linq.QueryModel queryModel, Remotion.Linq.IQueryExecutor executor) => throw null;
                    public Remotion.Linq.Clauses.StreamedData.IStreamedData ExecuteQueryModel(Remotion.Linq.QueryModel queryModel, Remotion.Linq.IQueryExecutor executor) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Linq.Expressions.Expression ItemExpression { get => throw null; }
                    public System.Type ResultItemType { get => throw null; }
                }
                public sealed class StreamedSingleValueInfo : Remotion.Linq.Clauses.StreamedData.StreamedValueInfo
                {
                    protected override Remotion.Linq.Clauses.StreamedData.StreamedValueInfo CloneWithNewDataType(System.Type dataType) => throw null;
                    public StreamedSingleValueInfo(System.Type dataType, bool returnDefaultWhenEmpty) => throw null;
                    public override bool Equals(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo obj) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedData ExecuteQueryModel(Remotion.Linq.QueryModel queryModel, Remotion.Linq.IQueryExecutor executor) => throw null;
                    public object ExecuteSingleQueryModel<T>(Remotion.Linq.QueryModel queryModel, Remotion.Linq.IQueryExecutor executor) => throw null;
                    public override int GetHashCode() => throw null;
                    public bool ReturnDefaultWhenEmpty { get => throw null; }
                }
                public sealed class StreamedValue : Remotion.Linq.Clauses.StreamedData.IStreamedData
                {
                    public StreamedValue(object value, Remotion.Linq.Clauses.StreamedData.StreamedValueInfo streamedValueInfo) => throw null;
                    public Remotion.Linq.Clauses.StreamedData.StreamedValueInfo DataInfo { get => throw null; }
                    Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo Remotion.Linq.Clauses.StreamedData.IStreamedData.DataInfo { get => throw null; }
                    public T GetTypedValue<T>() => throw null;
                    public object Value { get => throw null; }
                }
                public abstract class StreamedValueInfo : System.IEquatable<Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo>, Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo
                {
                    public virtual Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo AdjustDataType(System.Type dataType) => throw null;
                    protected abstract Remotion.Linq.Clauses.StreamedData.StreamedValueInfo CloneWithNewDataType(System.Type dataType);
                    public System.Type DataType { get => throw null; }
                    public override sealed bool Equals(object obj) => throw null;
                    public virtual bool Equals(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo obj) => throw null;
                    public abstract Remotion.Linq.Clauses.StreamedData.IStreamedData ExecuteQueryModel(Remotion.Linq.QueryModel queryModel, Remotion.Linq.IQueryExecutor executor);
                    public override int GetHashCode() => throw null;
                }
            }
            public sealed class WhereClause : Remotion.Linq.Clauses.IBodyClause, Remotion.Linq.Clauses.IClause
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, int index) => throw null;
                public Remotion.Linq.Clauses.WhereClause Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                Remotion.Linq.Clauses.IBodyClause Remotion.Linq.Clauses.IBodyClause.Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public WhereClause(System.Linq.Expressions.Expression predicate) => throw null;
                public System.Linq.Expressions.Expression Predicate { get => throw null; set { } }
                public override string ToString() => throw null;
                public void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
            }
        }
        public sealed class DefaultQueryProvider : Remotion.Linq.QueryProviderBase
        {
            public override System.Linq.IQueryable<T> CreateQuery<T>(System.Linq.Expressions.Expression expression) => throw null;
            public DefaultQueryProvider(System.Type queryableType, Remotion.Linq.Parsing.Structure.IQueryParser queryParser, Remotion.Linq.IQueryExecutor executor) : base(default(Remotion.Linq.Parsing.Structure.IQueryParser), default(Remotion.Linq.IQueryExecutor)) => throw null;
            public System.Type QueryableType { get => throw null; }
        }
        public interface IQueryExecutor
        {
            System.Collections.Generic.IEnumerable<T> ExecuteCollection<T>(Remotion.Linq.QueryModel queryModel);
            T ExecuteScalar<T>(Remotion.Linq.QueryModel queryModel);
            T ExecuteSingle<T>(Remotion.Linq.QueryModel queryModel, bool returnDefaultWhenEmpty);
        }
        public interface IQueryModelVisitor
        {
            void VisitAdditionalFromClause(Remotion.Linq.Clauses.AdditionalFromClause fromClause, Remotion.Linq.QueryModel queryModel, int index);
            void VisitGroupJoinClause(Remotion.Linq.Clauses.GroupJoinClause joinClause, Remotion.Linq.QueryModel queryModel, int index);
            void VisitJoinClause(Remotion.Linq.Clauses.JoinClause joinClause, Remotion.Linq.QueryModel queryModel, int index);
            void VisitJoinClause(Remotion.Linq.Clauses.JoinClause joinClause, Remotion.Linq.QueryModel queryModel, Remotion.Linq.Clauses.GroupJoinClause groupJoinClause);
            void VisitMainFromClause(Remotion.Linq.Clauses.MainFromClause fromClause, Remotion.Linq.QueryModel queryModel);
            void VisitOrderByClause(Remotion.Linq.Clauses.OrderByClause orderByClause, Remotion.Linq.QueryModel queryModel, int index);
            void VisitOrdering(Remotion.Linq.Clauses.Ordering ordering, Remotion.Linq.QueryModel queryModel, Remotion.Linq.Clauses.OrderByClause orderByClause, int index);
            void VisitQueryModel(Remotion.Linq.QueryModel queryModel);
            void VisitResultOperator(Remotion.Linq.Clauses.ResultOperatorBase resultOperator, Remotion.Linq.QueryModel queryModel, int index);
            void VisitSelectClause(Remotion.Linq.Clauses.SelectClause selectClause, Remotion.Linq.QueryModel queryModel);
            void VisitWhereClause(Remotion.Linq.Clauses.WhereClause whereClause, Remotion.Linq.QueryModel queryModel, int index);
        }
        namespace Parsing
        {
            namespace ExpressionVisitors
            {
                namespace MemberBindings
                {
                    public class FieldInfoBinding : Remotion.Linq.Parsing.ExpressionVisitors.MemberBindings.MemberBinding
                    {
                        public FieldInfoBinding(System.Reflection.FieldInfo boundMember, System.Linq.Expressions.Expression associatedExpression) : base(default(System.Reflection.MemberInfo), default(System.Linq.Expressions.Expression)) => throw null;
                        public override bool MatchesReadAccess(System.Reflection.MemberInfo member) => throw null;
                    }
                    public abstract class MemberBinding
                    {
                        public System.Linq.Expressions.Expression AssociatedExpression { get => throw null; }
                        public static Remotion.Linq.Parsing.ExpressionVisitors.MemberBindings.MemberBinding Bind(System.Reflection.MemberInfo boundMember, System.Linq.Expressions.Expression associatedExpression) => throw null;
                        public System.Reflection.MemberInfo BoundMember { get => throw null; }
                        public MemberBinding(System.Reflection.MemberInfo boundMember, System.Linq.Expressions.Expression associatedExpression) => throw null;
                        public abstract bool MatchesReadAccess(System.Reflection.MemberInfo member);
                    }
                    public class MethodInfoBinding : Remotion.Linq.Parsing.ExpressionVisitors.MemberBindings.MemberBinding
                    {
                        public MethodInfoBinding(System.Reflection.MethodInfo boundMember, System.Linq.Expressions.Expression associatedExpression) : base(default(System.Reflection.MemberInfo), default(System.Linq.Expressions.Expression)) => throw null;
                        public override bool MatchesReadAccess(System.Reflection.MemberInfo readMember) => throw null;
                    }
                    public class PropertyInfoBinding : Remotion.Linq.Parsing.ExpressionVisitors.MemberBindings.MemberBinding
                    {
                        public PropertyInfoBinding(System.Reflection.PropertyInfo boundMember, System.Linq.Expressions.Expression associatedExpression) : base(default(System.Reflection.MemberInfo), default(System.Linq.Expressions.Expression)) => throw null;
                        public override bool MatchesReadAccess(System.Reflection.MemberInfo member) => throw null;
                    }
                }
                public sealed class MultiReplacingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.Expression Replace(System.Collections.Generic.IDictionary<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> expressionMapping, System.Linq.Expressions.Expression sourceTree) => throw null;
                    public override System.Linq.Expressions.Expression Visit(System.Linq.Expressions.Expression expression) => throw null;
                    protected override System.Linq.Expressions.Expression VisitSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression expression) => throw null;
                }
                public sealed class PartialEvaluatingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.Expression EvaluateIndependentSubtrees(System.Linq.Expressions.Expression expressionTree, Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.IEvaluatableExpressionFilter evaluatableExpressionFilter) => throw null;
                    public override System.Linq.Expressions.Expression Visit(System.Linq.Expressions.Expression expression) => throw null;
                }
                public sealed class ReplacingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.Expression Replace(System.Linq.Expressions.Expression replacedExpression, System.Linq.Expressions.Expression replacementExpression, System.Linq.Expressions.Expression sourceTree) => throw null;
                    public override System.Linq.Expressions.Expression Visit(System.Linq.Expressions.Expression expression) => throw null;
                    protected override System.Linq.Expressions.Expression VisitSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression expression) => throw null;
                }
                public sealed class SubQueryFindingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.Expression Process(System.Linq.Expressions.Expression expressionTree, Remotion.Linq.Parsing.Structure.INodeTypeProvider nodeTypeProvider) => throw null;
                    public override System.Linq.Expressions.Expression Visit(System.Linq.Expressions.Expression expression) => throw null;
                }
                namespace Transformation
                {
                    public delegate System.Linq.Expressions.Expression ExpressionTransformation(System.Linq.Expressions.Expression expression);
                    public class ExpressionTransformerRegistry : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTranformationProvider
                    {
                        public static Remotion.Linq.Parsing.ExpressionVisitors.Transformation.ExpressionTransformerRegistry CreateDefault() => throw null;
                        public ExpressionTransformerRegistry() => throw null;
                        public Remotion.Linq.Parsing.ExpressionVisitors.Transformation.ExpressionTransformation[] GetAllTransformations(System.Linq.Expressions.ExpressionType expressionType) => throw null;
                        public System.Collections.Generic.IEnumerable<Remotion.Linq.Parsing.ExpressionVisitors.Transformation.ExpressionTransformation> GetTransformations(System.Linq.Expressions.Expression expression) => throw null;
                        public void Register<T>(Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<T> transformer) where T : System.Linq.Expressions.Expression => throw null;
                        public int RegisteredTransformerCount { get => throw null; }
                    }
                    public interface IExpressionTranformationProvider
                    {
                        System.Collections.Generic.IEnumerable<Remotion.Linq.Parsing.ExpressionVisitors.Transformation.ExpressionTransformation> GetTransformations(System.Linq.Expressions.Expression expression);
                    }
                    public interface IExpressionTransformer<T> where T : System.Linq.Expressions.Expression
                    {
                        System.Linq.Expressions.ExpressionType[] SupportedExpressionTypes { get; }
                        System.Linq.Expressions.Expression Transform(T expression);
                    }
                    namespace PredefinedTransformations
                    {
                        public class AttributeEvaluatingExpressionTransformer : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<System.Linq.Expressions.Expression>
                        {
                            public AttributeEvaluatingExpressionTransformer() => throw null;
                            public interface IMethodCallExpressionTransformerAttribute
                            {
                                Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<System.Linq.Expressions.MethodCallExpression> GetExpressionTransformer(System.Linq.Expressions.MethodCallExpression expression);
                            }
                            public System.Linq.Expressions.ExpressionType[] SupportedExpressionTypes { get => throw null; }
                            public System.Linq.Expressions.Expression Transform(System.Linq.Expressions.Expression expression) => throw null;
                        }
                        public class DictionaryEntryNewExpressionTransformer : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.MemberAddingNewExpressionTransformerBase
                        {
                            protected override bool CanAddMembers(System.Type instantiatedType, System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> arguments) => throw null;
                            public DictionaryEntryNewExpressionTransformer() => throw null;
                            protected override System.Reflection.MemberInfo[] GetMembers(System.Reflection.ConstructorInfo constructorInfo, System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> arguments) => throw null;
                        }
                        public class InvocationOfLambdaExpressionTransformer : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<System.Linq.Expressions.InvocationExpression>
                        {
                            public InvocationOfLambdaExpressionTransformer() => throw null;
                            public System.Linq.Expressions.ExpressionType[] SupportedExpressionTypes { get => throw null; }
                            public System.Linq.Expressions.Expression Transform(System.Linq.Expressions.InvocationExpression expression) => throw null;
                        }
                        public class KeyValuePairNewExpressionTransformer : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.MemberAddingNewExpressionTransformerBase
                        {
                            protected override bool CanAddMembers(System.Type instantiatedType, System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> arguments) => throw null;
                            public KeyValuePairNewExpressionTransformer() => throw null;
                            protected override System.Reflection.MemberInfo[] GetMembers(System.Reflection.ConstructorInfo constructorInfo, System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> arguments) => throw null;
                        }
                        public abstract class MemberAddingNewExpressionTransformerBase : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<System.Linq.Expressions.NewExpression>
                        {
                            protected abstract bool CanAddMembers(System.Type instantiatedType, System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> arguments);
                            protected MemberAddingNewExpressionTransformerBase() => throw null;
                            protected System.Reflection.MemberInfo GetMemberForNewExpression(System.Type instantiatedType, string propertyName) => throw null;
                            protected abstract System.Reflection.MemberInfo[] GetMembers(System.Reflection.ConstructorInfo constructorInfo, System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> arguments);
                            public System.Linq.Expressions.ExpressionType[] SupportedExpressionTypes { get => throw null; }
                            public System.Linq.Expressions.Expression Transform(System.Linq.Expressions.NewExpression expression) => throw null;
                        }
                        [System.AttributeUsage((System.AttributeTargets)64, AllowMultiple = false, Inherited = false)]
                        public class MethodCallExpressionTransformerAttribute : System.Attribute, Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.AttributeEvaluatingExpressionTransformer.IMethodCallExpressionTransformerAttribute
                        {
                            public MethodCallExpressionTransformerAttribute(System.Type transformerType) => throw null;
                            public Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<System.Linq.Expressions.MethodCallExpression> GetExpressionTransformer(System.Linq.Expressions.MethodCallExpression expression) => throw null;
                            public System.Type TransformerType { get => throw null; }
                        }
                        public class NullableValueTransformer : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<System.Linq.Expressions.MemberExpression>
                        {
                            public NullableValueTransformer() => throw null;
                            public System.Linq.Expressions.ExpressionType[] SupportedExpressionTypes { get => throw null; }
                            public System.Linq.Expressions.Expression Transform(System.Linq.Expressions.MemberExpression expression) => throw null;
                        }
                        public class TupleNewExpressionTransformer : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.MemberAddingNewExpressionTransformerBase
                        {
                            protected override bool CanAddMembers(System.Type instantiatedType, System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> arguments) => throw null;
                            public TupleNewExpressionTransformer() => throw null;
                            protected override System.Reflection.MemberInfo[] GetMembers(System.Reflection.ConstructorInfo constructorInfo, System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> arguments) => throw null;
                        }
                        public class VBCompareStringExpressionTransformer : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<System.Linq.Expressions.BinaryExpression>
                        {
                            public VBCompareStringExpressionTransformer() => throw null;
                            public System.Linq.Expressions.ExpressionType[] SupportedExpressionTypes { get => throw null; }
                            public System.Linq.Expressions.Expression Transform(System.Linq.Expressions.BinaryExpression expression) => throw null;
                        }
                        public class VBInformationIsNothingExpressionTransformer : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<System.Linq.Expressions.MethodCallExpression>
                        {
                            public VBInformationIsNothingExpressionTransformer() => throw null;
                            public System.Linq.Expressions.ExpressionType[] SupportedExpressionTypes { get => throw null; }
                            public System.Linq.Expressions.Expression Transform(System.Linq.Expressions.MethodCallExpression expression) => throw null;
                        }
                    }
                }
                public sealed class TransformingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.Expression Transform(System.Linq.Expressions.Expression expression, Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTranformationProvider tranformationProvider) => throw null;
                    public override System.Linq.Expressions.Expression Visit(System.Linq.Expressions.Expression expression) => throw null;
                }
                public sealed class TransparentIdentifierRemovingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.Expression ReplaceTransparentIdentifiers(System.Linq.Expressions.Expression expression) => throw null;
                    protected override System.Linq.Expressions.Expression VisitMember(System.Linq.Expressions.MemberExpression memberExpression) => throw null;
                    protected override System.Linq.Expressions.Expression VisitSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression expression) => throw null;
                }
                namespace TreeEvaluation
                {
                    public abstract class EvaluatableExpressionFilterBase : Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.IEvaluatableExpressionFilter
                    {
                        protected EvaluatableExpressionFilterBase() => throw null;
                        public virtual bool IsEvaluatableBinary(System.Linq.Expressions.BinaryExpression node) => throw null;
                        public virtual bool IsEvaluatableBlock(System.Linq.Expressions.BlockExpression node) => throw null;
                        public virtual bool IsEvaluatableCatchBlock(System.Linq.Expressions.CatchBlock node) => throw null;
                        public virtual bool IsEvaluatableConditional(System.Linq.Expressions.ConditionalExpression node) => throw null;
                        public virtual bool IsEvaluatableConstant(System.Linq.Expressions.ConstantExpression node) => throw null;
                        public virtual bool IsEvaluatableDebugInfo(System.Linq.Expressions.DebugInfoExpression node) => throw null;
                        public virtual bool IsEvaluatableDefault(System.Linq.Expressions.DefaultExpression node) => throw null;
                        public virtual bool IsEvaluatableElementInit(System.Linq.Expressions.ElementInit node) => throw null;
                        public virtual bool IsEvaluatableGoto(System.Linq.Expressions.GotoExpression node) => throw null;
                        public virtual bool IsEvaluatableIndex(System.Linq.Expressions.IndexExpression node) => throw null;
                        public virtual bool IsEvaluatableInvocation(System.Linq.Expressions.InvocationExpression node) => throw null;
                        public virtual bool IsEvaluatableLabel(System.Linq.Expressions.LabelExpression node) => throw null;
                        public virtual bool IsEvaluatableLabelTarget(System.Linq.Expressions.LabelTarget node) => throw null;
                        public virtual bool IsEvaluatableLambda(System.Linq.Expressions.LambdaExpression node) => throw null;
                        public virtual bool IsEvaluatableListInit(System.Linq.Expressions.ListInitExpression node) => throw null;
                        public virtual bool IsEvaluatableLoop(System.Linq.Expressions.LoopExpression node) => throw null;
                        public virtual bool IsEvaluatableMember(System.Linq.Expressions.MemberExpression node) => throw null;
                        public virtual bool IsEvaluatableMemberAssignment(System.Linq.Expressions.MemberAssignment node) => throw null;
                        public virtual bool IsEvaluatableMemberInit(System.Linq.Expressions.MemberInitExpression node) => throw null;
                        public virtual bool IsEvaluatableMemberListBinding(System.Linq.Expressions.MemberListBinding node) => throw null;
                        public virtual bool IsEvaluatableMemberMemberBinding(System.Linq.Expressions.MemberMemberBinding node) => throw null;
                        public virtual bool IsEvaluatableMethodCall(System.Linq.Expressions.MethodCallExpression node) => throw null;
                        public virtual bool IsEvaluatableNew(System.Linq.Expressions.NewExpression node) => throw null;
                        public virtual bool IsEvaluatableNewArray(System.Linq.Expressions.NewArrayExpression node) => throw null;
                        public virtual bool IsEvaluatableSwitch(System.Linq.Expressions.SwitchExpression node) => throw null;
                        public virtual bool IsEvaluatableSwitchCase(System.Linq.Expressions.SwitchCase node) => throw null;
                        public virtual bool IsEvaluatableTry(System.Linq.Expressions.TryExpression node) => throw null;
                        public virtual bool IsEvaluatableTypeBinary(System.Linq.Expressions.TypeBinaryExpression node) => throw null;
                        public virtual bool IsEvaluatableUnary(System.Linq.Expressions.UnaryExpression node) => throw null;
                    }
                    public sealed class EvaluatableTreeFindingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor, Remotion.Linq.Clauses.Expressions.IPartialEvaluationExceptionExpressionVisitor
                    {
                        public static Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.PartialEvaluationInfo Analyze(System.Linq.Expressions.Expression expressionTree, Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.IEvaluatableExpressionFilter evaluatableExpressionFilter) => throw null;
                        public override System.Linq.Expressions.Expression Visit(System.Linq.Expressions.Expression expression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitBinary(System.Linq.Expressions.BinaryExpression expression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitBlock(System.Linq.Expressions.BlockExpression expression) => throw null;
                        protected override System.Linq.Expressions.CatchBlock VisitCatchBlock(System.Linq.Expressions.CatchBlock node) => throw null;
                        protected override System.Linq.Expressions.Expression VisitConditional(System.Linq.Expressions.ConditionalExpression expression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitConstant(System.Linq.Expressions.ConstantExpression expression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitDebugInfo(System.Linq.Expressions.DebugInfoExpression expression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitDefault(System.Linq.Expressions.DefaultExpression expression) => throw null;
                        protected override System.Linq.Expressions.ElementInit VisitElementInit(System.Linq.Expressions.ElementInit node) => throw null;
                        protected override System.Linq.Expressions.Expression VisitGoto(System.Linq.Expressions.GotoExpression expression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitIndex(System.Linq.Expressions.IndexExpression expression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitInvocation(System.Linq.Expressions.InvocationExpression expression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitLabel(System.Linq.Expressions.LabelExpression expression) => throw null;
                        protected override System.Linq.Expressions.LabelTarget VisitLabelTarget(System.Linq.Expressions.LabelTarget node) => throw null;
                        protected override System.Linq.Expressions.Expression VisitLambda<T>(System.Linq.Expressions.Expression<T> expression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitListInit(System.Linq.Expressions.ListInitExpression expression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitLoop(System.Linq.Expressions.LoopExpression expression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitMember(System.Linq.Expressions.MemberExpression expression) => throw null;
                        protected override System.Linq.Expressions.MemberAssignment VisitMemberAssignment(System.Linq.Expressions.MemberAssignment node) => throw null;
                        protected override System.Linq.Expressions.Expression VisitMemberInit(System.Linq.Expressions.MemberInitExpression expression) => throw null;
                        protected override System.Linq.Expressions.MemberListBinding VisitMemberListBinding(System.Linq.Expressions.MemberListBinding node) => throw null;
                        protected override System.Linq.Expressions.MemberMemberBinding VisitMemberMemberBinding(System.Linq.Expressions.MemberMemberBinding node) => throw null;
                        protected override System.Linq.Expressions.Expression VisitMethodCall(System.Linq.Expressions.MethodCallExpression expression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitNew(System.Linq.Expressions.NewExpression expression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitNewArray(System.Linq.Expressions.NewArrayExpression expression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitParameter(System.Linq.Expressions.ParameterExpression expression) => throw null;
                        public System.Linq.Expressions.Expression VisitPartialEvaluationException(Remotion.Linq.Clauses.Expressions.PartialEvaluationExceptionExpression partialEvaluationExceptionExpression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitSwitch(System.Linq.Expressions.SwitchExpression expression) => throw null;
                        protected override System.Linq.Expressions.SwitchCase VisitSwitchCase(System.Linq.Expressions.SwitchCase node) => throw null;
                        protected override System.Linq.Expressions.Expression VisitTry(System.Linq.Expressions.TryExpression expression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitTypeBinary(System.Linq.Expressions.TypeBinaryExpression expression) => throw null;
                        protected override System.Linq.Expressions.Expression VisitUnary(System.Linq.Expressions.UnaryExpression expression) => throw null;
                    }
                    public interface IEvaluatableExpressionFilter
                    {
                        bool IsEvaluatableBinary(System.Linq.Expressions.BinaryExpression node);
                        bool IsEvaluatableBlock(System.Linq.Expressions.BlockExpression node);
                        bool IsEvaluatableCatchBlock(System.Linq.Expressions.CatchBlock node);
                        bool IsEvaluatableConditional(System.Linq.Expressions.ConditionalExpression node);
                        bool IsEvaluatableConstant(System.Linq.Expressions.ConstantExpression node);
                        bool IsEvaluatableDebugInfo(System.Linq.Expressions.DebugInfoExpression node);
                        bool IsEvaluatableDefault(System.Linq.Expressions.DefaultExpression node);
                        bool IsEvaluatableElementInit(System.Linq.Expressions.ElementInit node);
                        bool IsEvaluatableGoto(System.Linq.Expressions.GotoExpression node);
                        bool IsEvaluatableIndex(System.Linq.Expressions.IndexExpression node);
                        bool IsEvaluatableInvocation(System.Linq.Expressions.InvocationExpression node);
                        bool IsEvaluatableLabel(System.Linq.Expressions.LabelExpression node);
                        bool IsEvaluatableLabelTarget(System.Linq.Expressions.LabelTarget node);
                        bool IsEvaluatableLambda(System.Linq.Expressions.LambdaExpression node);
                        bool IsEvaluatableListInit(System.Linq.Expressions.ListInitExpression node);
                        bool IsEvaluatableLoop(System.Linq.Expressions.LoopExpression node);
                        bool IsEvaluatableMember(System.Linq.Expressions.MemberExpression node);
                        bool IsEvaluatableMemberAssignment(System.Linq.Expressions.MemberAssignment node);
                        bool IsEvaluatableMemberInit(System.Linq.Expressions.MemberInitExpression node);
                        bool IsEvaluatableMemberListBinding(System.Linq.Expressions.MemberListBinding node);
                        bool IsEvaluatableMemberMemberBinding(System.Linq.Expressions.MemberMemberBinding node);
                        bool IsEvaluatableMethodCall(System.Linq.Expressions.MethodCallExpression node);
                        bool IsEvaluatableNew(System.Linq.Expressions.NewExpression node);
                        bool IsEvaluatableNewArray(System.Linq.Expressions.NewArrayExpression node);
                        bool IsEvaluatableSwitch(System.Linq.Expressions.SwitchExpression node);
                        bool IsEvaluatableSwitchCase(System.Linq.Expressions.SwitchCase node);
                        bool IsEvaluatableTry(System.Linq.Expressions.TryExpression node);
                        bool IsEvaluatableTypeBinary(System.Linq.Expressions.TypeBinaryExpression node);
                        bool IsEvaluatableUnary(System.Linq.Expressions.UnaryExpression node);
                    }
                    public class PartialEvaluationInfo
                    {
                        public void AddEvaluatableExpression(System.Linq.Expressions.Expression expression) => throw null;
                        public int Count { get => throw null; }
                        public PartialEvaluationInfo() => throw null;
                        public bool IsEvaluatableExpression(System.Linq.Expressions.Expression expression) => throw null;
                    }
                }
            }
            public abstract class ParserException : System.Exception
            {
            }
            public abstract class RelinqExpressionVisitor : System.Linq.Expressions.ExpressionVisitor
            {
                public static System.Collections.Generic.IEnumerable<System.Linq.Expressions.Expression> AdjustArgumentsForNewExpression(System.Collections.Generic.IList<System.Linq.Expressions.Expression> arguments, System.Collections.Generic.IList<System.Reflection.MemberInfo> members) => throw null;
                protected RelinqExpressionVisitor() => throw null;
                protected override System.Linq.Expressions.Expression VisitNew(System.Linq.Expressions.NewExpression expression) => throw null;
                protected virtual System.Linq.Expressions.Expression VisitQuerySourceReference(Remotion.Linq.Clauses.Expressions.QuerySourceReferenceExpression expression) => throw null;
                protected virtual System.Linq.Expressions.Expression VisitSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression expression) => throw null;
            }
            namespace Structure
            {
                public sealed class ExpressionTreeParser
                {
                    public static Remotion.Linq.Parsing.Structure.ExpressionTreeParser CreateDefault() => throw null;
                    public static Remotion.Linq.Parsing.Structure.NodeTypeProviders.CompoundNodeTypeProvider CreateDefaultNodeTypeProvider() => throw null;
                    public static Remotion.Linq.Parsing.Structure.ExpressionTreeProcessors.CompoundExpressionTreeProcessor CreateDefaultProcessor(Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTranformationProvider tranformationProvider, Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.IEvaluatableExpressionFilter evaluatableExpressionFilter = default(Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.IEvaluatableExpressionFilter)) => throw null;
                    public ExpressionTreeParser(Remotion.Linq.Parsing.Structure.INodeTypeProvider nodeTypeProvider, Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor processor) => throw null;
                    public System.Linq.Expressions.MethodCallExpression GetQueryOperatorExpression(System.Linq.Expressions.Expression expression) => throw null;
                    public Remotion.Linq.Parsing.Structure.INodeTypeProvider NodeTypeProvider { get => throw null; }
                    public Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode ParseTree(System.Linq.Expressions.Expression expressionTree) => throw null;
                    public Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor Processor { get => throw null; }
                }
                namespace ExpressionTreeProcessors
                {
                    public sealed class CompoundExpressionTreeProcessor : Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor
                    {
                        public CompoundExpressionTreeProcessor(System.Collections.Generic.IEnumerable<Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor> innerProcessors) => throw null;
                        public System.Collections.Generic.IList<Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor> InnerProcessors { get => throw null; }
                        public System.Linq.Expressions.Expression Process(System.Linq.Expressions.Expression expressionTree) => throw null;
                    }
                    public sealed class NullExpressionTreeProcessor : Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor
                    {
                        public NullExpressionTreeProcessor() => throw null;
                        public System.Linq.Expressions.Expression Process(System.Linq.Expressions.Expression expressionTree) => throw null;
                    }
                    public sealed class PartialEvaluatingExpressionTreeProcessor : Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor
                    {
                        public PartialEvaluatingExpressionTreeProcessor(Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.IEvaluatableExpressionFilter filter) => throw null;
                        public Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.IEvaluatableExpressionFilter Filter { get => throw null; }
                        public System.Linq.Expressions.Expression Process(System.Linq.Expressions.Expression expressionTree) => throw null;
                    }
                    public sealed class TransformingExpressionTreeProcessor : Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor
                    {
                        public TransformingExpressionTreeProcessor(Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTranformationProvider provider) => throw null;
                        public System.Linq.Expressions.Expression Process(System.Linq.Expressions.Expression expressionTree) => throw null;
                        public Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTranformationProvider Provider { get => throw null; }
                    }
                }
                public interface IExpressionTreeProcessor
                {
                    System.Linq.Expressions.Expression Process(System.Linq.Expressions.Expression expressionTree);
                }
                public interface INodeTypeProvider
                {
                    System.Type GetNodeType(System.Reflection.MethodInfo method);
                    bool IsRegistered(System.Reflection.MethodInfo method);
                }
                namespace IntermediateModel
                {
                    public sealed class AggregateExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public AggregateExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression func) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public System.Linq.Expressions.LambdaExpression Func { get => throw null; }
                        public System.Linq.Expressions.LambdaExpression GetResolvedFunc(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class AggregateFromSeedExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public AggregateFromSeedExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression seed, System.Linq.Expressions.LambdaExpression func, System.Linq.Expressions.LambdaExpression optionalResultSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public System.Linq.Expressions.LambdaExpression Func { get => throw null; }
                        public System.Linq.Expressions.LambdaExpression GetResolvedFunc(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression OptionalResultSelector { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression Seed { get => throw null; }
                    }
                    public sealed class AllExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public AllExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression predicate) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedPredicate(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression Predicate { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class AnyExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public AnyExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalPredicate) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class AsQueryableExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public AsQueryableExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class AverageExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public AverageExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class CastExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        public System.Type CastItemType { get => throw null; }
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public CastExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public struct ClauseGenerationContext
                    {
                        public void AddContextInfo(Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode node, object contextInfo) => throw null;
                        public int Count { get => throw null; }
                        public ClauseGenerationContext(Remotion.Linq.Parsing.Structure.INodeTypeProvider nodeTypeProvider) => throw null;
                        public object GetContextInfo(Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode node) => throw null;
                        public Remotion.Linq.Parsing.Structure.INodeTypeProvider NodeTypeProvider { get => throw null; }
                    }
                    public sealed class ConcatExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.QuerySourceSetOperationExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateSpecificResultOperator() => throw null;
                        public ConcatExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression source2) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.Expression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                    }
                    public sealed class ContainsExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public ContainsExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression item) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<Remotion.Linq.Parsing.Structure.NodeTypeProviders.NameBasedRegistrationInfo> GetSupportedMethodNames() => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.Expression Item { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class CountExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public CountExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalPredicate) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class DefaultIfEmptyExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public DefaultIfEmptyExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression optionalDefaultValue) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.Expression OptionalDefaultValue { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class DistinctExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public DistinctExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class ExceptExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public ExceptExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression source2) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression Source2 { get => throw null; }
                    }
                    public sealed class ExpressionNodeInstantiationException : System.Exception
                    {
                    }
                    public sealed class ExpressionResolver
                    {
                        public ExpressionResolver(Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode currentNode) => throw null;
                        public Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode CurrentNode { get => throw null; }
                        public System.Linq.Expressions.Expression GetResolvedExpression(System.Linq.Expressions.Expression unresolvedExpression, System.Linq.Expressions.ParameterExpression parameterToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class FirstExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public FirstExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalPredicate) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class GroupByExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase, Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode, Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public GroupByExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression keySelector, System.Linq.Expressions.LambdaExpression optionalElementSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedKeySelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedOptionalElementSelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression KeySelector { get => throw null; }
                        public System.Linq.Expressions.LambdaExpression OptionalElementSelector { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class GroupByWithResultSelectorExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode, Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode
                    {
                        public Remotion.Linq.QueryModel Apply(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public string AssociatedIdentifier { get => throw null; }
                        public GroupByWithResultSelectorExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression keySelector, System.Linq.Expressions.LambdaExpression elementSelectorOrResultSelector, System.Linq.Expressions.LambdaExpression resultSelectorOrNull) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression Selector { get => throw null; }
                        public Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode Source { get => throw null; }
                    }
                    public sealed class GroupJoinExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase, Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode, Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public GroupJoinExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression innerSequence, System.Linq.Expressions.LambdaExpression outerKeySelector, System.Linq.Expressions.LambdaExpression innerKeySelector, System.Linq.Expressions.LambdaExpression resultSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedResultSelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression InnerKeySelector { get => throw null; }
                        public System.Linq.Expressions.Expression InnerSequence { get => throw null; }
                        public Remotion.Linq.Parsing.Structure.IntermediateModel.JoinExpressionNode JoinExpressionNode { get => throw null; }
                        public System.Linq.Expressions.LambdaExpression OuterKeySelector { get => throw null; }
                        public System.Linq.Expressions.MethodCallExpression ParsedExpression { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.LambdaExpression ResultSelector { get => throw null; }
                    }
                    public interface IExpressionNode
                    {
                        Remotion.Linq.QueryModel Apply(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext);
                        string AssociatedIdentifier { get; }
                        System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext);
                        Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode Source { get; }
                    }
                    public sealed class IntersectExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public IntersectExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression source2) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression Source2 { get => throw null; }
                    }
                    public interface IQuerySourceExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode
                    {
                    }
                    public sealed class JoinExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase, Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode, Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public Remotion.Linq.Clauses.JoinClause CreateJoinClause(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public JoinExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression innerSequence, System.Linq.Expressions.LambdaExpression outerKeySelector, System.Linq.Expressions.LambdaExpression innerKeySelector, System.Linq.Expressions.LambdaExpression resultSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedInnerKeySelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedOuterKeySelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedResultSelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression InnerKeySelector { get => throw null; }
                        public System.Linq.Expressions.Expression InnerSequence { get => throw null; }
                        public System.Linq.Expressions.LambdaExpression OuterKeySelector { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.LambdaExpression ResultSelector { get => throw null; }
                    }
                    public sealed class LastExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public LastExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalPredicate) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class LongCountExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public LongCountExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalPredicate) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class MainSourceExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode, Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode
                    {
                        public Remotion.Linq.QueryModel Apply(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public string AssociatedIdentifier { get => throw null; }
                        public MainSourceExpressionNode(string associatedIdentifier, System.Linq.Expressions.Expression expression) => throw null;
                        public System.Linq.Expressions.Expression ParsedExpression { get => throw null; }
                        public System.Type QuerySourceElementType { get => throw null; }
                        public System.Type QuerySourceType { get => throw null; }
                        public System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode Source { get => throw null; }
                    }
                    public sealed class MaxExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public MaxExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public abstract class MethodCallExpressionNodeBase : Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode
                    {
                        public Remotion.Linq.QueryModel Apply(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        protected abstract void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext);
                        public string AssociatedIdentifier { get => throw null; }
                        protected System.NotSupportedException CreateOutputParameterNotSupportedException() => throw null;
                        protected System.NotSupportedException CreateResolveNotSupportedException() => throw null;
                        protected MethodCallExpressionNodeBase(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo) => throw null;
                        public System.Type NodeResultType { get => throw null; }
                        public abstract System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext);
                        protected virtual void SetResultTypeOverride(Remotion.Linq.QueryModel queryModel) => throw null;
                        public Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode Source { get => throw null; }
                        protected virtual Remotion.Linq.QueryModel WrapQueryModelAfterEndOfQuery(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public static class MethodCallExpressionNodeFactory
                    {
                        public static Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode CreateExpressionNode(System.Type nodeType, Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, object[] additionalConstructorParameters) => throw null;
                    }
                    public struct MethodCallExpressionParseInfo
                    {
                        public string AssociatedIdentifier { get => throw null; }
                        public MethodCallExpressionParseInfo(string associatedIdentifier, Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode source, System.Linq.Expressions.MethodCallExpression parsedExpression) => throw null;
                        public System.Linq.Expressions.MethodCallExpression ParsedExpression { get => throw null; }
                        public Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode Source { get => throw null; }
                    }
                    public sealed class MinExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public MinExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class OfTypeExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public OfTypeExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Type SearchedItemType { get => throw null; }
                    }
                    public sealed class OrderByDescendingExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public OrderByDescendingExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression keySelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedKeySelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression KeySelector { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class OrderByExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public OrderByExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression keySelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedKeySelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression KeySelector { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public static class QuerySourceExpressionNodeUtility
                    {
                        public static Remotion.Linq.Clauses.IQuerySource GetQuerySourceForNode(Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode node, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext context) => throw null;
                        public static System.Linq.Expressions.Expression ReplaceParameterWithReference(Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode referencedNode, System.Linq.Expressions.ParameterExpression parameterToReplace, System.Linq.Expressions.Expression expression, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext context) => throw null;
                    }
                    public abstract class QuerySourceSetOperationExpressionNodeBase : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase, Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode, Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode
                    {
                        protected override sealed Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        protected abstract Remotion.Linq.Clauses.ResultOperatorBase CreateSpecificResultOperator();
                        protected QuerySourceSetOperationExpressionNodeBase(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression source2) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public System.Type ItemType { get => throw null; }
                        public override sealed System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression Source2 { get => throw null; }
                    }
                    public sealed class ResolvedExpressionCache<T> where T : System.Linq.Expressions.Expression
                    {
                        public ResolvedExpressionCache(Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode currentNode) => throw null;
                        public T GetOrCreate(System.Func<Remotion.Linq.Parsing.Structure.IntermediateModel.ExpressionResolver, T> generator) => throw null;
                    }
                    public abstract class ResultOperatorExpressionNodeBase : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        protected abstract Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext);
                        protected ResultOperatorExpressionNodeBase(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalPredicate, System.Linq.Expressions.LambdaExpression optionalSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                        public System.Linq.Expressions.MethodCallExpression ParsedExpression { get => throw null; }
                        protected override sealed Remotion.Linq.QueryModel WrapQueryModelAfterEndOfQuery(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class ReverseExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public ReverseExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class SelectExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public SelectExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression selector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedSelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.LambdaExpression Selector { get => throw null; }
                    }
                    public sealed class SelectManyExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase, Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode, Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.LambdaExpression CollectionSelector { get => throw null; }
                        public SelectManyExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression collectionSelector, System.Linq.Expressions.LambdaExpression resultSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedCollectionSelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedResultSelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.LambdaExpression ResultSelector { get => throw null; }
                    }
                    public sealed class SingleExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public SingleExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalPredicate) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class SkipExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        public System.Linq.Expressions.Expression Count { get => throw null; }
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public SkipExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression count) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class SumExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public SumExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class TakeExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        public System.Linq.Expressions.Expression Count { get => throw null; }
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public TakeExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression count) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class ThenByDescendingExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public ThenByDescendingExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression keySelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedKeySelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression KeySelector { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class ThenByExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public ThenByExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression keySelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedKeySelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression KeySelector { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                    public sealed class UnionExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.QuerySourceSetOperationExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateSpecificResultOperator() => throw null;
                        public UnionExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression source2) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.Expression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                    }
                    public sealed class WhereExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public WhereExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression predicate) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedPredicate(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression Predicate { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }
                }
                public interface IQueryParser
                {
                    Remotion.Linq.QueryModel GetParsedQuery(System.Linq.Expressions.Expression expressionTreeRoot);
                }
                public sealed class MethodCallExpressionParser
                {
                    public MethodCallExpressionParser(Remotion.Linq.Parsing.Structure.INodeTypeProvider nodeTypeProvider) => throw null;
                    public Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode Parse(string associatedIdentifier, Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode source, System.Collections.Generic.IEnumerable<System.Linq.Expressions.Expression> arguments, System.Linq.Expressions.MethodCallExpression expressionToParse) => throw null;
                }
                namespace NodeTypeProviders
                {
                    public sealed class CompoundNodeTypeProvider : Remotion.Linq.Parsing.Structure.INodeTypeProvider
                    {
                        public CompoundNodeTypeProvider(System.Collections.Generic.IEnumerable<Remotion.Linq.Parsing.Structure.INodeTypeProvider> innerProviders) => throw null;
                        public System.Type GetNodeType(System.Reflection.MethodInfo method) => throw null;
                        public System.Collections.Generic.IList<Remotion.Linq.Parsing.Structure.INodeTypeProvider> InnerProviders { get => throw null; }
                        public bool IsRegistered(System.Reflection.MethodInfo method) => throw null;
                    }
                    public sealed class MethodInfoBasedNodeTypeRegistry : Remotion.Linq.Parsing.Structure.INodeTypeProvider
                    {
                        public static Remotion.Linq.Parsing.Structure.NodeTypeProviders.MethodInfoBasedNodeTypeRegistry CreateFromRelinqAssembly() => throw null;
                        public MethodInfoBasedNodeTypeRegistry() => throw null;
                        public System.Type GetNodeType(System.Reflection.MethodInfo method) => throw null;
                        public static System.Reflection.MethodInfo GetRegisterableMethodDefinition(System.Reflection.MethodInfo method, bool throwOnAmbiguousMatch) => throw null;
                        public bool IsRegistered(System.Reflection.MethodInfo method) => throw null;
                        public void Register(System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> methods, System.Type nodeType) => throw null;
                        public int RegisteredMethodInfoCount { get => throw null; }
                    }
                    public sealed class MethodNameBasedNodeTypeRegistry : Remotion.Linq.Parsing.Structure.INodeTypeProvider
                    {
                        public static Remotion.Linq.Parsing.Structure.NodeTypeProviders.MethodNameBasedNodeTypeRegistry CreateFromRelinqAssembly() => throw null;
                        public MethodNameBasedNodeTypeRegistry() => throw null;
                        public System.Type GetNodeType(System.Reflection.MethodInfo method) => throw null;
                        public bool IsRegistered(System.Reflection.MethodInfo method) => throw null;
                        public void Register(System.Collections.Generic.IEnumerable<Remotion.Linq.Parsing.Structure.NodeTypeProviders.NameBasedRegistrationInfo> registrationInfo, System.Type nodeType) => throw null;
                        public int RegisteredNamesCount { get => throw null; }
                    }
                    public sealed class NameBasedRegistrationInfo
                    {
                        public NameBasedRegistrationInfo(string name, System.Func<System.Reflection.MethodInfo, bool> filter) => throw null;
                        public System.Func<System.Reflection.MethodInfo, bool> Filter { get => throw null; }
                        public string Name { get => throw null; }
                    }
                }
                public sealed class QueryParser : Remotion.Linq.Parsing.Structure.IQueryParser
                {
                    public static Remotion.Linq.Parsing.Structure.QueryParser CreateDefault() => throw null;
                    public QueryParser(Remotion.Linq.Parsing.Structure.ExpressionTreeParser expressionTreeParser) => throw null;
                    public Remotion.Linq.Parsing.Structure.ExpressionTreeParser ExpressionTreeParser { get => throw null; }
                    public Remotion.Linq.QueryModel GetParsedQuery(System.Linq.Expressions.Expression expressionTreeRoot) => throw null;
                    public Remotion.Linq.Parsing.Structure.INodeTypeProvider NodeTypeProvider { get => throw null; }
                    public Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor Processor { get => throw null; }
                }
            }
            public abstract class ThrowingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
            {
                protected System.Linq.Expressions.Expression BaseVisitBinary(System.Linq.Expressions.BinaryExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitBlock(System.Linq.Expressions.BlockExpression expression) => throw null;
                protected System.Linq.Expressions.CatchBlock BaseVisitCatchBlock(System.Linq.Expressions.CatchBlock expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitConditional(System.Linq.Expressions.ConditionalExpression arg) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitConstant(System.Linq.Expressions.ConstantExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitDebugInfo(System.Linq.Expressions.DebugInfoExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitDefault(System.Linq.Expressions.DefaultExpression expression) => throw null;
                protected System.Linq.Expressions.ElementInit BaseVisitElementInit(System.Linq.Expressions.ElementInit elementInit) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitExtension(System.Linq.Expressions.Expression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitGoto(System.Linq.Expressions.GotoExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitIndex(System.Linq.Expressions.IndexExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitInvocation(System.Linq.Expressions.InvocationExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitLabel(System.Linq.Expressions.LabelExpression expression) => throw null;
                protected System.Linq.Expressions.LabelTarget BaseVisitLabelTarget(System.Linq.Expressions.LabelTarget expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitLambda<T>(System.Linq.Expressions.Expression<T> expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitListInit(System.Linq.Expressions.ListInitExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitLoop(System.Linq.Expressions.LoopExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitMember(System.Linq.Expressions.MemberExpression expression) => throw null;
                protected System.Linq.Expressions.MemberAssignment BaseVisitMemberAssignment(System.Linq.Expressions.MemberAssignment memberAssigment) => throw null;
                protected System.Linq.Expressions.MemberBinding BaseVisitMemberBinding(System.Linq.Expressions.MemberBinding expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitMemberInit(System.Linq.Expressions.MemberInitExpression expression) => throw null;
                protected System.Linq.Expressions.MemberListBinding BaseVisitMemberListBinding(System.Linq.Expressions.MemberListBinding listBinding) => throw null;
                protected System.Linq.Expressions.MemberMemberBinding BaseVisitMemberMemberBinding(System.Linq.Expressions.MemberMemberBinding binding) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitMethodCall(System.Linq.Expressions.MethodCallExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitNew(System.Linq.Expressions.NewExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitNewArray(System.Linq.Expressions.NewArrayExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitParameter(System.Linq.Expressions.ParameterExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitQuerySourceReference(Remotion.Linq.Clauses.Expressions.QuerySourceReferenceExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitRuntimeVariables(System.Linq.Expressions.RuntimeVariablesExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitSwitch(System.Linq.Expressions.SwitchExpression expression) => throw null;
                protected System.Linq.Expressions.SwitchCase BaseVisitSwitchCase(System.Linq.Expressions.SwitchCase expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitTry(System.Linq.Expressions.TryExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitTypeBinary(System.Linq.Expressions.TypeBinaryExpression expression) => throw null;
                protected System.Linq.Expressions.Expression BaseVisitUnary(System.Linq.Expressions.UnaryExpression expression) => throw null;
                protected abstract System.Exception CreateUnhandledItemException<T>(T unhandledItem, string visitMethod);
                protected ThrowingExpressionVisitor() => throw null;
                public override System.Linq.Expressions.Expression Visit(System.Linq.Expressions.Expression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitBinary(System.Linq.Expressions.BinaryExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitBlock(System.Linq.Expressions.BlockExpression expression) => throw null;
                protected override System.Linq.Expressions.CatchBlock VisitCatchBlock(System.Linq.Expressions.CatchBlock expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitConditional(System.Linq.Expressions.ConditionalExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitConstant(System.Linq.Expressions.ConstantExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitDebugInfo(System.Linq.Expressions.DebugInfoExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitDefault(System.Linq.Expressions.DefaultExpression expression) => throw null;
                protected override System.Linq.Expressions.ElementInit VisitElementInit(System.Linq.Expressions.ElementInit elementInit) => throw null;
                protected override System.Linq.Expressions.Expression VisitExtension(System.Linq.Expressions.Expression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitGoto(System.Linq.Expressions.GotoExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitIndex(System.Linq.Expressions.IndexExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitInvocation(System.Linq.Expressions.InvocationExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitLabel(System.Linq.Expressions.LabelExpression expression) => throw null;
                protected override System.Linq.Expressions.LabelTarget VisitLabelTarget(System.Linq.Expressions.LabelTarget expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitLambda<T>(System.Linq.Expressions.Expression<T> expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitListInit(System.Linq.Expressions.ListInitExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitLoop(System.Linq.Expressions.LoopExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitMember(System.Linq.Expressions.MemberExpression expression) => throw null;
                protected override System.Linq.Expressions.MemberAssignment VisitMemberAssignment(System.Linq.Expressions.MemberAssignment memberAssigment) => throw null;
                protected override System.Linq.Expressions.MemberBinding VisitMemberBinding(System.Linq.Expressions.MemberBinding expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitMemberInit(System.Linq.Expressions.MemberInitExpression expression) => throw null;
                protected override System.Linq.Expressions.MemberListBinding VisitMemberListBinding(System.Linq.Expressions.MemberListBinding listBinding) => throw null;
                protected override System.Linq.Expressions.MemberMemberBinding VisitMemberMemberBinding(System.Linq.Expressions.MemberMemberBinding binding) => throw null;
                protected override System.Linq.Expressions.Expression VisitMethodCall(System.Linq.Expressions.MethodCallExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitNew(System.Linq.Expressions.NewExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitNewArray(System.Linq.Expressions.NewArrayExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitParameter(System.Linq.Expressions.ParameterExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitQuerySourceReference(Remotion.Linq.Clauses.Expressions.QuerySourceReferenceExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitRuntimeVariables(System.Linq.Expressions.RuntimeVariablesExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitSwitch(System.Linq.Expressions.SwitchExpression expression) => throw null;
                protected override System.Linq.Expressions.SwitchCase VisitSwitchCase(System.Linq.Expressions.SwitchCase expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitTry(System.Linq.Expressions.TryExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitTypeBinary(System.Linq.Expressions.TypeBinaryExpression expression) => throw null;
                protected override System.Linq.Expressions.Expression VisitUnary(System.Linq.Expressions.UnaryExpression expression) => throw null;
                protected virtual TResult VisitUnhandledItem<TItem, TResult>(TItem unhandledItem, string visitMethod, System.Func<TItem, TResult> baseBehavior) where TItem : TResult => throw null;
                protected virtual System.Linq.Expressions.Expression VisitUnknownStandardExpression(System.Linq.Expressions.Expression expression, string visitMethod, System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> baseBehavior) => throw null;
            }
            public static class TupleExpressionBuilder
            {
                public static System.Linq.Expressions.Expression AggregateExpressionsIntoTuple(System.Collections.Generic.IEnumerable<System.Linq.Expressions.Expression> expressions) => throw null;
                public static System.Collections.Generic.IEnumerable<System.Linq.Expressions.Expression> GetExpressionsFromTuple(System.Linq.Expressions.Expression tupleExpression) => throw null;
            }
        }
        public abstract class QueryableBase<T> : System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<T>, System.Linq.IOrderedQueryable<T>, System.Linq.IOrderedQueryable, System.Linq.IQueryable, System.Linq.IQueryable<T>
        {
            protected QueryableBase(Remotion.Linq.Parsing.Structure.IQueryParser queryParser, Remotion.Linq.IQueryExecutor executor) => throw null;
            protected QueryableBase(System.Linq.IQueryProvider provider) => throw null;
            protected QueryableBase(System.Linq.IQueryProvider provider, System.Linq.Expressions.Expression expression) => throw null;
            public System.Type ElementType { get => throw null; }
            public System.Linq.Expressions.Expression Expression { get => throw null; }
            public System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public System.Linq.IQueryProvider Provider { get => throw null; }
        }
        public sealed class QueryModel
        {
            public void Accept(Remotion.Linq.IQueryModelVisitor visitor) => throw null;
            public System.Collections.ObjectModel.ObservableCollection<Remotion.Linq.Clauses.IBodyClause> BodyClauses { get => throw null; }
            public Remotion.Linq.QueryModel Clone() => throw null;
            public Remotion.Linq.QueryModel Clone(Remotion.Linq.Clauses.QuerySourceMapping querySourceMapping) => throw null;
            public Remotion.Linq.QueryModel ConvertToSubQuery(string itemName) => throw null;
            public QueryModel(Remotion.Linq.Clauses.MainFromClause mainFromClause, Remotion.Linq.Clauses.SelectClause selectClause) => throw null;
            public Remotion.Linq.Clauses.StreamedData.IStreamedData Execute(Remotion.Linq.IQueryExecutor executor) => throw null;
            public string GetNewName(string prefix) => throw null;
            public Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo() => throw null;
            public System.Type GetResultType() => throw null;
            public Remotion.Linq.UniqueIdentifierGenerator GetUniqueIdentfierGenerator() => throw null;
            public bool IsIdentityQuery() => throw null;
            public Remotion.Linq.Clauses.MainFromClause MainFromClause { get => throw null; set { } }
            public System.Collections.ObjectModel.ObservableCollection<Remotion.Linq.Clauses.ResultOperatorBase> ResultOperators { get => throw null; }
            public System.Type ResultTypeOverride { get => throw null; set { } }
            public Remotion.Linq.Clauses.SelectClause SelectClause { get => throw null; set { } }
            public override string ToString() => throw null;
            public void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
        }
        public sealed class QueryModelBuilder
        {
            public void AddClause(Remotion.Linq.Clauses.IClause clause) => throw null;
            public void AddResultOperator(Remotion.Linq.Clauses.ResultOperatorBase resultOperator) => throw null;
            public System.Collections.ObjectModel.ReadOnlyCollection<Remotion.Linq.Clauses.IBodyClause> BodyClauses { get => throw null; }
            public Remotion.Linq.QueryModel Build() => throw null;
            public QueryModelBuilder() => throw null;
            public Remotion.Linq.Clauses.MainFromClause MainFromClause { get => throw null; }
            public System.Collections.ObjectModel.ReadOnlyCollection<Remotion.Linq.Clauses.ResultOperatorBase> ResultOperators { get => throw null; }
            public Remotion.Linq.Clauses.SelectClause SelectClause { get => throw null; }
        }
        public abstract class QueryModelVisitorBase : Remotion.Linq.IQueryModelVisitor
        {
            protected QueryModelVisitorBase() => throw null;
            public virtual void VisitAdditionalFromClause(Remotion.Linq.Clauses.AdditionalFromClause fromClause, Remotion.Linq.QueryModel queryModel, int index) => throw null;
            protected virtual void VisitBodyClauses(System.Collections.ObjectModel.ObservableCollection<Remotion.Linq.Clauses.IBodyClause> bodyClauses, Remotion.Linq.QueryModel queryModel) => throw null;
            public virtual void VisitGroupJoinClause(Remotion.Linq.Clauses.GroupJoinClause groupJoinClause, Remotion.Linq.QueryModel queryModel, int index) => throw null;
            public virtual void VisitJoinClause(Remotion.Linq.Clauses.JoinClause joinClause, Remotion.Linq.QueryModel queryModel, int index) => throw null;
            public virtual void VisitJoinClause(Remotion.Linq.Clauses.JoinClause joinClause, Remotion.Linq.QueryModel queryModel, Remotion.Linq.Clauses.GroupJoinClause groupJoinClause) => throw null;
            public virtual void VisitMainFromClause(Remotion.Linq.Clauses.MainFromClause fromClause, Remotion.Linq.QueryModel queryModel) => throw null;
            public virtual void VisitOrderByClause(Remotion.Linq.Clauses.OrderByClause orderByClause, Remotion.Linq.QueryModel queryModel, int index) => throw null;
            public virtual void VisitOrdering(Remotion.Linq.Clauses.Ordering ordering, Remotion.Linq.QueryModel queryModel, Remotion.Linq.Clauses.OrderByClause orderByClause, int index) => throw null;
            protected virtual void VisitOrderings(System.Collections.ObjectModel.ObservableCollection<Remotion.Linq.Clauses.Ordering> orderings, Remotion.Linq.QueryModel queryModel, Remotion.Linq.Clauses.OrderByClause orderByClause) => throw null;
            public virtual void VisitQueryModel(Remotion.Linq.QueryModel queryModel) => throw null;
            public virtual void VisitResultOperator(Remotion.Linq.Clauses.ResultOperatorBase resultOperator, Remotion.Linq.QueryModel queryModel, int index) => throw null;
            protected virtual void VisitResultOperators(System.Collections.ObjectModel.ObservableCollection<Remotion.Linq.Clauses.ResultOperatorBase> resultOperators, Remotion.Linq.QueryModel queryModel) => throw null;
            public virtual void VisitSelectClause(Remotion.Linq.Clauses.SelectClause selectClause, Remotion.Linq.QueryModel queryModel) => throw null;
            public virtual void VisitWhereClause(Remotion.Linq.Clauses.WhereClause whereClause, Remotion.Linq.QueryModel queryModel, int index) => throw null;
        }
        public abstract class QueryProviderBase : System.Linq.IQueryProvider
        {
            public System.Linq.IQueryable CreateQuery(System.Linq.Expressions.Expression expression) => throw null;
            public abstract System.Linq.IQueryable<T> CreateQuery<T>(System.Linq.Expressions.Expression expression);
            protected QueryProviderBase(Remotion.Linq.Parsing.Structure.IQueryParser queryParser, Remotion.Linq.IQueryExecutor executor) => throw null;
            public virtual Remotion.Linq.Clauses.StreamedData.IStreamedData Execute(System.Linq.Expressions.Expression expression) => throw null;
            TResult System.Linq.IQueryProvider.Execute<TResult>(System.Linq.Expressions.Expression expression) => throw null;
            object System.Linq.IQueryProvider.Execute(System.Linq.Expressions.Expression expression) => throw null;
            public Remotion.Linq.IQueryExecutor Executor { get => throw null; }
            public Remotion.Linq.Parsing.Structure.ExpressionTreeParser ExpressionTreeParser { get => throw null; }
            public virtual Remotion.Linq.QueryModel GenerateQueryModel(System.Linq.Expressions.Expression expression) => throw null;
            public Remotion.Linq.Parsing.Structure.IQueryParser QueryParser { get => throw null; }
        }
        namespace Transformations
        {
            public class SubQueryFromClauseFlattener : Remotion.Linq.QueryModelVisitorBase
            {
                protected virtual void CheckFlattenable(Remotion.Linq.QueryModel subQueryModel) => throw null;
                public SubQueryFromClauseFlattener() => throw null;
                protected virtual void FlattenSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression subQueryExpression, Remotion.Linq.Clauses.IFromClause fromClause, Remotion.Linq.QueryModel queryModel, int destinationIndex) => throw null;
                protected void InsertBodyClauses(System.Collections.ObjectModel.ObservableCollection<Remotion.Linq.Clauses.IBodyClause> bodyClauses, Remotion.Linq.QueryModel destinationQueryModel, int destinationIndex) => throw null;
                public override void VisitAdditionalFromClause(Remotion.Linq.Clauses.AdditionalFromClause fromClause, Remotion.Linq.QueryModel queryModel, int index) => throw null;
                public override void VisitMainFromClause(Remotion.Linq.Clauses.MainFromClause fromClause, Remotion.Linq.QueryModel queryModel) => throw null;
            }
        }
        public sealed class UniqueIdentifierGenerator
        {
            public void AddKnownIdentifier(string identifier) => throw null;
            public UniqueIdentifierGenerator() => throw null;
            public string GetUniqueIdentifier(string prefix) => throw null;
            public void Reset() => throw null;
        }
        namespace Utilities
        {
            public static class ItemTypeReflectionUtility
            {
                public static bool TryGetItemTypeOfClosedGenericIEnumerable(System.Type possibleEnumerableType, out System.Type itemType) => throw null;
            }
        }
    }
}
