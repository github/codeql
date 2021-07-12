// This file contains auto-generated code.

namespace Remotion
{
    namespace Linq
    {
        // Generated from `Remotion.Linq.DefaultQueryProvider` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
        public class DefaultQueryProvider : Remotion.Linq.QueryProviderBase
        {
            public override System.Linq.IQueryable<T> CreateQuery<T>(System.Linq.Expressions.Expression expression) => throw null;
            public DefaultQueryProvider(System.Type queryableType, Remotion.Linq.Parsing.Structure.IQueryParser queryParser, Remotion.Linq.IQueryExecutor executor) : base(default(Remotion.Linq.Parsing.Structure.IQueryParser), default(Remotion.Linq.IQueryExecutor)) => throw null;
            public System.Type QueryableType { get => throw null; }
        }

        // Generated from `Remotion.Linq.IQueryExecutor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
        public interface IQueryExecutor
        {
            System.Collections.Generic.IEnumerable<T> ExecuteCollection<T>(Remotion.Linq.QueryModel queryModel);
            T ExecuteScalar<T>(Remotion.Linq.QueryModel queryModel);
            T ExecuteSingle<T>(Remotion.Linq.QueryModel queryModel, bool returnDefaultWhenEmpty);
        }

        // Generated from `Remotion.Linq.IQueryModelVisitor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
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

        // Generated from `Remotion.Linq.QueryModel` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
        public class QueryModel
        {
            public void Accept(Remotion.Linq.IQueryModelVisitor visitor) => throw null;
            public System.Collections.ObjectModel.ObservableCollection<Remotion.Linq.Clauses.IBodyClause> BodyClauses { get => throw null; set => throw null; }
            public Remotion.Linq.QueryModel Clone(Remotion.Linq.Clauses.QuerySourceMapping querySourceMapping) => throw null;
            public Remotion.Linq.QueryModel Clone() => throw null;
            public Remotion.Linq.QueryModel ConvertToSubQuery(string itemName) => throw null;
            public Remotion.Linq.Clauses.StreamedData.IStreamedData Execute(Remotion.Linq.IQueryExecutor executor) => throw null;
            public string GetNewName(string prefix) => throw null;
            public Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo() => throw null;
            public System.Type GetResultType() => throw null;
            public Remotion.Linq.UniqueIdentifierGenerator GetUniqueIdentfierGenerator() => throw null;
            public bool IsIdentityQuery() => throw null;
            public Remotion.Linq.Clauses.MainFromClause MainFromClause { get => throw null; set => throw null; }
            public QueryModel(Remotion.Linq.Clauses.MainFromClause mainFromClause, Remotion.Linq.Clauses.SelectClause selectClause) => throw null;
            public System.Collections.ObjectModel.ObservableCollection<Remotion.Linq.Clauses.ResultOperatorBase> ResultOperators { get => throw null; set => throw null; }
            public System.Type ResultTypeOverride { get => throw null; set => throw null; }
            public Remotion.Linq.Clauses.SelectClause SelectClause { get => throw null; set => throw null; }
            public override string ToString() => throw null;
            public void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
        }

        // Generated from `Remotion.Linq.QueryModelBuilder` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
        public class QueryModelBuilder
        {
            public void AddClause(Remotion.Linq.Clauses.IClause clause) => throw null;
            public void AddResultOperator(Remotion.Linq.Clauses.ResultOperatorBase resultOperator) => throw null;
            public System.Collections.ObjectModel.ReadOnlyCollection<Remotion.Linq.Clauses.IBodyClause> BodyClauses { get => throw null; }
            public Remotion.Linq.QueryModel Build() => throw null;
            public Remotion.Linq.Clauses.MainFromClause MainFromClause { get => throw null; set => throw null; }
            public QueryModelBuilder() => throw null;
            public System.Collections.ObjectModel.ReadOnlyCollection<Remotion.Linq.Clauses.ResultOperatorBase> ResultOperators { get => throw null; }
            public Remotion.Linq.Clauses.SelectClause SelectClause { get => throw null; set => throw null; }
        }

        // Generated from `Remotion.Linq.QueryModelVisitorBase` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
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

        // Generated from `Remotion.Linq.QueryProviderBase` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
        public abstract class QueryProviderBase : System.Linq.IQueryProvider
        {
            public abstract System.Linq.IQueryable<T> CreateQuery<T>(System.Linq.Expressions.Expression expression);
            public System.Linq.IQueryable CreateQuery(System.Linq.Expressions.Expression expression) => throw null;
            public virtual Remotion.Linq.Clauses.StreamedData.IStreamedData Execute(System.Linq.Expressions.Expression expression) => throw null;
            object System.Linq.IQueryProvider.Execute(System.Linq.Expressions.Expression expression) => throw null;
            TResult System.Linq.IQueryProvider.Execute<TResult>(System.Linq.Expressions.Expression expression) => throw null;
            public Remotion.Linq.IQueryExecutor Executor { get => throw null; }
            public Remotion.Linq.Parsing.Structure.ExpressionTreeParser ExpressionTreeParser { get => throw null; }
            public virtual Remotion.Linq.QueryModel GenerateQueryModel(System.Linq.Expressions.Expression expression) => throw null;
            public Remotion.Linq.Parsing.Structure.IQueryParser QueryParser { get => throw null; }
            protected QueryProviderBase(Remotion.Linq.Parsing.Structure.IQueryParser queryParser, Remotion.Linq.IQueryExecutor executor) => throw null;
        }

        // Generated from `Remotion.Linq.QueryableBase<>` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
        public abstract class QueryableBase<T> : System.Linq.IQueryable<T>, System.Linq.IQueryable, System.Linq.IOrderedQueryable<T>, System.Linq.IOrderedQueryable, System.Collections.IEnumerable, System.Collections.Generic.IEnumerable<T>
        {
            public System.Type ElementType { get => throw null; }
            public System.Linq.Expressions.Expression Expression { get => throw null; set => throw null; }
            public System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
            public System.Linq.IQueryProvider Provider { get => throw null; }
            protected QueryableBase(System.Linq.IQueryProvider provider, System.Linq.Expressions.Expression expression) => throw null;
            protected QueryableBase(System.Linq.IQueryProvider provider) => throw null;
            protected QueryableBase(Remotion.Linq.Parsing.Structure.IQueryParser queryParser, Remotion.Linq.IQueryExecutor executor) => throw null;
        }

        // Generated from `Remotion.Linq.UniqueIdentifierGenerator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
        public class UniqueIdentifierGenerator
        {
            public void AddKnownIdentifier(string identifier) => throw null;
            public string GetUniqueIdentifier(string prefix) => throw null;
            public void Reset() => throw null;
            public UniqueIdentifierGenerator() => throw null;
        }

        namespace Clauses
        {
            // Generated from `Remotion.Linq.Clauses.AdditionalFromClause` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public class AdditionalFromClause : Remotion.Linq.Clauses.FromClauseBase, Remotion.Linq.Clauses.IClause, Remotion.Linq.Clauses.IBodyClause
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, int index) => throw null;
                public AdditionalFromClause(string itemName, System.Type itemType, System.Linq.Expressions.Expression fromExpression) : base(default(string), default(System.Type), default(System.Linq.Expressions.Expression)) => throw null;
                public Remotion.Linq.Clauses.AdditionalFromClause Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                Remotion.Linq.Clauses.IBodyClause Remotion.Linq.Clauses.IBodyClause.Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
            }

            // Generated from `Remotion.Linq.Clauses.CloneContext` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public class CloneContext
            {
                public CloneContext(Remotion.Linq.Clauses.QuerySourceMapping querySourceMapping) => throw null;
                public Remotion.Linq.Clauses.QuerySourceMapping QuerySourceMapping { get => throw null; set => throw null; }
            }

            // Generated from `Remotion.Linq.Clauses.FromClauseBase` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public abstract class FromClauseBase : Remotion.Linq.Clauses.IQuerySource, Remotion.Linq.Clauses.IFromClause, Remotion.Linq.Clauses.IClause
            {
                public virtual void CopyFromSource(Remotion.Linq.Clauses.IFromClause source) => throw null;
                internal FromClauseBase(string itemName, System.Type itemType, System.Linq.Expressions.Expression fromExpression) => throw null;
                public System.Linq.Expressions.Expression FromExpression { get => throw null; set => throw null; }
                public string ItemName { get => throw null; set => throw null; }
                public System.Type ItemType { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public virtual void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
            }

            // Generated from `Remotion.Linq.Clauses.GroupJoinClause` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public class GroupJoinClause : Remotion.Linq.Clauses.IQuerySource, Remotion.Linq.Clauses.IClause, Remotion.Linq.Clauses.IBodyClause
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, int index) => throw null;
                public Remotion.Linq.Clauses.GroupJoinClause Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                Remotion.Linq.Clauses.IBodyClause Remotion.Linq.Clauses.IBodyClause.Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public GroupJoinClause(string itemName, System.Type itemType, Remotion.Linq.Clauses.JoinClause joinClause) => throw null;
                public string ItemName { get => throw null; set => throw null; }
                public System.Type ItemType { get => throw null; set => throw null; }
                public Remotion.Linq.Clauses.JoinClause JoinClause { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
            }

            // Generated from `Remotion.Linq.Clauses.IBodyClause` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public interface IBodyClause : Remotion.Linq.Clauses.IClause
            {
                void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, int index);
                Remotion.Linq.Clauses.IBodyClause Clone(Remotion.Linq.Clauses.CloneContext cloneContext);
            }

            // Generated from `Remotion.Linq.Clauses.IClause` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public interface IClause
            {
                void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation);
            }

            // Generated from `Remotion.Linq.Clauses.IFromClause` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public interface IFromClause : Remotion.Linq.Clauses.IQuerySource, Remotion.Linq.Clauses.IClause
            {
                void CopyFromSource(Remotion.Linq.Clauses.IFromClause source);
                System.Linq.Expressions.Expression FromExpression { get; }
            }

            // Generated from `Remotion.Linq.Clauses.IQuerySource` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public interface IQuerySource
            {
                string ItemName { get; }
                System.Type ItemType { get; }
            }

            // Generated from `Remotion.Linq.Clauses.JoinClause` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public class JoinClause : Remotion.Linq.Clauses.IQuerySource, Remotion.Linq.Clauses.IClause, Remotion.Linq.Clauses.IBodyClause
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, int index) => throw null;
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, Remotion.Linq.Clauses.GroupJoinClause groupJoinClause) => throw null;
                public Remotion.Linq.Clauses.JoinClause Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                Remotion.Linq.Clauses.IBodyClause Remotion.Linq.Clauses.IBodyClause.Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public System.Linq.Expressions.Expression InnerKeySelector { get => throw null; set => throw null; }
                public System.Linq.Expressions.Expression InnerSequence { get => throw null; set => throw null; }
                public string ItemName { get => throw null; set => throw null; }
                public System.Type ItemType { get => throw null; set => throw null; }
                public JoinClause(string itemName, System.Type itemType, System.Linq.Expressions.Expression innerSequence, System.Linq.Expressions.Expression outerKeySelector, System.Linq.Expressions.Expression innerKeySelector) => throw null;
                public System.Linq.Expressions.Expression OuterKeySelector { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
            }

            // Generated from `Remotion.Linq.Clauses.MainFromClause` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public class MainFromClause : Remotion.Linq.Clauses.FromClauseBase
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel) => throw null;
                public Remotion.Linq.Clauses.MainFromClause Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public MainFromClause(string itemName, System.Type itemType, System.Linq.Expressions.Expression fromExpression) : base(default(string), default(System.Type), default(System.Linq.Expressions.Expression)) => throw null;
            }

            // Generated from `Remotion.Linq.Clauses.OrderByClause` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public class OrderByClause : Remotion.Linq.Clauses.IClause, Remotion.Linq.Clauses.IBodyClause
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, int index) => throw null;
                public Remotion.Linq.Clauses.OrderByClause Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                Remotion.Linq.Clauses.IBodyClause Remotion.Linq.Clauses.IBodyClause.Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public OrderByClause() => throw null;
                public System.Collections.ObjectModel.ObservableCollection<Remotion.Linq.Clauses.Ordering> Orderings { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
            }

            // Generated from `Remotion.Linq.Clauses.Ordering` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public class Ordering
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, Remotion.Linq.Clauses.OrderByClause orderByClause, int index) => throw null;
                public Remotion.Linq.Clauses.Ordering Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public System.Linq.Expressions.Expression Expression { get => throw null; set => throw null; }
                public Ordering(System.Linq.Expressions.Expression expression, Remotion.Linq.Clauses.OrderingDirection direction) => throw null;
                public Remotion.Linq.Clauses.OrderingDirection OrderingDirection { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
            }

            // Generated from `Remotion.Linq.Clauses.OrderingDirection` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public enum OrderingDirection
            {
                Asc,
                Desc,
            }

            // Generated from `Remotion.Linq.Clauses.QuerySourceMapping` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public class QuerySourceMapping
            {
                public void AddMapping(Remotion.Linq.Clauses.IQuerySource querySource, System.Linq.Expressions.Expression expression) => throw null;
                public bool ContainsMapping(Remotion.Linq.Clauses.IQuerySource querySource) => throw null;
                public System.Linq.Expressions.Expression GetExpression(Remotion.Linq.Clauses.IQuerySource querySource) => throw null;
                public QuerySourceMapping() => throw null;
                public void RemoveMapping(Remotion.Linq.Clauses.IQuerySource querySource) => throw null;
                public void ReplaceMapping(Remotion.Linq.Clauses.IQuerySource querySource, System.Linq.Expressions.Expression expression) => throw null;
            }

            // Generated from `Remotion.Linq.Clauses.ResultOperatorBase` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public abstract class ResultOperatorBase
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, int index) => throw null;
                protected void CheckSequenceItemType(Remotion.Linq.Clauses.StreamedData.StreamedSequenceInfo inputInfo, System.Type expectedItemType) => throw null;
                public abstract Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext);
                public abstract Remotion.Linq.Clauses.StreamedData.IStreamedData ExecuteInMemory(Remotion.Linq.Clauses.StreamedData.IStreamedData input);
                protected T GetConstantValueFromExpression<T>(string expressionName, System.Linq.Expressions.Expression expression) => throw null;
                public abstract Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo);
                protected object InvokeExecuteMethod(System.Reflection.MethodInfo method, object input) => throw null;
                protected ResultOperatorBase() => throw null;
                public abstract void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation);
            }

            // Generated from `Remotion.Linq.Clauses.SelectClause` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public class SelectClause : Remotion.Linq.Clauses.IClause
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel) => throw null;
                public Remotion.Linq.Clauses.SelectClause Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public Remotion.Linq.Clauses.StreamedData.StreamedSequenceInfo GetOutputDataInfo() => throw null;
                public SelectClause(System.Linq.Expressions.Expression selector) => throw null;
                public System.Linq.Expressions.Expression Selector { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
            }

            // Generated from `Remotion.Linq.Clauses.WhereClause` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public class WhereClause : Remotion.Linq.Clauses.IClause, Remotion.Linq.Clauses.IBodyClause
            {
                public void Accept(Remotion.Linq.IQueryModelVisitor visitor, Remotion.Linq.QueryModel queryModel, int index) => throw null;
                public Remotion.Linq.Clauses.WhereClause Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                Remotion.Linq.Clauses.IBodyClause Remotion.Linq.Clauses.IBodyClause.Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                public System.Linq.Expressions.Expression Predicate { get => throw null; set => throw null; }
                public override string ToString() => throw null;
                public void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                public WhereClause(System.Linq.Expressions.Expression predicate) => throw null;
            }

            namespace ExpressionVisitors
            {
                // Generated from `Remotion.Linq.Clauses.ExpressionVisitors.AccessorFindingExpressionVisitor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class AccessorFindingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.LambdaExpression FindAccessorLambda(System.Linq.Expressions.Expression searchedExpression, System.Linq.Expressions.Expression fullExpression, System.Linq.Expressions.ParameterExpression inputParameter) => throw null;
                    public override System.Linq.Expressions.Expression Visit(System.Linq.Expressions.Expression expression) => throw null;
                    protected override System.Linq.Expressions.MemberAssignment VisitMemberAssignment(System.Linq.Expressions.MemberAssignment memberAssigment) => throw null;
                    protected override System.Linq.Expressions.MemberBinding VisitMemberBinding(System.Linq.Expressions.MemberBinding memberBinding) => throw null;
                    protected internal override System.Linq.Expressions.Expression VisitNew(System.Linq.Expressions.NewExpression expression) => throw null;
                    protected internal override System.Linq.Expressions.Expression VisitUnary(System.Linq.Expressions.UnaryExpression expression) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ExpressionVisitors.CloningExpressionVisitor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class CloningExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.Expression AdjustExpressionAfterCloning(System.Linq.Expressions.Expression expression, Remotion.Linq.Clauses.QuerySourceMapping querySourceMapping) => throw null;
                    protected internal override System.Linq.Expressions.Expression VisitQuerySourceReference(Remotion.Linq.Clauses.Expressions.QuerySourceReferenceExpression expression) => throw null;
                    protected internal override System.Linq.Expressions.Expression VisitSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression expression) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ExpressionVisitors.ReferenceReplacingExpressionVisitor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class ReferenceReplacingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.Expression ReplaceClauseReferences(System.Linq.Expressions.Expression expression, Remotion.Linq.Clauses.QuerySourceMapping querySourceMapping, bool throwOnUnmappedReferences) => throw null;
                    protected internal override System.Linq.Expressions.Expression VisitQuerySourceReference(Remotion.Linq.Clauses.Expressions.QuerySourceReferenceExpression expression) => throw null;
                    protected internal override System.Linq.Expressions.Expression VisitSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression expression) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ExpressionVisitors.ReverseResolvingExpressionVisitor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class ReverseResolvingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.LambdaExpression ReverseResolve(System.Linq.Expressions.Expression itemExpression, System.Linq.Expressions.Expression resolvedExpression) => throw null;
                    public static System.Linq.Expressions.LambdaExpression ReverseResolveLambda(System.Linq.Expressions.Expression itemExpression, System.Linq.Expressions.LambdaExpression resolvedExpression, int parameterInsertionPosition) => throw null;
                    protected internal override System.Linq.Expressions.Expression VisitQuerySourceReference(Remotion.Linq.Clauses.Expressions.QuerySourceReferenceExpression expression) => throw null;
                }

            }
            namespace Expressions
            {
                // Generated from `Remotion.Linq.Clauses.Expressions.IPartialEvaluationExceptionExpressionVisitor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public interface IPartialEvaluationExceptionExpressionVisitor
                {
                    System.Linq.Expressions.Expression VisitPartialEvaluationException(Remotion.Linq.Clauses.Expressions.PartialEvaluationExceptionExpression partialEvaluationExceptionExpression);
                }

                // Generated from `Remotion.Linq.Clauses.Expressions.IVBSpecificExpressionVisitor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public interface IVBSpecificExpressionVisitor
                {
                    System.Linq.Expressions.Expression VisitVBStringComparison(Remotion.Linq.Clauses.Expressions.VBStringComparisonExpression vbStringComparisonExpression);
                }

                // Generated from `Remotion.Linq.Clauses.Expressions.PartialEvaluationExceptionExpression` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class PartialEvaluationExceptionExpression : System.Linq.Expressions.Expression
                {
                    protected internal override System.Linq.Expressions.Expression Accept(System.Linq.Expressions.ExpressionVisitor visitor) => throw null;
                    public override bool CanReduce { get => throw null; }
                    public System.Linq.Expressions.Expression EvaluatedExpression { get => throw null; }
                    public System.Exception Exception { get => throw null; }
                    public override System.Linq.Expressions.ExpressionType NodeType { get => throw null; }
                    public PartialEvaluationExceptionExpression(System.Exception exception, System.Linq.Expressions.Expression evaluatedExpression) => throw null;
                    public override System.Linq.Expressions.Expression Reduce() => throw null;
                    public override string ToString() => throw null;
                    public override System.Type Type { get => throw null; }
                    protected internal override System.Linq.Expressions.Expression VisitChildren(System.Linq.Expressions.ExpressionVisitor visitor) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.Expressions.QuerySourceReferenceExpression` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class QuerySourceReferenceExpression : System.Linq.Expressions.Expression
                {
                    protected internal override System.Linq.Expressions.Expression Accept(System.Linq.Expressions.ExpressionVisitor visitor) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public override System.Linq.Expressions.ExpressionType NodeType { get => throw null; }
                    public QuerySourceReferenceExpression(Remotion.Linq.Clauses.IQuerySource querySource) => throw null;
                    public Remotion.Linq.Clauses.IQuerySource ReferencedQuerySource { get => throw null; set => throw null; }
                    public override string ToString() => throw null;
                    public override System.Type Type { get => throw null; }
                }

                // Generated from `Remotion.Linq.Clauses.Expressions.SubQueryExpression` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class SubQueryExpression : System.Linq.Expressions.Expression
                {
                    protected internal override System.Linq.Expressions.Expression Accept(System.Linq.Expressions.ExpressionVisitor visitor) => throw null;
                    public override System.Linq.Expressions.ExpressionType NodeType { get => throw null; }
                    public Remotion.Linq.QueryModel QueryModel { get => throw null; set => throw null; }
                    public SubQueryExpression(Remotion.Linq.QueryModel queryModel) => throw null;
                    public override string ToString() => throw null;
                    public override System.Type Type { get => throw null; }
                }

                // Generated from `Remotion.Linq.Clauses.Expressions.VBStringComparisonExpression` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class VBStringComparisonExpression : System.Linq.Expressions.Expression
                {
                    protected internal override System.Linq.Expressions.Expression Accept(System.Linq.Expressions.ExpressionVisitor visitor) => throw null;
                    public override bool CanReduce { get => throw null; }
                    public System.Linq.Expressions.Expression Comparison { get => throw null; }
                    public override System.Linq.Expressions.ExpressionType NodeType { get => throw null; }
                    public override System.Linq.Expressions.Expression Reduce() => throw null;
                    public bool TextCompare { get => throw null; }
                    public override string ToString() => throw null;
                    public override System.Type Type { get => throw null; }
                    public VBStringComparisonExpression(System.Linq.Expressions.Expression comparison, bool textCompare) => throw null;
                    protected internal override System.Linq.Expressions.Expression VisitChildren(System.Linq.Expressions.ExpressionVisitor visitor) => throw null;
                }

            }
            namespace ResultOperators
            {
                // Generated from `Remotion.Linq.Clauses.ResultOperators.AggregateFromSeedResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class AggregateFromSeedResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public AggregateFromSeedResultOperator(System.Linq.Expressions.Expression seed, System.Linq.Expressions.LambdaExpression func, System.Linq.Expressions.LambdaExpression optionalResultSelector) => throw null;
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteAggregateInMemory<TInput, TAggregate, TResult>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<TInput>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public System.Linq.Expressions.LambdaExpression Func { get => throw null; set => throw null; }
                    public T GetConstantSeed<T>() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public System.Linq.Expressions.LambdaExpression OptionalResultSelector { get => throw null; set => throw null; }
                    public System.Linq.Expressions.Expression Seed { get => throw null; set => throw null; }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.AggregateResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class AggregateResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public AggregateResultOperator(System.Linq.Expressions.LambdaExpression func) => throw null;
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public System.Linq.Expressions.LambdaExpression Func { get => throw null; set => throw null; }
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.AllResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class AllResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public AllResultOperator(System.Linq.Expressions.Expression predicate) => throw null;
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public System.Linq.Expressions.Expression Predicate { get => throw null; set => throw null; }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.AnyResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class AnyResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public AnyResultOperator() => throw null;
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.AsQueryableResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class AsQueryableResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
                {
                    public AsQueryableResultOperator() => throw null;
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    // Generated from `Remotion.Linq.Clauses.ResultOperators.AsQueryableResultOperator+ISupportedByIQueryModelVistor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public interface ISupportedByIQueryModelVistor
                    {
                    }


                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.AverageResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class AverageResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public AverageResultOperator() => throw null;
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.CastResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class CastResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceFromSequenceResultOperatorBase
                {
                    public System.Type CastItemType { get => throw null; set => throw null; }
                    public CastResultOperator(System.Type castItemType) => throw null;
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<TInput>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.ChoiceResultOperatorBase` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public abstract class ChoiceResultOperatorBase : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    protected ChoiceResultOperatorBase(bool returnDefaultWhenEmpty) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    protected Remotion.Linq.Clauses.StreamedData.StreamedValueInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.StreamedSequenceInfo inputSequenceInfo) => throw null;
                    public bool ReturnDefaultWhenEmpty { get => throw null; set => throw null; }
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.ConcatResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class ConcatResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceFromSequenceResultOperatorBase, Remotion.Linq.Clauses.IQuerySource
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public ConcatResultOperator(string itemName, System.Type itemType, System.Linq.Expressions.Expression source2) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public System.Collections.IEnumerable GetConstantSource2() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public string ItemName { get => throw null; set => throw null; }
                    public System.Type ItemType { get => throw null; set => throw null; }
                    public System.Linq.Expressions.Expression Source2 { get => throw null; set => throw null; }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.ContainsResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class ContainsResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public ContainsResultOperator(System.Linq.Expressions.Expression item) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public T GetConstantItem<T>() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public System.Linq.Expressions.Expression Item { get => throw null; set => throw null; }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.CountResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class CountResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public CountResultOperator() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.DefaultIfEmptyResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class DefaultIfEmptyResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public DefaultIfEmptyResultOperator(System.Linq.Expressions.Expression optionalDefaultValue) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public object GetConstantOptionalDefaultValue() => throw null;
                    public System.Linq.Expressions.Expression OptionalDefaultValue { get => throw null; set => throw null; }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.DistinctResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class DistinctResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public DistinctResultOperator() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.ExceptResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class ExceptResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public ExceptResultOperator(System.Linq.Expressions.Expression source2) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public System.Collections.Generic.IEnumerable<T> GetConstantSource2<T>() => throw null;
                    public System.Linq.Expressions.Expression Source2 { get => throw null; set => throw null; }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.FirstResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class FirstResultOperator : Remotion.Linq.Clauses.ResultOperators.ChoiceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public FirstResultOperator(bool returnDefaultWhenEmpty) : base(default(bool)) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.GroupResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class GroupResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceFromSequenceResultOperatorBase, Remotion.Linq.Clauses.IQuerySource
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public System.Linq.Expressions.Expression ElementSelector { get => throw null; set => throw null; }
                    public Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteGroupingInMemory<TSource, TKey, TElement>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<TInput>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public GroupResultOperator(string itemName, System.Linq.Expressions.Expression keySelector, System.Linq.Expressions.Expression elementSelector) => throw null;
                    public string ItemName { get => throw null; set => throw null; }
                    public System.Type ItemType { get => throw null; }
                    public System.Linq.Expressions.Expression KeySelector { get => throw null; set => throw null; }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.IntersectResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class IntersectResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public System.Collections.Generic.IEnumerable<T> GetConstantSource2<T>() => throw null;
                    public IntersectResultOperator(System.Linq.Expressions.Expression source2) => throw null;
                    public System.Linq.Expressions.Expression Source2 { get => throw null; set => throw null; }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.LastResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class LastResultOperator : Remotion.Linq.Clauses.ResultOperators.ChoiceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public LastResultOperator(bool returnDefaultWhenEmpty) : base(default(bool)) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.LongCountResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class LongCountResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public LongCountResultOperator() => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.MaxResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class MaxResultOperator : Remotion.Linq.Clauses.ResultOperators.ChoiceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public MaxResultOperator() : base(default(bool)) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.MinResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class MinResultOperator : Remotion.Linq.Clauses.ResultOperators.ChoiceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public MinResultOperator() : base(default(bool)) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.OfTypeResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class OfTypeResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceFromSequenceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<TInput>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public OfTypeResultOperator(System.Type searchedItemType) => throw null;
                    public System.Type SearchedItemType { get => throw null; set => throw null; }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.ReverseResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class ReverseResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public ReverseResultOperator() => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.SequenceFromSequenceResultOperatorBase` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public abstract class SequenceFromSequenceResultOperatorBase : Remotion.Linq.Clauses.ResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedData ExecuteInMemory(Remotion.Linq.Clauses.StreamedData.IStreamedData input) => throw null;
                    public abstract Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input);
                    protected SequenceFromSequenceResultOperatorBase() => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public abstract class SequenceTypePreservingResultOperatorBase : Remotion.Linq.Clauses.ResultOperators.SequenceFromSequenceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    protected Remotion.Linq.Clauses.StreamedData.StreamedSequenceInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.StreamedSequenceInfo inputSequenceInfo) => throw null;
                    protected SequenceTypePreservingResultOperatorBase() => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.SingleResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class SingleResultOperator : Remotion.Linq.Clauses.ResultOperators.ChoiceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public SingleResultOperator(bool returnDefaultWhenEmpty) : base(default(bool)) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.SkipResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class SkipResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public System.Linq.Expressions.Expression Count { get => throw null; set => throw null; }
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public int GetConstantCount() => throw null;
                    public SkipResultOperator(System.Linq.Expressions.Expression count) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.SumResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class SumResultOperator : Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public SumResultOperator() => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.TakeResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class TakeResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceTypePreservingResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public System.Linq.Expressions.Expression Count { get => throw null; set => throw null; }
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public int GetConstantCount() => throw null;
                    public TakeResultOperator(System.Linq.Expressions.Expression count) => throw null;
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.UnionResultOperator` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class UnionResultOperator : Remotion.Linq.Clauses.ResultOperators.SequenceFromSequenceResultOperatorBase, Remotion.Linq.Clauses.IQuerySource
                {
                    public override Remotion.Linq.Clauses.ResultOperatorBase Clone(Remotion.Linq.Clauses.CloneContext cloneContext) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.StreamedSequence ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence input) => throw null;
                    public System.Collections.IEnumerable GetConstantSource2() => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo GetOutputDataInfo(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo inputInfo) => throw null;
                    public string ItemName { get => throw null; set => throw null; }
                    public System.Type ItemType { get => throw null; set => throw null; }
                    public System.Linq.Expressions.Expression Source2 { get => throw null; set => throw null; }
                    public override string ToString() => throw null;
                    public override void TransformExpressions(System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> transformation) => throw null;
                    public UnionResultOperator(string itemName, System.Type itemType, System.Linq.Expressions.Expression source2) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.ResultOperators.ValueFromSequenceResultOperatorBase` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public abstract class ValueFromSequenceResultOperatorBase : Remotion.Linq.Clauses.ResultOperatorBase
                {
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedData ExecuteInMemory(Remotion.Linq.Clauses.StreamedData.IStreamedData input) => throw null;
                    public abstract Remotion.Linq.Clauses.StreamedData.StreamedValue ExecuteInMemory<T>(Remotion.Linq.Clauses.StreamedData.StreamedSequence sequence);
                    protected ValueFromSequenceResultOperatorBase() => throw null;
                }

            }
            namespace StreamedData
            {
                // Generated from `Remotion.Linq.Clauses.StreamedData.IStreamedData` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public interface IStreamedData
                {
                    Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo DataInfo { get; }
                    object Value { get; }
                }

                // Generated from `Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public interface IStreamedDataInfo : System.IEquatable<Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo>
                {
                    Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo AdjustDataType(System.Type dataType);
                    System.Type DataType { get; }
                    Remotion.Linq.Clauses.StreamedData.IStreamedData ExecuteQueryModel(Remotion.Linq.QueryModel queryModel, Remotion.Linq.IQueryExecutor executor);
                }

                // Generated from `Remotion.Linq.Clauses.StreamedData.StreamedScalarValueInfo` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class StreamedScalarValueInfo : Remotion.Linq.Clauses.StreamedData.StreamedValueInfo
                {
                    protected override Remotion.Linq.Clauses.StreamedData.StreamedValueInfo CloneWithNewDataType(System.Type dataType) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedData ExecuteQueryModel(Remotion.Linq.QueryModel queryModel, Remotion.Linq.IQueryExecutor executor) => throw null;
                    public object ExecuteScalarQueryModel<T>(Remotion.Linq.QueryModel queryModel, Remotion.Linq.IQueryExecutor executor) => throw null;
                    public StreamedScalarValueInfo(System.Type dataType) : base(default(System.Type)) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.StreamedData.StreamedSequence` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class StreamedSequence : Remotion.Linq.Clauses.StreamedData.IStreamedData
                {
                    public Remotion.Linq.Clauses.StreamedData.StreamedSequenceInfo DataInfo { get => throw null; set => throw null; }
                    Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo Remotion.Linq.Clauses.StreamedData.IStreamedData.DataInfo { get => throw null; }
                    public System.Collections.Generic.IEnumerable<T> GetTypedSequence<T>() => throw null;
                    public System.Collections.IEnumerable Sequence { get => throw null; set => throw null; }
                    public StreamedSequence(System.Collections.IEnumerable sequence, Remotion.Linq.Clauses.StreamedData.StreamedSequenceInfo streamedSequenceInfo) => throw null;
                    object Remotion.Linq.Clauses.StreamedData.IStreamedData.Value { get => throw null; }
                }

                // Generated from `Remotion.Linq.Clauses.StreamedData.StreamedSequenceInfo` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class StreamedSequenceInfo : System.IEquatable<Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo>, Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo
                {
                    public Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo AdjustDataType(System.Type dataType) => throw null;
                    public System.Type DataType { get => throw null; set => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public bool Equals(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo obj) => throw null;
                    public System.Collections.IEnumerable ExecuteCollectionQueryModel<T>(Remotion.Linq.QueryModel queryModel, Remotion.Linq.IQueryExecutor executor) => throw null;
                    public Remotion.Linq.Clauses.StreamedData.IStreamedData ExecuteQueryModel(Remotion.Linq.QueryModel queryModel, Remotion.Linq.IQueryExecutor executor) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Linq.Expressions.Expression ItemExpression { get => throw null; set => throw null; }
                    public System.Type ResultItemType { get => throw null; set => throw null; }
                    public StreamedSequenceInfo(System.Type dataType, System.Linq.Expressions.Expression itemExpression) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.StreamedData.StreamedSingleValueInfo` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class StreamedSingleValueInfo : Remotion.Linq.Clauses.StreamedData.StreamedValueInfo
                {
                    protected override Remotion.Linq.Clauses.StreamedData.StreamedValueInfo CloneWithNewDataType(System.Type dataType) => throw null;
                    public override bool Equals(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo obj) => throw null;
                    public override Remotion.Linq.Clauses.StreamedData.IStreamedData ExecuteQueryModel(Remotion.Linq.QueryModel queryModel, Remotion.Linq.IQueryExecutor executor) => throw null;
                    public object ExecuteSingleQueryModel<T>(Remotion.Linq.QueryModel queryModel, Remotion.Linq.IQueryExecutor executor) => throw null;
                    public override int GetHashCode() => throw null;
                    public bool ReturnDefaultWhenEmpty { get => throw null; }
                    public StreamedSingleValueInfo(System.Type dataType, bool returnDefaultWhenEmpty) : base(default(System.Type)) => throw null;
                }

                // Generated from `Remotion.Linq.Clauses.StreamedData.StreamedValue` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class StreamedValue : Remotion.Linq.Clauses.StreamedData.IStreamedData
                {
                    public Remotion.Linq.Clauses.StreamedData.StreamedValueInfo DataInfo { get => throw null; set => throw null; }
                    Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo Remotion.Linq.Clauses.StreamedData.IStreamedData.DataInfo { get => throw null; }
                    public T GetTypedValue<T>() => throw null;
                    public StreamedValue(object value, Remotion.Linq.Clauses.StreamedData.StreamedValueInfo streamedValueInfo) => throw null;
                    public object Value { get => throw null; set => throw null; }
                }

                // Generated from `Remotion.Linq.Clauses.StreamedData.StreamedValueInfo` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public abstract class StreamedValueInfo : System.IEquatable<Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo>, Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo
                {
                    public virtual Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo AdjustDataType(System.Type dataType) => throw null;
                    protected abstract Remotion.Linq.Clauses.StreamedData.StreamedValueInfo CloneWithNewDataType(System.Type dataType);
                    public System.Type DataType { get => throw null; set => throw null; }
                    public virtual bool Equals(Remotion.Linq.Clauses.StreamedData.IStreamedDataInfo obj) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public abstract Remotion.Linq.Clauses.StreamedData.IStreamedData ExecuteQueryModel(Remotion.Linq.QueryModel queryModel, Remotion.Linq.IQueryExecutor executor);
                    public override int GetHashCode() => throw null;
                    internal StreamedValueInfo(System.Type dataType) => throw null;
                }

            }
        }
        namespace Parsing
        {
            // Generated from `Remotion.Linq.Parsing.ParserException` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public abstract class ParserException : System.Exception
            {
            }

            // Generated from `Remotion.Linq.Parsing.RelinqExpressionVisitor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public abstract class RelinqExpressionVisitor : System.Linq.Expressions.ExpressionVisitor
            {
                public static System.Collections.Generic.IEnumerable<System.Linq.Expressions.Expression> AdjustArgumentsForNewExpression(System.Collections.Generic.IList<System.Linq.Expressions.Expression> arguments, System.Collections.Generic.IList<System.Reflection.MemberInfo> members) => throw null;
                protected RelinqExpressionVisitor() => throw null;
                protected internal override System.Linq.Expressions.Expression VisitNew(System.Linq.Expressions.NewExpression expression) => throw null;
                protected internal virtual System.Linq.Expressions.Expression VisitQuerySourceReference(Remotion.Linq.Clauses.Expressions.QuerySourceReferenceExpression expression) => throw null;
                protected internal virtual System.Linq.Expressions.Expression VisitSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression expression) => throw null;
            }

            // Generated from `Remotion.Linq.Parsing.ThrowingExpressionVisitor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
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
                protected internal override System.Linq.Expressions.Expression VisitBinary(System.Linq.Expressions.BinaryExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitBlock(System.Linq.Expressions.BlockExpression expression) => throw null;
                protected override System.Linq.Expressions.CatchBlock VisitCatchBlock(System.Linq.Expressions.CatchBlock expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitConditional(System.Linq.Expressions.ConditionalExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitConstant(System.Linq.Expressions.ConstantExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitDebugInfo(System.Linq.Expressions.DebugInfoExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitDefault(System.Linq.Expressions.DefaultExpression expression) => throw null;
                protected override System.Linq.Expressions.ElementInit VisitElementInit(System.Linq.Expressions.ElementInit elementInit) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitExtension(System.Linq.Expressions.Expression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitGoto(System.Linq.Expressions.GotoExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitIndex(System.Linq.Expressions.IndexExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitInvocation(System.Linq.Expressions.InvocationExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitLabel(System.Linq.Expressions.LabelExpression expression) => throw null;
                protected override System.Linq.Expressions.LabelTarget VisitLabelTarget(System.Linq.Expressions.LabelTarget expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitLambda<T>(System.Linq.Expressions.Expression<T> expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitListInit(System.Linq.Expressions.ListInitExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitLoop(System.Linq.Expressions.LoopExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitMember(System.Linq.Expressions.MemberExpression expression) => throw null;
                protected override System.Linq.Expressions.MemberAssignment VisitMemberAssignment(System.Linq.Expressions.MemberAssignment memberAssigment) => throw null;
                protected override System.Linq.Expressions.MemberBinding VisitMemberBinding(System.Linq.Expressions.MemberBinding expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitMemberInit(System.Linq.Expressions.MemberInitExpression expression) => throw null;
                protected override System.Linq.Expressions.MemberListBinding VisitMemberListBinding(System.Linq.Expressions.MemberListBinding listBinding) => throw null;
                protected override System.Linq.Expressions.MemberMemberBinding VisitMemberMemberBinding(System.Linq.Expressions.MemberMemberBinding binding) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitMethodCall(System.Linq.Expressions.MethodCallExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitNew(System.Linq.Expressions.NewExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitNewArray(System.Linq.Expressions.NewArrayExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitParameter(System.Linq.Expressions.ParameterExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitQuerySourceReference(Remotion.Linq.Clauses.Expressions.QuerySourceReferenceExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitRuntimeVariables(System.Linq.Expressions.RuntimeVariablesExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitSwitch(System.Linq.Expressions.SwitchExpression expression) => throw null;
                protected override System.Linq.Expressions.SwitchCase VisitSwitchCase(System.Linq.Expressions.SwitchCase expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitTry(System.Linq.Expressions.TryExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitTypeBinary(System.Linq.Expressions.TypeBinaryExpression expression) => throw null;
                protected internal override System.Linq.Expressions.Expression VisitUnary(System.Linq.Expressions.UnaryExpression expression) => throw null;
                protected virtual TResult VisitUnhandledItem<TItem, TResult>(TItem unhandledItem, string visitMethod, System.Func<TItem, TResult> baseBehavior) where TItem : TResult => throw null;
                protected virtual System.Linq.Expressions.Expression VisitUnknownStandardExpression(System.Linq.Expressions.Expression expression, string visitMethod, System.Func<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> baseBehavior) => throw null;
            }

            // Generated from `Remotion.Linq.Parsing.TupleExpressionBuilder` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public static class TupleExpressionBuilder
            {
                public static System.Linq.Expressions.Expression AggregateExpressionsIntoTuple(System.Collections.Generic.IEnumerable<System.Linq.Expressions.Expression> expressions) => throw null;
                public static System.Collections.Generic.IEnumerable<System.Linq.Expressions.Expression> GetExpressionsFromTuple(System.Linq.Expressions.Expression tupleExpression) => throw null;
            }

            namespace ExpressionVisitors
            {
                // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.MultiReplacingExpressionVisitor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class MultiReplacingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.Expression Replace(System.Collections.Generic.IDictionary<System.Linq.Expressions.Expression, System.Linq.Expressions.Expression> expressionMapping, System.Linq.Expressions.Expression sourceTree) => throw null;
                    public override System.Linq.Expressions.Expression Visit(System.Linq.Expressions.Expression expression) => throw null;
                    protected internal override System.Linq.Expressions.Expression VisitSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression expression) => throw null;
                }

                // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.PartialEvaluatingExpressionVisitor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class PartialEvaluatingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.Expression EvaluateIndependentSubtrees(System.Linq.Expressions.Expression expressionTree, Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.IEvaluatableExpressionFilter evaluatableExpressionFilter) => throw null;
                    public override System.Linq.Expressions.Expression Visit(System.Linq.Expressions.Expression expression) => throw null;
                }

                // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.ReplacingExpressionVisitor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class ReplacingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.Expression Replace(System.Linq.Expressions.Expression replacedExpression, System.Linq.Expressions.Expression replacementExpression, System.Linq.Expressions.Expression sourceTree) => throw null;
                    public override System.Linq.Expressions.Expression Visit(System.Linq.Expressions.Expression expression) => throw null;
                    protected internal override System.Linq.Expressions.Expression VisitSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression expression) => throw null;
                }

                // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.SubQueryFindingExpressionVisitor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class SubQueryFindingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.Expression Process(System.Linq.Expressions.Expression expressionTree, Remotion.Linq.Parsing.Structure.INodeTypeProvider nodeTypeProvider) => throw null;
                    public override System.Linq.Expressions.Expression Visit(System.Linq.Expressions.Expression expression) => throw null;
                }

                // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.TransformingExpressionVisitor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class TransformingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.Expression Transform(System.Linq.Expressions.Expression expression, Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTranformationProvider tranformationProvider) => throw null;
                    public override System.Linq.Expressions.Expression Visit(System.Linq.Expressions.Expression expression) => throw null;
                }

                // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.TransparentIdentifierRemovingExpressionVisitor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class TransparentIdentifierRemovingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor
                {
                    public static System.Linq.Expressions.Expression ReplaceTransparentIdentifiers(System.Linq.Expressions.Expression expression) => throw null;
                    protected internal override System.Linq.Expressions.Expression VisitMember(System.Linq.Expressions.MemberExpression memberExpression) => throw null;
                    protected internal override System.Linq.Expressions.Expression VisitSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression expression) => throw null;
                }

                namespace MemberBindings
                {
                    // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.MemberBindings.FieldInfoBinding` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class FieldInfoBinding : Remotion.Linq.Parsing.ExpressionVisitors.MemberBindings.MemberBinding
                    {
                        public FieldInfoBinding(System.Reflection.FieldInfo boundMember, System.Linq.Expressions.Expression associatedExpression) : base(default(System.Reflection.MemberInfo), default(System.Linq.Expressions.Expression)) => throw null;
                        public override bool MatchesReadAccess(System.Reflection.MemberInfo member) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.MemberBindings.MemberBinding` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public abstract class MemberBinding
                    {
                        public System.Linq.Expressions.Expression AssociatedExpression { get => throw null; }
                        public static Remotion.Linq.Parsing.ExpressionVisitors.MemberBindings.MemberBinding Bind(System.Reflection.MemberInfo boundMember, System.Linq.Expressions.Expression associatedExpression) => throw null;
                        public System.Reflection.MemberInfo BoundMember { get => throw null; }
                        public abstract bool MatchesReadAccess(System.Reflection.MemberInfo member);
                        public MemberBinding(System.Reflection.MemberInfo boundMember, System.Linq.Expressions.Expression associatedExpression) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.MemberBindings.MethodInfoBinding` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class MethodInfoBinding : Remotion.Linq.Parsing.ExpressionVisitors.MemberBindings.MemberBinding
                    {
                        public override bool MatchesReadAccess(System.Reflection.MemberInfo readMember) => throw null;
                        public MethodInfoBinding(System.Reflection.MethodInfo boundMember, System.Linq.Expressions.Expression associatedExpression) : base(default(System.Reflection.MemberInfo), default(System.Linq.Expressions.Expression)) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.MemberBindings.PropertyInfoBinding` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class PropertyInfoBinding : Remotion.Linq.Parsing.ExpressionVisitors.MemberBindings.MemberBinding
                    {
                        public override bool MatchesReadAccess(System.Reflection.MemberInfo member) => throw null;
                        public PropertyInfoBinding(System.Reflection.PropertyInfo boundMember, System.Linq.Expressions.Expression associatedExpression) : base(default(System.Reflection.MemberInfo), default(System.Linq.Expressions.Expression)) => throw null;
                    }

                }
                namespace Transformation
                {
                    // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.Transformation.ExpressionTransformation` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public delegate System.Linq.Expressions.Expression ExpressionTransformation(System.Linq.Expressions.Expression expression);

                    // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.Transformation.ExpressionTransformerRegistry` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class ExpressionTransformerRegistry : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTranformationProvider
                    {
                        public static Remotion.Linq.Parsing.ExpressionVisitors.Transformation.ExpressionTransformerRegistry CreateDefault() => throw null;
                        public ExpressionTransformerRegistry() => throw null;
                        public Remotion.Linq.Parsing.ExpressionVisitors.Transformation.ExpressionTransformation[] GetAllTransformations(System.Linq.Expressions.ExpressionType expressionType) => throw null;
                        public System.Collections.Generic.IEnumerable<Remotion.Linq.Parsing.ExpressionVisitors.Transformation.ExpressionTransformation> GetTransformations(System.Linq.Expressions.Expression expression) => throw null;
                        public void Register<T>(Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<T> transformer) where T : System.Linq.Expressions.Expression => throw null;
                        public int RegisteredTransformerCount { get => throw null; }
                    }

                    // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTranformationProvider` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public interface IExpressionTranformationProvider
                    {
                        System.Collections.Generic.IEnumerable<Remotion.Linq.Parsing.ExpressionVisitors.Transformation.ExpressionTransformation> GetTransformations(System.Linq.Expressions.Expression expression);
                    }

                    // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<>` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public interface IExpressionTransformer<T> where T : System.Linq.Expressions.Expression
                    {
                        System.Linq.Expressions.ExpressionType[] SupportedExpressionTypes { get; }
                        System.Linq.Expressions.Expression Transform(T expression);
                    }

                    namespace PredefinedTransformations
                    {
                        // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.AttributeEvaluatingExpressionTransformer` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                        public class AttributeEvaluatingExpressionTransformer : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<System.Linq.Expressions.Expression>
                        {
                            public AttributeEvaluatingExpressionTransformer() => throw null;
                            // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.AttributeEvaluatingExpressionTransformer+IMethodCallExpressionTransformerAttribute` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                            public interface IMethodCallExpressionTransformerAttribute
                            {
                                Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<System.Linq.Expressions.MethodCallExpression> GetExpressionTransformer(System.Linq.Expressions.MethodCallExpression expression);
                            }


                            public System.Linq.Expressions.ExpressionType[] SupportedExpressionTypes { get => throw null; }
                            public System.Linq.Expressions.Expression Transform(System.Linq.Expressions.Expression expression) => throw null;
                        }

                        // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.DictionaryEntryNewExpressionTransformer` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                        public class DictionaryEntryNewExpressionTransformer : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.MemberAddingNewExpressionTransformerBase
                        {
                            protected override bool CanAddMembers(System.Type instantiatedType, System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> arguments) => throw null;
                            public DictionaryEntryNewExpressionTransformer() => throw null;
                            protected override System.Reflection.MemberInfo[] GetMembers(System.Reflection.ConstructorInfo constructorInfo, System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> arguments) => throw null;
                        }

                        // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.InvocationOfLambdaExpressionTransformer` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                        public class InvocationOfLambdaExpressionTransformer : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<System.Linq.Expressions.InvocationExpression>
                        {
                            public InvocationOfLambdaExpressionTransformer() => throw null;
                            public System.Linq.Expressions.ExpressionType[] SupportedExpressionTypes { get => throw null; }
                            public System.Linq.Expressions.Expression Transform(System.Linq.Expressions.InvocationExpression expression) => throw null;
                        }

                        // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.KeyValuePairNewExpressionTransformer` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                        public class KeyValuePairNewExpressionTransformer : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.MemberAddingNewExpressionTransformerBase
                        {
                            protected override bool CanAddMembers(System.Type instantiatedType, System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> arguments) => throw null;
                            protected override System.Reflection.MemberInfo[] GetMembers(System.Reflection.ConstructorInfo constructorInfo, System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> arguments) => throw null;
                            public KeyValuePairNewExpressionTransformer() => throw null;
                        }

                        // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.MemberAddingNewExpressionTransformerBase` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                        public abstract class MemberAddingNewExpressionTransformerBase : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<System.Linq.Expressions.NewExpression>
                        {
                            protected abstract bool CanAddMembers(System.Type instantiatedType, System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> arguments);
                            protected System.Reflection.MemberInfo GetMemberForNewExpression(System.Type instantiatedType, string propertyName) => throw null;
                            protected abstract System.Reflection.MemberInfo[] GetMembers(System.Reflection.ConstructorInfo constructorInfo, System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> arguments);
                            protected MemberAddingNewExpressionTransformerBase() => throw null;
                            public System.Linq.Expressions.ExpressionType[] SupportedExpressionTypes { get => throw null; }
                            public System.Linq.Expressions.Expression Transform(System.Linq.Expressions.NewExpression expression) => throw null;
                        }

                        // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.MethodCallExpressionTransformerAttribute` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                        public class MethodCallExpressionTransformerAttribute : System.Attribute, Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.AttributeEvaluatingExpressionTransformer.IMethodCallExpressionTransformerAttribute
                        {
                            public Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<System.Linq.Expressions.MethodCallExpression> GetExpressionTransformer(System.Linq.Expressions.MethodCallExpression expression) => throw null;
                            public MethodCallExpressionTransformerAttribute(System.Type transformerType) => throw null;
                            public System.Type TransformerType { get => throw null; }
                        }

                        // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.NullableValueTransformer` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                        public class NullableValueTransformer : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<System.Linq.Expressions.MemberExpression>
                        {
                            public NullableValueTransformer() => throw null;
                            public System.Linq.Expressions.ExpressionType[] SupportedExpressionTypes { get => throw null; }
                            public System.Linq.Expressions.Expression Transform(System.Linq.Expressions.MemberExpression expression) => throw null;
                        }

                        // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.TupleNewExpressionTransformer` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                        public class TupleNewExpressionTransformer : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.MemberAddingNewExpressionTransformerBase
                        {
                            protected override bool CanAddMembers(System.Type instantiatedType, System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> arguments) => throw null;
                            protected override System.Reflection.MemberInfo[] GetMembers(System.Reflection.ConstructorInfo constructorInfo, System.Collections.ObjectModel.ReadOnlyCollection<System.Linq.Expressions.Expression> arguments) => throw null;
                            public TupleNewExpressionTransformer() => throw null;
                        }

                        // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.VBCompareStringExpressionTransformer` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                        public class VBCompareStringExpressionTransformer : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<System.Linq.Expressions.BinaryExpression>
                        {
                            public System.Linq.Expressions.ExpressionType[] SupportedExpressionTypes { get => throw null; }
                            public System.Linq.Expressions.Expression Transform(System.Linq.Expressions.BinaryExpression expression) => throw null;
                            public VBCompareStringExpressionTransformer() => throw null;
                        }

                        // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.Transformation.PredefinedTransformations.VBInformationIsNothingExpressionTransformer` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                        public class VBInformationIsNothingExpressionTransformer : Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTransformer<System.Linq.Expressions.MethodCallExpression>
                        {
                            public System.Linq.Expressions.ExpressionType[] SupportedExpressionTypes { get => throw null; }
                            public System.Linq.Expressions.Expression Transform(System.Linq.Expressions.MethodCallExpression expression) => throw null;
                            public VBInformationIsNothingExpressionTransformer() => throw null;
                        }

                    }
                }
                namespace TreeEvaluation
                {
                    // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.EvaluatableExpressionFilterBase` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
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

                    // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.EvaluatableTreeFindingExpressionVisitor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class EvaluatableTreeFindingExpressionVisitor : Remotion.Linq.Parsing.RelinqExpressionVisitor, Remotion.Linq.Clauses.Expressions.IPartialEvaluationExceptionExpressionVisitor
                    {
                        public static Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.PartialEvaluationInfo Analyze(System.Linq.Expressions.Expression expressionTree, Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.IEvaluatableExpressionFilter evaluatableExpressionFilter) => throw null;
                        public override System.Linq.Expressions.Expression Visit(System.Linq.Expressions.Expression expression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitBinary(System.Linq.Expressions.BinaryExpression expression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitBlock(System.Linq.Expressions.BlockExpression expression) => throw null;
                        protected override System.Linq.Expressions.CatchBlock VisitCatchBlock(System.Linq.Expressions.CatchBlock node) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitConditional(System.Linq.Expressions.ConditionalExpression expression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitConstant(System.Linq.Expressions.ConstantExpression expression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitDebugInfo(System.Linq.Expressions.DebugInfoExpression expression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitDefault(System.Linq.Expressions.DefaultExpression expression) => throw null;
                        protected override System.Linq.Expressions.ElementInit VisitElementInit(System.Linq.Expressions.ElementInit node) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitGoto(System.Linq.Expressions.GotoExpression expression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitIndex(System.Linq.Expressions.IndexExpression expression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitInvocation(System.Linq.Expressions.InvocationExpression expression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitLabel(System.Linq.Expressions.LabelExpression expression) => throw null;
                        protected override System.Linq.Expressions.LabelTarget VisitLabelTarget(System.Linq.Expressions.LabelTarget node) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitLambda<T>(System.Linq.Expressions.Expression<T> expression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitListInit(System.Linq.Expressions.ListInitExpression expression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitLoop(System.Linq.Expressions.LoopExpression expression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitMember(System.Linq.Expressions.MemberExpression expression) => throw null;
                        protected override System.Linq.Expressions.MemberAssignment VisitMemberAssignment(System.Linq.Expressions.MemberAssignment node) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitMemberInit(System.Linq.Expressions.MemberInitExpression expression) => throw null;
                        protected override System.Linq.Expressions.MemberListBinding VisitMemberListBinding(System.Linq.Expressions.MemberListBinding node) => throw null;
                        protected override System.Linq.Expressions.MemberMemberBinding VisitMemberMemberBinding(System.Linq.Expressions.MemberMemberBinding node) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitMethodCall(System.Linq.Expressions.MethodCallExpression expression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitNew(System.Linq.Expressions.NewExpression expression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitNewArray(System.Linq.Expressions.NewArrayExpression expression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitParameter(System.Linq.Expressions.ParameterExpression expression) => throw null;
                        public System.Linq.Expressions.Expression VisitPartialEvaluationException(Remotion.Linq.Clauses.Expressions.PartialEvaluationExceptionExpression partialEvaluationExceptionExpression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitSwitch(System.Linq.Expressions.SwitchExpression expression) => throw null;
                        protected override System.Linq.Expressions.SwitchCase VisitSwitchCase(System.Linq.Expressions.SwitchCase node) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitTry(System.Linq.Expressions.TryExpression expression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitTypeBinary(System.Linq.Expressions.TypeBinaryExpression expression) => throw null;
                        protected internal override System.Linq.Expressions.Expression VisitUnary(System.Linq.Expressions.UnaryExpression expression) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.IEvaluatableExpressionFilter` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
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

                    // Generated from `Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.PartialEvaluationInfo` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class PartialEvaluationInfo
                    {
                        public void AddEvaluatableExpression(System.Linq.Expressions.Expression expression) => throw null;
                        public int Count { get => throw null; }
                        public bool IsEvaluatableExpression(System.Linq.Expressions.Expression expression) => throw null;
                        public PartialEvaluationInfo() => throw null;
                    }

                }
            }
            namespace Structure
            {
                // Generated from `Remotion.Linq.Parsing.Structure.ExpressionTreeParser` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class ExpressionTreeParser
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

                // Generated from `Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public interface IExpressionTreeProcessor
                {
                    System.Linq.Expressions.Expression Process(System.Linq.Expressions.Expression expressionTree);
                }

                // Generated from `Remotion.Linq.Parsing.Structure.INodeTypeProvider` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public interface INodeTypeProvider
                {
                    System.Type GetNodeType(System.Reflection.MethodInfo method);
                    bool IsRegistered(System.Reflection.MethodInfo method);
                }

                // Generated from `Remotion.Linq.Parsing.Structure.IQueryParser` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public interface IQueryParser
                {
                    Remotion.Linq.QueryModel GetParsedQuery(System.Linq.Expressions.Expression expressionTreeRoot);
                }

                // Generated from `Remotion.Linq.Parsing.Structure.MethodCallExpressionParser` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class MethodCallExpressionParser
                {
                    public MethodCallExpressionParser(Remotion.Linq.Parsing.Structure.INodeTypeProvider nodeTypeProvider) => throw null;
                    public Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode Parse(string associatedIdentifier, Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode source, System.Collections.Generic.IEnumerable<System.Linq.Expressions.Expression> arguments, System.Linq.Expressions.MethodCallExpression expressionToParse) => throw null;
                }

                // Generated from `Remotion.Linq.Parsing.Structure.QueryParser` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                public class QueryParser : Remotion.Linq.Parsing.Structure.IQueryParser
                {
                    public static Remotion.Linq.Parsing.Structure.QueryParser CreateDefault() => throw null;
                    public Remotion.Linq.Parsing.Structure.ExpressionTreeParser ExpressionTreeParser { get => throw null; }
                    public Remotion.Linq.QueryModel GetParsedQuery(System.Linq.Expressions.Expression expressionTreeRoot) => throw null;
                    public Remotion.Linq.Parsing.Structure.INodeTypeProvider NodeTypeProvider { get => throw null; }
                    public Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor Processor { get => throw null; }
                    public QueryParser(Remotion.Linq.Parsing.Structure.ExpressionTreeParser expressionTreeParser) => throw null;
                }

                namespace ExpressionTreeProcessors
                {
                    // Generated from `Remotion.Linq.Parsing.Structure.ExpressionTreeProcessors.CompoundExpressionTreeProcessor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class CompoundExpressionTreeProcessor : Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor
                    {
                        public CompoundExpressionTreeProcessor(System.Collections.Generic.IEnumerable<Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor> innerProcessors) => throw null;
                        public System.Collections.Generic.IList<Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor> InnerProcessors { get => throw null; }
                        public System.Linq.Expressions.Expression Process(System.Linq.Expressions.Expression expressionTree) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.ExpressionTreeProcessors.NullExpressionTreeProcessor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class NullExpressionTreeProcessor : Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor
                    {
                        public NullExpressionTreeProcessor() => throw null;
                        public System.Linq.Expressions.Expression Process(System.Linq.Expressions.Expression expressionTree) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.ExpressionTreeProcessors.PartialEvaluatingExpressionTreeProcessor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class PartialEvaluatingExpressionTreeProcessor : Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor
                    {
                        public Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.IEvaluatableExpressionFilter Filter { get => throw null; }
                        public PartialEvaluatingExpressionTreeProcessor(Remotion.Linq.Parsing.ExpressionVisitors.TreeEvaluation.IEvaluatableExpressionFilter filter) => throw null;
                        public System.Linq.Expressions.Expression Process(System.Linq.Expressions.Expression expressionTree) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.ExpressionTreeProcessors.TransformingExpressionTreeProcessor` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class TransformingExpressionTreeProcessor : Remotion.Linq.Parsing.Structure.IExpressionTreeProcessor
                    {
                        public System.Linq.Expressions.Expression Process(System.Linq.Expressions.Expression expressionTree) => throw null;
                        public Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTranformationProvider Provider { get => throw null; }
                        public TransformingExpressionTreeProcessor(Remotion.Linq.Parsing.ExpressionVisitors.Transformation.IExpressionTranformationProvider provider) => throw null;
                    }

                }
                namespace IntermediateModel
                {
                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.AggregateExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class AggregateExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        public AggregateExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression func) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.LambdaExpression Func { get => throw null; }
                        public System.Linq.Expressions.LambdaExpression GetResolvedFunc(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.AggregateFromSeedExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class AggregateFromSeedExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        public AggregateFromSeedExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression seed, System.Linq.Expressions.LambdaExpression func, System.Linq.Expressions.LambdaExpression optionalResultSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.LambdaExpression Func { get => throw null; }
                        public System.Linq.Expressions.LambdaExpression GetResolvedFunc(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression OptionalResultSelector { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression Seed { get => throw null; }
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.AllExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class AllExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        public AllExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression predicate) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedPredicate(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression Predicate { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.AnyExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class AnyExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        public AnyExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalPredicate) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.AsQueryableExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class AsQueryableExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        public AsQueryableExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.AverageExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class AverageExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        public AverageExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.CastExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class CastExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        public CastExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public System.Type CastItemType { get => throw null; }
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public struct ClauseGenerationContext
                    {
                        public void AddContextInfo(Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode node, object contextInfo) => throw null;
                        public ClauseGenerationContext(Remotion.Linq.Parsing.Structure.INodeTypeProvider nodeTypeProvider) => throw null;
                        // Stub generator skipped constructor 
                        public int Count { get => throw null; }
                        public object GetContextInfo(Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode node) => throw null;
                        public Remotion.Linq.Parsing.Structure.INodeTypeProvider NodeTypeProvider { get => throw null; }
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.ConcatExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class ConcatExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.QuerySourceSetOperationExpressionNodeBase
                    {
                        public ConcatExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression source2) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.Expression)) => throw null;
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateSpecificResultOperator() => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.ContainsExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class ContainsExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        public ContainsExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression item) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<Remotion.Linq.Parsing.Structure.NodeTypeProviders.NameBasedRegistrationInfo> GetSupportedMethodNames() => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.Expression Item { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.CountExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class CountExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        public CountExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalPredicate) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.DefaultIfEmptyExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class DefaultIfEmptyExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public DefaultIfEmptyExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression optionalDefaultValue) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.Expression OptionalDefaultValue { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.DistinctExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class DistinctExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public DistinctExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.ExceptExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class ExceptExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public ExceptExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression source2) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression Source2 { get => throw null; }
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.ExpressionNodeInstantiationException` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class ExpressionNodeInstantiationException : System.Exception
                    {
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.ExpressionResolver` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class ExpressionResolver
                    {
                        public Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode CurrentNode { get => throw null; }
                        public ExpressionResolver(Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode currentNode) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedExpression(System.Linq.Expressions.Expression unresolvedExpression, System.Linq.Expressions.ParameterExpression parameterToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.FirstExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class FirstExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public FirstExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalPredicate) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.GroupByExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class GroupByExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase, Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode, Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedKeySelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedOptionalElementSelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public GroupByExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression keySelector, System.Linq.Expressions.LambdaExpression optionalElementSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public System.Linq.Expressions.LambdaExpression KeySelector { get => throw null; }
                        public System.Linq.Expressions.LambdaExpression OptionalElementSelector { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.GroupByWithResultSelectorExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class GroupByWithResultSelectorExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode, Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode
                    {
                        public Remotion.Linq.QueryModel Apply(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public string AssociatedIdentifier { get => throw null; }
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public GroupByWithResultSelectorExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression keySelector, System.Linq.Expressions.LambdaExpression elementSelectorOrResultSelector, System.Linq.Expressions.LambdaExpression resultSelectorOrNull) => throw null;
                        public System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression Selector { get => throw null; }
                        public Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode Source { get => throw null; }
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.GroupJoinExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class GroupJoinExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase, Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode, Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedResultSelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public GroupJoinExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression innerSequence, System.Linq.Expressions.LambdaExpression outerKeySelector, System.Linq.Expressions.LambdaExpression innerKeySelector, System.Linq.Expressions.LambdaExpression resultSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                        public System.Linq.Expressions.LambdaExpression InnerKeySelector { get => throw null; }
                        public System.Linq.Expressions.Expression InnerSequence { get => throw null; }
                        public Remotion.Linq.Parsing.Structure.IntermediateModel.JoinExpressionNode JoinExpressionNode { get => throw null; }
                        public System.Linq.Expressions.LambdaExpression OuterKeySelector { get => throw null; }
                        public System.Linq.Expressions.MethodCallExpression ParsedExpression { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.LambdaExpression ResultSelector { get => throw null; }
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public interface IExpressionNode
                    {
                        Remotion.Linq.QueryModel Apply(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext);
                        string AssociatedIdentifier { get; }
                        System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext);
                        Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode Source { get; }
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public interface IQuerySourceExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode
                    {
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.IntersectExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class IntersectExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public IntersectExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression source2) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression Source2 { get => throw null; }
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.JoinExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class JoinExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase, Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode, Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public Remotion.Linq.Clauses.JoinClause CreateJoinClause(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedInnerKeySelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedOuterKeySelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedResultSelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression InnerKeySelector { get => throw null; }
                        public System.Linq.Expressions.Expression InnerSequence { get => throw null; }
                        public JoinExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression innerSequence, System.Linq.Expressions.LambdaExpression outerKeySelector, System.Linq.Expressions.LambdaExpression innerKeySelector, System.Linq.Expressions.LambdaExpression resultSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                        public System.Linq.Expressions.LambdaExpression OuterKeySelector { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.LambdaExpression ResultSelector { get => throw null; }
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.LastExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class LastExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public LastExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalPredicate) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.LongCountExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class LongCountExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public LongCountExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalPredicate) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.MainSourceExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class MainSourceExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode, Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode
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

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.MaxExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class MaxExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public MaxExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
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

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeFactory` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public static class MethodCallExpressionNodeFactory
                    {
                        public static Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode CreateExpressionNode(System.Type nodeType, Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, object[] additionalConstructorParameters) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public struct MethodCallExpressionParseInfo
                    {
                        public string AssociatedIdentifier { get => throw null; }
                        public MethodCallExpressionParseInfo(string associatedIdentifier, Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode source, System.Linq.Expressions.MethodCallExpression parsedExpression) => throw null;
                        // Stub generator skipped constructor 
                        public System.Linq.Expressions.MethodCallExpression ParsedExpression { get => throw null; }
                        public Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode Source { get => throw null; }
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.MinExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class MinExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public MinExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.OfTypeExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class OfTypeExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public OfTypeExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Type SearchedItemType { get => throw null; }
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.OrderByDescendingExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class OrderByDescendingExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedKeySelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression KeySelector { get => throw null; }
                        public OrderByDescendingExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression keySelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.OrderByExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class OrderByExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedKeySelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression KeySelector { get => throw null; }
                        public OrderByExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression keySelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.QuerySourceExpressionNodeUtility` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public static class QuerySourceExpressionNodeUtility
                    {
                        public static Remotion.Linq.Clauses.IQuerySource GetQuerySourceForNode(Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode node, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext context) => throw null;
                        public static System.Linq.Expressions.Expression ReplaceParameterWithReference(Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode referencedNode, System.Linq.Expressions.ParameterExpression parameterToReplace, System.Linq.Expressions.Expression expression, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext context) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.QuerySourceSetOperationExpressionNodeBase` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public abstract class QuerySourceSetOperationExpressionNodeBase : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase, Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode, Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        protected abstract Remotion.Linq.Clauses.ResultOperatorBase CreateSpecificResultOperator();
                        public System.Type ItemType { get => throw null; }
                        protected QuerySourceSetOperationExpressionNodeBase(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression source2) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression Source2 { get => throw null; }
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.ResolvedExpressionCache<>` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class ResolvedExpressionCache<T> where T : System.Linq.Expressions.Expression
                    {
                        public T GetOrCreate(System.Func<Remotion.Linq.Parsing.Structure.IntermediateModel.ExpressionResolver, T> generator) => throw null;
                        public ResolvedExpressionCache(Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode currentNode) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public abstract class ResultOperatorExpressionNodeBase : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        protected abstract Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext);
                        public System.Linq.Expressions.MethodCallExpression ParsedExpression { get => throw null; }
                        protected ResultOperatorExpressionNodeBase(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalPredicate, System.Linq.Expressions.LambdaExpression optionalSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                        protected override Remotion.Linq.QueryModel WrapQueryModelAfterEndOfQuery(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.ReverseExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class ReverseExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public ReverseExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.SelectExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class SelectExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedSelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public SelectExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression selector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                        public System.Linq.Expressions.LambdaExpression Selector { get => throw null; }
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.SelectManyExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class SelectManyExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase, Remotion.Linq.Parsing.Structure.IntermediateModel.IQuerySourceExpressionNode, Remotion.Linq.Parsing.Structure.IntermediateModel.IExpressionNode
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.LambdaExpression CollectionSelector { get => throw null; }
                        public System.Linq.Expressions.Expression GetResolvedCollectionSelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedResultSelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.LambdaExpression ResultSelector { get => throw null; }
                        public SelectManyExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression collectionSelector, System.Linq.Expressions.LambdaExpression resultSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.SingleExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class SingleExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public SingleExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalPredicate) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.SkipExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class SkipExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        public System.Linq.Expressions.Expression Count { get => throw null; }
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public SkipExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression count) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.SumExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class SumExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public SumExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression optionalSelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.TakeExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class TakeExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.ResultOperatorExpressionNodeBase
                    {
                        public System.Linq.Expressions.Expression Count { get => throw null; }
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateResultOperator(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public TakeExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression count) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.LambdaExpression), default(System.Linq.Expressions.LambdaExpression)) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.ThenByDescendingExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class ThenByDescendingExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedKeySelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression KeySelector { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public ThenByDescendingExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression keySelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.ThenByExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class ThenByExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedKeySelector(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression KeySelector { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public ThenByExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression keySelector) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.UnionExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class UnionExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.QuerySourceSetOperationExpressionNodeBase
                    {
                        protected override Remotion.Linq.Clauses.ResultOperatorBase CreateSpecificResultOperator() => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public UnionExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.Expression source2) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo), default(System.Linq.Expressions.Expression)) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.IntermediateModel.WhereExpressionNode` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class WhereExpressionNode : Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionNodeBase
                    {
                        protected override void ApplyNodeSpecificSemantics(Remotion.Linq.QueryModel queryModel, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public System.Linq.Expressions.Expression GetResolvedPredicate(Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> GetSupportedMethods() => throw null;
                        public System.Linq.Expressions.LambdaExpression Predicate { get => throw null; }
                        public override System.Linq.Expressions.Expression Resolve(System.Linq.Expressions.ParameterExpression inputParameter, System.Linq.Expressions.Expression expressionToBeResolved, Remotion.Linq.Parsing.Structure.IntermediateModel.ClauseGenerationContext clauseGenerationContext) => throw null;
                        public WhereExpressionNode(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo parseInfo, System.Linq.Expressions.LambdaExpression predicate) : base(default(Remotion.Linq.Parsing.Structure.IntermediateModel.MethodCallExpressionParseInfo)) => throw null;
                    }

                }
                namespace NodeTypeProviders
                {
                    // Generated from `Remotion.Linq.Parsing.Structure.NodeTypeProviders.CompoundNodeTypeProvider` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class CompoundNodeTypeProvider : Remotion.Linq.Parsing.Structure.INodeTypeProvider
                    {
                        public CompoundNodeTypeProvider(System.Collections.Generic.IEnumerable<Remotion.Linq.Parsing.Structure.INodeTypeProvider> innerProviders) => throw null;
                        public System.Type GetNodeType(System.Reflection.MethodInfo method) => throw null;
                        public System.Collections.Generic.IList<Remotion.Linq.Parsing.Structure.INodeTypeProvider> InnerProviders { get => throw null; }
                        public bool IsRegistered(System.Reflection.MethodInfo method) => throw null;
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.NodeTypeProviders.MethodInfoBasedNodeTypeRegistry` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class MethodInfoBasedNodeTypeRegistry : Remotion.Linq.Parsing.Structure.INodeTypeProvider
                    {
                        public static Remotion.Linq.Parsing.Structure.NodeTypeProviders.MethodInfoBasedNodeTypeRegistry CreateFromRelinqAssembly() => throw null;
                        public System.Type GetNodeType(System.Reflection.MethodInfo method) => throw null;
                        public static System.Reflection.MethodInfo GetRegisterableMethodDefinition(System.Reflection.MethodInfo method, bool throwOnAmbiguousMatch) => throw null;
                        public bool IsRegistered(System.Reflection.MethodInfo method) => throw null;
                        public MethodInfoBasedNodeTypeRegistry() => throw null;
                        public void Register(System.Collections.Generic.IEnumerable<System.Reflection.MethodInfo> methods, System.Type nodeType) => throw null;
                        public int RegisteredMethodInfoCount { get => throw null; }
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.NodeTypeProviders.MethodNameBasedNodeTypeRegistry` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class MethodNameBasedNodeTypeRegistry : Remotion.Linq.Parsing.Structure.INodeTypeProvider
                    {
                        public static Remotion.Linq.Parsing.Structure.NodeTypeProviders.MethodNameBasedNodeTypeRegistry CreateFromRelinqAssembly() => throw null;
                        public System.Type GetNodeType(System.Reflection.MethodInfo method) => throw null;
                        public bool IsRegistered(System.Reflection.MethodInfo method) => throw null;
                        public MethodNameBasedNodeTypeRegistry() => throw null;
                        public void Register(System.Collections.Generic.IEnumerable<Remotion.Linq.Parsing.Structure.NodeTypeProviders.NameBasedRegistrationInfo> registrationInfo, System.Type nodeType) => throw null;
                        public int RegisteredNamesCount { get => throw null; }
                    }

                    // Generated from `Remotion.Linq.Parsing.Structure.NodeTypeProviders.NameBasedRegistrationInfo` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
                    public class NameBasedRegistrationInfo
                    {
                        public System.Func<System.Reflection.MethodInfo, bool> Filter { get => throw null; }
                        public string Name { get => throw null; }
                        public NameBasedRegistrationInfo(string name, System.Func<System.Reflection.MethodInfo, bool> filter) => throw null;
                    }

                }
            }
        }
        namespace Transformations
        {
            // Generated from `Remotion.Linq.Transformations.SubQueryFromClauseFlattener` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public class SubQueryFromClauseFlattener : Remotion.Linq.QueryModelVisitorBase
            {
                protected virtual void CheckFlattenable(Remotion.Linq.QueryModel subQueryModel) => throw null;
                protected virtual void FlattenSubQuery(Remotion.Linq.Clauses.Expressions.SubQueryExpression subQueryExpression, Remotion.Linq.Clauses.IFromClause fromClause, Remotion.Linq.QueryModel queryModel, int destinationIndex) => throw null;
                protected void InsertBodyClauses(System.Collections.ObjectModel.ObservableCollection<Remotion.Linq.Clauses.IBodyClause> bodyClauses, Remotion.Linq.QueryModel destinationQueryModel, int destinationIndex) => throw null;
                public SubQueryFromClauseFlattener() => throw null;
                public override void VisitAdditionalFromClause(Remotion.Linq.Clauses.AdditionalFromClause fromClause, Remotion.Linq.QueryModel queryModel, int index) => throw null;
                public override void VisitMainFromClause(Remotion.Linq.Clauses.MainFromClause fromClause, Remotion.Linq.QueryModel queryModel) => throw null;
            }

        }
        namespace Utilities
        {
            // Generated from `Remotion.Linq.Utilities.ItemTypeReflectionUtility` in `Remotion.Linq, Version=2.2.0.0, Culture=neutral, PublicKeyToken=fee00910d6e5f53b`
            public static class ItemTypeReflectionUtility
            {
                public static bool TryGetItemTypeOfClosedGenericIEnumerable(System.Type possibleEnumerableType, out System.Type itemType) => throw null;
            }

        }
    }
}
