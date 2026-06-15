// This file contains auto-generated code.
// Generated from `EntityFramework, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089`.
namespace System
{
    namespace ComponentModel
    {
        namespace DataAnnotations
        {
            namespace Schema
            {
                [System.AttributeUsage((System.AttributeTargets)128, AllowMultiple = true)]
                public class IndexAttribute : System.Attribute
                {
                    public IndexAttribute() => throw null;
                    public IndexAttribute(string name) => throw null;
                    public IndexAttribute(string name, int order) => throw null;
                    protected virtual bool Equals(System.ComponentModel.DataAnnotations.Schema.IndexAttribute other) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public virtual bool IsClustered { get => throw null; set { } }
                    public virtual bool IsClusteredConfigured { get => throw null; }
                    public virtual bool IsUnique { get => throw null; set { } }
                    public virtual bool IsUniqueConfigured { get => throw null; }
                    public virtual string Name { get => throw null; set { } }
                    public virtual int Order { get => throw null; set { } }
                    public override string ToString() => throw null;
                    public override object TypeId { get => throw null; }
                }
            }
        }
    }
    namespace Data
    {
        namespace Entity
        {
            namespace Core
            {
                namespace Common
                {
                    namespace CommandTrees
                    {
                        public abstract class BasicCommandTreeVisitor : System.Data.Entity.Core.Common.CommandTrees.BasicExpressionVisitor
                        {
                            protected BasicCommandTreeVisitor() => throw null;
                            public virtual void VisitCommandTree(System.Data.Entity.Core.Common.CommandTrees.DbCommandTree commandTree) => throw null;
                            protected virtual void VisitDeleteCommandTree(System.Data.Entity.Core.Common.CommandTrees.DbDeleteCommandTree deleteTree) => throw null;
                            protected virtual void VisitFunctionCommandTree(System.Data.Entity.Core.Common.CommandTrees.DbFunctionCommandTree functionTree) => throw null;
                            protected virtual void VisitInsertCommandTree(System.Data.Entity.Core.Common.CommandTrees.DbInsertCommandTree insertTree) => throw null;
                            protected virtual void VisitModificationClause(System.Data.Entity.Core.Common.CommandTrees.DbModificationClause modificationClause) => throw null;
                            protected virtual void VisitModificationClauses(System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbModificationClause> modificationClauses) => throw null;
                            protected virtual void VisitQueryCommandTree(System.Data.Entity.Core.Common.CommandTrees.DbQueryCommandTree queryTree) => throw null;
                            protected virtual void VisitSetClause(System.Data.Entity.Core.Common.CommandTrees.DbSetClause setClause) => throw null;
                            protected virtual void VisitUpdateCommandTree(System.Data.Entity.Core.Common.CommandTrees.DbUpdateCommandTree updateTree) => throw null;
                        }
                        public abstract class BasicExpressionVisitor : System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor
                        {
                            protected BasicExpressionVisitor() => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbConstantExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbNullExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbParameterReferenceExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbLambdaExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbPropertyExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbComparisonExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbLikeExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbLimitExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbIsNullExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbArithmeticExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbAndExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbOrExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbInExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbNotExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbDistinctExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbElementExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbIsEmptyExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbUnionAllExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbIntersectExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbExceptExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbOfTypeExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbTreatExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbCastExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbIsOfExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbCaseExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbNewInstanceExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbRefExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbRelationshipNavigationExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbDerefExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbRefKeyExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbEntityRefExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbScanExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbFilterExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbProjectExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbCrossJoinExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbJoinExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbApplyExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbGroupByExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbSkipExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbSortExpression expression) => throw null;
                            public override void Visit(System.Data.Entity.Core.Common.CommandTrees.DbQuantifierExpression expression) => throw null;
                            public virtual void VisitAggregate(System.Data.Entity.Core.Common.CommandTrees.DbAggregate aggregate) => throw null;
                            public virtual void VisitAggregateList(System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbAggregate> aggregates) => throw null;
                            protected virtual void VisitBinaryExpression(System.Data.Entity.Core.Common.CommandTrees.DbBinaryExpression expression) => throw null;
                            public virtual void VisitExpression(System.Data.Entity.Core.Common.CommandTrees.DbExpression expression) => throw null;
                            protected virtual void VisitExpressionBindingPost(System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding binding) => throw null;
                            protected virtual void VisitExpressionBindingPre(System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding binding) => throw null;
                            public virtual void VisitExpressionList(System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbExpression> expressionList) => throw null;
                            protected virtual void VisitGroupExpressionBindingMid(System.Data.Entity.Core.Common.CommandTrees.DbGroupExpressionBinding binding) => throw null;
                            protected virtual void VisitGroupExpressionBindingPost(System.Data.Entity.Core.Common.CommandTrees.DbGroupExpressionBinding binding) => throw null;
                            protected virtual void VisitGroupExpressionBindingPre(System.Data.Entity.Core.Common.CommandTrees.DbGroupExpressionBinding binding) => throw null;
                            protected virtual void VisitLambdaPost(System.Data.Entity.Core.Common.CommandTrees.DbLambda lambda) => throw null;
                            protected virtual void VisitLambdaPre(System.Data.Entity.Core.Common.CommandTrees.DbLambda lambda) => throw null;
                            protected virtual void VisitUnaryExpression(System.Data.Entity.Core.Common.CommandTrees.DbUnaryExpression expression) => throw null;
                        }
                        public abstract class DbAggregate
                        {
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbExpression> Arguments { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.TypeUsage ResultType { get => throw null; }
                        }
                        public sealed class DbAndExpression : System.Data.Entity.Core.Common.CommandTrees.DbBinaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public sealed class DbApplyExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding Apply { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding Input { get => throw null; }
                        }
                        public sealed class DbArithmeticExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbExpression> Arguments { get => throw null; }
                        }
                        public abstract class DbBinaryExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public virtual System.Data.Entity.Core.Common.CommandTrees.DbExpression Left { get => throw null; }
                            public virtual System.Data.Entity.Core.Common.CommandTrees.DbExpression Right { get => throw null; }
                        }
                        public sealed class DbCaseExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Else { get => throw null; }
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbExpression> Then { get => throw null; }
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbExpression> When { get => throw null; }
                        }
                        public class DbCastExpression : System.Data.Entity.Core.Common.CommandTrees.DbUnaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public abstract class DbCommandTree
                        {
                            public abstract System.Data.Entity.Core.Common.CommandTrees.DbCommandTreeKind CommandTreeKind { get; }
                            public virtual System.Data.Entity.Core.Metadata.Edm.DataSpace DataSpace { get => throw null; }
                            public bool DisableFilterOverProjectionSimplificationForCustomFunctions { get => throw null; }
                            public virtual System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace MetadataWorkspace { get => throw null; }
                            public System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, System.Data.Entity.Core.Metadata.Edm.TypeUsage>> Parameters { get => throw null; }
                            public override string ToString() => throw null;
                            public bool UseDatabaseNullSemantics { get => throw null; }
                        }
                        public enum DbCommandTreeKind
                        {
                            Query = 0,
                            Update = 1,
                            Insert = 2,
                            Delete = 3,
                            Function = 4,
                        }
                        public sealed class DbComparisonExpression : System.Data.Entity.Core.Common.CommandTrees.DbBinaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public class DbConstantExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public virtual object Value { get => throw null; }
                        }
                        public sealed class DbCrossJoinExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding> Inputs { get => throw null; }
                        }
                        public sealed class DbDeleteCommandTree : System.Data.Entity.Core.Common.CommandTrees.DbModificationCommandTree
                        {
                            public override System.Data.Entity.Core.Common.CommandTrees.DbCommandTreeKind CommandTreeKind { get => throw null; }
                            public DbDeleteCommandTree(System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace metadata, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding target, System.Data.Entity.Core.Common.CommandTrees.DbExpression predicate) => throw null;
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Predicate { get => throw null; }
                        }
                        public sealed class DbDerefExpression : System.Data.Entity.Core.Common.CommandTrees.DbUnaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public sealed class DbDistinctExpression : System.Data.Entity.Core.Common.CommandTrees.DbUnaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public sealed class DbElementExpression : System.Data.Entity.Core.Common.CommandTrees.DbUnaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public sealed class DbEntityRefExpression : System.Data.Entity.Core.Common.CommandTrees.DbUnaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public sealed class DbExceptExpression : System.Data.Entity.Core.Common.CommandTrees.DbBinaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public abstract class DbExpression
                        {
                            public abstract void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor);
                            public abstract TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor);
                            public override bool Equals(object obj) => throw null;
                            public virtual System.Data.Entity.Core.Common.CommandTrees.DbExpressionKind ExpressionKind { get => throw null; }
                            public static System.Data.Entity.Core.Common.CommandTrees.DbExpression FromBinary(byte[] value) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbExpression FromBoolean(bool? value) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbExpression FromByte(byte? value) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbExpression FromDateTime(System.DateTime? value) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbExpression FromDateTimeOffset(System.DateTimeOffset? value) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbExpression FromDecimal(decimal? value) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbExpression FromDouble(double? value) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbExpression FromGeography(System.Data.Entity.Spatial.DbGeography value) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbExpression FromGeometry(System.Data.Entity.Spatial.DbGeometry value) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbExpression FromGuid(System.Guid? value) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbExpression FromInt16(short? value) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbExpression FromInt32(int? value) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbExpression FromInt64(long? value) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbExpression FromSingle(float? value) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbExpression FromString(string value) => throw null;
                            public override int GetHashCode() => throw null;
                            public static implicit operator System.Data.Entity.Core.Common.CommandTrees.DbExpression(byte[] value) => throw null;
                            public static implicit operator System.Data.Entity.Core.Common.CommandTrees.DbExpression(bool? value) => throw null;
                            public static implicit operator System.Data.Entity.Core.Common.CommandTrees.DbExpression(byte? value) => throw null;
                            public static implicit operator System.Data.Entity.Core.Common.CommandTrees.DbExpression(System.DateTime? value) => throw null;
                            public static implicit operator System.Data.Entity.Core.Common.CommandTrees.DbExpression(System.DateTimeOffset? value) => throw null;
                            public static implicit operator System.Data.Entity.Core.Common.CommandTrees.DbExpression(decimal? value) => throw null;
                            public static implicit operator System.Data.Entity.Core.Common.CommandTrees.DbExpression(double? value) => throw null;
                            public static implicit operator System.Data.Entity.Core.Common.CommandTrees.DbExpression(System.Data.Entity.Spatial.DbGeography value) => throw null;
                            public static implicit operator System.Data.Entity.Core.Common.CommandTrees.DbExpression(System.Data.Entity.Spatial.DbGeometry value) => throw null;
                            public static implicit operator System.Data.Entity.Core.Common.CommandTrees.DbExpression(System.Guid? value) => throw null;
                            public static implicit operator System.Data.Entity.Core.Common.CommandTrees.DbExpression(short? value) => throw null;
                            public static implicit operator System.Data.Entity.Core.Common.CommandTrees.DbExpression(int? value) => throw null;
                            public static implicit operator System.Data.Entity.Core.Common.CommandTrees.DbExpression(long? value) => throw null;
                            public static implicit operator System.Data.Entity.Core.Common.CommandTrees.DbExpression(float? value) => throw null;
                            public static implicit operator System.Data.Entity.Core.Common.CommandTrees.DbExpression(string value) => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.TypeUsage ResultType { get => throw null; }
                        }
                        public sealed class DbExpressionBinding
                        {
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Expression { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression Variable { get => throw null; }
                            public string VariableName { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.TypeUsage VariableType { get => throw null; }
                        }
                        public enum DbExpressionKind
                        {
                            All = 0,
                            And = 1,
                            Any = 2,
                            Case = 3,
                            Cast = 4,
                            Constant = 5,
                            CrossApply = 6,
                            CrossJoin = 7,
                            Deref = 8,
                            Distinct = 9,
                            Divide = 10,
                            Element = 11,
                            EntityRef = 12,
                            Equals = 13,
                            Except = 14,
                            Filter = 15,
                            FullOuterJoin = 16,
                            Function = 17,
                            GreaterThan = 18,
                            GreaterThanOrEquals = 19,
                            GroupBy = 20,
                            InnerJoin = 21,
                            Intersect = 22,
                            IsEmpty = 23,
                            IsNull = 24,
                            IsOf = 25,
                            IsOfOnly = 26,
                            LeftOuterJoin = 27,
                            LessThan = 28,
                            LessThanOrEquals = 29,
                            Like = 30,
                            Limit = 31,
                            Minus = 32,
                            Modulo = 33,
                            Multiply = 34,
                            NewInstance = 35,
                            Not = 36,
                            NotEquals = 37,
                            Null = 38,
                            OfType = 39,
                            OfTypeOnly = 40,
                            Or = 41,
                            OuterApply = 42,
                            ParameterReference = 43,
                            Plus = 44,
                            Project = 45,
                            Property = 46,
                            Ref = 47,
                            RefKey = 48,
                            RelationshipNavigation = 49,
                            Scan = 50,
                            Skip = 51,
                            Sort = 52,
                            Treat = 53,
                            UnaryMinus = 54,
                            UnionAll = 55,
                            VariableReference = 56,
                            Lambda = 57,
                            In = 58,
                        }
                        public class DbExpressionRebinder : System.Data.Entity.Core.Common.CommandTrees.DefaultExpressionVisitor
                        {
                            protected DbExpressionRebinder(System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace targetWorkspace) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbPropertyExpression expression) => throw null;
                            protected override System.Data.Entity.Core.Metadata.Edm.EntitySetBase VisitEntitySet(System.Data.Entity.Core.Metadata.Edm.EntitySetBase entitySet) => throw null;
                            protected override System.Data.Entity.Core.Metadata.Edm.EdmFunction VisitFunction(System.Data.Entity.Core.Metadata.Edm.EdmFunction functionMetadata) => throw null;
                            protected override System.Data.Entity.Core.Metadata.Edm.EdmType VisitType(System.Data.Entity.Core.Metadata.Edm.EdmType type) => throw null;
                            protected override System.Data.Entity.Core.Metadata.Edm.TypeUsage VisitTypeUsage(System.Data.Entity.Core.Metadata.Edm.TypeUsage type) => throw null;
                        }
                        public abstract class DbExpressionVisitor
                        {
                            protected DbExpressionVisitor() => throw null;
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbAndExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbApplyExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbArithmeticExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbCaseExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbCastExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbComparisonExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbConstantExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbCrossJoinExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbDerefExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbDistinctExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbElementExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbExceptExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbFilterExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbEntityRefExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbRefKeyExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbGroupByExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbIntersectExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbIsEmptyExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbIsNullExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbIsOfExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbJoinExpression expression);
                            public virtual void Visit(System.Data.Entity.Core.Common.CommandTrees.DbLambdaExpression expression) => throw null;
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbLikeExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbLimitExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbNewInstanceExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbNotExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbNullExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbOfTypeExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbOrExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbParameterReferenceExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbProjectExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbPropertyExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbQuantifierExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbRefExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbRelationshipNavigationExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbScanExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbSkipExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbSortExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbTreatExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbUnionAllExpression expression);
                            public abstract void Visit(System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression expression);
                            public virtual void Visit(System.Data.Entity.Core.Common.CommandTrees.DbInExpression expression) => throw null;
                        }
                        public abstract class DbExpressionVisitor<TResultType>
                        {
                            protected DbExpressionVisitor() => throw null;
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbAndExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbApplyExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbArithmeticExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbCaseExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbCastExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbComparisonExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbConstantExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbCrossJoinExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbDerefExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbDistinctExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbElementExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbExceptExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbFilterExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbEntityRefExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbRefKeyExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbGroupByExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbIntersectExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbIsEmptyExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbIsNullExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbIsOfExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbJoinExpression expression);
                            public virtual TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbLambdaExpression expression) => throw null;
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbLikeExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbLimitExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbNewInstanceExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbNotExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbNullExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbOfTypeExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbOrExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbParameterReferenceExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbProjectExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbPropertyExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbQuantifierExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbRefExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbRelationshipNavigationExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbScanExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbSortExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbSkipExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbTreatExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbUnionAllExpression expression);
                            public abstract TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression expression);
                            public virtual TResultType Visit(System.Data.Entity.Core.Common.CommandTrees.DbInExpression expression) => throw null;
                        }
                        public sealed class DbFilterExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding Input { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Predicate { get => throw null; }
                        }
                        public sealed class DbFunctionAggregate : System.Data.Entity.Core.Common.CommandTrees.DbAggregate
                        {
                            public bool Distinct { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.EdmFunction Function { get => throw null; }
                        }
                        public sealed class DbFunctionCommandTree : System.Data.Entity.Core.Common.CommandTrees.DbCommandTree
                        {
                            public override System.Data.Entity.Core.Common.CommandTrees.DbCommandTreeKind CommandTreeKind { get => throw null; }
                            public DbFunctionCommandTree(System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace metadata, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, System.Data.Entity.Core.Metadata.Edm.EdmFunction edmFunction, System.Data.Entity.Core.Metadata.Edm.TypeUsage resultType, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, System.Data.Entity.Core.Metadata.Edm.TypeUsage>> parameters) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.EdmFunction EdmFunction { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.TypeUsage ResultType { get => throw null; }
                        }
                        public class DbFunctionExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public virtual System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbExpression> Arguments { get => throw null; }
                            public virtual System.Data.Entity.Core.Metadata.Edm.EdmFunction Function { get => throw null; }
                        }
                        public sealed class DbGroupAggregate : System.Data.Entity.Core.Common.CommandTrees.DbAggregate
                        {
                        }
                        public sealed class DbGroupByExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbAggregate> Aggregates { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbGroupExpressionBinding Input { get => throw null; }
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbExpression> Keys { get => throw null; }
                        }
                        public sealed class DbGroupExpressionBinding
                        {
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Expression { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbGroupAggregate GroupAggregate { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression GroupVariable { get => throw null; }
                            public string GroupVariableName { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.TypeUsage GroupVariableType { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression Variable { get => throw null; }
                            public string VariableName { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.TypeUsage VariableType { get => throw null; }
                        }
                        public class DbInExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Item { get => throw null; }
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbExpression> List { get => throw null; }
                        }
                        public sealed class DbInsertCommandTree : System.Data.Entity.Core.Common.CommandTrees.DbModificationCommandTree
                        {
                            public override System.Data.Entity.Core.Common.CommandTrees.DbCommandTreeKind CommandTreeKind { get => throw null; }
                            public DbInsertCommandTree(System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace metadata, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding target, System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Common.CommandTrees.DbModificationClause> setClauses, System.Data.Entity.Core.Common.CommandTrees.DbExpression returning) => throw null;
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Returning { get => throw null; }
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbModificationClause> SetClauses { get => throw null; }
                        }
                        public sealed class DbIntersectExpression : System.Data.Entity.Core.Common.CommandTrees.DbBinaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public sealed class DbIsEmptyExpression : System.Data.Entity.Core.Common.CommandTrees.DbUnaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public class DbIsNullExpression : System.Data.Entity.Core.Common.CommandTrees.DbUnaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public sealed class DbIsOfExpression : System.Data.Entity.Core.Common.CommandTrees.DbUnaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.TypeUsage OfType { get => throw null; }
                        }
                        public sealed class DbJoinExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression JoinCondition { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding Left { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding Right { get => throw null; }
                        }
                        public sealed class DbLambda
                        {
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Body { get => throw null; }
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Common.CommandTrees.DbExpression body, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression> variables) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Common.CommandTrees.DbExpression body, params System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression[] variables) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Metadata.Edm.TypeUsage argument1Type, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> lambdaFunction) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Metadata.Edm.TypeUsage argument1Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument2Type, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> lambdaFunction) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Metadata.Edm.TypeUsage argument1Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument2Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument3Type, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> lambdaFunction) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Metadata.Edm.TypeUsage argument1Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument2Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument3Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument4Type, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> lambdaFunction) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Metadata.Edm.TypeUsage argument1Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument2Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument3Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument4Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument5Type, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> lambdaFunction) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Metadata.Edm.TypeUsage argument1Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument2Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument3Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument4Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument5Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument6Type, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> lambdaFunction) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Metadata.Edm.TypeUsage argument1Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument2Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument3Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument4Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument5Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument6Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument7Type, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> lambdaFunction) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Metadata.Edm.TypeUsage argument1Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument2Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument3Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument4Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument5Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument6Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument7Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument8Type, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> lambdaFunction) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Metadata.Edm.TypeUsage argument1Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument2Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument3Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument4Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument5Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument6Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument7Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument8Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument9Type, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> lambdaFunction) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Metadata.Edm.TypeUsage argument1Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument2Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument3Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument4Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument5Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument6Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument7Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument8Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument9Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument10Type, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> lambdaFunction) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Metadata.Edm.TypeUsage argument1Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument2Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument3Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument4Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument5Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument6Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument7Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument8Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument9Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument10Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument11Type, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> lambdaFunction) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Metadata.Edm.TypeUsage argument1Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument2Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument3Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument4Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument5Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument6Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument7Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument8Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument9Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument10Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument11Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument12Type, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> lambdaFunction) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Metadata.Edm.TypeUsage argument1Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument2Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument3Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument4Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument5Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument6Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument7Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument8Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument9Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument10Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument11Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument12Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument13Type, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> lambdaFunction) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Metadata.Edm.TypeUsage argument1Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument2Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument3Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument4Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument5Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument6Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument7Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument8Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument9Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument10Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument11Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument12Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument13Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument14Type, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> lambdaFunction) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Metadata.Edm.TypeUsage argument1Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument2Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument3Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument4Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument5Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument6Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument7Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument8Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument9Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument10Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument11Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument12Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument13Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument14Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument15Type, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> lambdaFunction) => throw null;
                            public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Create(System.Data.Entity.Core.Metadata.Edm.TypeUsage argument1Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument2Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument3Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument4Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument5Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument6Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument7Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument8Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument9Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument10Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument11Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument12Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument13Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument14Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument15Type, System.Data.Entity.Core.Metadata.Edm.TypeUsage argument16Type, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> lambdaFunction) => throw null;
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression> Variables { get => throw null; }
                        }
                        public sealed class DbLambdaExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbExpression> Arguments { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbLambda Lambda { get => throw null; }
                        }
                        public sealed class DbLikeExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Argument { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Escape { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Pattern { get => throw null; }
                        }
                        public sealed class DbLimitExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Argument { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Limit { get => throw null; }
                            public bool WithTies { get => throw null; }
                        }
                        public abstract class DbModificationClause
                        {
                        }
                        public abstract class DbModificationCommandTree : System.Data.Entity.Core.Common.CommandTrees.DbCommandTree
                        {
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding Target { get => throw null; }
                        }
                        public sealed class DbNewInstanceExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbExpression> Arguments { get => throw null; }
                        }
                        public sealed class DbNotExpression : System.Data.Entity.Core.Common.CommandTrees.DbUnaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public sealed class DbNullExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public sealed class DbOfTypeExpression : System.Data.Entity.Core.Common.CommandTrees.DbUnaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.TypeUsage OfType { get => throw null; }
                        }
                        public class DbOrExpression : System.Data.Entity.Core.Common.CommandTrees.DbBinaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public class DbParameterReferenceExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public virtual string ParameterName { get => throw null; }
                        }
                        public sealed class DbProjectExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding Input { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Projection { get => throw null; }
                        }
                        public class DbPropertyExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public virtual System.Data.Entity.Core.Common.CommandTrees.DbExpression Instance { get => throw null; }
                            public static implicit operator System.Collections.Generic.KeyValuePair<string, System.Data.Entity.Core.Common.CommandTrees.DbExpression>(System.Data.Entity.Core.Common.CommandTrees.DbPropertyExpression value) => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.EdmMember Property { get => throw null; }
                            public System.Collections.Generic.KeyValuePair<string, System.Data.Entity.Core.Common.CommandTrees.DbExpression> ToKeyValuePair() => throw null;
                        }
                        public sealed class DbQuantifierExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding Input { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Predicate { get => throw null; }
                        }
                        public sealed class DbQueryCommandTree : System.Data.Entity.Core.Common.CommandTrees.DbCommandTree
                        {
                            public override System.Data.Entity.Core.Common.CommandTrees.DbCommandTreeKind CommandTreeKind { get => throw null; }
                            public DbQueryCommandTree(System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace metadata, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, System.Data.Entity.Core.Common.CommandTrees.DbExpression query, bool validate, bool useDatabaseNullSemantics, bool disableFilterOverProjectionSimplificationForCustomFunctions) => throw null;
                            public DbQueryCommandTree(System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace metadata, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, System.Data.Entity.Core.Common.CommandTrees.DbExpression query, bool validate, bool useDatabaseNullSemantics) => throw null;
                            public DbQueryCommandTree(System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace metadata, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, System.Data.Entity.Core.Common.CommandTrees.DbExpression query, bool validate) => throw null;
                            public DbQueryCommandTree(System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace metadata, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, System.Data.Entity.Core.Common.CommandTrees.DbExpression query) => throw null;
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Query { get => throw null; }
                        }
                        public sealed class DbRefExpression : System.Data.Entity.Core.Common.CommandTrees.DbUnaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.EntitySet EntitySet { get => throw null; }
                        }
                        public sealed class DbRefKeyExpression : System.Data.Entity.Core.Common.CommandTrees.DbUnaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public sealed class DbRelationshipNavigationExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.RelationshipEndMember NavigateFrom { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.RelationshipEndMember NavigateTo { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression NavigationSource { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.RelationshipType Relationship { get => throw null; }
                        }
                        public class DbScanExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.EntitySetBase Target { get => throw null; }
                        }
                        public sealed class DbSetClause : System.Data.Entity.Core.Common.CommandTrees.DbModificationClause
                        {
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Property { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Value { get => throw null; }
                        }
                        public sealed class DbSkipExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Count { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding Input { get => throw null; }
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbSortClause> SortOrder { get => throw null; }
                        }
                        public sealed class DbSortClause
                        {
                            public bool Ascending { get => throw null; }
                            public string Collation { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Expression { get => throw null; }
                        }
                        public sealed class DbSortExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding Input { get => throw null; }
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbSortClause> SortOrder { get => throw null; }
                        }
                        public sealed class DbTreatExpression : System.Data.Entity.Core.Common.CommandTrees.DbUnaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public abstract class DbUnaryExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public virtual System.Data.Entity.Core.Common.CommandTrees.DbExpression Argument { get => throw null; }
                        }
                        public sealed class DbUnionAllExpression : System.Data.Entity.Core.Common.CommandTrees.DbBinaryExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                        }
                        public sealed class DbUpdateCommandTree : System.Data.Entity.Core.Common.CommandTrees.DbModificationCommandTree
                        {
                            public override System.Data.Entity.Core.Common.CommandTrees.DbCommandTreeKind CommandTreeKind { get => throw null; }
                            public DbUpdateCommandTree(System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace metadata, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding target, System.Data.Entity.Core.Common.CommandTrees.DbExpression predicate, System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Common.CommandTrees.DbModificationClause> setClauses, System.Data.Entity.Core.Common.CommandTrees.DbExpression returning) => throw null;
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Predicate { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbExpression Returning { get => throw null; }
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbModificationClause> SetClauses { get => throw null; }
                        }
                        public class DbVariableReferenceExpression : System.Data.Entity.Core.Common.CommandTrees.DbExpression
                        {
                            public override void Accept(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor visitor) => throw null;
                            public override TResultType Accept<TResultType>(System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<TResultType> visitor) => throw null;
                            public virtual string VariableName { get => throw null; }
                        }
                        public class DefaultExpressionVisitor : System.Data.Entity.Core.Common.CommandTrees.DbExpressionVisitor<System.Data.Entity.Core.Common.CommandTrees.DbExpression>
                        {
                            protected DefaultExpressionVisitor() => throw null;
                            protected virtual void OnEnterScope(System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression> scopeVariables) => throw null;
                            protected virtual void OnExitScope() => throw null;
                            protected virtual void OnExpressionReplaced(System.Data.Entity.Core.Common.CommandTrees.DbExpression oldExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression newExpression) => throw null;
                            protected virtual void OnVariableRebound(System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression fromVarRef, System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression toVarRef) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbConstantExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbNullExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbParameterReferenceExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbLambdaExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbPropertyExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbComparisonExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbLikeExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbLimitExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbIsNullExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbArithmeticExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbAndExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbOrExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbInExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbNotExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbDistinctExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbElementExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbIsEmptyExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbUnionAllExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbIntersectExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbExceptExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbTreatExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbIsOfExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbCastExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbCaseExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbOfTypeExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbNewInstanceExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbRefExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbRelationshipNavigationExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbDerefExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbRefKeyExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbEntityRefExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbScanExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbFilterExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbProjectExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbCrossJoinExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbJoinExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbApplyExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbGroupByExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbSkipExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbSortExpression expression) => throw null;
                            public override System.Data.Entity.Core.Common.CommandTrees.DbExpression Visit(System.Data.Entity.Core.Common.CommandTrees.DbQuantifierExpression expression) => throw null;
                            protected virtual System.Data.Entity.Core.Common.CommandTrees.DbAggregate VisitAggregate(System.Data.Entity.Core.Common.CommandTrees.DbAggregate aggregate) => throw null;
                            protected virtual System.Data.Entity.Core.Metadata.Edm.EntitySetBase VisitEntitySet(System.Data.Entity.Core.Metadata.Edm.EntitySetBase entitySet) => throw null;
                            protected virtual System.Data.Entity.Core.Common.CommandTrees.DbExpression VisitExpression(System.Data.Entity.Core.Common.CommandTrees.DbExpression expression) => throw null;
                            protected virtual System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding VisitExpressionBinding(System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding binding) => throw null;
                            protected virtual System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding> VisitExpressionBindingList(System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding> list) => throw null;
                            protected virtual System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbExpression> VisitExpressionList(System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbExpression> list) => throw null;
                            protected virtual System.Data.Entity.Core.Metadata.Edm.EdmFunction VisitFunction(System.Data.Entity.Core.Metadata.Edm.EdmFunction functionMetadata) => throw null;
                            protected virtual System.Data.Entity.Core.Common.CommandTrees.DbFunctionAggregate VisitFunctionAggregate(System.Data.Entity.Core.Common.CommandTrees.DbFunctionAggregate aggregate) => throw null;
                            protected virtual System.Data.Entity.Core.Common.CommandTrees.DbGroupAggregate VisitGroupAggregate(System.Data.Entity.Core.Common.CommandTrees.DbGroupAggregate aggregate) => throw null;
                            protected virtual System.Data.Entity.Core.Common.CommandTrees.DbGroupExpressionBinding VisitGroupExpressionBinding(System.Data.Entity.Core.Common.CommandTrees.DbGroupExpressionBinding binding) => throw null;
                            protected virtual System.Data.Entity.Core.Common.CommandTrees.DbLambda VisitLambda(System.Data.Entity.Core.Common.CommandTrees.DbLambda lambda) => throw null;
                            protected virtual System.Data.Entity.Core.Common.CommandTrees.DbSortClause VisitSortClause(System.Data.Entity.Core.Common.CommandTrees.DbSortClause clause) => throw null;
                            protected virtual System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbSortClause> VisitSortOrder(System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbSortClause> sortOrder) => throw null;
                            protected virtual System.Data.Entity.Core.Metadata.Edm.EdmType VisitType(System.Data.Entity.Core.Metadata.Edm.EdmType type) => throw null;
                            protected virtual System.Data.Entity.Core.Metadata.Edm.TypeUsage VisitTypeUsage(System.Data.Entity.Core.Metadata.Edm.TypeUsage type) => throw null;
                        }
                        namespace ExpressionBuilder
                        {
                            public static class DbExpressionBuilder
                            {
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionAggregate Aggregate(this System.Data.Entity.Core.Metadata.Edm.EdmFunction function, System.Data.Entity.Core.Common.CommandTrees.DbExpression argument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionAggregate Aggregate(this System.Data.Entity.Core.Metadata.Edm.EdmFunction function, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Common.CommandTrees.DbExpression> arguments) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionAggregate AggregateDistinct(this System.Data.Entity.Core.Metadata.Edm.EdmFunction function, System.Data.Entity.Core.Common.CommandTrees.DbExpression argument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionAggregate AggregateDistinct(this System.Data.Entity.Core.Metadata.Edm.EdmFunction function, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Common.CommandTrees.DbExpression> arguments) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbQuantifierExpression All(this System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding input, System.Data.Entity.Core.Common.CommandTrees.DbExpression predicate) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbQuantifierExpression All(this System.Data.Entity.Core.Common.CommandTrees.DbExpression source, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> predicate) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbAndExpression And(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbQuantifierExpression Any(this System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding input, System.Data.Entity.Core.Common.CommandTrees.DbExpression predicate) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbExpression Any(this System.Data.Entity.Core.Common.CommandTrees.DbExpression source) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbQuantifierExpression Any(this System.Data.Entity.Core.Common.CommandTrees.DbExpression source, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> predicate) => throw null;
                                public static System.Collections.Generic.KeyValuePair<string, System.Data.Entity.Core.Common.CommandTrees.DbExpression> As(this System.Data.Entity.Core.Common.CommandTrees.DbExpression value, string alias) => throw null;
                                public static System.Collections.Generic.KeyValuePair<string, System.Data.Entity.Core.Common.CommandTrees.DbAggregate> As(this System.Data.Entity.Core.Common.CommandTrees.DbAggregate value, string alias) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding Bind(this System.Data.Entity.Core.Common.CommandTrees.DbExpression input) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding BindAs(this System.Data.Entity.Core.Common.CommandTrees.DbExpression input, string varName) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbCaseExpression Case(System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Common.CommandTrees.DbExpression> whenExpressions, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Common.CommandTrees.DbExpression> thenExpressions, System.Data.Entity.Core.Common.CommandTrees.DbExpression elseExpression) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbCastExpression CastTo(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument, System.Data.Entity.Core.Metadata.Edm.TypeUsage toType) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbConstantExpression Constant(object value) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbConstantExpression Constant(this System.Data.Entity.Core.Metadata.Edm.TypeUsage constantType, object value) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbRefExpression CreateRef(this System.Data.Entity.Core.Metadata.Edm.EntitySet entitySet, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Common.CommandTrees.DbExpression> keyValues) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbRefExpression CreateRef(this System.Data.Entity.Core.Metadata.Edm.EntitySet entitySet, params System.Data.Entity.Core.Common.CommandTrees.DbExpression[] keyValues) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbRefExpression CreateRef(this System.Data.Entity.Core.Metadata.Edm.EntitySet entitySet, System.Data.Entity.Core.Metadata.Edm.EntityType entityType, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Common.CommandTrees.DbExpression> keyValues) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbRefExpression CreateRef(this System.Data.Entity.Core.Metadata.Edm.EntitySet entitySet, System.Data.Entity.Core.Metadata.Edm.EntityType entityType, params System.Data.Entity.Core.Common.CommandTrees.DbExpression[] keyValues) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbApplyExpression CrossApply(this System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding input, System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding apply) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbApplyExpression CrossApply(this System.Data.Entity.Core.Common.CommandTrees.DbExpression source, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Collections.Generic.KeyValuePair<string, System.Data.Entity.Core.Common.CommandTrees.DbExpression>> apply) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbCrossJoinExpression CrossJoin(System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding> inputs) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbDerefExpression Deref(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbDistinctExpression Distinct(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbArithmeticExpression Divide(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbElementExpression Element(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbComparisonExpression Equal(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbExceptExpression Except(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbExpression Exists(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbConstantExpression False { get => throw null; }
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFilterExpression Filter(this System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding input, System.Data.Entity.Core.Common.CommandTrees.DbExpression predicate) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbJoinExpression FullOuterJoin(this System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding left, System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding right, System.Data.Entity.Core.Common.CommandTrees.DbExpression joinCondition) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbJoinExpression FullOuterJoin(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> joinCondition) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbEntityRefExpression GetEntityRef(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbRefKeyExpression GetRefKey(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbComparisonExpression GreaterThan(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbComparisonExpression GreaterThanOrEqual(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbGroupAggregate GroupAggregate(System.Data.Entity.Core.Common.CommandTrees.DbExpression argument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbGroupExpressionBinding GroupBind(this System.Data.Entity.Core.Common.CommandTrees.DbExpression input) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbGroupExpressionBinding GroupBindAs(this System.Data.Entity.Core.Common.CommandTrees.DbExpression input, string varName, string groupVarName) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbGroupByExpression GroupBy(this System.Data.Entity.Core.Common.CommandTrees.DbGroupExpressionBinding input, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, System.Data.Entity.Core.Common.CommandTrees.DbExpression>> keys, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, System.Data.Entity.Core.Common.CommandTrees.DbAggregate>> aggregates) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbInExpression In(this System.Data.Entity.Core.Common.CommandTrees.DbExpression expression, System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbConstantExpression> list) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbJoinExpression InnerJoin(this System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding left, System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding right, System.Data.Entity.Core.Common.CommandTrees.DbExpression joinCondition) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbJoinExpression InnerJoin(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> joinCondition) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbIntersectExpression Intersect(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Invoke(this System.Data.Entity.Core.Metadata.Edm.EdmFunction function, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Common.CommandTrees.DbExpression> arguments) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Invoke(this System.Data.Entity.Core.Metadata.Edm.EdmFunction function, params System.Data.Entity.Core.Common.CommandTrees.DbExpression[] arguments) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbLambdaExpression Invoke(this System.Data.Entity.Core.Common.CommandTrees.DbLambda lambda, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Common.CommandTrees.DbExpression> arguments) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbLambdaExpression Invoke(this System.Data.Entity.Core.Common.CommandTrees.DbLambda lambda, params System.Data.Entity.Core.Common.CommandTrees.DbExpression[] arguments) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbIsEmptyExpression IsEmpty(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbIsNullExpression IsNull(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbIsOfExpression IsOf(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument, System.Data.Entity.Core.Metadata.Edm.TypeUsage type) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbIsOfExpression IsOfOnly(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument, System.Data.Entity.Core.Metadata.Edm.TypeUsage type) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbJoinExpression Join(this System.Data.Entity.Core.Common.CommandTrees.DbExpression outer, System.Data.Entity.Core.Common.CommandTrees.DbExpression inner, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> outerKey, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> innerKey) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbProjectExpression Join<TSelector>(this System.Data.Entity.Core.Common.CommandTrees.DbExpression outer, System.Data.Entity.Core.Common.CommandTrees.DbExpression inner, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> outerKey, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> innerKey, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, TSelector> selector) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Lambda(System.Data.Entity.Core.Common.CommandTrees.DbExpression body, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression> variables) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbLambda Lambda(System.Data.Entity.Core.Common.CommandTrees.DbExpression body, params System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression[] variables) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbJoinExpression LeftOuterJoin(this System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding left, System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding right, System.Data.Entity.Core.Common.CommandTrees.DbExpression joinCondition) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbJoinExpression LeftOuterJoin(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> joinCondition) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbComparisonExpression LessThan(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbComparisonExpression LessThanOrEqual(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbLikeExpression Like(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument, System.Data.Entity.Core.Common.CommandTrees.DbExpression pattern) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbLikeExpression Like(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument, System.Data.Entity.Core.Common.CommandTrees.DbExpression pattern, System.Data.Entity.Core.Common.CommandTrees.DbExpression escape) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbLimitExpression Limit(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument, System.Data.Entity.Core.Common.CommandTrees.DbExpression count) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbArithmeticExpression Minus(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbArithmeticExpression Modulo(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbArithmeticExpression Multiply(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbRelationshipNavigationExpression Navigate(this System.Data.Entity.Core.Common.CommandTrees.DbExpression navigateFrom, System.Data.Entity.Core.Metadata.Edm.RelationshipEndMember fromEnd, System.Data.Entity.Core.Metadata.Edm.RelationshipEndMember toEnd) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbRelationshipNavigationExpression Navigate(this System.Data.Entity.Core.Metadata.Edm.RelationshipType type, string fromEndName, string toEndName, System.Data.Entity.Core.Common.CommandTrees.DbExpression navigateFrom) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbArithmeticExpression Negate(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbNewInstanceExpression New(this System.Data.Entity.Core.Metadata.Edm.TypeUsage instanceType, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Common.CommandTrees.DbExpression> arguments) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbNewInstanceExpression New(this System.Data.Entity.Core.Metadata.Edm.TypeUsage instanceType, params System.Data.Entity.Core.Common.CommandTrees.DbExpression[] arguments) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbNewInstanceExpression NewCollection(System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Common.CommandTrees.DbExpression> elements) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbNewInstanceExpression NewCollection(params System.Data.Entity.Core.Common.CommandTrees.DbExpression[] elements) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbNewInstanceExpression NewEmptyCollection(this System.Data.Entity.Core.Metadata.Edm.TypeUsage collectionType) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbNewInstanceExpression NewRow(System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, System.Data.Entity.Core.Common.CommandTrees.DbExpression>> columnValues) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbNotExpression Not(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbComparisonExpression NotEqual(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbNullExpression Null(this System.Data.Entity.Core.Metadata.Edm.TypeUsage nullType) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbOfTypeExpression OfType(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument, System.Data.Entity.Core.Metadata.Edm.TypeUsage type) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbOfTypeExpression OfTypeOnly(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument, System.Data.Entity.Core.Metadata.Edm.TypeUsage type) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbOrExpression Or(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbSortExpression OrderBy(this System.Data.Entity.Core.Common.CommandTrees.DbExpression source, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> sortKey) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbSortExpression OrderBy(this System.Data.Entity.Core.Common.CommandTrees.DbExpression source, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> sortKey, string collation) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbSortExpression OrderByDescending(this System.Data.Entity.Core.Common.CommandTrees.DbExpression source, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> sortKey) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbSortExpression OrderByDescending(this System.Data.Entity.Core.Common.CommandTrees.DbExpression source, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> sortKey, string collation) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbApplyExpression OuterApply(this System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding input, System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding apply) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbApplyExpression OuterApply(this System.Data.Entity.Core.Common.CommandTrees.DbExpression source, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Collections.Generic.KeyValuePair<string, System.Data.Entity.Core.Common.CommandTrees.DbExpression>> apply) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbParameterReferenceExpression Parameter(this System.Data.Entity.Core.Metadata.Edm.TypeUsage type, string name) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbArithmeticExpression Plus(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbProjectExpression Project(this System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding input, System.Data.Entity.Core.Common.CommandTrees.DbExpression projection) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbPropertyExpression Property(this System.Data.Entity.Core.Common.CommandTrees.DbExpression instance, System.Data.Entity.Core.Metadata.Edm.EdmProperty propertyMetadata) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbPropertyExpression Property(this System.Data.Entity.Core.Common.CommandTrees.DbExpression instance, System.Data.Entity.Core.Metadata.Edm.NavigationProperty navigationProperty) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbPropertyExpression Property(this System.Data.Entity.Core.Common.CommandTrees.DbExpression instance, System.Data.Entity.Core.Metadata.Edm.RelationshipEndMember relationshipEnd) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbPropertyExpression Property(this System.Data.Entity.Core.Common.CommandTrees.DbExpression instance, string propertyName) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbRefExpression RefFromKey(this System.Data.Entity.Core.Metadata.Edm.EntitySet entitySet, System.Data.Entity.Core.Common.CommandTrees.DbExpression keyRow) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbRefExpression RefFromKey(this System.Data.Entity.Core.Metadata.Edm.EntitySet entitySet, System.Data.Entity.Core.Common.CommandTrees.DbExpression keyRow, System.Data.Entity.Core.Metadata.Edm.EntityType entityType) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbScanExpression Scan(this System.Data.Entity.Core.Metadata.Edm.EntitySetBase targetSet) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbProjectExpression Select<TProjection>(this System.Data.Entity.Core.Common.CommandTrees.DbExpression source, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, TProjection> projection) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbProjectExpression SelectMany(this System.Data.Entity.Core.Common.CommandTrees.DbExpression source, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> apply) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbProjectExpression SelectMany<TSelector>(this System.Data.Entity.Core.Common.CommandTrees.DbExpression source, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> apply, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression, TSelector> selector) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbSetClause SetClause(System.Data.Entity.Core.Common.CommandTrees.DbExpression property, System.Data.Entity.Core.Common.CommandTrees.DbExpression value) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbSkipExpression Skip(this System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding input, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Common.CommandTrees.DbSortClause> sortOrder, System.Data.Entity.Core.Common.CommandTrees.DbExpression count) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbSkipExpression Skip(this System.Data.Entity.Core.Common.CommandTrees.DbSortExpression argument, System.Data.Entity.Core.Common.CommandTrees.DbExpression count) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbSortExpression Sort(this System.Data.Entity.Core.Common.CommandTrees.DbExpressionBinding input, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Common.CommandTrees.DbSortClause> sortOrder) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbLimitExpression Take(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument, System.Data.Entity.Core.Common.CommandTrees.DbExpression count) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbSortExpression ThenBy(this System.Data.Entity.Core.Common.CommandTrees.DbSortExpression source, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> sortKey) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbSortExpression ThenBy(this System.Data.Entity.Core.Common.CommandTrees.DbSortExpression source, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> sortKey, string collation) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbSortExpression ThenByDescending(this System.Data.Entity.Core.Common.CommandTrees.DbSortExpression source, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> sortKey) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbSortExpression ThenByDescending(this System.Data.Entity.Core.Common.CommandTrees.DbSortExpression source, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> sortKey, string collation) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbSortClause ToSortClause(this System.Data.Entity.Core.Common.CommandTrees.DbExpression key) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbSortClause ToSortClause(this System.Data.Entity.Core.Common.CommandTrees.DbExpression key, string collation) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbSortClause ToSortClauseDescending(this System.Data.Entity.Core.Common.CommandTrees.DbExpression key) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbSortClause ToSortClauseDescending(this System.Data.Entity.Core.Common.CommandTrees.DbExpression key, string collation) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbTreatExpression TreatAs(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument, System.Data.Entity.Core.Metadata.Edm.TypeUsage treatType) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbConstantExpression True { get => throw null; }
                                public static System.Data.Entity.Core.Common.CommandTrees.DbArithmeticExpression UnaryMinus(this System.Data.Entity.Core.Common.CommandTrees.DbExpression argument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbExpression Union(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbUnionAllExpression UnionAll(this System.Data.Entity.Core.Common.CommandTrees.DbExpression left, System.Data.Entity.Core.Common.CommandTrees.DbExpression right) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression Variable(this System.Data.Entity.Core.Metadata.Edm.TypeUsage type, string name) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFilterExpression Where(this System.Data.Entity.Core.Common.CommandTrees.DbExpression source, System.Func<System.Data.Entity.Core.Common.CommandTrees.DbExpression, System.Data.Entity.Core.Common.CommandTrees.DbExpression> predicate) => throw null;
                            }
                            public static class EdmFunctions
                            {
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Abs(this System.Data.Entity.Core.Common.CommandTrees.DbExpression value) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression AddDays(this System.Data.Entity.Core.Common.CommandTrees.DbExpression dateValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression addValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression AddHours(this System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression addValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression AddMicroseconds(this System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression addValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression AddMilliseconds(this System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression addValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression AddMinutes(this System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression addValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression AddMonths(this System.Data.Entity.Core.Common.CommandTrees.DbExpression dateValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression addValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression AddNanoseconds(this System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression addValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression AddSeconds(this System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression addValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression AddYears(this System.Data.Entity.Core.Common.CommandTrees.DbExpression dateValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression addValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Average(this System.Data.Entity.Core.Common.CommandTrees.DbExpression collection) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression BitwiseAnd(this System.Data.Entity.Core.Common.CommandTrees.DbExpression value1, System.Data.Entity.Core.Common.CommandTrees.DbExpression value2) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression BitwiseNot(this System.Data.Entity.Core.Common.CommandTrees.DbExpression value) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression BitwiseOr(this System.Data.Entity.Core.Common.CommandTrees.DbExpression value1, System.Data.Entity.Core.Common.CommandTrees.DbExpression value2) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression BitwiseXor(this System.Data.Entity.Core.Common.CommandTrees.DbExpression value1, System.Data.Entity.Core.Common.CommandTrees.DbExpression value2) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Ceiling(this System.Data.Entity.Core.Common.CommandTrees.DbExpression value) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Concat(this System.Data.Entity.Core.Common.CommandTrees.DbExpression string1, System.Data.Entity.Core.Common.CommandTrees.DbExpression string2) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbExpression Contains(this System.Data.Entity.Core.Common.CommandTrees.DbExpression searchedString, System.Data.Entity.Core.Common.CommandTrees.DbExpression searchedForString) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Count(this System.Data.Entity.Core.Common.CommandTrees.DbExpression collection) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression CreateDateTime(System.Data.Entity.Core.Common.CommandTrees.DbExpression year, System.Data.Entity.Core.Common.CommandTrees.DbExpression month, System.Data.Entity.Core.Common.CommandTrees.DbExpression day, System.Data.Entity.Core.Common.CommandTrees.DbExpression hour, System.Data.Entity.Core.Common.CommandTrees.DbExpression minute, System.Data.Entity.Core.Common.CommandTrees.DbExpression second) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression CreateDateTimeOffset(System.Data.Entity.Core.Common.CommandTrees.DbExpression year, System.Data.Entity.Core.Common.CommandTrees.DbExpression month, System.Data.Entity.Core.Common.CommandTrees.DbExpression day, System.Data.Entity.Core.Common.CommandTrees.DbExpression hour, System.Data.Entity.Core.Common.CommandTrees.DbExpression minute, System.Data.Entity.Core.Common.CommandTrees.DbExpression second, System.Data.Entity.Core.Common.CommandTrees.DbExpression timeZoneOffset) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression CreateTime(System.Data.Entity.Core.Common.CommandTrees.DbExpression hour, System.Data.Entity.Core.Common.CommandTrees.DbExpression minute, System.Data.Entity.Core.Common.CommandTrees.DbExpression second) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression CurrentDateTime() => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression CurrentDateTimeOffset() => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression CurrentUtcDateTime() => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Day(this System.Data.Entity.Core.Common.CommandTrees.DbExpression dateValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression DayOfYear(this System.Data.Entity.Core.Common.CommandTrees.DbExpression dateValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression DiffDays(this System.Data.Entity.Core.Common.CommandTrees.DbExpression dateValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression dateValue2) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression DiffHours(this System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue2) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression DiffMicroseconds(this System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue2) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression DiffMilliseconds(this System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue2) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression DiffMinutes(this System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue2) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression DiffMonths(this System.Data.Entity.Core.Common.CommandTrees.DbExpression dateValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression dateValue2) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression DiffNanoseconds(this System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue2) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression DiffSeconds(this System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue2) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression DiffYears(this System.Data.Entity.Core.Common.CommandTrees.DbExpression dateValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression dateValue2) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression EndsWith(this System.Data.Entity.Core.Common.CommandTrees.DbExpression stringArgument, System.Data.Entity.Core.Common.CommandTrees.DbExpression suffix) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Floor(this System.Data.Entity.Core.Common.CommandTrees.DbExpression value) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GetTotalOffsetMinutes(this System.Data.Entity.Core.Common.CommandTrees.DbExpression dateTimeOffsetArgument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Hour(this System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression IndexOf(this System.Data.Entity.Core.Common.CommandTrees.DbExpression searchString, System.Data.Entity.Core.Common.CommandTrees.DbExpression stringToFind) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Left(this System.Data.Entity.Core.Common.CommandTrees.DbExpression stringArgument, System.Data.Entity.Core.Common.CommandTrees.DbExpression length) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Length(this System.Data.Entity.Core.Common.CommandTrees.DbExpression stringArgument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression LocalDateTime(this System.Data.Entity.Core.Common.CommandTrees.DbExpression dateTimeOffsetArgument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression LongCount(this System.Data.Entity.Core.Common.CommandTrees.DbExpression collection) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Max(this System.Data.Entity.Core.Common.CommandTrees.DbExpression collection) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Millisecond(this System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Min(this System.Data.Entity.Core.Common.CommandTrees.DbExpression collection) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Minute(this System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Month(this System.Data.Entity.Core.Common.CommandTrees.DbExpression dateValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression NewGuid() => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Power(this System.Data.Entity.Core.Common.CommandTrees.DbExpression baseArgument, System.Data.Entity.Core.Common.CommandTrees.DbExpression exponent) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Replace(this System.Data.Entity.Core.Common.CommandTrees.DbExpression stringArgument, System.Data.Entity.Core.Common.CommandTrees.DbExpression toReplace, System.Data.Entity.Core.Common.CommandTrees.DbExpression replacement) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Reverse(this System.Data.Entity.Core.Common.CommandTrees.DbExpression stringArgument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Right(this System.Data.Entity.Core.Common.CommandTrees.DbExpression stringArgument, System.Data.Entity.Core.Common.CommandTrees.DbExpression length) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Round(this System.Data.Entity.Core.Common.CommandTrees.DbExpression value) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Round(this System.Data.Entity.Core.Common.CommandTrees.DbExpression value, System.Data.Entity.Core.Common.CommandTrees.DbExpression digits) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Second(this System.Data.Entity.Core.Common.CommandTrees.DbExpression timeValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression StartsWith(this System.Data.Entity.Core.Common.CommandTrees.DbExpression stringArgument, System.Data.Entity.Core.Common.CommandTrees.DbExpression prefix) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression StDev(this System.Data.Entity.Core.Common.CommandTrees.DbExpression collection) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression StDevP(this System.Data.Entity.Core.Common.CommandTrees.DbExpression collection) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Substring(this System.Data.Entity.Core.Common.CommandTrees.DbExpression stringArgument, System.Data.Entity.Core.Common.CommandTrees.DbExpression start, System.Data.Entity.Core.Common.CommandTrees.DbExpression length) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Sum(this System.Data.Entity.Core.Common.CommandTrees.DbExpression collection) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression ToLower(this System.Data.Entity.Core.Common.CommandTrees.DbExpression stringArgument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression ToUpper(this System.Data.Entity.Core.Common.CommandTrees.DbExpression stringArgument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Trim(this System.Data.Entity.Core.Common.CommandTrees.DbExpression stringArgument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression TrimEnd(this System.Data.Entity.Core.Common.CommandTrees.DbExpression stringArgument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression TrimStart(this System.Data.Entity.Core.Common.CommandTrees.DbExpression stringArgument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Truncate(this System.Data.Entity.Core.Common.CommandTrees.DbExpression value, System.Data.Entity.Core.Common.CommandTrees.DbExpression digits) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression TruncateTime(this System.Data.Entity.Core.Common.CommandTrees.DbExpression dateValue) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression UtcDateTime(this System.Data.Entity.Core.Common.CommandTrees.DbExpression dateTimeOffsetArgument) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Var(this System.Data.Entity.Core.Common.CommandTrees.DbExpression collection) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression VarP(this System.Data.Entity.Core.Common.CommandTrees.DbExpression collection) => throw null;
                                public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Year(this System.Data.Entity.Core.Common.CommandTrees.DbExpression dateValue) => throw null;
                            }
                            namespace Hierarchy
                            {
                                public static class HierarchyIdEdmFunctions
                                {
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GetAncestor(this System.Data.Entity.Core.Common.CommandTrees.DbExpression hierarchyIdValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression n) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GetDescendant(this System.Data.Entity.Core.Common.CommandTrees.DbExpression hierarchyIdValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression child1, System.Data.Entity.Core.Common.CommandTrees.DbExpression child2) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GetLevel(this System.Data.Entity.Core.Common.CommandTrees.DbExpression hierarchyIdValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GetReparentedValue(this System.Data.Entity.Core.Common.CommandTrees.DbExpression hierarchyIdValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression oldRoot, System.Data.Entity.Core.Common.CommandTrees.DbExpression newRoot) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression HierarchyIdGetRoot() => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression HierarchyIdParse(System.Data.Entity.Core.Common.CommandTrees.DbExpression input) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression IsDescendantOf(this System.Data.Entity.Core.Common.CommandTrees.DbExpression hierarchyIdValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression parent) => throw null;
                                }
                            }
                            public sealed class Row
                            {
                                public Row(System.Collections.Generic.KeyValuePair<string, System.Data.Entity.Core.Common.CommandTrees.DbExpression> columnValue, params System.Collections.Generic.KeyValuePair<string, System.Data.Entity.Core.Common.CommandTrees.DbExpression>[] columnValues) => throw null;
                                public static implicit operator System.Data.Entity.Core.Common.CommandTrees.DbExpression(System.Data.Entity.Core.Common.CommandTrees.ExpressionBuilder.Row row) => throw null;
                                public System.Data.Entity.Core.Common.CommandTrees.DbNewInstanceExpression ToExpression() => throw null;
                            }
                            namespace Spatial
                            {
                                public static class SpatialEdmFunctions
                                {
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Area(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression AsBinary(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression AsGml(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression AsText(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Centroid(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression CoordinateSystemId(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Distance(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue2) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Elevation(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression EndPoint(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression ExteriorRing(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyCollectionFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression geographyCollectionWellKnownBinaryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyCollectionFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression geographyCollectionWellKnownText, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression wellKnownBinaryValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression wellKnownBinaryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyFromGml(System.Data.Entity.Core.Common.CommandTrees.DbExpression geographyMarkup) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyFromGml(System.Data.Entity.Core.Common.CommandTrees.DbExpression geographyMarkup, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression wellKnownText) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression wellKnownText, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyLineFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression lineWellKnownBinaryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyLineFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression lineWellKnownText, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyMultiLineFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression multiLineWellKnownBinaryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyMultiLineFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression multiLineWellKnownText, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyMultiPointFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression multiPointWellKnownBinaryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyMultiPointFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression multiPointWellKnownText, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyMultiPolygonFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression multiPolygonWellKnownBinaryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyMultiPolygonFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression multiPolygonWellKnownText, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyPointFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression pointWellKnownBinaryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyPointFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression pointWellKnownText, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyPolygonFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression polygonWellKnownBinaryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeographyPolygonFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression polygonWellKnownText, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryCollectionFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryCollectionWellKnownBinaryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryCollectionFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryCollectionWellKnownText, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression wellKnownBinaryValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression wellKnownBinaryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryFromGml(System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryMarkup) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryFromGml(System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryMarkup, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression wellKnownText) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression wellKnownText, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryLineFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression lineWellKnownBinaryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryLineFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression lineWellKnownText, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryMultiLineFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression multiLineWellKnownBinaryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryMultiLineFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression multiLineWellKnownText, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryMultiPointFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression multiPointWellKnownBinaryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryMultiPointFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression multiPointWellKnownText, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryMultiPolygonFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression multiPolygonWellKnownBinaryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryMultiPolygonFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression multiPolygonWellKnownText, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryPointFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression pointWellKnownBinaryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryPointFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression pointWellKnownText, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryPolygonFromBinary(System.Data.Entity.Core.Common.CommandTrees.DbExpression polygonWellKnownBinaryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression GeometryPolygonFromText(System.Data.Entity.Core.Common.CommandTrees.DbExpression polygonWellKnownText, System.Data.Entity.Core.Common.CommandTrees.DbExpression coordinateSystemId) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression InteriorRingAt(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression indexValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression InteriorRingCount(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression IsClosedSpatial(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression IsEmptySpatial(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression IsRing(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression IsSimpleGeometry(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression IsValidGeometry(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Latitude(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geographyValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Longitude(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geographyValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression Measure(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression PointAt(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression indexValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression PointCount(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression PointOnSurface(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialBoundary(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialBuffer(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression distance) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialContains(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue2) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialConvexHull(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialCrosses(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue2) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialDifference(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue2) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialDimension(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialDisjoint(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue2) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialElementAt(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue, System.Data.Entity.Core.Common.CommandTrees.DbExpression indexValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialElementCount(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialEnvelope(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialEquals(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue2) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialIntersection(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue2) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialIntersects(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue2) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialLength(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialOverlaps(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue2) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialRelate(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue2, System.Data.Entity.Core.Common.CommandTrees.DbExpression intersectionPatternMatrix) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialSymmetricDifference(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue2) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialTouches(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue2) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialTypeName(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialUnion(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue2) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression SpatialWithin(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue1, System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue2) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression StartPoint(this System.Data.Entity.Core.Common.CommandTrees.DbExpression spatialValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression XCoordinate(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue) => throw null;
                                    public static System.Data.Entity.Core.Common.CommandTrees.DbFunctionExpression YCoordinate(this System.Data.Entity.Core.Common.CommandTrees.DbExpression geometryValue) => throw null;
                                }
                            }
                        }
                    }
                    public class DataRecordInfo
                    {
                        public DataRecordInfo(System.Data.Entity.Core.Metadata.Edm.TypeUsage metadata, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmMember> memberInfo) => throw null;
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Common.FieldMetadata> FieldMetadata { get => throw null; }
                        public virtual System.Data.Entity.Core.Metadata.Edm.TypeUsage RecordType { get => throw null; }
                    }
                    public class DbCommandDefinition
                    {
                        public virtual System.Data.Common.DbCommand CreateCommand() => throw null;
                        protected DbCommandDefinition(System.Data.Common.DbCommand prototype, System.Func<System.Data.Common.DbCommand, System.Data.Common.DbCommand> cloneMethod) => throw null;
                        protected DbCommandDefinition() => throw null;
                    }
                    public abstract class DbProviderManifest
                    {
                        public const string CollationFacetName = default;
                        public const string ConceptualSchemaDefinition = default;
                        public const string ConceptualSchemaDefinitionVersion3 = default;
                        protected DbProviderManifest() => throw null;
                        public const string DefaultValueFacetName = default;
                        public virtual string EscapeLikeArgument(string argument) => throw null;
                        public const string FixedLengthFacetName = default;
                        protected abstract System.Xml.XmlReader GetDbInformation(string informationType);
                        public abstract System.Data.Entity.Core.Metadata.Edm.TypeUsage GetEdmType(System.Data.Entity.Core.Metadata.Edm.TypeUsage storeType);
                        public abstract System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.FacetDescription> GetFacetDescriptions(System.Data.Entity.Core.Metadata.Edm.EdmType edmType);
                        public System.Xml.XmlReader GetInformation(string informationType) => throw null;
                        public abstract System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.EdmFunction> GetStoreFunctions();
                        public abstract System.Data.Entity.Core.Metadata.Edm.TypeUsage GetStoreType(System.Data.Entity.Core.Metadata.Edm.TypeUsage edmType);
                        public abstract System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.PrimitiveType> GetStoreTypes();
                        public const string IsStrictFacetName = default;
                        public const string MaxLengthFacetName = default;
                        public abstract string NamespaceName { get; }
                        public const string NullableFacetName = default;
                        public const string PrecisionFacetName = default;
                        public const string ScaleFacetName = default;
                        public const string SridFacetName = default;
                        public const string StoreSchemaDefinition = default;
                        public const string StoreSchemaDefinitionVersion3 = default;
                        public const string StoreSchemaMapping = default;
                        public const string StoreSchemaMappingVersion3 = default;
                        public virtual bool SupportsEscapingLikeArgument(out char escapeCharacter) => throw null;
                        public virtual bool SupportsInExpression() => throw null;
                        public virtual bool SupportsIntersectAndUnionAllFlattening() => throw null;
                        public virtual bool SupportsParameterOptimizationInSchemaQueries() => throw null;
                        public const string UnicodeFacetName = default;
                    }
                    public abstract class DbProviderServices : System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver
                    {
                        protected void AddDependencyResolver(System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver resolver) => throw null;
                        protected virtual System.Data.Common.DbCommand CloneDbCommand(System.Data.Common.DbCommand fromDbCommand) => throw null;
                        public virtual System.Data.Common.DbConnection CloneDbConnection(System.Data.Common.DbConnection connection) => throw null;
                        public virtual System.Data.Common.DbConnection CloneDbConnection(System.Data.Common.DbConnection connection, System.Data.Common.DbProviderFactory factory) => throw null;
                        public System.Data.Entity.Core.Common.DbCommandDefinition CreateCommandDefinition(System.Data.Entity.Core.Common.CommandTrees.DbCommandTree commandTree) => throw null;
                        public System.Data.Entity.Core.Common.DbCommandDefinition CreateCommandDefinition(System.Data.Entity.Core.Common.DbProviderManifest providerManifest, System.Data.Entity.Core.Common.CommandTrees.DbCommandTree commandTree) => throw null;
                        public virtual System.Data.Entity.Core.Common.DbCommandDefinition CreateCommandDefinition(System.Data.Common.DbCommand prototype) => throw null;
                        public void CreateDatabase(System.Data.Common.DbConnection connection, int? commandTimeout, System.Data.Entity.Core.Metadata.Edm.StoreItemCollection storeItemCollection) => throw null;
                        public string CreateDatabaseScript(string providerManifestToken, System.Data.Entity.Core.Metadata.Edm.StoreItemCollection storeItemCollection) => throw null;
                        protected abstract System.Data.Entity.Core.Common.DbCommandDefinition CreateDbCommandDefinition(System.Data.Entity.Core.Common.DbProviderManifest providerManifest, System.Data.Entity.Core.Common.CommandTrees.DbCommandTree commandTree);
                        protected DbProviderServices() => throw null;
                        public bool DatabaseExists(System.Data.Common.DbConnection connection, int? commandTimeout, System.Data.Entity.Core.Metadata.Edm.StoreItemCollection storeItemCollection) => throw null;
                        public bool DatabaseExists(System.Data.Common.DbConnection connection, int? commandTimeout, System.Lazy<System.Data.Entity.Core.Metadata.Edm.StoreItemCollection> storeItemCollection) => throw null;
                        protected virtual void DbCreateDatabase(System.Data.Common.DbConnection connection, int? commandTimeout, System.Data.Entity.Core.Metadata.Edm.StoreItemCollection storeItemCollection) => throw null;
                        protected virtual string DbCreateDatabaseScript(string providerManifestToken, System.Data.Entity.Core.Metadata.Edm.StoreItemCollection storeItemCollection) => throw null;
                        protected virtual bool DbDatabaseExists(System.Data.Common.DbConnection connection, int? commandTimeout, System.Data.Entity.Core.Metadata.Edm.StoreItemCollection storeItemCollection) => throw null;
                        protected virtual bool DbDatabaseExists(System.Data.Common.DbConnection connection, int? commandTimeout, System.Lazy<System.Data.Entity.Core.Metadata.Edm.StoreItemCollection> storeItemCollection) => throw null;
                        protected virtual void DbDeleteDatabase(System.Data.Common.DbConnection connection, int? commandTimeout, System.Data.Entity.Core.Metadata.Edm.StoreItemCollection storeItemCollection) => throw null;
                        protected virtual System.Data.Entity.Spatial.DbSpatialServices DbGetSpatialServices(string manifestToken) => throw null;
                        public void DeleteDatabase(System.Data.Common.DbConnection connection, int? commandTimeout, System.Data.Entity.Core.Metadata.Edm.StoreItemCollection storeItemCollection) => throw null;
                        public static string ExpandDataDirectory(string path) => throw null;
                        public static System.Xml.XmlReader GetConceptualSchemaDefinition(string csdlName) => throw null;
                        protected abstract System.Data.Entity.Core.Common.DbProviderManifest GetDbProviderManifest(string manifestToken);
                        protected abstract string GetDbProviderManifestToken(System.Data.Common.DbConnection connection);
                        protected virtual System.Data.Entity.Spatial.DbSpatialDataReader GetDbSpatialDataReader(System.Data.Common.DbDataReader fromReader, string manifestToken) => throw null;
                        public static System.Data.Entity.Infrastructure.IDbExecutionStrategy GetExecutionStrategy(System.Data.Common.DbConnection connection) => throw null;
                        protected static System.Data.Entity.Infrastructure.IDbExecutionStrategy GetExecutionStrategy(System.Data.Common.DbConnection connection, string providerInvariantName) => throw null;
                        public static System.Data.Common.DbProviderFactory GetProviderFactory(System.Data.Common.DbConnection connection) => throw null;
                        public System.Data.Entity.Core.Common.DbProviderManifest GetProviderManifest(string manifestToken) => throw null;
                        public string GetProviderManifestToken(System.Data.Common.DbConnection connection) => throw null;
                        public static System.Data.Entity.Core.Common.DbProviderServices GetProviderServices(System.Data.Common.DbConnection connection) => throw null;
                        public virtual object GetService(System.Type type, object key) => throw null;
                        public virtual System.Collections.Generic.IEnumerable<object> GetServices(System.Type type, object key) => throw null;
                        public System.Data.Entity.Spatial.DbSpatialDataReader GetSpatialDataReader(System.Data.Common.DbDataReader fromReader, string manifestToken) => throw null;
                        public System.Data.Entity.Spatial.DbSpatialServices GetSpatialServices(string manifestToken) => throw null;
                        public System.Data.Entity.Spatial.DbSpatialServices GetSpatialServices(System.Data.Entity.Infrastructure.DbProviderInfo key) => throw null;
                        public virtual void RegisterInfoMessageHandler(System.Data.Common.DbConnection connection, System.Action<string> handler) => throw null;
                        protected virtual void SetDbParameterValue(System.Data.Common.DbParameter parameter, System.Data.Entity.Core.Metadata.Edm.TypeUsage parameterType, object value) => throw null;
                        public void SetParameterValue(System.Data.Common.DbParameter parameter, System.Data.Entity.Core.Metadata.Edm.TypeUsage parameterType, object value) => throw null;
                    }
                    public abstract class DbXmlEnabledProviderManifest : System.Data.Entity.Core.Common.DbProviderManifest
                    {
                        protected DbXmlEnabledProviderManifest(System.Xml.XmlReader reader) => throw null;
                        public override System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.FacetDescription> GetFacetDescriptions(System.Data.Entity.Core.Metadata.Edm.EdmType edmType) => throw null;
                        public override System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.EdmFunction> GetStoreFunctions() => throw null;
                        public override System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.PrimitiveType> GetStoreTypes() => throw null;
                        public override string NamespaceName { get => throw null; }
                        protected System.Collections.Generic.Dictionary<string, System.Data.Entity.Core.Metadata.Edm.PrimitiveType> StoreTypeNameToEdmPrimitiveType { get => throw null; }
                        protected System.Collections.Generic.Dictionary<string, System.Data.Entity.Core.Metadata.Edm.PrimitiveType> StoreTypeNameToStorePrimitiveType { get => throw null; }
                    }
                    public class EntityRecordInfo : System.Data.Entity.Core.Common.DataRecordInfo
                    {
                        public EntityRecordInfo(System.Data.Entity.Core.Metadata.Edm.EntityType metadata, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmMember> memberInfo, System.Data.Entity.Core.EntityKey entityKey, System.Data.Entity.Core.Metadata.Edm.EntitySet entitySet) : base(default(System.Data.Entity.Core.Metadata.Edm.TypeUsage), default(System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmMember>)) => throw null;
                        public System.Data.Entity.Core.EntityKey EntityKey { get => throw null; }
                    }
                    namespace EntitySql
                    {
                        public sealed class EntitySqlParser
                        {
                            public System.Data.Entity.Core.Common.EntitySql.ParseResult Parse(string query, params System.Data.Entity.Core.Common.CommandTrees.DbParameterReferenceExpression[] parameters) => throw null;
                            public System.Data.Entity.Core.Common.CommandTrees.DbLambda ParseLambda(string query, params System.Data.Entity.Core.Common.CommandTrees.DbVariableReferenceExpression[] variables) => throw null;
                        }
                        public sealed class FunctionDefinition
                        {
                            public int EndPosition { get => throw null; }
                            public System.Data.Entity.Core.Common.CommandTrees.DbLambda Lambda { get => throw null; }
                            public string Name { get => throw null; }
                            public int StartPosition { get => throw null; }
                        }
                        public sealed class ParseResult
                        {
                            public System.Data.Entity.Core.Common.CommandTrees.DbCommandTree CommandTree { get => throw null; }
                            public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Common.EntitySql.FunctionDefinition> FunctionDefinitions { get => throw null; }
                        }
                    }
                    public struct FieldMetadata
                    {
                        public FieldMetadata(int ordinal, System.Data.Entity.Core.Metadata.Edm.EdmMember fieldType) => throw null;
                        public System.Data.Entity.Core.Metadata.Edm.EdmMember FieldType { get => throw null; }
                        public int Ordinal { get => throw null; }
                    }
                }
                namespace EntityClient
                {
                    public class EntityCommand : System.Data.Common.DbCommand
                    {
                        public override void Cancel() => throw null;
                        public override string CommandText { get => throw null; set { } }
                        public override int CommandTimeout { get => throw null; set { } }
                        public virtual System.Data.Entity.Core.Common.CommandTrees.DbCommandTree CommandTree { get => throw null; set { } }
                        public override System.Data.CommandType CommandType { get => throw null; set { } }
                        public virtual System.Data.Entity.Core.EntityClient.EntityConnection Connection { get => throw null; set { } }
                        protected override System.Data.Common.DbParameter CreateDbParameter() => throw null;
                        public virtual System.Data.Entity.Core.EntityClient.EntityParameter CreateParameter() => throw null;
                        public EntityCommand() => throw null;
                        public EntityCommand(string statement) => throw null;
                        public EntityCommand(string statement, System.Data.Entity.Core.EntityClient.EntityConnection connection, System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver resolver) => throw null;
                        public EntityCommand(string statement, System.Data.Entity.Core.EntityClient.EntityConnection connection) => throw null;
                        public EntityCommand(string statement, System.Data.Entity.Core.EntityClient.EntityConnection connection, System.Data.Entity.Core.EntityClient.EntityTransaction transaction) => throw null;
                        protected override System.Data.Common.DbConnection DbConnection { get => throw null; set { } }
                        protected override System.Data.Common.DbParameterCollection DbParameterCollection { get => throw null; }
                        protected override System.Data.Common.DbTransaction DbTransaction { get => throw null; set { } }
                        public override bool DesignTimeVisible { get => throw null; set { } }
                        public virtual bool EnablePlanCaching { get => throw null; set { } }
                        protected override System.Data.Common.DbDataReader ExecuteDbDataReader(System.Data.CommandBehavior behavior) => throw null;
                        protected override System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ExecuteDbDataReaderAsync(System.Data.CommandBehavior behavior, System.Threading.CancellationToken cancellationToken) => throw null;
                        public override int ExecuteNonQuery() => throw null;
                        public override System.Threading.Tasks.Task<int> ExecuteNonQueryAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                        public virtual System.Data.Entity.Core.EntityClient.EntityDataReader ExecuteReader() => throw null;
                        public virtual System.Data.Entity.Core.EntityClient.EntityDataReader ExecuteReader(System.Data.CommandBehavior behavior) => throw null;
                        public virtual System.Threading.Tasks.Task<System.Data.Entity.Core.EntityClient.EntityDataReader> ExecuteReaderAsync() => throw null;
                        public virtual System.Threading.Tasks.Task<System.Data.Entity.Core.EntityClient.EntityDataReader> ExecuteReaderAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                        public virtual System.Threading.Tasks.Task<System.Data.Entity.Core.EntityClient.EntityDataReader> ExecuteReaderAsync(System.Data.CommandBehavior behavior) => throw null;
                        public virtual System.Threading.Tasks.Task<System.Data.Entity.Core.EntityClient.EntityDataReader> ExecuteReaderAsync(System.Data.CommandBehavior behavior, System.Threading.CancellationToken cancellationToken) => throw null;
                        public override object ExecuteScalar() => throw null;
                        public virtual System.Data.Entity.Core.EntityClient.EntityParameterCollection Parameters { get => throw null; }
                        public override void Prepare() => throw null;
                        public virtual string ToTraceString() => throw null;
                        public virtual System.Data.Entity.Core.EntityClient.EntityTransaction Transaction { get => throw null; set { } }
                        public override System.Data.UpdateRowSource UpdatedRowSource { get => throw null; set { } }
                    }
                    public class EntityConnection : System.Data.Common.DbConnection
                    {
                        protected override System.Data.Common.DbTransaction BeginDbTransaction(System.Data.IsolationLevel isolationLevel) => throw null;
                        public virtual System.Data.Entity.Core.EntityClient.EntityTransaction BeginTransaction() => throw null;
                        public virtual System.Data.Entity.Core.EntityClient.EntityTransaction BeginTransaction(System.Data.IsolationLevel isolationLevel) => throw null;
                        public override void ChangeDatabase(string databaseName) => throw null;
                        public override void Close() => throw null;
                        public override string ConnectionString { get => throw null; set { } }
                        public override int ConnectionTimeout { get => throw null; }
                        public virtual System.Data.Entity.Core.EntityClient.EntityCommand CreateCommand() => throw null;
                        protected override System.Data.Common.DbCommand CreateDbCommand() => throw null;
                        public EntityConnection() => throw null;
                        public EntityConnection(string connectionString) => throw null;
                        public EntityConnection(System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace workspace, System.Data.Common.DbConnection connection) => throw null;
                        public EntityConnection(System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace workspace, System.Data.Common.DbConnection connection, bool entityConnectionOwnsStoreConnection) => throw null;
                        public virtual System.Data.Entity.Core.EntityClient.EntityTransaction CurrentTransaction { get => throw null; }
                        public override string Database { get => throw null; }
                        public override string DataSource { get => throw null; }
                        protected override System.Data.Common.DbProviderFactory DbProviderFactory { get => throw null; }
                        protected override void Dispose(bool disposing) => throw null;
                        public override void EnlistTransaction(System.Transactions.Transaction transaction) => throw null;
                        public virtual System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace GetMetadataWorkspace() => throw null;
                        public override void Open() => throw null;
                        public override System.Threading.Tasks.Task OpenAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                        public override string ServerVersion { get => throw null; }
                        public override System.Data.ConnectionState State { get => throw null; }
                        public virtual System.Data.Common.DbConnection StoreConnection { get => throw null; }
                    }
                    public sealed class EntityConnectionStringBuilder : System.Data.Common.DbConnectionStringBuilder
                    {
                        public override void Clear() => throw null;
                        public override bool ContainsKey(string keyword) => throw null;
                        public EntityConnectionStringBuilder() => throw null;
                        public EntityConnectionStringBuilder(string connectionString) => throw null;
                        public override bool IsFixedSize { get => throw null; }
                        public override System.Collections.ICollection Keys { get => throw null; }
                        public string Metadata { get => throw null; set { } }
                        public string Name { get => throw null; set { } }
                        public string Provider { get => throw null; set { } }
                        public string ProviderConnectionString { get => throw null; set { } }
                        public override bool Remove(string keyword) => throw null;
                        public override object this[string keyword] { get => throw null; set { } }
                        public override bool TryGetValue(string keyword, out object value) => throw null;
                    }
                    public class EntityDataReader : System.Data.Common.DbDataReader, System.Data.IDataRecord, System.Data.Entity.Core.IExtendedDataRecord
                    {
                        public override void Close() => throw null;
                        public System.Data.Entity.Core.Common.DataRecordInfo DataRecordInfo { get => throw null; }
                        public override int Depth { get => throw null; }
                        protected override void Dispose(bool disposing) => throw null;
                        public override int FieldCount { get => throw null; }
                        public override bool GetBoolean(int ordinal) => throw null;
                        public override byte GetByte(int ordinal) => throw null;
                        public override long GetBytes(int ordinal, long dataOffset, byte[] buffer, int bufferOffset, int length) => throw null;
                        public override char GetChar(int ordinal) => throw null;
                        public override long GetChars(int ordinal, long dataOffset, char[] buffer, int bufferOffset, int length) => throw null;
                        public System.Data.Common.DbDataReader GetDataReader(int i) => throw null;
                        public System.Data.Common.DbDataRecord GetDataRecord(int i) => throw null;
                        public override string GetDataTypeName(int ordinal) => throw null;
                        public override System.DateTime GetDateTime(int ordinal) => throw null;
                        protected override System.Data.Common.DbDataReader GetDbDataReader(int ordinal) => throw null;
                        public override decimal GetDecimal(int ordinal) => throw null;
                        public override double GetDouble(int ordinal) => throw null;
                        public override System.Collections.IEnumerator GetEnumerator() => throw null;
                        public override System.Type GetFieldType(int ordinal) => throw null;
                        public override float GetFloat(int ordinal) => throw null;
                        public override System.Guid GetGuid(int ordinal) => throw null;
                        public override short GetInt16(int ordinal) => throw null;
                        public override int GetInt32(int ordinal) => throw null;
                        public override long GetInt64(int ordinal) => throw null;
                        public override string GetName(int ordinal) => throw null;
                        public override int GetOrdinal(string name) => throw null;
                        public override System.Type GetProviderSpecificFieldType(int ordinal) => throw null;
                        public override object GetProviderSpecificValue(int ordinal) => throw null;
                        public override int GetProviderSpecificValues(object[] values) => throw null;
                        public override System.Data.DataTable GetSchemaTable() => throw null;
                        public override string GetString(int ordinal) => throw null;
                        public override object GetValue(int ordinal) => throw null;
                        public override int GetValues(object[] values) => throw null;
                        public override bool HasRows { get => throw null; }
                        public override bool IsClosed { get => throw null; }
                        public override bool IsDBNull(int ordinal) => throw null;
                        public override bool NextResult() => throw null;
                        public override System.Threading.Tasks.Task<bool> NextResultAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                        public override bool Read() => throw null;
                        public override System.Threading.Tasks.Task<bool> ReadAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                        public override int RecordsAffected { get => throw null; }
                        public override object this[int ordinal] { get => throw null; }
                        public override object this[string name] { get => throw null; }
                        public override int VisibleFieldCount { get => throw null; }
                    }
                    public class EntityParameter : System.Data.Common.DbParameter, System.Data.IDataParameter, System.Data.IDbDataParameter
                    {
                        public EntityParameter() => throw null;
                        public EntityParameter(string parameterName, System.Data.DbType dbType) => throw null;
                        public EntityParameter(string parameterName, System.Data.DbType dbType, int size) => throw null;
                        public EntityParameter(string parameterName, System.Data.DbType dbType, int size, string sourceColumn) => throw null;
                        public EntityParameter(string parameterName, System.Data.DbType dbType, int size, System.Data.ParameterDirection direction, bool isNullable, byte precision, byte scale, string sourceColumn, System.Data.DataRowVersion sourceVersion, object value) => throw null;
                        public override System.Data.DbType DbType { get => throw null; set { } }
                        public override System.Data.ParameterDirection Direction { get => throw null; set { } }
                        public virtual System.Data.Entity.Core.Metadata.Edm.EdmType EdmType { get => throw null; set { } }
                        public override bool IsNullable { get => throw null; set { } }
                        public override string ParameterName { get => throw null; set { } }
                        public virtual byte Precision { get => throw null; set { } }
                        public override void ResetDbType() => throw null;
                        public virtual byte Scale { get => throw null; set { } }
                        public override int Size { get => throw null; set { } }
                        public override string SourceColumn { get => throw null; set { } }
                        public override bool SourceColumnNullMapping { get => throw null; set { } }
                        public override System.Data.DataRowVersion SourceVersion { get => throw null; set { } }
                        public override string ToString() => throw null;
                        public override object Value { get => throw null; set { } }
                    }
                    public sealed class EntityParameterCollection : System.Data.Common.DbParameterCollection
                    {
                        public override int Add(object value) => throw null;
                        public System.Data.Entity.Core.EntityClient.EntityParameter Add(System.Data.Entity.Core.EntityClient.EntityParameter value) => throw null;
                        public System.Data.Entity.Core.EntityClient.EntityParameter Add(string parameterName, System.Data.DbType dbType) => throw null;
                        public System.Data.Entity.Core.EntityClient.EntityParameter Add(string parameterName, System.Data.DbType dbType, int size) => throw null;
                        public override void AddRange(System.Array values) => throw null;
                        public void AddRange(System.Data.Entity.Core.EntityClient.EntityParameter[] values) => throw null;
                        public System.Data.Entity.Core.EntityClient.EntityParameter AddWithValue(string parameterName, object value) => throw null;
                        public override void Clear() => throw null;
                        public override bool Contains(object value) => throw null;
                        public override bool Contains(string parameterName) => throw null;
                        public override void CopyTo(System.Array array, int index) => throw null;
                        public void CopyTo(System.Data.Entity.Core.EntityClient.EntityParameter[] array, int index) => throw null;
                        public override int Count { get => throw null; }
                        public override System.Collections.IEnumerator GetEnumerator() => throw null;
                        protected override System.Data.Common.DbParameter GetParameter(int index) => throw null;
                        protected override System.Data.Common.DbParameter GetParameter(string parameterName) => throw null;
                        public override int IndexOf(string parameterName) => throw null;
                        public override int IndexOf(object value) => throw null;
                        public int IndexOf(System.Data.Entity.Core.EntityClient.EntityParameter value) => throw null;
                        public override void Insert(int index, object value) => throw null;
                        public void Insert(int index, System.Data.Entity.Core.EntityClient.EntityParameter value) => throw null;
                        public override bool IsFixedSize { get => throw null; }
                        public override bool IsReadOnly { get => throw null; }
                        public override bool IsSynchronized { get => throw null; }
                        public override void Remove(object value) => throw null;
                        public void Remove(System.Data.Entity.Core.EntityClient.EntityParameter value) => throw null;
                        public override void RemoveAt(int index) => throw null;
                        public override void RemoveAt(string parameterName) => throw null;
                        protected override void SetParameter(int index, System.Data.Common.DbParameter value) => throw null;
                        protected override void SetParameter(string parameterName, System.Data.Common.DbParameter value) => throw null;
                        public override object SyncRoot { get => throw null; }
                        public System.Data.Entity.Core.EntityClient.EntityParameter this[int index] { get => throw null; set { } }
                        public System.Data.Entity.Core.EntityClient.EntityParameter this[string parameterName] { get => throw null; set { } }
                    }
                    public sealed class EntityProviderFactory : System.Data.Common.DbProviderFactory, System.IServiceProvider
                    {
                        public override System.Data.Common.DbCommand CreateCommand() => throw null;
                        public override System.Data.Common.DbCommandBuilder CreateCommandBuilder() => throw null;
                        public override System.Data.Common.DbConnection CreateConnection() => throw null;
                        public override System.Data.Common.DbConnectionStringBuilder CreateConnectionStringBuilder() => throw null;
                        public override System.Data.Common.DbDataAdapter CreateDataAdapter() => throw null;
                        public override System.Data.Common.DbParameter CreateParameter() => throw null;
                        object System.IServiceProvider.GetService(System.Type serviceType) => throw null;
                        public static readonly System.Data.Entity.Core.EntityClient.EntityProviderFactory Instance;
                    }
                    public class EntityTransaction : System.Data.Common.DbTransaction
                    {
                        public override void Commit() => throw null;
                        public virtual System.Data.Entity.Core.EntityClient.EntityConnection Connection { get => throw null; }
                        protected override System.Data.Common.DbConnection DbConnection { get => throw null; }
                        protected override void Dispose(bool disposing) => throw null;
                        public override System.Data.IsolationLevel IsolationLevel { get => throw null; }
                        public override void Rollback() => throw null;
                        public virtual System.Data.Common.DbTransaction StoreTransaction { get => throw null; }
                    }
                }
                public sealed class EntityCommandCompilationException : System.Data.Entity.Core.EntityException
                {
                    public EntityCommandCompilationException() => throw null;
                    public EntityCommandCompilationException(string message) => throw null;
                    public EntityCommandCompilationException(string message, System.Exception innerException) => throw null;
                }
                public sealed class EntityCommandExecutionException : System.Data.Entity.Core.EntityException
                {
                    public EntityCommandExecutionException() => throw null;
                    public EntityCommandExecutionException(string message) => throw null;
                    public EntityCommandExecutionException(string message, System.Exception innerException) => throw null;
                }
                public class EntityException : System.Data.DataException
                {
                    public EntityException() => throw null;
                    public EntityException(string message) => throw null;
                    public EntityException(string message, System.Exception innerException) => throw null;
                    protected EntityException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public sealed class EntityKey : System.IEquatable<System.Data.Entity.Core.EntityKey>
                {
                    public EntityKey() => throw null;
                    public EntityKey(string qualifiedEntitySetName, System.Collections.Generic.IEnumerable<System.Collections.Generic.KeyValuePair<string, object>> entityKeyValues) => throw null;
                    public EntityKey(string qualifiedEntitySetName, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.EntityKeyMember> entityKeyValues) => throw null;
                    public EntityKey(string qualifiedEntitySetName, string keyName, object keyValue) => throw null;
                    public string EntityContainerName { get => throw null; set { } }
                    public System.Data.Entity.Core.EntityKeyMember[] EntityKeyValues { get => throw null; set { } }
                    public static System.Data.Entity.Core.EntityKey EntityNotValidKey { get => throw null; }
                    public string EntitySetName { get => throw null; set { } }
                    public override bool Equals(object obj) => throw null;
                    public bool Equals(System.Data.Entity.Core.EntityKey other) => throw null;
                    public System.Data.Entity.Core.Metadata.Edm.EntitySet GetEntitySet(System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace metadataWorkspace) => throw null;
                    public override int GetHashCode() => throw null;
                    public bool IsTemporary { get => throw null; }
                    public static System.Data.Entity.Core.EntityKey NoEntitySetKey { get => throw null; }
                    public void OnDeserialized(System.Runtime.Serialization.StreamingContext context) => throw null;
                    public void OnDeserializing(System.Runtime.Serialization.StreamingContext context) => throw null;
                    public static bool operator ==(System.Data.Entity.Core.EntityKey key1, System.Data.Entity.Core.EntityKey key2) => throw null;
                    public static bool operator !=(System.Data.Entity.Core.EntityKey key1, System.Data.Entity.Core.EntityKey key2) => throw null;
                }
                public class EntityKeyMember
                {
                    public EntityKeyMember() => throw null;
                    public EntityKeyMember(string keyName, object keyValue) => throw null;
                    public string Key { get => throw null; set { } }
                    public override string ToString() => throw null;
                    public object Value { get => throw null; set { } }
                }
                public sealed class EntitySqlException : System.Data.Entity.Core.EntityException
                {
                    public int Column { get => throw null; }
                    public EntitySqlException() => throw null;
                    public EntitySqlException(string message) => throw null;
                    public EntitySqlException(string message, System.Exception innerException) => throw null;
                    public string ErrorContext { get => throw null; }
                    public string ErrorDescription { get => throw null; }
                    public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public int Line { get => throw null; }
                }
                public interface IExtendedDataRecord : System.Data.IDataRecord
                {
                    System.Data.Entity.Core.Common.DataRecordInfo DataRecordInfo { get; }
                    System.Data.Common.DbDataReader GetDataReader(int i);
                    System.Data.Common.DbDataRecord GetDataRecord(int i);
                }
                public sealed class InvalidCommandTreeException : System.Data.DataException
                {
                    public InvalidCommandTreeException() => throw null;
                    public InvalidCommandTreeException(string message) => throw null;
                    public InvalidCommandTreeException(string message, System.Exception innerException) => throw null;
                }
                namespace Mapping
                {
                    public class AssociationSetMapping : System.Data.Entity.Core.Mapping.EntitySetBaseMapping
                    {
                        public void AddCondition(System.Data.Entity.Core.Mapping.ConditionPropertyMapping condition) => throw null;
                        public System.Data.Entity.Core.Metadata.Edm.AssociationSet AssociationSet { get => throw null; }
                        public System.Data.Entity.Core.Mapping.AssociationTypeMapping AssociationTypeMapping { get => throw null; }
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.ConditionPropertyMapping> Conditions { get => throw null; }
                        public AssociationSetMapping(System.Data.Entity.Core.Metadata.Edm.AssociationSet associationSet, System.Data.Entity.Core.Metadata.Edm.EntitySet storeEntitySet, System.Data.Entity.Core.Mapping.EntityContainerMapping containerMapping) => throw null;
                        public System.Data.Entity.Core.Mapping.AssociationSetModificationFunctionMapping ModificationFunctionMapping { get => throw null; set { } }
                        public void RemoveCondition(System.Data.Entity.Core.Mapping.ConditionPropertyMapping condition) => throw null;
                        public System.Data.Entity.Core.Mapping.EndPropertyMapping SourceEndMapping { get => throw null; set { } }
                        public System.Data.Entity.Core.Metadata.Edm.EntitySet StoreEntitySet { get => throw null; }
                        public System.Data.Entity.Core.Mapping.EndPropertyMapping TargetEndMapping { get => throw null; set { } }
                    }
                    public sealed class AssociationSetModificationFunctionMapping : System.Data.Entity.Core.Mapping.MappingItem
                    {
                        public System.Data.Entity.Core.Metadata.Edm.AssociationSet AssociationSet { get => throw null; }
                        public AssociationSetModificationFunctionMapping(System.Data.Entity.Core.Metadata.Edm.AssociationSet associationSet, System.Data.Entity.Core.Mapping.ModificationFunctionMapping deleteFunctionMapping, System.Data.Entity.Core.Mapping.ModificationFunctionMapping insertFunctionMapping) => throw null;
                        public System.Data.Entity.Core.Mapping.ModificationFunctionMapping DeleteFunctionMapping { get => throw null; }
                        public System.Data.Entity.Core.Mapping.ModificationFunctionMapping InsertFunctionMapping { get => throw null; }
                        public override string ToString() => throw null;
                    }
                    public class AssociationTypeMapping : System.Data.Entity.Core.Mapping.TypeMapping
                    {
                        public System.Data.Entity.Core.Mapping.AssociationSetMapping AssociationSetMapping { get => throw null; }
                        public System.Data.Entity.Core.Metadata.Edm.AssociationType AssociationType { get => throw null; }
                        public AssociationTypeMapping(System.Data.Entity.Core.Mapping.AssociationSetMapping associationSetMapping) => throw null;
                        public System.Data.Entity.Core.Mapping.MappingFragment MappingFragment { get => throw null; }
                    }
                    public class ComplexPropertyMapping : System.Data.Entity.Core.Mapping.PropertyMapping
                    {
                        public void AddTypeMapping(System.Data.Entity.Core.Mapping.ComplexTypeMapping typeMapping) => throw null;
                        public ComplexPropertyMapping(System.Data.Entity.Core.Metadata.Edm.EdmProperty property) => throw null;
                        public void RemoveTypeMapping(System.Data.Entity.Core.Mapping.ComplexTypeMapping typeMapping) => throw null;
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.ComplexTypeMapping> TypeMappings { get => throw null; }
                    }
                    public class ComplexTypeMapping : System.Data.Entity.Core.Mapping.StructuralTypeMapping
                    {
                        public override void AddCondition(System.Data.Entity.Core.Mapping.ConditionPropertyMapping condition) => throw null;
                        public override void AddPropertyMapping(System.Data.Entity.Core.Mapping.PropertyMapping propertyMapping) => throw null;
                        public System.Data.Entity.Core.Metadata.Edm.ComplexType ComplexType { get => throw null; }
                        public override System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.ConditionPropertyMapping> Conditions { get => throw null; }
                        public ComplexTypeMapping(System.Data.Entity.Core.Metadata.Edm.ComplexType complexType) => throw null;
                        public override System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.PropertyMapping> PropertyMappings { get => throw null; }
                        public override void RemoveCondition(System.Data.Entity.Core.Mapping.ConditionPropertyMapping condition) => throw null;
                        public override void RemovePropertyMapping(System.Data.Entity.Core.Mapping.PropertyMapping propertyMapping) => throw null;
                    }
                    public class ConditionPropertyMapping : System.Data.Entity.Core.Mapping.PropertyMapping
                    {
                        public System.Data.Entity.Core.Metadata.Edm.EdmProperty Column { get => throw null; }
                        public override System.Data.Entity.Core.Metadata.Edm.EdmProperty Property { get => throw null; set { } }
                    }
                    public class EndPropertyMapping : System.Data.Entity.Core.Mapping.PropertyMapping
                    {
                        public void AddPropertyMapping(System.Data.Entity.Core.Mapping.ScalarPropertyMapping propertyMapping) => throw null;
                        public System.Data.Entity.Core.Metadata.Edm.AssociationEndMember AssociationEnd { get => throw null; }
                        public EndPropertyMapping(System.Data.Entity.Core.Metadata.Edm.AssociationEndMember associationEnd) => throw null;
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.ScalarPropertyMapping> PropertyMappings { get => throw null; }
                        public void RemovePropertyMapping(System.Data.Entity.Core.Mapping.ScalarPropertyMapping propertyMapping) => throw null;
                    }
                    public class EntityContainerMapping : System.Data.Entity.Core.Mapping.MappingBase
                    {
                        public void AddFunctionImportMapping(System.Data.Entity.Core.Mapping.FunctionImportMapping functionImportMapping) => throw null;
                        public void AddSetMapping(System.Data.Entity.Core.Mapping.EntitySetMapping setMapping) => throw null;
                        public void AddSetMapping(System.Data.Entity.Core.Mapping.AssociationSetMapping setMapping) => throw null;
                        public virtual System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Mapping.AssociationSetMapping> AssociationSetMappings { get => throw null; }
                        public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                        public System.Data.Entity.Core.Metadata.Edm.EntityContainer ConceptualEntityContainer { get => throw null; }
                        public EntityContainerMapping(System.Data.Entity.Core.Metadata.Edm.EntityContainer conceptualEntityContainer, System.Data.Entity.Core.Metadata.Edm.EntityContainer storeEntityContainer, System.Data.Entity.Core.Mapping.StorageMappingItemCollection mappingItemCollection, bool generateUpdateViews) => throw null;
                        public virtual System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Mapping.EntitySetMapping> EntitySetMappings { get => throw null; }
                        public System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Mapping.FunctionImportMapping> FunctionImportMappings { get => throw null; }
                        public bool GenerateUpdateViews { get => throw null; }
                        public System.Data.Entity.Core.Mapping.StorageMappingItemCollection MappingItemCollection { get => throw null; }
                        public void RemoveFunctionImportMapping(System.Data.Entity.Core.Mapping.FunctionImportMapping functionImportMapping) => throw null;
                        public void RemoveSetMapping(System.Data.Entity.Core.Mapping.EntitySetMapping setMapping) => throw null;
                        public void RemoveSetMapping(System.Data.Entity.Core.Mapping.AssociationSetMapping setMapping) => throw null;
                        public System.Data.Entity.Core.Metadata.Edm.EntityContainer StoreEntityContainer { get => throw null; }
                    }
                    public abstract class EntitySetBaseMapping : System.Data.Entity.Core.Mapping.MappingItem
                    {
                        public System.Data.Entity.Core.Mapping.EntityContainerMapping ContainerMapping { get => throw null; }
                        public string QueryView { get => throw null; set { } }
                    }
                    public class EntitySetMapping : System.Data.Entity.Core.Mapping.EntitySetBaseMapping
                    {
                        public void AddModificationFunctionMapping(System.Data.Entity.Core.Mapping.EntityTypeModificationFunctionMapping modificationFunctionMapping) => throw null;
                        public void AddTypeMapping(System.Data.Entity.Core.Mapping.EntityTypeMapping typeMapping) => throw null;
                        public EntitySetMapping(System.Data.Entity.Core.Metadata.Edm.EntitySet entitySet, System.Data.Entity.Core.Mapping.EntityContainerMapping containerMapping) => throw null;
                        public System.Data.Entity.Core.Metadata.Edm.EntitySet EntitySet { get => throw null; }
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.EntityTypeMapping> EntityTypeMappings { get => throw null; }
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.EntityTypeModificationFunctionMapping> ModificationFunctionMappings { get => throw null; }
                        public void RemoveModificationFunctionMapping(System.Data.Entity.Core.Mapping.EntityTypeModificationFunctionMapping modificationFunctionMapping) => throw null;
                        public void RemoveTypeMapping(System.Data.Entity.Core.Mapping.EntityTypeMapping typeMapping) => throw null;
                    }
                    public class EntityTypeMapping : System.Data.Entity.Core.Mapping.TypeMapping
                    {
                        public void AddFragment(System.Data.Entity.Core.Mapping.MappingFragment fragment) => throw null;
                        public void AddIsOfType(System.Data.Entity.Core.Metadata.Edm.EntityType type) => throw null;
                        public void AddType(System.Data.Entity.Core.Metadata.Edm.EntityType type) => throw null;
                        public EntityTypeMapping(System.Data.Entity.Core.Mapping.EntitySetMapping entitySetMapping) => throw null;
                        public System.Data.Entity.Core.Mapping.EntitySetMapping EntitySetMapping { get => throw null; }
                        public System.Data.Entity.Core.Metadata.Edm.EntityType EntityType { get => throw null; }
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.EntityTypeBase> EntityTypes { get => throw null; }
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.MappingFragment> Fragments { get => throw null; }
                        public bool IsHierarchyMapping { get => throw null; }
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.EntityTypeBase> IsOfEntityTypes { get => throw null; }
                        public void RemoveFragment(System.Data.Entity.Core.Mapping.MappingFragment fragment) => throw null;
                        public void RemoveIsOfType(System.Data.Entity.Core.Metadata.Edm.EntityType type) => throw null;
                        public void RemoveType(System.Data.Entity.Core.Metadata.Edm.EntityType type) => throw null;
                    }
                    public sealed class EntityTypeModificationFunctionMapping : System.Data.Entity.Core.Mapping.MappingItem
                    {
                        public EntityTypeModificationFunctionMapping(System.Data.Entity.Core.Metadata.Edm.EntityType entityType, System.Data.Entity.Core.Mapping.ModificationFunctionMapping deleteFunctionMapping, System.Data.Entity.Core.Mapping.ModificationFunctionMapping insertFunctionMapping, System.Data.Entity.Core.Mapping.ModificationFunctionMapping updateFunctionMapping) => throw null;
                        public System.Data.Entity.Core.Mapping.ModificationFunctionMapping DeleteFunctionMapping { get => throw null; }
                        public System.Data.Entity.Core.Metadata.Edm.EntityType EntityType { get => throw null; }
                        public System.Data.Entity.Core.Mapping.ModificationFunctionMapping InsertFunctionMapping { get => throw null; }
                        public override string ToString() => throw null;
                        public System.Data.Entity.Core.Mapping.ModificationFunctionMapping UpdateFunctionMapping { get => throw null; }
                    }
                    public abstract class EntityViewContainer
                    {
                        protected EntityViewContainer() => throw null;
                        public string EdmEntityContainerName { get => throw null; set { } }
                        protected abstract System.Collections.Generic.KeyValuePair<string, string> GetViewAt(int index);
                        public string HashOverAllExtentViews { get => throw null; set { } }
                        public string HashOverMappingClosure { get => throw null; set { } }
                        public string StoreEntityContainerName { get => throw null; set { } }
                        public int ViewCount { get => throw null; set { } }
                    }
                    [System.AttributeUsage((System.AttributeTargets)1, AllowMultiple = true)]
                    public sealed class EntityViewGenerationAttribute : System.Attribute
                    {
                        public EntityViewGenerationAttribute(System.Type viewGenerationType) => throw null;
                        public System.Type ViewGenerationType { get => throw null; }
                    }
                    public sealed class FunctionImportComplexTypeMapping : System.Data.Entity.Core.Mapping.FunctionImportStructuralTypeMapping
                    {
                        public FunctionImportComplexTypeMapping(System.Data.Entity.Core.Metadata.Edm.ComplexType returnType, System.Collections.ObjectModel.Collection<System.Data.Entity.Core.Mapping.FunctionImportReturnTypePropertyMapping> properties) => throw null;
                        public System.Data.Entity.Core.Metadata.Edm.ComplexType ReturnType { get => throw null; }
                    }
                    public sealed class FunctionImportEntityTypeMapping : System.Data.Entity.Core.Mapping.FunctionImportStructuralTypeMapping
                    {
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.FunctionImportEntityTypeMappingCondition> Conditions { get => throw null; }
                        public FunctionImportEntityTypeMapping(System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EntityType> isOfTypeEntityTypes, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EntityType> entityTypes, System.Collections.ObjectModel.Collection<System.Data.Entity.Core.Mapping.FunctionImportReturnTypePropertyMapping> properties, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Mapping.FunctionImportEntityTypeMappingCondition> conditions) => throw null;
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.EntityType> EntityTypes { get => throw null; }
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.EntityType> IsOfTypeEntityTypes { get => throw null; }
                    }
                    public abstract class FunctionImportEntityTypeMappingCondition : System.Data.Entity.Core.Mapping.MappingItem
                    {
                        public string ColumnName { get => throw null; }
                        public override string ToString() => throw null;
                    }
                    public sealed class FunctionImportEntityTypeMappingConditionIsNull : System.Data.Entity.Core.Mapping.FunctionImportEntityTypeMappingCondition
                    {
                        public FunctionImportEntityTypeMappingConditionIsNull(string columnName, bool isNull) => throw null;
                        public bool IsNull { get => throw null; }
                    }
                    public sealed class FunctionImportEntityTypeMappingConditionValue : System.Data.Entity.Core.Mapping.FunctionImportEntityTypeMappingCondition
                    {
                        public FunctionImportEntityTypeMappingConditionValue(string columnName, object value) => throw null;
                        public object Value { get => throw null; }
                    }
                    public abstract class FunctionImportMapping : System.Data.Entity.Core.Mapping.MappingItem
                    {
                        public System.Data.Entity.Core.Metadata.Edm.EdmFunction FunctionImport { get => throw null; }
                        public System.Data.Entity.Core.Metadata.Edm.EdmFunction TargetFunction { get => throw null; }
                    }
                    public sealed class FunctionImportMappingComposable : System.Data.Entity.Core.Mapping.FunctionImportMapping
                    {
                        public FunctionImportMappingComposable(System.Data.Entity.Core.Metadata.Edm.EdmFunction functionImport, System.Data.Entity.Core.Metadata.Edm.EdmFunction targetFunction, System.Data.Entity.Core.Mapping.FunctionImportResultMapping resultMapping, System.Data.Entity.Core.Mapping.EntityContainerMapping containerMapping) => throw null;
                        public System.Data.Entity.Core.Mapping.FunctionImportResultMapping ResultMapping { get => throw null; }
                    }
                    public sealed class FunctionImportMappingNonComposable : System.Data.Entity.Core.Mapping.FunctionImportMapping
                    {
                        public FunctionImportMappingNonComposable(System.Data.Entity.Core.Metadata.Edm.EdmFunction functionImport, System.Data.Entity.Core.Metadata.Edm.EdmFunction targetFunction, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Mapping.FunctionImportResultMapping> resultMappings, System.Data.Entity.Core.Mapping.EntityContainerMapping containerMapping) => throw null;
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.FunctionImportResultMapping> ResultMappings { get => throw null; }
                    }
                    public sealed class FunctionImportResultMapping : System.Data.Entity.Core.Mapping.MappingItem
                    {
                        public void AddTypeMapping(System.Data.Entity.Core.Mapping.FunctionImportStructuralTypeMapping typeMapping) => throw null;
                        public FunctionImportResultMapping() => throw null;
                        public void RemoveTypeMapping(System.Data.Entity.Core.Mapping.FunctionImportStructuralTypeMapping typeMapping) => throw null;
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.FunctionImportStructuralTypeMapping> TypeMappings { get => throw null; }
                    }
                    public abstract class FunctionImportReturnTypePropertyMapping : System.Data.Entity.Core.Mapping.MappingItem
                    {
                    }
                    public sealed class FunctionImportReturnTypeScalarPropertyMapping : System.Data.Entity.Core.Mapping.FunctionImportReturnTypePropertyMapping
                    {
                        public string ColumnName { get => throw null; }
                        public FunctionImportReturnTypeScalarPropertyMapping(string propertyName, string columnName) => throw null;
                        public string PropertyName { get => throw null; }
                    }
                    public abstract class FunctionImportStructuralTypeMapping : System.Data.Entity.Core.Mapping.MappingItem
                    {
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.FunctionImportReturnTypePropertyMapping> PropertyMappings { get => throw null; }
                    }
                    public class IsNullConditionMapping : System.Data.Entity.Core.Mapping.ConditionPropertyMapping
                    {
                        public IsNullConditionMapping(System.Data.Entity.Core.Metadata.Edm.EdmProperty propertyOrColumn, bool isNull) => throw null;
                        public bool IsNull { get => throw null; }
                    }
                    public abstract class MappingBase : System.Data.Entity.Core.Metadata.Edm.GlobalItem
                    {
                    }
                    public class MappingFragment : System.Data.Entity.Core.Mapping.StructuralTypeMapping
                    {
                        public override void AddCondition(System.Data.Entity.Core.Mapping.ConditionPropertyMapping condition) => throw null;
                        public override void AddPropertyMapping(System.Data.Entity.Core.Mapping.PropertyMapping propertyMapping) => throw null;
                        public override System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.ConditionPropertyMapping> Conditions { get => throw null; }
                        public MappingFragment(System.Data.Entity.Core.Metadata.Edm.EntitySet storeEntitySet, System.Data.Entity.Core.Mapping.TypeMapping typeMapping, bool makeColumnsDistinct) => throw null;
                        public bool MakeColumnsDistinct { get => throw null; }
                        public override System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.PropertyMapping> PropertyMappings { get => throw null; }
                        public override void RemoveCondition(System.Data.Entity.Core.Mapping.ConditionPropertyMapping condition) => throw null;
                        public override void RemovePropertyMapping(System.Data.Entity.Core.Mapping.PropertyMapping propertyMapping) => throw null;
                        public System.Data.Entity.Core.Metadata.Edm.EntitySet StoreEntitySet { get => throw null; }
                        public System.Data.Entity.Core.Mapping.TypeMapping TypeMapping { get => throw null; }
                    }
                    public abstract class MappingItem
                    {
                        protected MappingItem() => throw null;
                    }
                    public abstract class MappingItemCollection : System.Data.Entity.Core.Metadata.Edm.ItemCollection
                    {
                    }
                    public sealed class ModificationFunctionMapping : System.Data.Entity.Core.Mapping.MappingItem
                    {
                        public ModificationFunctionMapping(System.Data.Entity.Core.Metadata.Edm.EntitySetBase entitySet, System.Data.Entity.Core.Metadata.Edm.EntityTypeBase entityType, System.Data.Entity.Core.Metadata.Edm.EdmFunction function, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Mapping.ModificationFunctionParameterBinding> parameterBindings, System.Data.Entity.Core.Metadata.Edm.FunctionParameter rowsAffectedParameter, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Mapping.ModificationFunctionResultBinding> resultBindings) => throw null;
                        public System.Data.Entity.Core.Metadata.Edm.EdmFunction Function { get => throw null; }
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.ModificationFunctionParameterBinding> ParameterBindings { get => throw null; }
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.ModificationFunctionResultBinding> ResultBindings { get => throw null; }
                        public System.Data.Entity.Core.Metadata.Edm.FunctionParameter RowsAffectedParameter { get => throw null; }
                        public override string ToString() => throw null;
                    }
                    public sealed class ModificationFunctionMemberPath : System.Data.Entity.Core.Mapping.MappingItem
                    {
                        public System.Data.Entity.Core.Metadata.Edm.AssociationSetEnd AssociationSetEnd { get => throw null; }
                        public ModificationFunctionMemberPath(System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmMember> members, System.Data.Entity.Core.Metadata.Edm.AssociationSet associationSet) => throw null;
                        public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.EdmMember> Members { get => throw null; }
                        public override string ToString() => throw null;
                    }
                    public sealed class ModificationFunctionParameterBinding : System.Data.Entity.Core.Mapping.MappingItem
                    {
                        public ModificationFunctionParameterBinding(System.Data.Entity.Core.Metadata.Edm.FunctionParameter parameter, System.Data.Entity.Core.Mapping.ModificationFunctionMemberPath memberPath, bool isCurrent) => throw null;
                        public bool IsCurrent { get => throw null; }
                        public System.Data.Entity.Core.Mapping.ModificationFunctionMemberPath MemberPath { get => throw null; }
                        public System.Data.Entity.Core.Metadata.Edm.FunctionParameter Parameter { get => throw null; }
                        public override string ToString() => throw null;
                    }
                    public sealed class ModificationFunctionResultBinding : System.Data.Entity.Core.Mapping.MappingItem
                    {
                        public string ColumnName { get => throw null; }
                        public ModificationFunctionResultBinding(string columnName, System.Data.Entity.Core.Metadata.Edm.EdmProperty property) => throw null;
                        public System.Data.Entity.Core.Metadata.Edm.EdmProperty Property { get => throw null; }
                        public override string ToString() => throw null;
                    }
                    public abstract class PropertyMapping : System.Data.Entity.Core.Mapping.MappingItem
                    {
                        public virtual System.Data.Entity.Core.Metadata.Edm.EdmProperty Property { get => throw null; set { } }
                    }
                    public class ScalarPropertyMapping : System.Data.Entity.Core.Mapping.PropertyMapping
                    {
                        public System.Data.Entity.Core.Metadata.Edm.EdmProperty Column { get => throw null; }
                        public ScalarPropertyMapping(System.Data.Entity.Core.Metadata.Edm.EdmProperty property, System.Data.Entity.Core.Metadata.Edm.EdmProperty column) => throw null;
                    }
                    public class StorageMappingItemCollection : System.Data.Entity.Core.Mapping.MappingItemCollection
                    {
                        public string ComputeMappingHashValue(string conceptualModelContainerName, string storeModelContainerName) => throw null;
                        public string ComputeMappingHashValue() => throw null;
                        public static System.Data.Entity.Core.Mapping.StorageMappingItemCollection Create(System.Data.Entity.Core.Metadata.Edm.EdmItemCollection edmItemCollection, System.Data.Entity.Core.Metadata.Edm.StoreItemCollection storeItemCollection, System.Collections.Generic.IEnumerable<System.Xml.XmlReader> xmlReaders, System.Collections.Generic.IList<string> filePaths, out System.Collections.Generic.IList<System.Data.Entity.Core.Metadata.Edm.EdmSchemaError> errors) => throw null;
                        public StorageMappingItemCollection(System.Data.Entity.Core.Metadata.Edm.EdmItemCollection edmCollection, System.Data.Entity.Core.Metadata.Edm.StoreItemCollection storeCollection, params string[] filePaths) => throw null;
                        public StorageMappingItemCollection(System.Data.Entity.Core.Metadata.Edm.EdmItemCollection edmCollection, System.Data.Entity.Core.Metadata.Edm.StoreItemCollection storeCollection, System.Collections.Generic.IEnumerable<System.Xml.XmlReader> xmlReaders) => throw null;
                        public System.Collections.Generic.Dictionary<System.Data.Entity.Core.Metadata.Edm.EntitySetBase, System.Data.Entity.Infrastructure.MappingViews.DbMappingView> GenerateViews(string conceptualModelContainerName, string storeModelContainerName, System.Collections.Generic.IList<System.Data.Entity.Core.Metadata.Edm.EdmSchemaError> errors) => throw null;
                        public System.Collections.Generic.Dictionary<System.Data.Entity.Core.Metadata.Edm.EntitySetBase, System.Data.Entity.Infrastructure.MappingViews.DbMappingView> GenerateViews(System.Collections.Generic.IList<System.Data.Entity.Core.Metadata.Edm.EdmSchemaError> errors) => throw null;
                        public double MappingVersion { get => throw null; }
                        public System.Data.Entity.Infrastructure.MappingViews.DbMappingViewCacheFactory MappingViewCacheFactory { get => throw null; set { } }
                    }
                    public abstract class StructuralTypeMapping : System.Data.Entity.Core.Mapping.MappingItem
                    {
                        public abstract void AddCondition(System.Data.Entity.Core.Mapping.ConditionPropertyMapping condition);
                        public abstract void AddPropertyMapping(System.Data.Entity.Core.Mapping.PropertyMapping propertyMapping);
                        public abstract System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.ConditionPropertyMapping> Conditions { get; }
                        protected StructuralTypeMapping() => throw null;
                        public abstract System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Mapping.PropertyMapping> PropertyMappings { get; }
                        public abstract void RemoveCondition(System.Data.Entity.Core.Mapping.ConditionPropertyMapping condition);
                        public abstract void RemovePropertyMapping(System.Data.Entity.Core.Mapping.PropertyMapping propertyMapping);
                    }
                    public abstract class TypeMapping : System.Data.Entity.Core.Mapping.MappingItem
                    {
                    }
                    public class ValueConditionMapping : System.Data.Entity.Core.Mapping.ConditionPropertyMapping
                    {
                        public ValueConditionMapping(System.Data.Entity.Core.Metadata.Edm.EdmProperty propertyOrColumn, object value) => throw null;
                        public object Value { get => throw null; }
                    }
                }
                public sealed class MappingException : System.Data.Entity.Core.EntityException
                {
                    public MappingException() => throw null;
                    public MappingException(string message) => throw null;
                    public MappingException(string message, System.Exception innerException) => throw null;
                }
                namespace Metadata
                {
                    namespace Edm
                    {
                        public sealed class AssociationEndMember : System.Data.Entity.Core.Metadata.Edm.RelationshipEndMember
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public static System.Data.Entity.Core.Metadata.Edm.AssociationEndMember Create(string name, System.Data.Entity.Core.Metadata.Edm.RefType endRefType, System.Data.Entity.Core.Metadata.Edm.RelationshipMultiplicity multiplicity, System.Data.Entity.Core.Metadata.Edm.OperationAction deleteAction, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                        }
                        public sealed class AssociationSet : System.Data.Entity.Core.Metadata.Edm.RelationshipSet
                        {
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.AssociationSetEnd> AssociationSetEnds { get => throw null; }
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public static System.Data.Entity.Core.Metadata.Edm.AssociationSet Create(string name, System.Data.Entity.Core.Metadata.Edm.AssociationType type, System.Data.Entity.Core.Metadata.Edm.EntitySet sourceSet, System.Data.Entity.Core.Metadata.Edm.EntitySet targetSet, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.AssociationType ElementType { get => throw null; }
                        }
                        public sealed class AssociationSetEnd : System.Data.Entity.Core.Metadata.Edm.MetadataItem
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.AssociationEndMember CorrespondingAssociationEndMember { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.EntitySet EntitySet { get => throw null; }
                            public string Name { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.AssociationSet ParentAssociationSet { get => throw null; }
                            public string Role { get => throw null; }
                            public override string ToString() => throw null;
                        }
                        public class AssociationType : System.Data.Entity.Core.Metadata.Edm.RelationshipType
                        {
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.AssociationEndMember> AssociationEndMembers { get => throw null; }
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.ReferentialConstraint Constraint { get => throw null; set { } }
                            public static System.Data.Entity.Core.Metadata.Edm.AssociationType Create(string name, string namespaceName, bool foreignKey, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, System.Data.Entity.Core.Metadata.Edm.AssociationEndMember sourceEnd, System.Data.Entity.Core.Metadata.Edm.AssociationEndMember targetEnd, System.Data.Entity.Core.Metadata.Edm.ReferentialConstraint constraint, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public bool IsForeignKey { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.ReferentialConstraint> ReferentialConstraints { get => throw null; }
                        }
                        public enum BuiltInTypeKind
                        {
                            AssociationEndMember = 0,
                            AssociationSetEnd = 1,
                            AssociationSet = 2,
                            AssociationType = 3,
                            EntitySetBase = 4,
                            EntityTypeBase = 5,
                            CollectionType = 6,
                            CollectionKind = 7,
                            ComplexType = 8,
                            Documentation = 9,
                            OperationAction = 10,
                            EdmType = 11,
                            EntityContainer = 12,
                            EntitySet = 13,
                            EntityType = 14,
                            EnumType = 15,
                            EnumMember = 16,
                            Facet = 17,
                            EdmFunction = 18,
                            FunctionParameter = 19,
                            GlobalItem = 20,
                            MetadataProperty = 21,
                            NavigationProperty = 22,
                            MetadataItem = 23,
                            EdmMember = 24,
                            ParameterMode = 25,
                            PrimitiveType = 26,
                            PrimitiveTypeKind = 27,
                            EdmProperty = 28,
                            ProviderManifest = 29,
                            ReferentialConstraint = 30,
                            RefType = 31,
                            RelationshipEndMember = 32,
                            RelationshipMultiplicity = 33,
                            RelationshipSet = 34,
                            RelationshipType = 35,
                            RowType = 36,
                            SimpleType = 37,
                            StructuralType = 38,
                            TypeUsage = 39,
                        }
                        public enum CollectionKind
                        {
                            None = 0,
                            Bag = 1,
                            List = 2,
                        }
                        public class CollectionType : System.Data.Entity.Core.Metadata.Edm.EdmType
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public virtual System.Data.Entity.Core.Metadata.Edm.TypeUsage TypeUsage { get => throw null; }
                        }
                        public class ComplexType : System.Data.Entity.Core.Metadata.Edm.StructuralType
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public static System.Data.Entity.Core.Metadata.Edm.ComplexType Create(string name, string namespaceName, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmMember> members, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.EdmProperty> Properties { get => throw null; }
                        }
                        public enum ConcurrencyMode
                        {
                            None = 0,
                            Fixed = 1,
                        }
                        public class CsdlSerializer
                        {
                            public CsdlSerializer() => throw null;
                            public event System.EventHandler<System.Data.Entity.Core.Metadata.Edm.DataModelErrorEventArgs> OnError;
                            public bool Serialize(System.Data.Entity.Core.Metadata.Edm.EdmModel model, System.Xml.XmlWriter xmlWriter, string modelNamespace = default(string)) => throw null;
                        }
                        public class DataModelErrorEventArgs : System.EventArgs
                        {
                            public DataModelErrorEventArgs() => throw null;
                            public string ErrorMessage { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.MetadataItem Item { get => throw null; set { } }
                            public string PropertyName { get => throw null; }
                        }
                        public enum DataSpace
                        {
                            OSpace = 0,
                            CSpace = 1,
                            SSpace = 2,
                            OCSpace = 3,
                            CSSpace = 4,
                        }
                        public static partial class DbModelExtensions
                        {
                            public static System.Data.Entity.Core.Metadata.Edm.EdmModel GetConceptualModel(this System.Data.Entity.Core.Metadata.Edm.IEdmModelAdapter model) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.EdmModel GetStoreModel(this System.Data.Entity.Core.Metadata.Edm.IEdmModelAdapter model) => throw null;
                        }
                        public sealed class Documentation : System.Data.Entity.Core.Metadata.Edm.MetadataItem
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public Documentation(string summary, string longDescription) => throw null;
                            public bool IsEmpty { get => throw null; }
                            public string LongDescription { get => throw null; }
                            public string Summary { get => throw null; }
                            public override string ToString() => throw null;
                        }
                        public abstract class EdmError
                        {
                            public string Message { get => throw null; }
                        }
                        public class EdmFunction : System.Data.Entity.Core.Metadata.Edm.EdmType
                        {
                            public void AddParameter(System.Data.Entity.Core.Metadata.Edm.FunctionParameter functionParameter) => throw null;
                            public bool AggregateAttribute { get => throw null; }
                            public virtual bool BuiltInAttribute { get => throw null; }
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public string CommandTextAttribute { get => throw null; }
                            public static System.Data.Entity.Core.Metadata.Edm.EdmFunction Create(string name, string namespaceName, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, System.Data.Entity.Core.Metadata.Edm.EdmFunctionPayload payload, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public override string FullName { get => throw null; }
                            public bool IsComposableAttribute { get => throw null; }
                            public bool IsFromProviderManifest { get => throw null; }
                            public bool NiladicFunctionAttribute { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.FunctionParameter> Parameters { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.ParameterTypeSemantics ParameterTypeSemanticsAttribute { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.FunctionParameter ReturnParameter { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.FunctionParameter> ReturnParameters { get => throw null; }
                            public string Schema { get => throw null; set { } }
                            public string StoreFunctionNameAttribute { get => throw null; set { } }
                        }
                        public class EdmFunctionPayload
                        {
                            public string CommandText { get => throw null; set { } }
                            public EdmFunctionPayload() => throw null;
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Metadata.Edm.EntitySet> EntitySets { get => throw null; set { } }
                            public bool? IsAggregate { get => throw null; set { } }
                            public bool? IsBuiltIn { get => throw null; set { } }
                            public bool? IsCachedStoreFunction { get => throw null; set { } }
                            public bool? IsComposable { get => throw null; set { } }
                            public bool? IsFromProviderManifest { get => throw null; set { } }
                            public bool? IsFunctionImport { get => throw null; set { } }
                            public bool? IsNiladic { get => throw null; set { } }
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Metadata.Edm.FunctionParameter> Parameters { get => throw null; set { } }
                            public System.Data.Entity.Core.Metadata.Edm.ParameterTypeSemantics? ParameterTypeSemantics { get => throw null; set { } }
                            public System.Collections.Generic.IList<System.Data.Entity.Core.Metadata.Edm.FunctionParameter> ReturnParameters { get => throw null; set { } }
                            public string Schema { get => throw null; set { } }
                            public string StoreFunctionName { get => throw null; set { } }
                        }
                        public sealed class EdmItemCollection : System.Data.Entity.Core.Metadata.Edm.ItemCollection
                        {
                            public static System.Data.Entity.Core.Metadata.Edm.EdmItemCollection Create(System.Collections.Generic.IEnumerable<System.Xml.XmlReader> xmlReaders, System.Collections.ObjectModel.ReadOnlyCollection<string> filePaths, out System.Collections.Generic.IList<System.Data.Entity.Core.Metadata.Edm.EdmSchemaError> errors) => throw null;
                            public EdmItemCollection(System.Collections.Generic.IEnumerable<System.Xml.XmlReader> xmlReaders) => throw null;
                            public EdmItemCollection(System.Data.Entity.Core.Metadata.Edm.EdmModel model) => throw null;
                            public EdmItemCollection(params string[] filePaths) => throw null;
                            public double EdmVersion { get => throw null; }
                            public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.PrimitiveType> GetPrimitiveTypes() => throw null;
                            public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.PrimitiveType> GetPrimitiveTypes(double edmVersion) => throw null;
                        }
                        public abstract class EdmMember : System.Data.Entity.Core.Metadata.Edm.MetadataItem
                        {
                            public virtual System.Data.Entity.Core.Metadata.Edm.StructuralType DeclaringType { get => throw null; }
                            public bool IsStoreGeneratedComputed { get => throw null; }
                            public bool IsStoreGeneratedIdentity { get => throw null; }
                            public virtual string Name { get => throw null; set { } }
                            public override string ToString() => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.TypeUsage TypeUsage { get => throw null; set { } }
                        }
                        public class EdmModel : System.Data.Entity.Core.Metadata.Edm.MetadataItem
                        {
                            public void AddItem(System.Data.Entity.Core.Metadata.Edm.AssociationType item) => throw null;
                            public void AddItem(System.Data.Entity.Core.Metadata.Edm.ComplexType item) => throw null;
                            public void AddItem(System.Data.Entity.Core.Metadata.Edm.EntityType item) => throw null;
                            public void AddItem(System.Data.Entity.Core.Metadata.Edm.EnumType item) => throw null;
                            public void AddItem(System.Data.Entity.Core.Metadata.Edm.EdmFunction item) => throw null;
                            public System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.AssociationType> AssociationTypes { get => throw null; }
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.ComplexType> ComplexTypes { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.EntityContainer Container { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.DataSpace DataSpace { get => throw null; }
                            public System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EntityType> EntityTypes { get => throw null; }
                            public System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EnumType> EnumTypes { get => throw null; }
                            public System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmFunction> Functions { get => throw null; }
                            public System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.GlobalItem> GlobalItems { get => throw null; }
                            public void RemoveItem(System.Data.Entity.Core.Metadata.Edm.AssociationType item) => throw null;
                            public void RemoveItem(System.Data.Entity.Core.Metadata.Edm.ComplexType item) => throw null;
                            public void RemoveItem(System.Data.Entity.Core.Metadata.Edm.EntityType item) => throw null;
                            public void RemoveItem(System.Data.Entity.Core.Metadata.Edm.EnumType item) => throw null;
                            public void RemoveItem(System.Data.Entity.Core.Metadata.Edm.EdmFunction item) => throw null;
                        }
                        public class EdmProperty : System.Data.Entity.Core.Metadata.Edm.EdmMember
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.CollectionKind CollectionKind { get => throw null; set { } }
                            public System.Data.Entity.Core.Metadata.Edm.ComplexType ComplexType { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.ConcurrencyMode ConcurrencyMode { get => throw null; set { } }
                            public static System.Data.Entity.Core.Metadata.Edm.EdmProperty Create(string name, System.Data.Entity.Core.Metadata.Edm.TypeUsage typeUsage) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.EdmProperty CreateComplex(string name, System.Data.Entity.Core.Metadata.Edm.ComplexType complexType) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.EdmProperty CreateEnum(string name, System.Data.Entity.Core.Metadata.Edm.EnumType enumType) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.EdmProperty CreatePrimitive(string name, System.Data.Entity.Core.Metadata.Edm.PrimitiveType primitiveType) => throw null;
                            public object DefaultValue { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.EnumType EnumType { get => throw null; }
                            public bool IsCollectionType { get => throw null; }
                            public bool IsComplexType { get => throw null; }
                            public bool IsEnumType { get => throw null; }
                            public bool? IsFixedLength { get => throw null; set { } }
                            public bool IsFixedLengthConstant { get => throw null; }
                            public bool IsMaxLength { get => throw null; set { } }
                            public bool IsMaxLengthConstant { get => throw null; }
                            public bool IsPrecisionConstant { get => throw null; }
                            public bool IsPrimitiveType { get => throw null; }
                            public bool IsScaleConstant { get => throw null; }
                            public bool IsUnderlyingPrimitiveType { get => throw null; }
                            public bool? IsUnicode { get => throw null; set { } }
                            public bool IsUnicodeConstant { get => throw null; }
                            public int? MaxLength { get => throw null; set { } }
                            public bool Nullable { get => throw null; set { } }
                            public byte? Precision { get => throw null; set { } }
                            public System.Data.Entity.Core.Metadata.Edm.PrimitiveType PrimitiveType { get => throw null; }
                            public byte? Scale { get => throw null; set { } }
                            public void SetMetadataProperties(System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.StoreGeneratedPattern StoreGeneratedPattern { get => throw null; set { } }
                            public string TypeName { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.PrimitiveType UnderlyingPrimitiveType { get => throw null; }
                        }
                        public sealed class EdmSchemaError : System.Data.Entity.Core.Metadata.Edm.EdmError
                        {
                            public int Column { get => throw null; }
                            public EdmSchemaError(string message, int errorCode, System.Data.Entity.Core.Metadata.Edm.EdmSchemaErrorSeverity severity) => throw null;
                            public int ErrorCode { get => throw null; }
                            public int Line { get => throw null; }
                            public string SchemaLocation { get => throw null; }
                            public string SchemaName { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.EdmSchemaErrorSeverity Severity { get => throw null; set { } }
                            public string StackTrace { get => throw null; }
                            public override string ToString() => throw null;
                        }
                        public enum EdmSchemaErrorSeverity
                        {
                            Warning = 0,
                            Error = 1,
                        }
                        public abstract class EdmType : System.Data.Entity.Core.Metadata.Edm.GlobalItem
                        {
                            public bool Abstract { get => throw null; }
                            public virtual System.Data.Entity.Core.Metadata.Edm.EdmType BaseType { get => throw null; set { } }
                            public virtual string FullName { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.CollectionType GetCollectionType() => throw null;
                            public virtual string Name { get => throw null; set { } }
                            public virtual string NamespaceName { get => throw null; set { } }
                            public override string ToString() => throw null;
                        }
                        public class EntityContainer : System.Data.Entity.Core.Metadata.Edm.GlobalItem
                        {
                            public void AddEntitySetBase(System.Data.Entity.Core.Metadata.Edm.EntitySetBase entitySetBase) => throw null;
                            public void AddFunctionImport(System.Data.Entity.Core.Metadata.Edm.EdmFunction function) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.AssociationSet> AssociationSets { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.EntitySetBase> BaseEntitySets { get => throw null; }
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public static System.Data.Entity.Core.Metadata.Edm.EntityContainer Create(string name, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EntitySetBase> entitySets, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmFunction> functionImports, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public EntityContainer(string name, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.EntitySet> EntitySets { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.EdmFunction> FunctionImports { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.EntitySet GetEntitySetByName(string name, bool ignoreCase) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.RelationshipSet GetRelationshipSetByName(string name, bool ignoreCase) => throw null;
                            public virtual string Name { get => throw null; set { } }
                            public void RemoveEntitySetBase(System.Data.Entity.Core.Metadata.Edm.EntitySetBase entitySetBase) => throw null;
                            public override string ToString() => throw null;
                            public bool TryGetEntitySetByName(string name, bool ignoreCase, out System.Data.Entity.Core.Metadata.Edm.EntitySet entitySet) => throw null;
                            public bool TryGetRelationshipSetByName(string name, bool ignoreCase, out System.Data.Entity.Core.Metadata.Edm.RelationshipSet relationshipSet) => throw null;
                        }
                        public class EntitySet : System.Data.Entity.Core.Metadata.Edm.EntitySetBase
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public static System.Data.Entity.Core.Metadata.Edm.EntitySet Create(string name, string schema, string table, string definingQuery, System.Data.Entity.Core.Metadata.Edm.EntityType entityType, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.EntityType ElementType { get => throw null; }
                        }
                        public abstract class EntitySetBase : System.Data.Entity.Core.Metadata.Edm.MetadataItem
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public string DefiningQuery { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.EntityTypeBase ElementType { get => throw null; }
                            public virtual System.Data.Entity.Core.Metadata.Edm.EntityContainer EntityContainer { get => throw null; }
                            public virtual string Name { get => throw null; set { } }
                            public string Schema { get => throw null; set { } }
                            public string Table { get => throw null; set { } }
                            public override string ToString() => throw null;
                        }
                        public class EntityType : System.Data.Entity.Core.Metadata.Edm.EntityTypeBase
                        {
                            public void AddNavigationProperty(System.Data.Entity.Core.Metadata.Edm.NavigationProperty property) => throw null;
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public static System.Data.Entity.Core.Metadata.Edm.EntityType Create(string name, string namespaceName, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, System.Collections.Generic.IEnumerable<string> keyMemberNames, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmMember> members, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.EntityType Create(string name, string namespaceName, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, System.Data.Entity.Core.Metadata.Edm.EntityType baseType, System.Collections.Generic.IEnumerable<string> keyMemberNames, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmMember> members, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.EdmMember> DeclaredMembers { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.NavigationProperty> DeclaredNavigationProperties { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.EdmProperty> DeclaredProperties { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.RefType GetReferenceType() => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.NavigationProperty> NavigationProperties { get => throw null; }
                            public virtual System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.EdmProperty> Properties { get => throw null; }
                        }
                        public abstract class EntityTypeBase : System.Data.Entity.Core.Metadata.Edm.StructuralType
                        {
                            public void AddKeyMember(System.Data.Entity.Core.Metadata.Edm.EdmMember member) => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.EdmMember> KeyMembers { get => throw null; }
                            public virtual System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.EdmProperty> KeyProperties { get => throw null; }
                            public override void RemoveMember(System.Data.Entity.Core.Metadata.Edm.EdmMember member) => throw null;
                        }
                        public sealed class EnumMember : System.Data.Entity.Core.Metadata.Edm.MetadataItem
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public static System.Data.Entity.Core.Metadata.Edm.EnumMember Create(string name, sbyte value, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.EnumMember Create(string name, byte value, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.EnumMember Create(string name, short value, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.EnumMember Create(string name, int value, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.EnumMember Create(string name, long value, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public string Name { get => throw null; }
                            public override string ToString() => throw null;
                            public object Value { get => throw null; }
                        }
                        public class EnumType : System.Data.Entity.Core.Metadata.Edm.SimpleType
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public static System.Data.Entity.Core.Metadata.Edm.EnumType Create(string name, string namespaceName, System.Data.Entity.Core.Metadata.Edm.PrimitiveType underlyingType, bool isFlags, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EnumMember> members, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public bool IsFlags { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.EnumMember> Members { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.PrimitiveType UnderlyingType { get => throw null; }
                        }
                        public class Facet : System.Data.Entity.Core.Metadata.Edm.MetadataItem
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.FacetDescription Description { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.EdmType FacetType { get => throw null; }
                            public bool IsUnbounded { get => throw null; }
                            public virtual string Name { get => throw null; }
                            public override string ToString() => throw null;
                            public virtual object Value { get => throw null; }
                        }
                        public class FacetDescription
                        {
                            public object DefaultValue { get => throw null; }
                            public virtual string FacetName { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.EdmType FacetType { get => throw null; }
                            public virtual bool IsConstant { get => throw null; }
                            public bool IsRequired { get => throw null; }
                            public int? MaxValue { get => throw null; }
                            public int? MinValue { get => throw null; }
                            public override string ToString() => throw null;
                        }
                        public sealed class FunctionParameter : System.Data.Entity.Core.Metadata.Edm.MetadataItem
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public static System.Data.Entity.Core.Metadata.Edm.FunctionParameter Create(string name, System.Data.Entity.Core.Metadata.Edm.EdmType edmType, System.Data.Entity.Core.Metadata.Edm.ParameterMode parameterMode) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.EdmFunction DeclaringFunction { get => throw null; }
                            public bool IsMaxLength { get => throw null; }
                            public bool IsMaxLengthConstant { get => throw null; }
                            public bool IsPrecisionConstant { get => throw null; }
                            public bool IsScaleConstant { get => throw null; }
                            public int? MaxLength { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.ParameterMode Mode { get => throw null; }
                            public string Name { get => throw null; set { } }
                            public byte? Precision { get => throw null; }
                            public byte? Scale { get => throw null; }
                            public override string ToString() => throw null;
                            public string TypeName { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.TypeUsage TypeUsage { get => throw null; }
                        }
                        public abstract class GlobalItem : System.Data.Entity.Core.Metadata.Edm.MetadataItem
                        {
                        }
                        public interface IEdmModelAdapter
                        {
                            System.Data.Entity.Core.Metadata.Edm.EdmModel ConceptualModel { get; }
                            System.Data.Entity.Core.Metadata.Edm.EdmModel StoreModel { get; }
                        }
                        public abstract class ItemCollection : System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.GlobalItem>
                        {
                            public System.Data.Entity.Core.Metadata.Edm.DataSpace DataSpace { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.EntityContainer GetEntityContainer(string name) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.EntityContainer GetEntityContainer(string name, bool ignoreCase) => throw null;
                            public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.EdmFunction> GetFunctions(string functionName) => throw null;
                            public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.EdmFunction> GetFunctions(string functionName, bool ignoreCase) => throw null;
                            protected static System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.EdmFunction> GetFunctions(System.Collections.Generic.Dictionary<string, System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.EdmFunction>> functionCollection, string functionName, bool ignoreCase) => throw null;
                            public T GetItem<T>(string identity) where T : System.Data.Entity.Core.Metadata.Edm.GlobalItem => throw null;
                            public T GetItem<T>(string identity, bool ignoreCase) where T : System.Data.Entity.Core.Metadata.Edm.GlobalItem => throw null;
                            public virtual System.Collections.ObjectModel.ReadOnlyCollection<T> GetItems<T>() where T : System.Data.Entity.Core.Metadata.Edm.GlobalItem => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.EdmType GetType(string name, string namespaceName) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.EdmType GetType(string name, string namespaceName, bool ignoreCase) => throw null;
                            public bool TryGetEntityContainer(string name, out System.Data.Entity.Core.Metadata.Edm.EntityContainer entityContainer) => throw null;
                            public bool TryGetEntityContainer(string name, bool ignoreCase, out System.Data.Entity.Core.Metadata.Edm.EntityContainer entityContainer) => throw null;
                            public bool TryGetItem<T>(string identity, out T item) where T : System.Data.Entity.Core.Metadata.Edm.GlobalItem => throw null;
                            public bool TryGetItem<T>(string identity, bool ignoreCase, out T item) where T : System.Data.Entity.Core.Metadata.Edm.GlobalItem => throw null;
                            public bool TryGetType(string name, string namespaceName, out System.Data.Entity.Core.Metadata.Edm.EdmType type) => throw null;
                            public bool TryGetType(string name, string namespaceName, bool ignoreCase, out System.Data.Entity.Core.Metadata.Edm.EdmType type) => throw null;
                        }
                        public abstract class MetadataItem
                        {
                            public void AddAnnotation(string name, object value) => throw null;
                            public abstract System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get; }
                            public System.Data.Entity.Core.Metadata.Edm.Documentation Documentation { get => throw null; set { } }
                            public static System.Data.Entity.Core.Metadata.Edm.EdmType GetBuiltInType(System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind builtInTypeKind) => throw null;
                            public static System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.FacetDescription> GetGeneralFacetDescriptions() => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> MetadataProperties { get => throw null; }
                            public bool RemoveAnnotation(string name) => throw null;
                        }
                        public class MetadataProperty : System.Data.Entity.Core.Metadata.Edm.MetadataItem
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public static System.Data.Entity.Core.Metadata.Edm.MetadataProperty Create(string name, System.Data.Entity.Core.Metadata.Edm.TypeUsage typeUsage, object value) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.MetadataProperty CreateAnnotation(string name, object value) => throw null;
                            public bool IsAnnotation { get => throw null; }
                            public virtual string Name { get => throw null; }
                            public virtual System.Data.Entity.Core.Metadata.Edm.PropertyKind PropertyKind { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.TypeUsage TypeUsage { get => throw null; }
                            public virtual object Value { get => throw null; set { } }
                        }
                        public class MetadataWorkspace
                        {
                            public static void ClearCache() => throw null;
                            public virtual System.Data.Entity.Core.Common.EntitySql.EntitySqlParser CreateEntitySqlParser() => throw null;
                            public virtual System.Data.Entity.Core.Common.CommandTrees.DbQueryCommandTree CreateQueryCommandTree(System.Data.Entity.Core.Common.CommandTrees.DbExpression query) => throw null;
                            public MetadataWorkspace() => throw null;
                            public MetadataWorkspace(System.Func<System.Data.Entity.Core.Metadata.Edm.EdmItemCollection> cSpaceLoader, System.Func<System.Data.Entity.Core.Metadata.Edm.StoreItemCollection> sSpaceLoader, System.Func<System.Data.Entity.Core.Mapping.StorageMappingItemCollection> csMappingLoader, System.Func<System.Data.Entity.Core.Metadata.Edm.ObjectItemCollection> oSpaceLoader) => throw null;
                            public MetadataWorkspace(System.Func<System.Data.Entity.Core.Metadata.Edm.EdmItemCollection> cSpaceLoader, System.Func<System.Data.Entity.Core.Metadata.Edm.StoreItemCollection> sSpaceLoader, System.Func<System.Data.Entity.Core.Mapping.StorageMappingItemCollection> csMappingLoader) => throw null;
                            public MetadataWorkspace(System.Collections.Generic.IEnumerable<string> paths, System.Collections.Generic.IEnumerable<System.Reflection.Assembly> assembliesToConsider) => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.StructuralType GetEdmSpaceType(System.Data.Entity.Core.Metadata.Edm.StructuralType objectSpaceType) => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.EnumType GetEdmSpaceType(System.Data.Entity.Core.Metadata.Edm.EnumType objectSpaceType) => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.EntityContainer GetEntityContainer(string name, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace) => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.EntityContainer GetEntityContainer(string name, bool ignoreCase, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace) => throw null;
                            public virtual System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.EdmFunction> GetFunctions(string name, string namespaceName, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace) => throw null;
                            public virtual System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.EdmFunction> GetFunctions(string name, string namespaceName, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, bool ignoreCase) => throw null;
                            public virtual T GetItem<T>(string identity, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace) where T : System.Data.Entity.Core.Metadata.Edm.GlobalItem => throw null;
                            public virtual T GetItem<T>(string identity, bool ignoreCase, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace) where T : System.Data.Entity.Core.Metadata.Edm.GlobalItem => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.ItemCollection GetItemCollection(System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace) => throw null;
                            public virtual System.Collections.ObjectModel.ReadOnlyCollection<T> GetItems<T>(System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace) where T : System.Data.Entity.Core.Metadata.Edm.GlobalItem => throw null;
                            public virtual System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.GlobalItem> GetItems(System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace) => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.StructuralType GetObjectSpaceType(System.Data.Entity.Core.Metadata.Edm.StructuralType edmSpaceType) => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.EnumType GetObjectSpaceType(System.Data.Entity.Core.Metadata.Edm.EnumType edmSpaceType) => throw null;
                            public virtual System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.PrimitiveType> GetPrimitiveTypes(System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace) => throw null;
                            public virtual System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.EdmMember> GetRelevantMembersForUpdate(System.Data.Entity.Core.Metadata.Edm.EntitySetBase entitySet, System.Data.Entity.Core.Metadata.Edm.EntityTypeBase entityType, bool partialUpdateSupported) => throw null;
                            public virtual System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmMember> GetRequiredOriginalValueMembers(System.Data.Entity.Core.Metadata.Edm.EntitySetBase entitySet, System.Data.Entity.Core.Metadata.Edm.EntityTypeBase entityType) => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.EdmType GetType(string name, string namespaceName, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace) => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.EdmType GetType(string name, string namespaceName, bool ignoreCase, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace) => throw null;
                            public virtual void LoadFromAssembly(System.Reflection.Assembly assembly) => throw null;
                            public virtual void LoadFromAssembly(System.Reflection.Assembly assembly, System.Action<string> logLoadMessage) => throw null;
                            public static double MaximumEdmVersionSupported { get => throw null; }
                            public virtual void RegisterItemCollection(System.Data.Entity.Core.Metadata.Edm.ItemCollection collection) => throw null;
                            public virtual bool TryGetEdmSpaceType(System.Data.Entity.Core.Metadata.Edm.StructuralType objectSpaceType, out System.Data.Entity.Core.Metadata.Edm.StructuralType edmSpaceType) => throw null;
                            public virtual bool TryGetEdmSpaceType(System.Data.Entity.Core.Metadata.Edm.EnumType objectSpaceType, out System.Data.Entity.Core.Metadata.Edm.EnumType edmSpaceType) => throw null;
                            public virtual bool TryGetEntityContainer(string name, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, out System.Data.Entity.Core.Metadata.Edm.EntityContainer entityContainer) => throw null;
                            public virtual bool TryGetEntityContainer(string name, bool ignoreCase, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, out System.Data.Entity.Core.Metadata.Edm.EntityContainer entityContainer) => throw null;
                            public virtual bool TryGetItem<T>(string identity, System.Data.Entity.Core.Metadata.Edm.DataSpace space, out T item) where T : System.Data.Entity.Core.Metadata.Edm.GlobalItem => throw null;
                            public virtual bool TryGetItem<T>(string identity, bool ignoreCase, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, out T item) where T : System.Data.Entity.Core.Metadata.Edm.GlobalItem => throw null;
                            public virtual bool TryGetItemCollection(System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, out System.Data.Entity.Core.Metadata.Edm.ItemCollection collection) => throw null;
                            public virtual bool TryGetObjectSpaceType(System.Data.Entity.Core.Metadata.Edm.StructuralType edmSpaceType, out System.Data.Entity.Core.Metadata.Edm.StructuralType objectSpaceType) => throw null;
                            public virtual bool TryGetObjectSpaceType(System.Data.Entity.Core.Metadata.Edm.EnumType edmSpaceType, out System.Data.Entity.Core.Metadata.Edm.EnumType objectSpaceType) => throw null;
                            public virtual bool TryGetType(string name, string namespaceName, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, out System.Data.Entity.Core.Metadata.Edm.EdmType type) => throw null;
                            public virtual bool TryGetType(string name, string namespaceName, bool ignoreCase, System.Data.Entity.Core.Metadata.Edm.DataSpace dataSpace, out System.Data.Entity.Core.Metadata.Edm.EdmType type) => throw null;
                        }
                        public sealed class NavigationProperty : System.Data.Entity.Core.Metadata.Edm.EdmMember
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public static System.Data.Entity.Core.Metadata.Edm.NavigationProperty Create(string name, System.Data.Entity.Core.Metadata.Edm.TypeUsage typeUsage, System.Data.Entity.Core.Metadata.Edm.RelationshipType relationshipType, System.Data.Entity.Core.Metadata.Edm.RelationshipEndMember from, System.Data.Entity.Core.Metadata.Edm.RelationshipEndMember to, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.RelationshipEndMember FromEndMember { get => throw null; }
                            public System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmProperty> GetDependentProperties() => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.RelationshipType RelationshipType { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.RelationshipEndMember ToEndMember { get => throw null; }
                        }
                        public class ObjectItemCollection : System.Data.Entity.Core.Metadata.Edm.ItemCollection
                        {
                            public ObjectItemCollection() => throw null;
                            public System.Type GetClrType(System.Data.Entity.Core.Metadata.Edm.StructuralType objectSpaceType) => throw null;
                            public System.Type GetClrType(System.Data.Entity.Core.Metadata.Edm.EnumType objectSpaceType) => throw null;
                            public override System.Collections.ObjectModel.ReadOnlyCollection<T> GetItems<T>() => throw null;
                            public System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.PrimitiveType> GetPrimitiveTypes() => throw null;
                            public void LoadFromAssembly(System.Reflection.Assembly assembly) => throw null;
                            public void LoadFromAssembly(System.Reflection.Assembly assembly, System.Data.Entity.Core.Metadata.Edm.EdmItemCollection edmItemCollection, System.Action<string> logLoadMessage) => throw null;
                            public void LoadFromAssembly(System.Reflection.Assembly assembly, System.Data.Entity.Core.Metadata.Edm.EdmItemCollection edmItemCollection) => throw null;
                            public bool TryGetClrType(System.Data.Entity.Core.Metadata.Edm.StructuralType objectSpaceType, out System.Type clrType) => throw null;
                            public bool TryGetClrType(System.Data.Entity.Core.Metadata.Edm.EnumType objectSpaceType, out System.Type clrType) => throw null;
                        }
                        public enum OperationAction
                        {
                            None = 0,
                            Cascade = 1,
                        }
                        public enum ParameterMode
                        {
                            In = 0,
                            Out = 1,
                            InOut = 2,
                            ReturnValue = 3,
                        }
                        public enum ParameterTypeSemantics
                        {
                            AllowImplicitConversion = 0,
                            AllowImplicitPromotion = 1,
                            ExactMatchOnly = 2,
                        }
                        public class PrimitiveType : System.Data.Entity.Core.Metadata.Edm.SimpleType
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public System.Type ClrEquivalentType { get => throw null; }
                            public virtual System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.FacetDescription> FacetDescriptions { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.EdmType GetEdmPrimitiveType() => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.PrimitiveType GetEdmPrimitiveType(System.Data.Entity.Core.Metadata.Edm.PrimitiveTypeKind primitiveTypeKind) => throw null;
                            public static System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.PrimitiveType> GetEdmPrimitiveTypes() => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.PrimitiveTypeKind PrimitiveTypeKind { get => throw null; set { } }
                        }
                        public enum PrimitiveTypeKind
                        {
                            Binary = 0,
                            Boolean = 1,
                            Byte = 2,
                            DateTime = 3,
                            Decimal = 4,
                            Double = 5,
                            Guid = 6,
                            Single = 7,
                            SByte = 8,
                            Int16 = 9,
                            Int32 = 10,
                            Int64 = 11,
                            String = 12,
                            Time = 13,
                            DateTimeOffset = 14,
                            Geometry = 15,
                            Geography = 16,
                            GeometryPoint = 17,
                            GeometryLineString = 18,
                            GeometryPolygon = 19,
                            GeometryMultiPoint = 20,
                            GeometryMultiLineString = 21,
                            GeometryMultiPolygon = 22,
                            GeometryCollection = 23,
                            GeographyPoint = 24,
                            GeographyLineString = 25,
                            GeographyPolygon = 26,
                            GeographyMultiPoint = 27,
                            GeographyMultiLineString = 28,
                            GeographyMultiPolygon = 29,
                            GeographyCollection = 30,
                            HierarchyId = 31,
                        }
                        public enum PropertyKind
                        {
                            System = 0,
                            Extended = 1,
                        }
                        public class ReadOnlyMetadataCollection<T> : System.Collections.ObjectModel.ReadOnlyCollection<T> where T : System.Data.Entity.Core.Metadata.Edm.MetadataItem
                        {
                            public virtual bool Contains(string identity) => throw null;
                            public struct Enumerator : System.IDisposable, System.Collections.Generic.IEnumerator<T>, System.Collections.IEnumerator
                            {
                                public T Current { get => throw null; }
                                object System.Collections.IEnumerator.Current { get => throw null; }
                                public void Dispose() => throw null;
                                public bool MoveNext() => throw null;
                                public void Reset() => throw null;
                            }
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<T>.Enumerator GetEnumerator() => throw null;
                            public virtual T GetValue(string identity, bool ignoreCase) => throw null;
                            public virtual int IndexOf(T value) => throw null;
                            public bool IsReadOnly { get => throw null; }
                            public virtual T this[string identity] { get => throw null; }
                            public virtual bool TryGetValue(string identity, bool ignoreCase, out T item) => throw null;
                            internal ReadOnlyMetadataCollection() : base(default(System.Collections.Generic.IList<T>)) { }
                        }
                        public sealed class ReferentialConstraint : System.Data.Entity.Core.Metadata.Edm.MetadataItem
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public ReferentialConstraint(System.Data.Entity.Core.Metadata.Edm.RelationshipEndMember fromRole, System.Data.Entity.Core.Metadata.Edm.RelationshipEndMember toRole, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmProperty> fromProperties, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmProperty> toProperties) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.EdmProperty> FromProperties { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.RelationshipEndMember FromRole { get => throw null; set { } }
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.EdmProperty> ToProperties { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.RelationshipEndMember ToRole { get => throw null; set { } }
                            public override string ToString() => throw null;
                        }
                        public class RefType : System.Data.Entity.Core.Metadata.Edm.EdmType
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public virtual System.Data.Entity.Core.Metadata.Edm.EntityTypeBase ElementType { get => throw null; }
                            public override bool Equals(object obj) => throw null;
                            public override int GetHashCode() => throw null;
                        }
                        public abstract class RelationshipEndMember : System.Data.Entity.Core.Metadata.Edm.EdmMember
                        {
                            public System.Data.Entity.Core.Metadata.Edm.OperationAction DeleteBehavior { get => throw null; set { } }
                            public System.Data.Entity.Core.Metadata.Edm.EntityType GetEntityType() => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.RelationshipMultiplicity RelationshipMultiplicity { get => throw null; set { } }
                        }
                        public enum RelationshipMultiplicity
                        {
                            ZeroOrOne = 0,
                            One = 1,
                            Many = 2,
                        }
                        public abstract class RelationshipSet : System.Data.Entity.Core.Metadata.Edm.EntitySetBase
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.RelationshipType ElementType { get => throw null; }
                        }
                        public abstract class RelationshipType : System.Data.Entity.Core.Metadata.Edm.EntityTypeBase
                        {
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.RelationshipEndMember> RelationshipEndMembers { get => throw null; }
                        }
                        public class RowType : System.Data.Entity.Core.Metadata.Edm.StructuralType
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public static System.Data.Entity.Core.Metadata.Edm.RowType Create(System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmProperty> properties, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.MetadataProperty> metadataProperties) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.EdmProperty> DeclaredProperties { get => throw null; }
                            public virtual System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.EdmProperty> Properties { get => throw null; }
                        }
                        public abstract class SimpleType : System.Data.Entity.Core.Metadata.Edm.EdmType
                        {
                        }
                        public class SsdlSerializer
                        {
                            public SsdlSerializer() => throw null;
                            public event System.EventHandler<System.Data.Entity.Core.Metadata.Edm.DataModelErrorEventArgs> OnError;
                            public virtual bool Serialize(System.Data.Entity.Core.Metadata.Edm.EdmModel dbDatabase, string provider, string providerManifestToken, System.Xml.XmlWriter xmlWriter, bool serializeDefaultNullability = default(bool)) => throw null;
                            public virtual bool Serialize(System.Data.Entity.Core.Metadata.Edm.EdmModel dbDatabase, string namespaceName, string provider, string providerManifestToken, System.Xml.XmlWriter xmlWriter, bool serializeDefaultNullability = default(bool)) => throw null;
                        }
                        public enum StoreGeneratedPattern
                        {
                            None = 0,
                            Identity = 1,
                            Computed = 2,
                        }
                        public class StoreItemCollection : System.Data.Entity.Core.Metadata.Edm.ItemCollection
                        {
                            public static System.Data.Entity.Core.Metadata.Edm.StoreItemCollection Create(System.Collections.Generic.IEnumerable<System.Xml.XmlReader> xmlReaders, System.Collections.ObjectModel.ReadOnlyCollection<string> filePaths, System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver resolver, out System.Collections.Generic.IList<System.Data.Entity.Core.Metadata.Edm.EdmSchemaError> errors) => throw null;
                            public StoreItemCollection(System.Collections.Generic.IEnumerable<System.Xml.XmlReader> xmlReaders) => throw null;
                            public StoreItemCollection(System.Data.Entity.Core.Metadata.Edm.EdmModel model) => throw null;
                            public StoreItemCollection(params string[] filePaths) => throw null;
                            public virtual System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Metadata.Edm.PrimitiveType> GetPrimitiveTypes() => throw null;
                            public virtual System.Data.Common.DbProviderFactory ProviderFactory { get => throw null; }
                            public virtual string ProviderInvariantName { get => throw null; }
                            public virtual System.Data.Entity.Core.Common.DbProviderManifest ProviderManifest { get => throw null; }
                            public virtual string ProviderManifestToken { get => throw null; }
                            public double StoreSchemaVersion { get => throw null; }
                        }
                        public abstract class StructuralType : System.Data.Entity.Core.Metadata.Edm.EdmType
                        {
                            public void AddMember(System.Data.Entity.Core.Metadata.Edm.EdmMember member) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.EdmMember> Members { get => throw null; }
                            public virtual void RemoveMember(System.Data.Entity.Core.Metadata.Edm.EdmMember member) => throw null;
                        }
                        public class TypeUsage : System.Data.Entity.Core.Metadata.Edm.MetadataItem
                        {
                            public override System.Data.Entity.Core.Metadata.Edm.BuiltInTypeKind BuiltInTypeKind { get => throw null; }
                            public static System.Data.Entity.Core.Metadata.Edm.TypeUsage Create(System.Data.Entity.Core.Metadata.Edm.EdmType edmType, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.Facet> facets) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.TypeUsage CreateBinaryTypeUsage(System.Data.Entity.Core.Metadata.Edm.PrimitiveType primitiveType, bool isFixedLength, int maxLength) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.TypeUsage CreateBinaryTypeUsage(System.Data.Entity.Core.Metadata.Edm.PrimitiveType primitiveType, bool isFixedLength) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.TypeUsage CreateDateTimeOffsetTypeUsage(System.Data.Entity.Core.Metadata.Edm.PrimitiveType primitiveType, byte? precision) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.TypeUsage CreateDateTimeTypeUsage(System.Data.Entity.Core.Metadata.Edm.PrimitiveType primitiveType, byte? precision) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.TypeUsage CreateDecimalTypeUsage(System.Data.Entity.Core.Metadata.Edm.PrimitiveType primitiveType, byte precision, byte scale) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.TypeUsage CreateDecimalTypeUsage(System.Data.Entity.Core.Metadata.Edm.PrimitiveType primitiveType) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.TypeUsage CreateDefaultTypeUsage(System.Data.Entity.Core.Metadata.Edm.EdmType edmType) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.TypeUsage CreateStringTypeUsage(System.Data.Entity.Core.Metadata.Edm.PrimitiveType primitiveType, bool isUnicode, bool isFixedLength, int maxLength) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.TypeUsage CreateStringTypeUsage(System.Data.Entity.Core.Metadata.Edm.PrimitiveType primitiveType, bool isUnicode, bool isFixedLength) => throw null;
                            public static System.Data.Entity.Core.Metadata.Edm.TypeUsage CreateTimeTypeUsage(System.Data.Entity.Core.Metadata.Edm.PrimitiveType primitiveType, byte? precision) => throw null;
                            public virtual System.Data.Entity.Core.Metadata.Edm.EdmType EdmType { get => throw null; }
                            public virtual System.Data.Entity.Core.Metadata.Edm.ReadOnlyMetadataCollection<System.Data.Entity.Core.Metadata.Edm.Facet> Facets { get => throw null; }
                            public bool IsSubtypeOf(System.Data.Entity.Core.Metadata.Edm.TypeUsage typeUsage) => throw null;
                            public System.Data.Entity.Core.Metadata.Edm.TypeUsage ModelTypeUsage { get => throw null; }
                            public override string ToString() => throw null;
                        }
                    }
                }
                public sealed class MetadataException : System.Data.Entity.Core.EntityException
                {
                    public MetadataException() => throw null;
                    public MetadataException(string message) => throw null;
                    public MetadataException(string message, System.Exception innerException) => throw null;
                }
                public sealed class ObjectNotFoundException : System.Data.DataException
                {
                    public ObjectNotFoundException() => throw null;
                    public ObjectNotFoundException(string message) => throw null;
                    public ObjectNotFoundException(string message, System.Exception innerException) => throw null;
                }
                namespace Objects
                {
                    public sealed class CompiledQuery
                    {
                        public static System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TArg11, TArg12, TArg13, TArg14, TArg15, TResult> Compile<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TArg11, TArg12, TArg13, TArg14, TArg15, TResult>(System.Linq.Expressions.Expression<System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TArg11, TArg12, TArg13, TArg14, TArg15, TResult>> query) where TArg0 : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                        public static System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TArg11, TArg12, TArg13, TArg14, TResult> Compile<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TArg11, TArg12, TArg13, TArg14, TResult>(System.Linq.Expressions.Expression<System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TArg11, TArg12, TArg13, TArg14, TResult>> query) where TArg0 : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                        public static System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TArg11, TArg12, TArg13, TResult> Compile<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TArg11, TArg12, TArg13, TResult>(System.Linq.Expressions.Expression<System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TArg11, TArg12, TArg13, TResult>> query) where TArg0 : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                        public static System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TArg11, TArg12, TResult> Compile<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TArg11, TArg12, TResult>(System.Linq.Expressions.Expression<System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TArg11, TArg12, TResult>> query) where TArg0 : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                        public static System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TArg11, TResult> Compile<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TArg11, TResult>(System.Linq.Expressions.Expression<System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TArg11, TResult>> query) where TArg0 : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                        public static System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TResult> Compile<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TResult>(System.Linq.Expressions.Expression<System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TArg10, TResult>> query) where TArg0 : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                        public static System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TResult> Compile<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TResult>(System.Linq.Expressions.Expression<System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TArg9, TResult>> query) where TArg0 : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                        public static System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TResult> Compile<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TResult>(System.Linq.Expressions.Expression<System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TArg8, TResult>> query) where TArg0 : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                        public static System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TResult> Compile<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TResult>(System.Linq.Expressions.Expression<System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TArg7, TResult>> query) where TArg0 : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                        public static System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TResult> Compile<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TResult>(System.Linq.Expressions.Expression<System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TArg6, TResult>> query) where TArg0 : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                        public static System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TResult> Compile<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TResult>(System.Linq.Expressions.Expression<System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TArg5, TResult>> query) where TArg0 : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                        public static System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TResult> Compile<TArg0, TArg1, TArg2, TArg3, TArg4, TResult>(System.Linq.Expressions.Expression<System.Func<TArg0, TArg1, TArg2, TArg3, TArg4, TResult>> query) where TArg0 : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                        public static System.Func<TArg0, TArg1, TArg2, TArg3, TResult> Compile<TArg0, TArg1, TArg2, TArg3, TResult>(System.Linq.Expressions.Expression<System.Func<TArg0, TArg1, TArg2, TArg3, TResult>> query) where TArg0 : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                        public static System.Func<TArg0, TArg1, TArg2, TResult> Compile<TArg0, TArg1, TArg2, TResult>(System.Linq.Expressions.Expression<System.Func<TArg0, TArg1, TArg2, TResult>> query) where TArg0 : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                        public static System.Func<TArg0, TArg1, TResult> Compile<TArg0, TArg1, TResult>(System.Linq.Expressions.Expression<System.Func<TArg0, TArg1, TResult>> query) where TArg0 : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                        public static System.Func<TArg0, TResult> Compile<TArg0, TResult>(System.Linq.Expressions.Expression<System.Func<TArg0, TResult>> query) where TArg0 : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                    }
                    public abstract class CurrentValueRecord : System.Data.Entity.Core.Objects.DbUpdatableDataRecord
                    {
                    }
                    namespace DataClasses
                    {
                        public abstract class ComplexObject : System.Data.Entity.Core.Objects.DataClasses.StructuralObject
                        {
                            protected ComplexObject() => throw null;
                            protected override sealed void ReportPropertyChanged(string property) => throw null;
                            protected override sealed void ReportPropertyChanging(string property) => throw null;
                        }
                        [System.AttributeUsage((System.AttributeTargets)128)]
                        public sealed class EdmComplexPropertyAttribute : System.Data.Entity.Core.Objects.DataClasses.EdmPropertyAttribute
                        {
                            public EdmComplexPropertyAttribute() => throw null;
                        }
                        [System.AttributeUsage((System.AttributeTargets)4)]
                        public sealed class EdmComplexTypeAttribute : System.Data.Entity.Core.Objects.DataClasses.EdmTypeAttribute
                        {
                            public EdmComplexTypeAttribute() => throw null;
                        }
                        [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false)]
                        public sealed class EdmEntityTypeAttribute : System.Data.Entity.Core.Objects.DataClasses.EdmTypeAttribute
                        {
                            public EdmEntityTypeAttribute() => throw null;
                        }
                        [System.AttributeUsage((System.AttributeTargets)16)]
                        public sealed class EdmEnumTypeAttribute : System.Data.Entity.Core.Objects.DataClasses.EdmTypeAttribute
                        {
                            public EdmEnumTypeAttribute() => throw null;
                        }
                        [System.AttributeUsage((System.AttributeTargets)64, Inherited = false, AllowMultiple = false)]
                        public sealed class EdmFunctionAttribute : System.Data.Entity.DbFunctionAttribute
                        {
                            public EdmFunctionAttribute(string namespaceName, string functionName) : base(default(string), default(string)) => throw null;
                        }
                        [System.AttributeUsage((System.AttributeTargets)128)]
                        public abstract class EdmPropertyAttribute : System.Attribute
                        {
                        }
                        [System.AttributeUsage((System.AttributeTargets)1, AllowMultiple = true)]
                        public sealed class EdmRelationshipAttribute : System.Attribute
                        {
                            public EdmRelationshipAttribute(string relationshipNamespaceName, string relationshipName, string role1Name, System.Data.Entity.Core.Metadata.Edm.RelationshipMultiplicity role1Multiplicity, System.Type role1Type, string role2Name, System.Data.Entity.Core.Metadata.Edm.RelationshipMultiplicity role2Multiplicity, System.Type role2Type) => throw null;
                            public EdmRelationshipAttribute(string relationshipNamespaceName, string relationshipName, string role1Name, System.Data.Entity.Core.Metadata.Edm.RelationshipMultiplicity role1Multiplicity, System.Type role1Type, string role2Name, System.Data.Entity.Core.Metadata.Edm.RelationshipMultiplicity role2Multiplicity, System.Type role2Type, bool isForeignKey) => throw null;
                            public bool IsForeignKey { get => throw null; }
                            public string RelationshipName { get => throw null; }
                            public string RelationshipNamespaceName { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.RelationshipMultiplicity Role1Multiplicity { get => throw null; }
                            public string Role1Name { get => throw null; }
                            public System.Type Role1Type { get => throw null; }
                            public System.Data.Entity.Core.Metadata.Edm.RelationshipMultiplicity Role2Multiplicity { get => throw null; }
                            public string Role2Name { get => throw null; }
                            public System.Type Role2Type { get => throw null; }
                        }
                        [System.AttributeUsage((System.AttributeTargets)128)]
                        public sealed class EdmRelationshipNavigationPropertyAttribute : System.Data.Entity.Core.Objects.DataClasses.EdmPropertyAttribute
                        {
                            public EdmRelationshipNavigationPropertyAttribute(string relationshipNamespaceName, string relationshipName, string targetRoleName) => throw null;
                            public string RelationshipName { get => throw null; }
                            public string RelationshipNamespaceName { get => throw null; }
                            public string TargetRoleName { get => throw null; }
                        }
                        [System.AttributeUsage((System.AttributeTargets)128)]
                        public sealed class EdmScalarPropertyAttribute : System.Data.Entity.Core.Objects.DataClasses.EdmPropertyAttribute
                        {
                            public EdmScalarPropertyAttribute() => throw null;
                            public bool EntityKeyProperty { get => throw null; set { } }
                            public bool IsNullable { get => throw null; set { } }
                        }
                        [System.AttributeUsage((System.AttributeTargets)5, AllowMultiple = true)]
                        public sealed class EdmSchemaAttribute : System.Attribute
                        {
                            public EdmSchemaAttribute() => throw null;
                            public EdmSchemaAttribute(string assemblyGuid) => throw null;
                        }
                        public abstract class EdmTypeAttribute : System.Attribute
                        {
                            public string Name { get => throw null; set { } }
                            public string NamespaceName { get => throw null; set { } }
                        }
                        public class EntityCollection<TEntity> : System.Data.Entity.Core.Objects.DataClasses.RelatedEnd, System.Collections.Generic.ICollection<TEntity>, System.Collections.Generic.IEnumerable<TEntity>, System.Collections.IEnumerable, System.ComponentModel.IListSource where TEntity : class
                        {
                            public void Add(TEntity item) => throw null;
                            public void Attach(System.Collections.Generic.IEnumerable<TEntity> entities) => throw null;
                            public void Attach(TEntity entity) => throw null;
                            public void Clear() => throw null;
                            public bool Contains(TEntity item) => throw null;
                            bool System.ComponentModel.IListSource.ContainsListCollection { get => throw null; }
                            public void CopyTo(TEntity[] array, int arrayIndex) => throw null;
                            public int Count { get => throw null; }
                            public System.Data.Entity.Core.Objects.ObjectQuery<TEntity> CreateSourceQuery() => throw null;
                            public EntityCollection() => throw null;
                            public System.Collections.Generic.IEnumerator<TEntity> GetEnumerator() => throw null;
                            System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                            System.Collections.IList System.ComponentModel.IListSource.GetList() => throw null;
                            public bool IsReadOnly { get => throw null; }
                            public override void Load(System.Data.Entity.Core.Objects.MergeOption mergeOption) => throw null;
                            public override System.Threading.Tasks.Task LoadAsync(System.Data.Entity.Core.Objects.MergeOption mergeOption, System.Threading.CancellationToken cancellationToken) => throw null;
                            public void OnCollectionDeserialized(System.Runtime.Serialization.StreamingContext context) => throw null;
                            public void OnSerializing(System.Runtime.Serialization.StreamingContext context) => throw null;
                            public bool Remove(TEntity item) => throw null;
                        }
                        public abstract class EntityObject : System.Data.Entity.Core.Objects.DataClasses.StructuralObject, System.Data.Entity.Core.Objects.DataClasses.IEntityWithChangeTracker, System.Data.Entity.Core.Objects.DataClasses.IEntityWithKey, System.Data.Entity.Core.Objects.DataClasses.IEntityWithRelationships
                        {
                            protected EntityObject() => throw null;
                            public System.Data.Entity.Core.EntityKey EntityKey { get => throw null; set { } }
                            public System.Data.Entity.EntityState EntityState { get => throw null; }
                            System.Data.Entity.Core.Objects.DataClasses.RelationshipManager System.Data.Entity.Core.Objects.DataClasses.IEntityWithRelationships.RelationshipManager { get => throw null; }
                            protected override sealed void ReportPropertyChanged(string property) => throw null;
                            protected override sealed void ReportPropertyChanging(string property) => throw null;
                            void System.Data.Entity.Core.Objects.DataClasses.IEntityWithChangeTracker.SetChangeTracker(System.Data.Entity.Core.Objects.DataClasses.IEntityChangeTracker changeTracker) => throw null;
                        }
                        public abstract class EntityReference : System.Data.Entity.Core.Objects.DataClasses.RelatedEnd
                        {
                            public System.Data.Entity.Core.EntityKey EntityKey { get => throw null; set { } }
                        }
                        public class EntityReference<TEntity> : System.Data.Entity.Core.Objects.DataClasses.EntityReference where TEntity : class
                        {
                            public void Attach(TEntity entity) => throw null;
                            public System.Data.Entity.Core.Objects.ObjectQuery<TEntity> CreateSourceQuery() => throw null;
                            public EntityReference() => throw null;
                            public override void Load(System.Data.Entity.Core.Objects.MergeOption mergeOption) => throw null;
                            public override System.Threading.Tasks.Task LoadAsync(System.Data.Entity.Core.Objects.MergeOption mergeOption, System.Threading.CancellationToken cancellationToken) => throw null;
                            public void OnRefDeserialized(System.Runtime.Serialization.StreamingContext context) => throw null;
                            public void OnSerializing(System.Runtime.Serialization.StreamingContext context) => throw null;
                            public TEntity Value { get => throw null; set { } }
                        }
                        public interface IEntityChangeTracker
                        {
                            void EntityComplexMemberChanged(string entityMemberName, object complexObject, string complexObjectMemberName);
                            void EntityComplexMemberChanging(string entityMemberName, object complexObject, string complexObjectMemberName);
                            void EntityMemberChanged(string entityMemberName);
                            void EntityMemberChanging(string entityMemberName);
                            System.Data.Entity.EntityState EntityState { get; }
                        }
                        public interface IEntityWithChangeTracker
                        {
                            void SetChangeTracker(System.Data.Entity.Core.Objects.DataClasses.IEntityChangeTracker changeTracker);
                        }
                        public interface IEntityWithKey
                        {
                            System.Data.Entity.Core.EntityKey EntityKey { get; set; }
                        }
                        public interface IEntityWithRelationships
                        {
                            System.Data.Entity.Core.Objects.DataClasses.RelationshipManager RelationshipManager { get; }
                        }
                        public interface IRelatedEnd
                        {
                            void Add(System.Data.Entity.Core.Objects.DataClasses.IEntityWithRelationships entity);
                            void Add(object entity);
                            void Attach(System.Data.Entity.Core.Objects.DataClasses.IEntityWithRelationships entity);
                            void Attach(object entity);
                            System.Collections.IEnumerable CreateSourceQuery();
                            System.Collections.IEnumerator GetEnumerator();
                            bool IsLoaded { get; set; }
                            void Load();
                            void Load(System.Data.Entity.Core.Objects.MergeOption mergeOption);
                            System.Threading.Tasks.Task LoadAsync(System.Threading.CancellationToken cancellationToken);
                            System.Threading.Tasks.Task LoadAsync(System.Data.Entity.Core.Objects.MergeOption mergeOption, System.Threading.CancellationToken cancellationToken);
                            string RelationshipName { get; }
                            System.Data.Entity.Core.Metadata.Edm.RelationshipSet RelationshipSet { get; }
                            bool Remove(System.Data.Entity.Core.Objects.DataClasses.IEntityWithRelationships entity);
                            bool Remove(object entity);
                            string SourceRoleName { get; }
                            string TargetRoleName { get; }
                        }
                        public abstract class RelatedEnd : System.Data.Entity.Core.Objects.DataClasses.IRelatedEnd
                        {
                            void System.Data.Entity.Core.Objects.DataClasses.IRelatedEnd.Add(System.Data.Entity.Core.Objects.DataClasses.IEntityWithRelationships entity) => throw null;
                            void System.Data.Entity.Core.Objects.DataClasses.IRelatedEnd.Add(object entity) => throw null;
                            public event System.ComponentModel.CollectionChangeEventHandler AssociationChanged;
                            void System.Data.Entity.Core.Objects.DataClasses.IRelatedEnd.Attach(System.Data.Entity.Core.Objects.DataClasses.IEntityWithRelationships entity) => throw null;
                            void System.Data.Entity.Core.Objects.DataClasses.IRelatedEnd.Attach(object entity) => throw null;
                            System.Collections.IEnumerable System.Data.Entity.Core.Objects.DataClasses.IRelatedEnd.CreateSourceQuery() => throw null;
                            public System.Collections.IEnumerator GetEnumerator() => throw null;
                            public bool IsLoaded { get => throw null; set { } }
                            public void Load() => throw null;
                            public abstract void Load(System.Data.Entity.Core.Objects.MergeOption mergeOption);
                            public System.Threading.Tasks.Task LoadAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                            public abstract System.Threading.Tasks.Task LoadAsync(System.Data.Entity.Core.Objects.MergeOption mergeOption, System.Threading.CancellationToken cancellationToken);
                            public void OnDeserialized(System.Runtime.Serialization.StreamingContext context) => throw null;
                            public string RelationshipName { get => throw null; }
                            public virtual System.Data.Entity.Core.Metadata.Edm.RelationshipSet RelationshipSet { get => throw null; }
                            bool System.Data.Entity.Core.Objects.DataClasses.IRelatedEnd.Remove(System.Data.Entity.Core.Objects.DataClasses.IEntityWithRelationships entity) => throw null;
                            bool System.Data.Entity.Core.Objects.DataClasses.IRelatedEnd.Remove(object entity) => throw null;
                            public virtual string SourceRoleName { get => throw null; }
                            public virtual string TargetRoleName { get => throw null; }
                        }
                        public enum RelationshipKind
                        {
                            Association = 0,
                        }
                        public class RelationshipManager
                        {
                            public static System.Data.Entity.Core.Objects.DataClasses.RelationshipManager Create(System.Data.Entity.Core.Objects.DataClasses.IEntityWithRelationships owner) => throw null;
                            public System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Objects.DataClasses.IRelatedEnd> GetAllRelatedEnds() => throw null;
                            public System.Data.Entity.Core.Objects.DataClasses.EntityCollection<TTargetEntity> GetRelatedCollection<TTargetEntity>(string relationshipName, string targetRoleName) where TTargetEntity : class => throw null;
                            public System.Data.Entity.Core.Objects.DataClasses.IRelatedEnd GetRelatedEnd(string relationshipName, string targetRoleName) => throw null;
                            public System.Data.Entity.Core.Objects.DataClasses.EntityReference<TTargetEntity> GetRelatedReference<TTargetEntity>(string relationshipName, string targetRoleName) where TTargetEntity : class => throw null;
                            public void InitializeRelatedCollection<TTargetEntity>(string relationshipName, string targetRoleName, System.Data.Entity.Core.Objects.DataClasses.EntityCollection<TTargetEntity> entityCollection) where TTargetEntity : class => throw null;
                            public void InitializeRelatedReference<TTargetEntity>(string relationshipName, string targetRoleName, System.Data.Entity.Core.Objects.DataClasses.EntityReference<TTargetEntity> entityReference) where TTargetEntity : class => throw null;
                            public void OnDeserialized(System.Runtime.Serialization.StreamingContext context) => throw null;
                            public void OnSerializing(System.Runtime.Serialization.StreamingContext context) => throw null;
                        }
                        public abstract class StructuralObject : System.ComponentModel.INotifyPropertyChanged, System.ComponentModel.INotifyPropertyChanging
                        {
                            protected static bool BinaryEquals(byte[] first, byte[] second) => throw null;
                            protected StructuralObject() => throw null;
                            protected static System.DateTime DefaultDateTimeValue() => throw null;
                            public const string EntityKeyPropertyName = default;
                            protected T GetValidValue<T>(T currentValue, string property, bool isNullable, bool isInitialized) where T : System.Data.Entity.Core.Objects.DataClasses.ComplexObject, new() => throw null;
                            protected static byte[] GetValidValue(byte[] currentValue) => throw null;
                            protected virtual void OnPropertyChanged(string property) => throw null;
                            protected virtual void OnPropertyChanging(string property) => throw null;
                            public event System.ComponentModel.PropertyChangedEventHandler PropertyChanged;
                            public event System.ComponentModel.PropertyChangingEventHandler PropertyChanging;
                            protected virtual void ReportPropertyChanged(string property) => throw null;
                            protected virtual void ReportPropertyChanging(string property) => throw null;
                            protected static byte[] SetValidValue(byte[] value, bool isNullable, string propertyName) => throw null;
                            protected static byte[] SetValidValue(byte[] value, bool isNullable) => throw null;
                            protected static bool SetValidValue(bool value, string propertyName) => throw null;
                            protected static bool SetValidValue(bool value) => throw null;
                            protected static bool? SetValidValue(bool? value, string propertyName) => throw null;
                            protected static bool? SetValidValue(bool? value) => throw null;
                            protected static byte SetValidValue(byte value, string propertyName) => throw null;
                            protected static byte SetValidValue(byte value) => throw null;
                            protected static byte? SetValidValue(byte? value, string propertyName) => throw null;
                            protected static byte? SetValidValue(byte? value) => throw null;
                            protected static sbyte SetValidValue(sbyte value, string propertyName) => throw null;
                            protected static sbyte SetValidValue(sbyte value) => throw null;
                            protected static sbyte? SetValidValue(sbyte? value, string propertyName) => throw null;
                            protected static sbyte? SetValidValue(sbyte? value) => throw null;
                            protected static System.DateTime SetValidValue(System.DateTime value, string propertyName) => throw null;
                            protected static System.DateTime SetValidValue(System.DateTime value) => throw null;
                            protected static System.DateTime? SetValidValue(System.DateTime? value, string propertyName) => throw null;
                            protected static System.DateTime? SetValidValue(System.DateTime? value) => throw null;
                            protected static System.TimeSpan SetValidValue(System.TimeSpan value, string propertyName) => throw null;
                            protected static System.TimeSpan SetValidValue(System.TimeSpan value) => throw null;
                            protected static System.TimeSpan? SetValidValue(System.TimeSpan? value, string propertyName) => throw null;
                            protected static System.TimeSpan? SetValidValue(System.TimeSpan? value) => throw null;
                            protected static System.DateTimeOffset SetValidValue(System.DateTimeOffset value, string propertyName) => throw null;
                            protected static System.DateTimeOffset SetValidValue(System.DateTimeOffset value) => throw null;
                            protected static System.DateTimeOffset? SetValidValue(System.DateTimeOffset? value, string propertyName) => throw null;
                            protected static System.DateTimeOffset? SetValidValue(System.DateTimeOffset? value) => throw null;
                            protected static decimal SetValidValue(decimal value, string propertyName) => throw null;
                            protected static decimal SetValidValue(decimal value) => throw null;
                            protected static decimal? SetValidValue(decimal? value, string propertyName) => throw null;
                            protected static decimal? SetValidValue(decimal? value) => throw null;
                            protected static double SetValidValue(double value, string propertyName) => throw null;
                            protected static double SetValidValue(double value) => throw null;
                            protected static double? SetValidValue(double? value, string propertyName) => throw null;
                            protected static double? SetValidValue(double? value) => throw null;
                            protected static float SetValidValue(float value, string propertyName) => throw null;
                            protected static float SetValidValue(float value) => throw null;
                            protected static float? SetValidValue(float? value, string propertyName) => throw null;
                            protected static float? SetValidValue(float? value) => throw null;
                            protected static System.Guid SetValidValue(System.Guid value, string propertyName) => throw null;
                            protected static System.Guid SetValidValue(System.Guid value) => throw null;
                            protected static System.Guid? SetValidValue(System.Guid? value, string propertyName) => throw null;
                            protected static System.Guid? SetValidValue(System.Guid? value) => throw null;
                            protected static short SetValidValue(short value, string propertyName) => throw null;
                            protected static short SetValidValue(short value) => throw null;
                            protected static short? SetValidValue(short? value, string propertyName) => throw null;
                            protected static short? SetValidValue(short? value) => throw null;
                            protected static int SetValidValue(int value, string propertyName) => throw null;
                            protected static int SetValidValue(int value) => throw null;
                            protected static int? SetValidValue(int? value, string propertyName) => throw null;
                            protected static int? SetValidValue(int? value) => throw null;
                            protected static long SetValidValue(long value, string propertyName) => throw null;
                            protected static long SetValidValue(long value) => throw null;
                            protected static long? SetValidValue(long? value, string propertyName) => throw null;
                            protected static long? SetValidValue(long? value) => throw null;
                            protected static ushort SetValidValue(ushort value, string propertyName) => throw null;
                            protected static ushort SetValidValue(ushort value) => throw null;
                            protected static ushort? SetValidValue(ushort? value, string propertyName) => throw null;
                            protected static ushort? SetValidValue(ushort? value) => throw null;
                            protected static uint SetValidValue(uint value, string propertyName) => throw null;
                            protected static uint SetValidValue(uint value) => throw null;
                            protected static uint? SetValidValue(uint? value, string propertyName) => throw null;
                            protected static uint? SetValidValue(uint? value) => throw null;
                            protected static ulong SetValidValue(ulong value, string propertyName) => throw null;
                            protected static ulong SetValidValue(ulong value) => throw null;
                            protected static ulong? SetValidValue(ulong? value, string propertyName) => throw null;
                            protected static ulong? SetValidValue(ulong? value) => throw null;
                            protected static string SetValidValue(string value, bool isNullable, string propertyName) => throw null;
                            protected static string SetValidValue(string value, bool isNullable) => throw null;
                            protected static System.Data.Entity.Spatial.DbGeography SetValidValue(System.Data.Entity.Spatial.DbGeography value, bool isNullable, string propertyName) => throw null;
                            protected static System.Data.Entity.Spatial.DbGeography SetValidValue(System.Data.Entity.Spatial.DbGeography value, bool isNullable) => throw null;
                            protected static System.Data.Entity.Spatial.DbGeometry SetValidValue(System.Data.Entity.Spatial.DbGeometry value, bool isNullable, string propertyName) => throw null;
                            protected static System.Data.Entity.Spatial.DbGeometry SetValidValue(System.Data.Entity.Spatial.DbGeometry value, bool isNullable) => throw null;
                            protected T SetValidValue<T>(T oldValue, T newValue, string property) where T : System.Data.Entity.Core.Objects.DataClasses.ComplexObject => throw null;
                            protected static TComplex VerifyComplexObjectIsNotNull<TComplex>(TComplex complexObject, string propertyName) where TComplex : System.Data.Entity.Core.Objects.DataClasses.ComplexObject => throw null;
                        }
                    }
                    public abstract class DbUpdatableDataRecord : System.Data.Common.DbDataRecord, System.Data.IDataRecord, System.Data.Entity.Core.IExtendedDataRecord
                    {
                        public virtual System.Data.Entity.Core.Common.DataRecordInfo DataRecordInfo { get => throw null; }
                        public override int FieldCount { get => throw null; }
                        public override bool GetBoolean(int i) => throw null;
                        public override byte GetByte(int i) => throw null;
                        public override long GetBytes(int i, long dataIndex, byte[] buffer, int bufferIndex, int length) => throw null;
                        public override char GetChar(int i) => throw null;
                        public override long GetChars(int i, long dataIndex, char[] buffer, int bufferIndex, int length) => throw null;
                        System.Data.IDataReader System.Data.IDataRecord.GetData(int ordinal) => throw null;
                        public System.Data.Common.DbDataReader GetDataReader(int i) => throw null;
                        public System.Data.Common.DbDataRecord GetDataRecord(int i) => throw null;
                        public override string GetDataTypeName(int i) => throw null;
                        public override System.DateTime GetDateTime(int i) => throw null;
                        protected override System.Data.Common.DbDataReader GetDbDataReader(int i) => throw null;
                        public override decimal GetDecimal(int i) => throw null;
                        public override double GetDouble(int i) => throw null;
                        public override System.Type GetFieldType(int i) => throw null;
                        public override float GetFloat(int i) => throw null;
                        public override System.Guid GetGuid(int i) => throw null;
                        public override short GetInt16(int i) => throw null;
                        public override int GetInt32(int i) => throw null;
                        public override long GetInt64(int i) => throw null;
                        public override string GetName(int i) => throw null;
                        public override int GetOrdinal(string name) => throw null;
                        protected abstract object GetRecordValue(int ordinal);
                        public override string GetString(int i) => throw null;
                        public override object GetValue(int i) => throw null;
                        public override int GetValues(object[] values) => throw null;
                        public override bool IsDBNull(int i) => throw null;
                        public void SetBoolean(int ordinal, bool value) => throw null;
                        public void SetByte(int ordinal, byte value) => throw null;
                        public void SetChar(int ordinal, char value) => throw null;
                        public void SetDataRecord(int ordinal, System.Data.IDataRecord value) => throw null;
                        public void SetDateTime(int ordinal, System.DateTime value) => throw null;
                        public void SetDBNull(int ordinal) => throw null;
                        public void SetDecimal(int ordinal, decimal value) => throw null;
                        public void SetDouble(int ordinal, double value) => throw null;
                        public void SetFloat(int ordinal, float value) => throw null;
                        public void SetGuid(int ordinal, System.Guid value) => throw null;
                        public void SetInt16(int ordinal, short value) => throw null;
                        public void SetInt32(int ordinal, int value) => throw null;
                        public void SetInt64(int ordinal, long value) => throw null;
                        protected abstract void SetRecordValue(int ordinal, object value);
                        public void SetString(int ordinal, string value) => throw null;
                        public void SetValue(int ordinal, object value) => throw null;
                        public int SetValues(params object[] values) => throw null;
                        public override object this[int i] { get => throw null; }
                        public override object this[string name] { get => throw null; }
                    }
                    public static class EntityFunctions
                    {
                        public static System.DateTimeOffset? AddDays(System.DateTimeOffset? dateValue, int? addValue) => throw null;
                        public static System.DateTime? AddDays(System.DateTime? dateValue, int? addValue) => throw null;
                        public static System.DateTimeOffset? AddHours(System.DateTimeOffset? timeValue, int? addValue) => throw null;
                        public static System.DateTime? AddHours(System.DateTime? timeValue, int? addValue) => throw null;
                        public static System.TimeSpan? AddHours(System.TimeSpan? timeValue, int? addValue) => throw null;
                        public static System.DateTimeOffset? AddMicroseconds(System.DateTimeOffset? timeValue, int? addValue) => throw null;
                        public static System.DateTime? AddMicroseconds(System.DateTime? timeValue, int? addValue) => throw null;
                        public static System.TimeSpan? AddMicroseconds(System.TimeSpan? timeValue, int? addValue) => throw null;
                        public static System.DateTimeOffset? AddMilliseconds(System.DateTimeOffset? timeValue, int? addValue) => throw null;
                        public static System.DateTime? AddMilliseconds(System.DateTime? timeValue, int? addValue) => throw null;
                        public static System.TimeSpan? AddMilliseconds(System.TimeSpan? timeValue, int? addValue) => throw null;
                        public static System.DateTimeOffset? AddMinutes(System.DateTimeOffset? timeValue, int? addValue) => throw null;
                        public static System.DateTime? AddMinutes(System.DateTime? timeValue, int? addValue) => throw null;
                        public static System.TimeSpan? AddMinutes(System.TimeSpan? timeValue, int? addValue) => throw null;
                        public static System.DateTimeOffset? AddMonths(System.DateTimeOffset? dateValue, int? addValue) => throw null;
                        public static System.DateTime? AddMonths(System.DateTime? dateValue, int? addValue) => throw null;
                        public static System.DateTimeOffset? AddNanoseconds(System.DateTimeOffset? timeValue, int? addValue) => throw null;
                        public static System.DateTime? AddNanoseconds(System.DateTime? timeValue, int? addValue) => throw null;
                        public static System.TimeSpan? AddNanoseconds(System.TimeSpan? timeValue, int? addValue) => throw null;
                        public static System.DateTimeOffset? AddSeconds(System.DateTimeOffset? timeValue, int? addValue) => throw null;
                        public static System.DateTime? AddSeconds(System.DateTime? timeValue, int? addValue) => throw null;
                        public static System.TimeSpan? AddSeconds(System.TimeSpan? timeValue, int? addValue) => throw null;
                        public static System.DateTimeOffset? AddYears(System.DateTimeOffset? dateValue, int? addValue) => throw null;
                        public static System.DateTime? AddYears(System.DateTime? dateValue, int? addValue) => throw null;
                        public static string AsNonUnicode(string value) => throw null;
                        public static string AsUnicode(string value) => throw null;
                        public static System.DateTime? CreateDateTime(int? year, int? month, int? day, int? hour, int? minute, double? second) => throw null;
                        public static System.DateTimeOffset? CreateDateTimeOffset(int? year, int? month, int? day, int? hour, int? minute, double? second, int? timeZoneOffset) => throw null;
                        public static System.TimeSpan? CreateTime(int? hour, int? minute, double? second) => throw null;
                        public static int? DiffDays(System.DateTimeOffset? dateValue1, System.DateTimeOffset? dateValue2) => throw null;
                        public static int? DiffDays(System.DateTime? dateValue1, System.DateTime? dateValue2) => throw null;
                        public static int? DiffHours(System.DateTimeOffset? timeValue1, System.DateTimeOffset? timeValue2) => throw null;
                        public static int? DiffHours(System.DateTime? timeValue1, System.DateTime? timeValue2) => throw null;
                        public static int? DiffHours(System.TimeSpan? timeValue1, System.TimeSpan? timeValue2) => throw null;
                        public static int? DiffMicroseconds(System.DateTimeOffset? timeValue1, System.DateTimeOffset? timeValue2) => throw null;
                        public static int? DiffMicroseconds(System.DateTime? timeValue1, System.DateTime? timeValue2) => throw null;
                        public static int? DiffMicroseconds(System.TimeSpan? timeValue1, System.TimeSpan? timeValue2) => throw null;
                        public static int? DiffMilliseconds(System.DateTimeOffset? timeValue1, System.DateTimeOffset? timeValue2) => throw null;
                        public static int? DiffMilliseconds(System.DateTime? timeValue1, System.DateTime? timeValue2) => throw null;
                        public static int? DiffMilliseconds(System.TimeSpan? timeValue1, System.TimeSpan? timeValue2) => throw null;
                        public static int? DiffMinutes(System.DateTimeOffset? timeValue1, System.DateTimeOffset? timeValue2) => throw null;
                        public static int? DiffMinutes(System.DateTime? timeValue1, System.DateTime? timeValue2) => throw null;
                        public static int? DiffMinutes(System.TimeSpan? timeValue1, System.TimeSpan? timeValue2) => throw null;
                        public static int? DiffMonths(System.DateTimeOffset? dateValue1, System.DateTimeOffset? dateValue2) => throw null;
                        public static int? DiffMonths(System.DateTime? dateValue1, System.DateTime? dateValue2) => throw null;
                        public static int? DiffNanoseconds(System.DateTimeOffset? timeValue1, System.DateTimeOffset? timeValue2) => throw null;
                        public static int? DiffNanoseconds(System.DateTime? timeValue1, System.DateTime? timeValue2) => throw null;
                        public static int? DiffNanoseconds(System.TimeSpan? timeValue1, System.TimeSpan? timeValue2) => throw null;
                        public static int? DiffSeconds(System.DateTimeOffset? timeValue1, System.DateTimeOffset? timeValue2) => throw null;
                        public static int? DiffSeconds(System.DateTime? timeValue1, System.DateTime? timeValue2) => throw null;
                        public static int? DiffSeconds(System.TimeSpan? timeValue1, System.TimeSpan? timeValue2) => throw null;
                        public static int? DiffYears(System.DateTimeOffset? dateValue1, System.DateTimeOffset? dateValue2) => throw null;
                        public static int? DiffYears(System.DateTime? dateValue1, System.DateTime? dateValue2) => throw null;
                        public static int? GetTotalOffsetMinutes(System.DateTimeOffset? dateTimeOffsetArgument) => throw null;
                        public static string Left(string stringArgument, long? length) => throw null;
                        public static bool Like(string searchString, string likeExpression) => throw null;
                        public static bool Like(string searchString, string likeExpression, string escapeCharacter) => throw null;
                        public static string Reverse(string stringArgument) => throw null;
                        public static string Right(string stringArgument, long? length) => throw null;
                        public static double? StandardDeviation(System.Collections.Generic.IEnumerable<decimal> collection) => throw null;
                        public static double? StandardDeviation(System.Collections.Generic.IEnumerable<decimal?> collection) => throw null;
                        public static double? StandardDeviation(System.Collections.Generic.IEnumerable<double> collection) => throw null;
                        public static double? StandardDeviation(System.Collections.Generic.IEnumerable<double?> collection) => throw null;
                        public static double? StandardDeviation(System.Collections.Generic.IEnumerable<int> collection) => throw null;
                        public static double? StandardDeviation(System.Collections.Generic.IEnumerable<int?> collection) => throw null;
                        public static double? StandardDeviation(System.Collections.Generic.IEnumerable<long> collection) => throw null;
                        public static double? StandardDeviation(System.Collections.Generic.IEnumerable<long?> collection) => throw null;
                        public static double? StandardDeviationP(System.Collections.Generic.IEnumerable<decimal> collection) => throw null;
                        public static double? StandardDeviationP(System.Collections.Generic.IEnumerable<decimal?> collection) => throw null;
                        public static double? StandardDeviationP(System.Collections.Generic.IEnumerable<double> collection) => throw null;
                        public static double? StandardDeviationP(System.Collections.Generic.IEnumerable<double?> collection) => throw null;
                        public static double? StandardDeviationP(System.Collections.Generic.IEnumerable<int> collection) => throw null;
                        public static double? StandardDeviationP(System.Collections.Generic.IEnumerable<int?> collection) => throw null;
                        public static double? StandardDeviationP(System.Collections.Generic.IEnumerable<long> collection) => throw null;
                        public static double? StandardDeviationP(System.Collections.Generic.IEnumerable<long?> collection) => throw null;
                        public static double? Truncate(double? value, int? digits) => throw null;
                        public static decimal? Truncate(decimal? value, int? digits) => throw null;
                        public static System.DateTimeOffset? TruncateTime(System.DateTimeOffset? dateValue) => throw null;
                        public static System.DateTime? TruncateTime(System.DateTime? dateValue) => throw null;
                        public static double? Var(System.Collections.Generic.IEnumerable<decimal> collection) => throw null;
                        public static double? Var(System.Collections.Generic.IEnumerable<decimal?> collection) => throw null;
                        public static double? Var(System.Collections.Generic.IEnumerable<double> collection) => throw null;
                        public static double? Var(System.Collections.Generic.IEnumerable<double?> collection) => throw null;
                        public static double? Var(System.Collections.Generic.IEnumerable<int> collection) => throw null;
                        public static double? Var(System.Collections.Generic.IEnumerable<int?> collection) => throw null;
                        public static double? Var(System.Collections.Generic.IEnumerable<long> collection) => throw null;
                        public static double? Var(System.Collections.Generic.IEnumerable<long?> collection) => throw null;
                        public static double? VarP(System.Collections.Generic.IEnumerable<decimal> collection) => throw null;
                        public static double? VarP(System.Collections.Generic.IEnumerable<decimal?> collection) => throw null;
                        public static double? VarP(System.Collections.Generic.IEnumerable<double> collection) => throw null;
                        public static double? VarP(System.Collections.Generic.IEnumerable<double?> collection) => throw null;
                        public static double? VarP(System.Collections.Generic.IEnumerable<int> collection) => throw null;
                        public static double? VarP(System.Collections.Generic.IEnumerable<int?> collection) => throw null;
                        public static double? VarP(System.Collections.Generic.IEnumerable<long> collection) => throw null;
                        public static double? VarP(System.Collections.Generic.IEnumerable<long?> collection) => throw null;
                    }
                    public class ExecutionOptions
                    {
                        public ExecutionOptions(System.Data.Entity.Core.Objects.MergeOption mergeOption) => throw null;
                        public ExecutionOptions(System.Data.Entity.Core.Objects.MergeOption mergeOption, bool streaming) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Data.Entity.Core.Objects.MergeOption MergeOption { get => throw null; }
                        public static bool operator ==(System.Data.Entity.Core.Objects.ExecutionOptions left, System.Data.Entity.Core.Objects.ExecutionOptions right) => throw null;
                        public static bool operator !=(System.Data.Entity.Core.Objects.ExecutionOptions left, System.Data.Entity.Core.Objects.ExecutionOptions right) => throw null;
                        public bool Streaming { get => throw null; }
                    }
                    public interface IObjectSet<TEntity> : System.Collections.Generic.IEnumerable<TEntity>, System.Collections.IEnumerable, System.Linq.IQueryable<TEntity>, System.Linq.IQueryable where TEntity : class
                    {
                        void AddObject(TEntity entity);
                        void Attach(TEntity entity);
                        void DeleteObject(TEntity entity);
                        void Detach(TEntity entity);
                    }
                    public enum MergeOption
                    {
                        AppendOnly = 0,
                        OverwriteChanges = 1,
                        PreserveChanges = 2,
                        NoTracking = 3,
                    }
                    public class ObjectContext : System.IDisposable, System.Data.Entity.Infrastructure.IObjectContextAdapter
                    {
                        public virtual void AcceptAllChanges() => throw null;
                        public virtual void AddObject(string entitySetName, object entity) => throw null;
                        public virtual TEntity ApplyCurrentValues<TEntity>(string entitySetName, TEntity currentEntity) where TEntity : class => throw null;
                        public virtual TEntity ApplyOriginalValues<TEntity>(string entitySetName, TEntity originalEntity) where TEntity : class => throw null;
                        public virtual void ApplyPropertyChanges(string entitySetName, object changed) => throw null;
                        public virtual void Attach(System.Data.Entity.Core.Objects.DataClasses.IEntityWithKey entity) => throw null;
                        public virtual void AttachTo(string entitySetName, object entity) => throw null;
                        public virtual int? CommandTimeout { get => throw null; set { } }
                        public virtual System.Data.Common.DbConnection Connection { get => throw null; }
                        public virtual System.Data.Entity.Core.Objects.ObjectContextOptions ContextOptions { get => throw null; }
                        public virtual void CreateDatabase() => throw null;
                        public virtual string CreateDatabaseScript() => throw null;
                        public virtual System.Data.Entity.Core.EntityKey CreateEntityKey(string entitySetName, object entity) => throw null;
                        public virtual T CreateObject<T>() where T : class => throw null;
                        public virtual System.Data.Entity.Core.Objects.ObjectSet<TEntity> CreateObjectSet<TEntity>() where TEntity : class => throw null;
                        public virtual System.Data.Entity.Core.Objects.ObjectSet<TEntity> CreateObjectSet<TEntity>(string entitySetName) where TEntity : class => throw null;
                        public virtual void CreateProxyTypes(System.Collections.Generic.IEnumerable<System.Type> types) => throw null;
                        public virtual System.Data.Entity.Core.Objects.ObjectQuery<T> CreateQuery<T>(string queryString, params System.Data.Entity.Core.Objects.ObjectParameter[] parameters) => throw null;
                        public ObjectContext(System.Data.Entity.Core.EntityClient.EntityConnection connection) => throw null;
                        public ObjectContext(System.Data.Entity.Core.EntityClient.EntityConnection connection, bool contextOwnsConnection) => throw null;
                        public ObjectContext(string connectionString) => throw null;
                        protected ObjectContext(string connectionString, string defaultContainerName) => throw null;
                        protected ObjectContext(System.Data.Entity.Core.EntityClient.EntityConnection connection, string defaultContainerName) => throw null;
                        public virtual bool DatabaseExists() => throw null;
                        public virtual string DefaultContainerName { get => throw null; set { } }
                        public virtual void DeleteDatabase() => throw null;
                        public virtual void DeleteObject(object entity) => throw null;
                        public virtual void Detach(object entity) => throw null;
                        public virtual void DetectChanges() => throw null;
                        public void Dispose() => throw null;
                        protected virtual void Dispose(bool disposing) => throw null;
                        public System.Data.Entity.Core.Objects.ObjectResult<TElement> ExecuteFunction<TElement>(string functionName, params System.Data.Entity.Core.Objects.ObjectParameter[] parameters) => throw null;
                        public virtual System.Data.Entity.Core.Objects.ObjectResult<TElement> ExecuteFunction<TElement>(string functionName, System.Data.Entity.Core.Objects.MergeOption mergeOption, params System.Data.Entity.Core.Objects.ObjectParameter[] parameters) => throw null;
                        public virtual System.Data.Entity.Core.Objects.ObjectResult<TElement> ExecuteFunction<TElement>(string functionName, System.Data.Entity.Core.Objects.ExecutionOptions executionOptions, params System.Data.Entity.Core.Objects.ObjectParameter[] parameters) => throw null;
                        public virtual int ExecuteFunction(string functionName, params System.Data.Entity.Core.Objects.ObjectParameter[] parameters) => throw null;
                        public virtual int ExecuteStoreCommand(string commandText, params object[] parameters) => throw null;
                        public virtual int ExecuteStoreCommand(System.Data.Entity.TransactionalBehavior transactionalBehavior, string commandText, params object[] parameters) => throw null;
                        public System.Threading.Tasks.Task<int> ExecuteStoreCommandAsync(string commandText, params object[] parameters) => throw null;
                        public System.Threading.Tasks.Task<int> ExecuteStoreCommandAsync(System.Data.Entity.TransactionalBehavior transactionalBehavior, string commandText, params object[] parameters) => throw null;
                        public virtual System.Threading.Tasks.Task<int> ExecuteStoreCommandAsync(string commandText, System.Threading.CancellationToken cancellationToken, params object[] parameters) => throw null;
                        public virtual System.Threading.Tasks.Task<int> ExecuteStoreCommandAsync(System.Data.Entity.TransactionalBehavior transactionalBehavior, string commandText, System.Threading.CancellationToken cancellationToken, params object[] parameters) => throw null;
                        public virtual System.Data.Entity.Core.Objects.ObjectResult<TElement> ExecuteStoreQuery<TElement>(string commandText, params object[] parameters) => throw null;
                        public virtual System.Data.Entity.Core.Objects.ObjectResult<TElement> ExecuteStoreQuery<TElement>(string commandText, System.Data.Entity.Core.Objects.ExecutionOptions executionOptions, params object[] parameters) => throw null;
                        public virtual System.Data.Entity.Core.Objects.ObjectResult<TElement> ExecuteStoreQuery<TElement>(string commandText, string entitySetName, System.Data.Entity.Core.Objects.MergeOption mergeOption, params object[] parameters) => throw null;
                        public virtual System.Data.Entity.Core.Objects.ObjectResult<TElement> ExecuteStoreQuery<TElement>(string commandText, string entitySetName, System.Data.Entity.Core.Objects.ExecutionOptions executionOptions, params object[] parameters) => throw null;
                        public System.Threading.Tasks.Task<System.Data.Entity.Core.Objects.ObjectResult<TElement>> ExecuteStoreQueryAsync<TElement>(string commandText, params object[] parameters) => throw null;
                        public virtual System.Threading.Tasks.Task<System.Data.Entity.Core.Objects.ObjectResult<TElement>> ExecuteStoreQueryAsync<TElement>(string commandText, System.Threading.CancellationToken cancellationToken, params object[] parameters) => throw null;
                        public virtual System.Threading.Tasks.Task<System.Data.Entity.Core.Objects.ObjectResult<TElement>> ExecuteStoreQueryAsync<TElement>(string commandText, System.Data.Entity.Core.Objects.ExecutionOptions executionOptions, params object[] parameters) => throw null;
                        public virtual System.Threading.Tasks.Task<System.Data.Entity.Core.Objects.ObjectResult<TElement>> ExecuteStoreQueryAsync<TElement>(string commandText, System.Data.Entity.Core.Objects.ExecutionOptions executionOptions, System.Threading.CancellationToken cancellationToken, params object[] parameters) => throw null;
                        public System.Threading.Tasks.Task<System.Data.Entity.Core.Objects.ObjectResult<TElement>> ExecuteStoreQueryAsync<TElement>(string commandText, string entitySetName, System.Data.Entity.Core.Objects.ExecutionOptions executionOptions, params object[] parameters) => throw null;
                        public virtual System.Threading.Tasks.Task<System.Data.Entity.Core.Objects.ObjectResult<TElement>> ExecuteStoreQueryAsync<TElement>(string commandText, string entitySetName, System.Data.Entity.Core.Objects.ExecutionOptions executionOptions, System.Threading.CancellationToken cancellationToken, params object[] parameters) => throw null;
                        public static System.Collections.Generic.IEnumerable<System.Type> GetKnownProxyTypes() => throw null;
                        public virtual object GetObjectByKey(System.Data.Entity.Core.EntityKey key) => throw null;
                        public static System.Type GetObjectType(System.Type type) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbInterceptionContext InterceptionContext { get => throw null; }
                        public virtual void LoadProperty(object entity, string navigationProperty) => throw null;
                        public virtual void LoadProperty(object entity, string navigationProperty, System.Data.Entity.Core.Objects.MergeOption mergeOption) => throw null;
                        public virtual void LoadProperty<TEntity>(TEntity entity, System.Linq.Expressions.Expression<System.Func<TEntity, object>> selector) => throw null;
                        public virtual void LoadProperty<TEntity>(TEntity entity, System.Linq.Expressions.Expression<System.Func<TEntity, object>> selector, System.Data.Entity.Core.Objects.MergeOption mergeOption) => throw null;
                        public virtual System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace MetadataWorkspace { get => throw null; }
                        System.Data.Entity.Core.Objects.ObjectContext System.Data.Entity.Infrastructure.IObjectContextAdapter.ObjectContext { get => throw null; }
                        public event System.Data.Entity.Core.Objects.ObjectMaterializedEventHandler ObjectMaterialized;
                        public virtual System.Data.Entity.Core.Objects.ObjectStateManager ObjectStateManager { get => throw null; }
                        protected virtual System.Linq.IQueryProvider QueryProvider { get => throw null; }
                        public virtual void Refresh(System.Data.Entity.Core.Objects.RefreshMode refreshMode, System.Collections.IEnumerable collection) => throw null;
                        public virtual void Refresh(System.Data.Entity.Core.Objects.RefreshMode refreshMode, object entity) => throw null;
                        public System.Threading.Tasks.Task RefreshAsync(System.Data.Entity.Core.Objects.RefreshMode refreshMode, System.Collections.IEnumerable collection) => throw null;
                        public virtual System.Threading.Tasks.Task RefreshAsync(System.Data.Entity.Core.Objects.RefreshMode refreshMode, System.Collections.IEnumerable collection, System.Threading.CancellationToken cancellationToken) => throw null;
                        public System.Threading.Tasks.Task RefreshAsync(System.Data.Entity.Core.Objects.RefreshMode refreshMode, object entity) => throw null;
                        public virtual System.Threading.Tasks.Task RefreshAsync(System.Data.Entity.Core.Objects.RefreshMode refreshMode, object entity, System.Threading.CancellationToken cancellationToken) => throw null;
                        public virtual int SaveChanges() => throw null;
                        public virtual int SaveChanges(bool acceptChangesDuringSave) => throw null;
                        public virtual int SaveChanges(System.Data.Entity.Core.Objects.SaveOptions options) => throw null;
                        public virtual System.Threading.Tasks.Task<int> SaveChangesAsync() => throw null;
                        public virtual System.Threading.Tasks.Task<int> SaveChangesAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                        public virtual System.Threading.Tasks.Task<int> SaveChangesAsync(System.Data.Entity.Core.Objects.SaveOptions options) => throw null;
                        public virtual System.Threading.Tasks.Task<int> SaveChangesAsync(System.Data.Entity.Core.Objects.SaveOptions options, System.Threading.CancellationToken cancellationToken) => throw null;
                        public event System.EventHandler SavingChanges;
                        public System.Data.Entity.Infrastructure.TransactionHandler TransactionHandler { get => throw null; }
                        public virtual System.Data.Entity.Core.Objects.ObjectResult<TElement> Translate<TElement>(System.Data.Common.DbDataReader reader) => throw null;
                        public virtual System.Data.Entity.Core.Objects.ObjectResult<TEntity> Translate<TEntity>(System.Data.Common.DbDataReader reader, string entitySetName, System.Data.Entity.Core.Objects.MergeOption mergeOption) => throw null;
                        public virtual bool TryGetObjectByKey(System.Data.Entity.Core.EntityKey key, out object value) => throw null;
                    }
                    public sealed class ObjectContextOptions
                    {
                        public bool DisableFilterOverProjectionSimplificationForCustomFunctions { get => throw null; set { } }
                        public bool EnsureTransactionsForFunctionsAndCommands { get => throw null; set { } }
                        public bool LazyLoadingEnabled { get => throw null; set { } }
                        public bool ProxyCreationEnabled { get => throw null; set { } }
                        public bool UseConsistentNullReferenceBehavior { get => throw null; set { } }
                        public bool UseCSharpNullComparisonBehavior { get => throw null; set { } }
                        public bool UseLegacyPreserveChangesBehavior { get => throw null; set { } }
                    }
                    public class ObjectMaterializedEventArgs : System.EventArgs
                    {
                        public ObjectMaterializedEventArgs(object entity) => throw null;
                        public object Entity { get => throw null; }
                    }
                    public delegate void ObjectMaterializedEventHandler(object sender, System.Data.Entity.Core.Objects.ObjectMaterializedEventArgs e);
                    public sealed class ObjectParameter
                    {
                        public ObjectParameter(string name, System.Type type) => throw null;
                        public ObjectParameter(string name, object value) => throw null;
                        public string Name { get => throw null; }
                        public System.Type ParameterType { get => throw null; }
                        public object Value { get => throw null; set { } }
                    }
                    public class ObjectParameterCollection : System.Collections.Generic.ICollection<System.Data.Entity.Core.Objects.ObjectParameter>, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Objects.ObjectParameter>, System.Collections.IEnumerable
                    {
                        public void Add(System.Data.Entity.Core.Objects.ObjectParameter item) => throw null;
                        public void Clear() => throw null;
                        public bool Contains(System.Data.Entity.Core.Objects.ObjectParameter item) => throw null;
                        public bool Contains(string name) => throw null;
                        public void CopyTo(System.Data.Entity.Core.Objects.ObjectParameter[] array, int arrayIndex) => throw null;
                        public int Count { get => throw null; }
                        public virtual System.Collections.Generic.IEnumerator<System.Data.Entity.Core.Objects.ObjectParameter> GetEnumerator() => throw null;
                        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                        bool System.Collections.Generic.ICollection<System.Data.Entity.Core.Objects.ObjectParameter>.IsReadOnly { get => throw null; }
                        public bool Remove(System.Data.Entity.Core.Objects.ObjectParameter item) => throw null;
                        public System.Data.Entity.Core.Objects.ObjectParameter this[string name] { get => throw null; }
                    }
                    public abstract class ObjectQuery : System.Data.Entity.Infrastructure.IDbAsyncEnumerable, System.Collections.IEnumerable, System.ComponentModel.IListSource, System.Linq.IOrderedQueryable, System.Linq.IQueryable
                    {
                        public string CommandText { get => throw null; }
                        bool System.ComponentModel.IListSource.ContainsListCollection { get => throw null; }
                        public System.Data.Entity.Core.Objects.ObjectContext Context { get => throw null; }
                        System.Type System.Linq.IQueryable.ElementType { get => throw null; }
                        public bool EnablePlanCaching { get => throw null; set { } }
                        public System.Data.Entity.Core.Objects.ObjectResult Execute(System.Data.Entity.Core.Objects.MergeOption mergeOption) => throw null;
                        public System.Threading.Tasks.Task<System.Data.Entity.Core.Objects.ObjectResult> ExecuteAsync(System.Data.Entity.Core.Objects.MergeOption mergeOption) => throw null;
                        public System.Threading.Tasks.Task<System.Data.Entity.Core.Objects.ObjectResult> ExecuteAsync(System.Data.Entity.Core.Objects.MergeOption mergeOption, System.Threading.CancellationToken cancellationToken) => throw null;
                        System.Linq.Expressions.Expression System.Linq.IQueryable.Expression { get => throw null; }
                        System.Data.Entity.Infrastructure.IDbAsyncEnumerator System.Data.Entity.Infrastructure.IDbAsyncEnumerable.GetAsyncEnumerator() => throw null;
                        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                        System.Collections.IList System.ComponentModel.IListSource.GetList() => throw null;
                        public System.Data.Entity.Core.Metadata.Edm.TypeUsage GetResultType() => throw null;
                        public System.Data.Entity.Core.Objects.MergeOption MergeOption { get => throw null; set { } }
                        public System.Data.Entity.Core.Objects.ObjectParameterCollection Parameters { get => throw null; }
                        System.Linq.IQueryProvider System.Linq.IQueryable.Provider { get => throw null; }
                        public bool Streaming { get => throw null; set { } }
                        public string ToTraceString() => throw null;
                    }
                    public class ObjectQuery<T> : System.Data.Entity.Core.Objects.ObjectQuery, System.Data.Entity.Infrastructure.IDbAsyncEnumerable<T>, System.Data.Entity.Infrastructure.IDbAsyncEnumerable, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable, System.Linq.IOrderedQueryable<T>, System.Linq.IOrderedQueryable, System.Linq.IQueryable, System.Linq.IQueryable<T>
                    {
                        public ObjectQuery(string commandText, System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                        public ObjectQuery(string commandText, System.Data.Entity.Core.Objects.ObjectContext context, System.Data.Entity.Core.Objects.MergeOption mergeOption) => throw null;
                        public System.Data.Entity.Core.Objects.ObjectQuery<T> Distinct() => throw null;
                        public System.Data.Entity.Core.Objects.ObjectQuery<T> Except(System.Data.Entity.Core.Objects.ObjectQuery<T> query) => throw null;
                        public System.Data.Entity.Core.Objects.ObjectResult<T> Execute(System.Data.Entity.Core.Objects.MergeOption mergeOption) => throw null;
                        public System.Threading.Tasks.Task<System.Data.Entity.Core.Objects.ObjectResult<T>> ExecuteAsync(System.Data.Entity.Core.Objects.MergeOption mergeOption) => throw null;
                        public System.Threading.Tasks.Task<System.Data.Entity.Core.Objects.ObjectResult<T>> ExecuteAsync(System.Data.Entity.Core.Objects.MergeOption mergeOption, System.Threading.CancellationToken cancellationToken) => throw null;
                        System.Data.Entity.Infrastructure.IDbAsyncEnumerator<T> System.Data.Entity.Infrastructure.IDbAsyncEnumerable<T>.GetAsyncEnumerator() => throw null;
                        System.Collections.Generic.IEnumerator<T> System.Collections.Generic.IEnumerable<T>.GetEnumerator() => throw null;
                        public System.Data.Entity.Core.Objects.ObjectQuery<System.Data.Common.DbDataRecord> GroupBy(string keys, string projection, params System.Data.Entity.Core.Objects.ObjectParameter[] parameters) => throw null;
                        public System.Data.Entity.Core.Objects.ObjectQuery<T> Include(string path) => throw null;
                        public System.Data.Entity.Core.Objects.ObjectQuery<T> Intersect(System.Data.Entity.Core.Objects.ObjectQuery<T> query) => throw null;
                        public string Name { get => throw null; set { } }
                        public System.Data.Entity.Core.Objects.ObjectQuery<TResultType> OfType<TResultType>() => throw null;
                        public System.Data.Entity.Core.Objects.ObjectQuery<T> OrderBy(string keys, params System.Data.Entity.Core.Objects.ObjectParameter[] parameters) => throw null;
                        public System.Data.Entity.Core.Objects.ObjectQuery<System.Data.Common.DbDataRecord> Select(string projection, params System.Data.Entity.Core.Objects.ObjectParameter[] parameters) => throw null;
                        public System.Data.Entity.Core.Objects.ObjectQuery<TResultType> SelectValue<TResultType>(string projection, params System.Data.Entity.Core.Objects.ObjectParameter[] parameters) => throw null;
                        public System.Data.Entity.Core.Objects.ObjectQuery<T> Skip(string keys, string count, params System.Data.Entity.Core.Objects.ObjectParameter[] parameters) => throw null;
                        public System.Data.Entity.Core.Objects.ObjectQuery<T> Top(string count, params System.Data.Entity.Core.Objects.ObjectParameter[] parameters) => throw null;
                        public System.Data.Entity.Core.Objects.ObjectQuery<T> Union(System.Data.Entity.Core.Objects.ObjectQuery<T> query) => throw null;
                        public System.Data.Entity.Core.Objects.ObjectQuery<T> UnionAll(System.Data.Entity.Core.Objects.ObjectQuery<T> query) => throw null;
                        public System.Data.Entity.Core.Objects.ObjectQuery<T> Where(string predicate, params System.Data.Entity.Core.Objects.ObjectParameter[] parameters) => throw null;
                    }
                    public abstract class ObjectResult : System.Data.Entity.Infrastructure.IDbAsyncEnumerable, System.IDisposable, System.Collections.IEnumerable, System.ComponentModel.IListSource
                    {
                        bool System.ComponentModel.IListSource.ContainsListCollection { get => throw null; }
                        protected ObjectResult() => throw null;
                        public void Dispose() => throw null;
                        protected abstract void Dispose(bool disposing);
                        public abstract System.Type ElementType { get; }
                        System.Data.Entity.Infrastructure.IDbAsyncEnumerator System.Data.Entity.Infrastructure.IDbAsyncEnumerable.GetAsyncEnumerator() => throw null;
                        System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                        System.Collections.IList System.ComponentModel.IListSource.GetList() => throw null;
                        public virtual System.Data.Entity.Core.Objects.ObjectResult<TElement> GetNextResult<TElement>() => throw null;
                    }
                    public class ObjectResult<T> : System.Data.Entity.Core.Objects.ObjectResult, System.Data.Entity.Infrastructure.IDbAsyncEnumerable<T>, System.Data.Entity.Infrastructure.IDbAsyncEnumerable, System.Collections.Generic.IEnumerable<T>, System.Collections.IEnumerable
                    {
                        protected ObjectResult() => throw null;
                        protected override void Dispose(bool disposing) => throw null;
                        public override System.Type ElementType { get => throw null; }
                        System.Data.Entity.Infrastructure.IDbAsyncEnumerator<T> System.Data.Entity.Infrastructure.IDbAsyncEnumerable<T>.GetAsyncEnumerator() => throw null;
                        public virtual System.Collections.Generic.IEnumerator<T> GetEnumerator() => throw null;
                    }
                    public class ObjectSet<TEntity> : System.Data.Entity.Core.Objects.ObjectQuery<TEntity>, System.Collections.Generic.IEnumerable<TEntity>, System.Collections.IEnumerable, System.Data.Entity.Core.Objects.IObjectSet<TEntity>, System.Linq.IQueryable<TEntity>, System.Linq.IQueryable where TEntity : class
                    {
                        public void AddObject(TEntity entity) => throw null;
                        public TEntity ApplyCurrentValues(TEntity currentEntity) => throw null;
                        public TEntity ApplyOriginalValues(TEntity originalEntity) => throw null;
                        public void Attach(TEntity entity) => throw null;
                        public TEntity CreateObject() => throw null;
                        public T CreateObject<T>() where T : class, TEntity => throw null;
                        public void DeleteObject(TEntity entity) => throw null;
                        public void Detach(TEntity entity) => throw null;
                        public System.Data.Entity.Core.Metadata.Edm.EntitySet EntitySet { get => throw null; }
                        internal ObjectSet() : base(default(string), default(System.Data.Entity.Core.Objects.ObjectContext)) { }
                    }
                    public abstract class ObjectStateEntry : System.Data.Entity.Core.Objects.DataClasses.IEntityChangeTracker
                    {
                        public abstract void AcceptChanges();
                        public abstract void ApplyCurrentValues(object currentEntity);
                        public abstract void ApplyOriginalValues(object originalEntity);
                        public abstract void ChangeState(System.Data.Entity.EntityState state);
                        public abstract System.Data.Entity.Core.Objects.CurrentValueRecord CurrentValues { get; }
                        public abstract void Delete();
                        public abstract object Entity { get; }
                        void System.Data.Entity.Core.Objects.DataClasses.IEntityChangeTracker.EntityComplexMemberChanged(string entityMemberName, object complexObject, string complexObjectMemberName) => throw null;
                        void System.Data.Entity.Core.Objects.DataClasses.IEntityChangeTracker.EntityComplexMemberChanging(string entityMemberName, object complexObject, string complexObjectMemberName) => throw null;
                        public abstract System.Data.Entity.Core.EntityKey EntityKey { get; set; }
                        void System.Data.Entity.Core.Objects.DataClasses.IEntityChangeTracker.EntityMemberChanged(string entityMemberName) => throw null;
                        void System.Data.Entity.Core.Objects.DataClasses.IEntityChangeTracker.EntityMemberChanging(string entityMemberName) => throw null;
                        public System.Data.Entity.Core.Metadata.Edm.EntitySetBase EntitySet { get => throw null; }
                        System.Data.Entity.EntityState System.Data.Entity.Core.Objects.DataClasses.IEntityChangeTracker.EntityState { get => throw null; }
                        public abstract System.Collections.Generic.IEnumerable<string> GetModifiedProperties();
                        public abstract System.Data.Entity.Core.Objects.OriginalValueRecord GetUpdatableOriginalValues();
                        public abstract bool IsPropertyChanged(string propertyName);
                        public abstract bool IsRelationship { get; }
                        public System.Data.Entity.Core.Objects.ObjectStateManager ObjectStateManager { get => throw null; }
                        public abstract System.Data.Common.DbDataRecord OriginalValues { get; }
                        public abstract void RejectPropertyChanges(string propertyName);
                        public abstract System.Data.Entity.Core.Objects.DataClasses.RelationshipManager RelationshipManager { get; }
                        public abstract void SetModified();
                        public abstract void SetModifiedProperty(string propertyName);
                        public System.Data.Entity.EntityState State { get => throw null; }
                    }
                    public class ObjectStateManager
                    {
                        public virtual System.Data.Entity.Core.Objects.ObjectStateEntry ChangeObjectState(object entity, System.Data.Entity.EntityState entityState) => throw null;
                        public virtual System.Data.Entity.Core.Objects.ObjectStateEntry ChangeRelationshipState(object sourceEntity, object targetEntity, string navigationProperty, System.Data.Entity.EntityState relationshipState) => throw null;
                        public virtual System.Data.Entity.Core.Objects.ObjectStateEntry ChangeRelationshipState<TEntity>(TEntity sourceEntity, object targetEntity, System.Linq.Expressions.Expression<System.Func<TEntity, object>> navigationPropertySelector, System.Data.Entity.EntityState relationshipState) where TEntity : class => throw null;
                        public virtual System.Data.Entity.Core.Objects.ObjectStateEntry ChangeRelationshipState(object sourceEntity, object targetEntity, string relationshipName, string targetRoleName, System.Data.Entity.EntityState relationshipState) => throw null;
                        public ObjectStateManager(System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace metadataWorkspace) => throw null;
                        public virtual System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Objects.ObjectStateEntry> GetObjectStateEntries(System.Data.Entity.EntityState state) => throw null;
                        public virtual System.Data.Entity.Core.Objects.ObjectStateEntry GetObjectStateEntry(System.Data.Entity.Core.EntityKey key) => throw null;
                        public virtual System.Data.Entity.Core.Objects.ObjectStateEntry GetObjectStateEntry(object entity) => throw null;
                        public virtual System.Data.Entity.Core.Objects.DataClasses.RelationshipManager GetRelationshipManager(object entity) => throw null;
                        public virtual System.Data.Entity.Core.Metadata.Edm.MetadataWorkspace MetadataWorkspace { get => throw null; }
                        public event System.ComponentModel.CollectionChangeEventHandler ObjectStateManagerChanged;
                        public virtual bool TryGetObjectStateEntry(object entity, out System.Data.Entity.Core.Objects.ObjectStateEntry entry) => throw null;
                        public virtual bool TryGetObjectStateEntry(System.Data.Entity.Core.EntityKey key, out System.Data.Entity.Core.Objects.ObjectStateEntry entry) => throw null;
                        public virtual bool TryGetRelationshipManager(object entity, out System.Data.Entity.Core.Objects.DataClasses.RelationshipManager relationshipManager) => throw null;
                    }
                    public abstract class OriginalValueRecord : System.Data.Entity.Core.Objects.DbUpdatableDataRecord
                    {
                    }
                    public class ProxyDataContractResolver : System.Runtime.Serialization.DataContractResolver
                    {
                        public ProxyDataContractResolver() => throw null;
                        public override System.Type ResolveName(string typeName, string typeNamespace, System.Type declaredType, System.Runtime.Serialization.DataContractResolver knownTypeResolver) => throw null;
                        public override bool TryResolveType(System.Type type, System.Type declaredType, System.Runtime.Serialization.DataContractResolver knownTypeResolver, out System.Xml.XmlDictionaryString typeName, out System.Xml.XmlDictionaryString typeNamespace) => throw null;
                    }
                    public enum RefreshMode
                    {
                        ClientWins = 2,
                        StoreWins = 1,
                    }
                    [System.Flags]
                    public enum SaveOptions
                    {
                        None = 0,
                        AcceptAllChangesAfterSave = 1,
                        DetectChangesBeforeSave = 2,
                    }
                }
                public sealed class OptimisticConcurrencyException : System.Data.Entity.Core.UpdateException
                {
                    public OptimisticConcurrencyException() => throw null;
                    public OptimisticConcurrencyException(string message) => throw null;
                    public OptimisticConcurrencyException(string message, System.Exception innerException) => throw null;
                    public OptimisticConcurrencyException(string message, System.Exception innerException, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Objects.ObjectStateEntry> stateEntries) => throw null;
                }
                public sealed class PropertyConstraintException : System.Data.ConstraintException
                {
                    public PropertyConstraintException() => throw null;
                    public PropertyConstraintException(string message) => throw null;
                    public PropertyConstraintException(string message, System.Exception innerException) => throw null;
                    public PropertyConstraintException(string message, string propertyName) => throw null;
                    public PropertyConstraintException(string message, string propertyName, System.Exception innerException) => throw null;
                    public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public string PropertyName { get => throw null; }
                }
                public sealed class ProviderIncompatibleException : System.Data.Entity.Core.EntityException
                {
                    public ProviderIncompatibleException() => throw null;
                    public ProviderIncompatibleException(string message) => throw null;
                    public ProviderIncompatibleException(string message, System.Exception innerException) => throw null;
                }
                public class UpdateException : System.Data.DataException
                {
                    public UpdateException() => throw null;
                    public UpdateException(string message) => throw null;
                    public UpdateException(string message, System.Exception innerException) => throw null;
                    public UpdateException(string message, System.Exception innerException, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Objects.ObjectStateEntry> stateEntries) => throw null;
                    protected UpdateException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public System.Collections.ObjectModel.ReadOnlyCollection<System.Data.Entity.Core.Objects.ObjectStateEntry> StateEntries { get => throw null; }
                }
            }
            public class CreateDatabaseIfNotExists<TContext> : System.Data.Entity.IDatabaseInitializer<TContext> where TContext : System.Data.Entity.DbContext
            {
                public CreateDatabaseIfNotExists() => throw null;
                public virtual void InitializeDatabase(TContext context) => throw null;
                protected virtual void Seed(TContext context) => throw null;
            }
            public class Database
            {
                public System.Data.Entity.DbContextTransaction BeginTransaction() => throw null;
                public System.Data.Entity.DbContextTransaction BeginTransaction(System.Data.IsolationLevel isolationLevel) => throw null;
                public int? CommandTimeout { get => throw null; set { } }
                public bool CompatibleWithModel(bool throwIfNoMetadata) => throw null;
                public System.Data.Common.DbConnection Connection { get => throw null; }
                public void Create() => throw null;
                public bool CreateIfNotExists() => throw null;
                public System.Data.Entity.DbContextTransaction CurrentTransaction { get => throw null; }
                public static System.Data.Entity.Infrastructure.IDbConnectionFactory DefaultConnectionFactory { get => throw null; set { } }
                public bool Delete() => throw null;
                public static bool Delete(string nameOrConnectionString) => throw null;
                public static bool Delete(System.Data.Common.DbConnection existingConnection) => throw null;
                public override bool Equals(object obj) => throw null;
                public int ExecuteSqlCommand(string sql, params object[] parameters) => throw null;
                public int ExecuteSqlCommand(System.Data.Entity.TransactionalBehavior transactionalBehavior, string sql, params object[] parameters) => throw null;
                public System.Threading.Tasks.Task<int> ExecuteSqlCommandAsync(string sql, params object[] parameters) => throw null;
                public System.Threading.Tasks.Task<int> ExecuteSqlCommandAsync(System.Data.Entity.TransactionalBehavior transactionalBehavior, string sql, params object[] parameters) => throw null;
                public System.Threading.Tasks.Task<int> ExecuteSqlCommandAsync(string sql, System.Threading.CancellationToken cancellationToken, params object[] parameters) => throw null;
                public System.Threading.Tasks.Task<int> ExecuteSqlCommandAsync(System.Data.Entity.TransactionalBehavior transactionalBehavior, string sql, System.Threading.CancellationToken cancellationToken, params object[] parameters) => throw null;
                public bool Exists() => throw null;
                public static bool Exists(string nameOrConnectionString) => throw null;
                public static bool Exists(System.Data.Common.DbConnection existingConnection) => throw null;
                public override int GetHashCode() => throw null;
                public System.Type GetType() => throw null;
                public void Initialize(bool force) => throw null;
                public System.Action<string> Log { get => throw null; set { } }
                public static void SetInitializer<TContext>(System.Data.Entity.IDatabaseInitializer<TContext> strategy) where TContext : System.Data.Entity.DbContext => throw null;
                public System.Data.Entity.Infrastructure.DbRawSqlQuery<TElement> SqlQuery<TElement>(string sql, params object[] parameters) => throw null;
                public System.Data.Entity.Infrastructure.DbRawSqlQuery SqlQuery(System.Type elementType, string sql, params object[] parameters) => throw null;
                public override string ToString() => throw null;
                public void UseTransaction(System.Data.Common.DbTransaction transaction) => throw null;
            }
            public class DbConfiguration
            {
                protected void AddDefaultResolver(System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver resolver) => throw null;
                protected void AddDependencyResolver(System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver resolver) => throw null;
                protected void AddInterceptor(System.Data.Entity.Infrastructure.Interception.IDbInterceptor interceptor) => throw null;
                protected DbConfiguration() => throw null;
                public static System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver DependencyResolver { get => throw null; }
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public System.Type GetType() => throw null;
                public static void LoadConfiguration(System.Type contextType) => throw null;
                public static void LoadConfiguration(System.Reflection.Assembly assemblyHint) => throw null;
                public static event System.EventHandler<System.Data.Entity.Infrastructure.DependencyResolution.DbConfigurationLoadedEventArgs> Loaded;
                protected object MemberwiseClone() => throw null;
                public static void SetConfiguration(System.Data.Entity.DbConfiguration configuration) => throw null;
                protected void SetContextFactory(System.Type contextType, System.Func<System.Data.Entity.DbContext> factory) => throw null;
                protected void SetContextFactory<TContext>(System.Func<TContext> factory) where TContext : System.Data.Entity.DbContext => throw null;
                protected void SetDatabaseInitializer<TContext>(System.Data.Entity.IDatabaseInitializer<TContext> initializer) where TContext : System.Data.Entity.DbContext => throw null;
                protected void SetDatabaseLogFormatter(System.Func<System.Data.Entity.DbContext, System.Action<string>, System.Data.Entity.Infrastructure.Interception.DatabaseLogFormatter> logFormatterFactory) => throw null;
                protected void SetDefaultConnectionFactory(System.Data.Entity.Infrastructure.IDbConnectionFactory connectionFactory) => throw null;
                protected void SetDefaultHistoryContext(System.Func<System.Data.Common.DbConnection, string, System.Data.Entity.Migrations.History.HistoryContext> factory) => throw null;
                protected void SetDefaultSpatialServices(System.Data.Entity.Spatial.DbSpatialServices spatialProvider) => throw null;
                protected void SetDefaultTransactionHandler(System.Func<System.Data.Entity.Infrastructure.TransactionHandler> transactionHandlerFactory) => throw null;
                protected void SetExecutionStrategy(string providerInvariantName, System.Func<System.Data.Entity.Infrastructure.IDbExecutionStrategy> getExecutionStrategy) => throw null;
                protected void SetExecutionStrategy(string providerInvariantName, System.Func<System.Data.Entity.Infrastructure.IDbExecutionStrategy> getExecutionStrategy, string serverName) => throw null;
                protected void SetHistoryContext(string providerInvariantName, System.Func<System.Data.Common.DbConnection, string, System.Data.Entity.Migrations.History.HistoryContext> factory) => throw null;
                protected void SetManifestTokenResolver(System.Data.Entity.Infrastructure.IManifestTokenResolver resolver) => throw null;
                protected void SetMetadataAnnotationSerializer(string annotationName, System.Func<System.Data.Entity.Infrastructure.IMetadataAnnotationSerializer> serializerFactory) => throw null;
                protected void SetMigrationSqlGenerator(string providerInvariantName, System.Func<System.Data.Entity.Migrations.Sql.MigrationSqlGenerator> sqlGenerator) => throw null;
                protected void SetModelCacheKey(System.Func<System.Data.Entity.DbContext, System.Data.Entity.Infrastructure.IDbModelCacheKey> keyFactory) => throw null;
                protected void SetModelStore(System.Data.Entity.Infrastructure.DbModelStore modelStore) => throw null;
                protected void SetPluralizationService(System.Data.Entity.Infrastructure.Pluralization.IPluralizationService pluralizationService) => throw null;
                protected void SetProviderFactory(string providerInvariantName, System.Data.Common.DbProviderFactory providerFactory) => throw null;
                protected void SetProviderFactoryResolver(System.Data.Entity.Infrastructure.IDbProviderFactoryResolver providerFactoryResolver) => throw null;
                protected void SetProviderServices(string providerInvariantName, System.Data.Entity.Core.Common.DbProviderServices provider) => throw null;
                protected void SetSpatialServices(System.Data.Entity.Infrastructure.DbProviderInfo key, System.Data.Entity.Spatial.DbSpatialServices spatialProvider) => throw null;
                protected void SetSpatialServices(string providerInvariantName, System.Data.Entity.Spatial.DbSpatialServices spatialProvider) => throw null;
                protected void SetTableExistenceChecker(string providerInvariantName, System.Data.Entity.Infrastructure.TableExistenceChecker tableExistenceChecker) => throw null;
                protected void SetTransactionHandler(string providerInvariantName, System.Func<System.Data.Entity.Infrastructure.TransactionHandler> transactionHandlerFactory) => throw null;
                protected void SetTransactionHandler(string providerInvariantName, System.Func<System.Data.Entity.Infrastructure.TransactionHandler> transactionHandlerFactory, string serverName) => throw null;
                public override string ToString() => throw null;
            }
            [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false)]
            public class DbConfigurationTypeAttribute : System.Attribute
            {
                public System.Type ConfigurationType { get => throw null; }
                public DbConfigurationTypeAttribute(System.Type configurationType) => throw null;
                public DbConfigurationTypeAttribute(string configurationTypeName) => throw null;
            }
            public class DbContext : System.IDisposable, System.Data.Entity.Infrastructure.IObjectContextAdapter
            {
                public System.Data.Entity.Infrastructure.DbChangeTracker ChangeTracker { get => throw null; }
                public System.Data.Entity.Infrastructure.DbContextConfiguration Configuration { get => throw null; }
                protected DbContext() => throw null;
                protected DbContext(System.Data.Entity.Infrastructure.DbCompiledModel model) => throw null;
                public DbContext(string nameOrConnectionString) => throw null;
                public DbContext(string nameOrConnectionString, System.Data.Entity.Infrastructure.DbCompiledModel model) => throw null;
                public DbContext(System.Data.Common.DbConnection existingConnection, bool contextOwnsConnection) => throw null;
                public DbContext(System.Data.Common.DbConnection existingConnection, System.Data.Entity.Infrastructure.DbCompiledModel model, bool contextOwnsConnection) => throw null;
                public DbContext(System.Data.Entity.Core.Objects.ObjectContext objectContext, bool dbContextOwnsObjectContext) => throw null;
                public System.Data.Entity.Database Database { get => throw null; }
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public System.Data.Entity.Infrastructure.DbEntityEntry<TEntity> Entry<TEntity>(TEntity entity) where TEntity : class => throw null;
                public System.Data.Entity.Infrastructure.DbEntityEntry Entry(object entity) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public System.Type GetType() => throw null;
                public System.Collections.Generic.IEnumerable<System.Data.Entity.Validation.DbEntityValidationResult> GetValidationErrors() => throw null;
                System.Data.Entity.Core.Objects.ObjectContext System.Data.Entity.Infrastructure.IObjectContextAdapter.ObjectContext { get => throw null; }
                protected virtual void OnModelCreating(System.Data.Entity.DbModelBuilder modelBuilder) => throw null;
                public virtual int SaveChanges() => throw null;
                public virtual System.Threading.Tasks.Task<int> SaveChangesAsync() => throw null;
                public virtual System.Threading.Tasks.Task<int> SaveChangesAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                public virtual System.Data.Entity.DbSet<TEntity> Set<TEntity>() where TEntity : class => throw null;
                public virtual System.Data.Entity.DbSet Set(System.Type entityType) => throw null;
                protected virtual bool ShouldValidateEntity(System.Data.Entity.Infrastructure.DbEntityEntry entityEntry) => throw null;
                public override string ToString() => throw null;
                protected virtual System.Data.Entity.Validation.DbEntityValidationResult ValidateEntity(System.Data.Entity.Infrastructure.DbEntityEntry entityEntry, System.Collections.Generic.IDictionary<object, object> items) => throw null;
            }
            public class DbContextTransaction : System.IDisposable
            {
                public void Commit() => throw null;
                public void Dispose() => throw null;
                protected virtual void Dispose(bool disposing) => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public System.Type GetType() => throw null;
                public void Rollback() => throw null;
                public override string ToString() => throw null;
                public System.Data.Common.DbTransaction UnderlyingTransaction { get => throw null; }
            }
            [System.AttributeUsage((System.AttributeTargets)64, Inherited = false, AllowMultiple = false)]
            public class DbFunctionAttribute : System.Attribute
            {
                public DbFunctionAttribute(string namespaceName, string functionName) => throw null;
                public string FunctionName { get => throw null; }
                public string NamespaceName { get => throw null; }
            }
            public static class DbFunctions
            {
                public static System.DateTimeOffset? AddDays(System.DateTimeOffset? dateValue, int? addValue) => throw null;
                public static System.DateTime? AddDays(System.DateTime? dateValue, int? addValue) => throw null;
                public static System.DateTimeOffset? AddHours(System.DateTimeOffset? timeValue, int? addValue) => throw null;
                public static System.DateTime? AddHours(System.DateTime? timeValue, int? addValue) => throw null;
                public static System.TimeSpan? AddHours(System.TimeSpan? timeValue, int? addValue) => throw null;
                public static System.DateTimeOffset? AddMicroseconds(System.DateTimeOffset? timeValue, int? addValue) => throw null;
                public static System.DateTime? AddMicroseconds(System.DateTime? timeValue, int? addValue) => throw null;
                public static System.TimeSpan? AddMicroseconds(System.TimeSpan? timeValue, int? addValue) => throw null;
                public static System.DateTimeOffset? AddMilliseconds(System.DateTimeOffset? timeValue, int? addValue) => throw null;
                public static System.DateTime? AddMilliseconds(System.DateTime? timeValue, int? addValue) => throw null;
                public static System.TimeSpan? AddMilliseconds(System.TimeSpan? timeValue, int? addValue) => throw null;
                public static System.DateTimeOffset? AddMinutes(System.DateTimeOffset? timeValue, int? addValue) => throw null;
                public static System.DateTime? AddMinutes(System.DateTime? timeValue, int? addValue) => throw null;
                public static System.TimeSpan? AddMinutes(System.TimeSpan? timeValue, int? addValue) => throw null;
                public static System.DateTimeOffset? AddMonths(System.DateTimeOffset? dateValue, int? addValue) => throw null;
                public static System.DateTime? AddMonths(System.DateTime? dateValue, int? addValue) => throw null;
                public static System.DateTimeOffset? AddNanoseconds(System.DateTimeOffset? timeValue, int? addValue) => throw null;
                public static System.DateTime? AddNanoseconds(System.DateTime? timeValue, int? addValue) => throw null;
                public static System.TimeSpan? AddNanoseconds(System.TimeSpan? timeValue, int? addValue) => throw null;
                public static System.DateTimeOffset? AddSeconds(System.DateTimeOffset? timeValue, int? addValue) => throw null;
                public static System.DateTime? AddSeconds(System.DateTime? timeValue, int? addValue) => throw null;
                public static System.TimeSpan? AddSeconds(System.TimeSpan? timeValue, int? addValue) => throw null;
                public static System.DateTimeOffset? AddYears(System.DateTimeOffset? dateValue, int? addValue) => throw null;
                public static System.DateTime? AddYears(System.DateTime? dateValue, int? addValue) => throw null;
                public static string AsNonUnicode(string value) => throw null;
                public static string AsUnicode(string value) => throw null;
                public static System.DateTime? CreateDateTime(int? year, int? month, int? day, int? hour, int? minute, double? second) => throw null;
                public static System.DateTimeOffset? CreateDateTimeOffset(int? year, int? month, int? day, int? hour, int? minute, double? second, int? timeZoneOffset) => throw null;
                public static System.TimeSpan? CreateTime(int? hour, int? minute, double? second) => throw null;
                public static int? DiffDays(System.DateTimeOffset? dateValue1, System.DateTimeOffset? dateValue2) => throw null;
                public static int? DiffDays(System.DateTime? dateValue1, System.DateTime? dateValue2) => throw null;
                public static int? DiffHours(System.DateTimeOffset? timeValue1, System.DateTimeOffset? timeValue2) => throw null;
                public static int? DiffHours(System.DateTime? timeValue1, System.DateTime? timeValue2) => throw null;
                public static int? DiffHours(System.TimeSpan? timeValue1, System.TimeSpan? timeValue2) => throw null;
                public static int? DiffMicroseconds(System.DateTimeOffset? timeValue1, System.DateTimeOffset? timeValue2) => throw null;
                public static int? DiffMicroseconds(System.DateTime? timeValue1, System.DateTime? timeValue2) => throw null;
                public static int? DiffMicroseconds(System.TimeSpan? timeValue1, System.TimeSpan? timeValue2) => throw null;
                public static int? DiffMilliseconds(System.DateTimeOffset? timeValue1, System.DateTimeOffset? timeValue2) => throw null;
                public static int? DiffMilliseconds(System.DateTime? timeValue1, System.DateTime? timeValue2) => throw null;
                public static int? DiffMilliseconds(System.TimeSpan? timeValue1, System.TimeSpan? timeValue2) => throw null;
                public static int? DiffMinutes(System.DateTimeOffset? timeValue1, System.DateTimeOffset? timeValue2) => throw null;
                public static int? DiffMinutes(System.DateTime? timeValue1, System.DateTime? timeValue2) => throw null;
                public static int? DiffMinutes(System.TimeSpan? timeValue1, System.TimeSpan? timeValue2) => throw null;
                public static int? DiffMonths(System.DateTimeOffset? dateValue1, System.DateTimeOffset? dateValue2) => throw null;
                public static int? DiffMonths(System.DateTime? dateValue1, System.DateTime? dateValue2) => throw null;
                public static int? DiffNanoseconds(System.DateTimeOffset? timeValue1, System.DateTimeOffset? timeValue2) => throw null;
                public static int? DiffNanoseconds(System.DateTime? timeValue1, System.DateTime? timeValue2) => throw null;
                public static int? DiffNanoseconds(System.TimeSpan? timeValue1, System.TimeSpan? timeValue2) => throw null;
                public static int? DiffSeconds(System.DateTimeOffset? timeValue1, System.DateTimeOffset? timeValue2) => throw null;
                public static int? DiffSeconds(System.DateTime? timeValue1, System.DateTime? timeValue2) => throw null;
                public static int? DiffSeconds(System.TimeSpan? timeValue1, System.TimeSpan? timeValue2) => throw null;
                public static int? DiffYears(System.DateTimeOffset? dateValue1, System.DateTimeOffset? dateValue2) => throw null;
                public static int? DiffYears(System.DateTime? dateValue1, System.DateTime? dateValue2) => throw null;
                public static int? GetTotalOffsetMinutes(System.DateTimeOffset? dateTimeOffsetArgument) => throw null;
                public static string Left(string stringArgument, long? length) => throw null;
                public static bool Like(string searchString, string likeExpression) => throw null;
                public static bool Like(string searchString, string likeExpression, string escapeCharacter) => throw null;
                public static string Reverse(string stringArgument) => throw null;
                public static string Right(string stringArgument, long? length) => throw null;
                public static double? StandardDeviation(System.Collections.Generic.IEnumerable<decimal> collection) => throw null;
                public static double? StandardDeviation(System.Collections.Generic.IEnumerable<decimal?> collection) => throw null;
                public static double? StandardDeviation(System.Collections.Generic.IEnumerable<double> collection) => throw null;
                public static double? StandardDeviation(System.Collections.Generic.IEnumerable<double?> collection) => throw null;
                public static double? StandardDeviation(System.Collections.Generic.IEnumerable<int> collection) => throw null;
                public static double? StandardDeviation(System.Collections.Generic.IEnumerable<int?> collection) => throw null;
                public static double? StandardDeviation(System.Collections.Generic.IEnumerable<long> collection) => throw null;
                public static double? StandardDeviation(System.Collections.Generic.IEnumerable<long?> collection) => throw null;
                public static double? StandardDeviationP(System.Collections.Generic.IEnumerable<decimal> collection) => throw null;
                public static double? StandardDeviationP(System.Collections.Generic.IEnumerable<decimal?> collection) => throw null;
                public static double? StandardDeviationP(System.Collections.Generic.IEnumerable<double> collection) => throw null;
                public static double? StandardDeviationP(System.Collections.Generic.IEnumerable<double?> collection) => throw null;
                public static double? StandardDeviationP(System.Collections.Generic.IEnumerable<int> collection) => throw null;
                public static double? StandardDeviationP(System.Collections.Generic.IEnumerable<int?> collection) => throw null;
                public static double? StandardDeviationP(System.Collections.Generic.IEnumerable<long> collection) => throw null;
                public static double? StandardDeviationP(System.Collections.Generic.IEnumerable<long?> collection) => throw null;
                public static double? Truncate(double? value, int? digits) => throw null;
                public static decimal? Truncate(decimal? value, int? digits) => throw null;
                public static System.DateTimeOffset? TruncateTime(System.DateTimeOffset? dateValue) => throw null;
                public static System.DateTime? TruncateTime(System.DateTime? dateValue) => throw null;
                public static double? Var(System.Collections.Generic.IEnumerable<decimal> collection) => throw null;
                public static double? Var(System.Collections.Generic.IEnumerable<decimal?> collection) => throw null;
                public static double? Var(System.Collections.Generic.IEnumerable<double> collection) => throw null;
                public static double? Var(System.Collections.Generic.IEnumerable<double?> collection) => throw null;
                public static double? Var(System.Collections.Generic.IEnumerable<int> collection) => throw null;
                public static double? Var(System.Collections.Generic.IEnumerable<int?> collection) => throw null;
                public static double? Var(System.Collections.Generic.IEnumerable<long> collection) => throw null;
                public static double? Var(System.Collections.Generic.IEnumerable<long?> collection) => throw null;
                public static double? VarP(System.Collections.Generic.IEnumerable<decimal> collection) => throw null;
                public static double? VarP(System.Collections.Generic.IEnumerable<decimal?> collection) => throw null;
                public static double? VarP(System.Collections.Generic.IEnumerable<double> collection) => throw null;
                public static double? VarP(System.Collections.Generic.IEnumerable<double?> collection) => throw null;
                public static double? VarP(System.Collections.Generic.IEnumerable<int> collection) => throw null;
                public static double? VarP(System.Collections.Generic.IEnumerable<int?> collection) => throw null;
                public static double? VarP(System.Collections.Generic.IEnumerable<long> collection) => throw null;
                public static double? VarP(System.Collections.Generic.IEnumerable<long?> collection) => throw null;
            }
            public class DbModelBuilder
            {
                public virtual System.Data.Entity.Infrastructure.DbModel Build(System.Data.Common.DbConnection providerConnection) => throw null;
                public virtual System.Data.Entity.Infrastructure.DbModel Build(System.Data.Entity.Infrastructure.DbProviderInfo providerInfo) => throw null;
                public virtual System.Data.Entity.ModelConfiguration.ComplexTypeConfiguration<TComplexType> ComplexType<TComplexType>() where TComplexType : class => throw null;
                public virtual System.Data.Entity.ModelConfiguration.Configuration.ConfigurationRegistrar Configurations { get => throw null; }
                public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionsConfiguration Conventions { get => throw null; }
                public DbModelBuilder() => throw null;
                public DbModelBuilder(System.Data.Entity.DbModelBuilderVersion modelBuilderVersion) => throw null;
                public virtual System.Data.Entity.ModelConfiguration.EntityTypeConfiguration<TEntityType> Entity<TEntityType>() where TEntityType : class => throw null;
                public override bool Equals(object obj) => throw null;
                public override int GetHashCode() => throw null;
                public System.Type GetType() => throw null;
                public virtual System.Data.Entity.DbModelBuilder HasDefaultSchema(string schema) => throw null;
                public virtual System.Data.Entity.DbModelBuilder Ignore<T>() where T : class => throw null;
                public virtual System.Data.Entity.DbModelBuilder Ignore(System.Collections.Generic.IEnumerable<System.Type> types) => throw null;
                public System.Data.Entity.ModelConfiguration.Configuration.PropertyConventionConfiguration Properties() => throw null;
                public System.Data.Entity.ModelConfiguration.Configuration.PropertyConventionConfiguration Properties<T>() => throw null;
                public virtual void RegisterEntityType(System.Type entityType) => throw null;
                public override string ToString() => throw null;
                public System.Data.Entity.ModelConfiguration.Configuration.TypeConventionConfiguration Types() => throw null;
                public System.Data.Entity.ModelConfiguration.Configuration.TypeConventionConfiguration<T> Types<T>() where T : class => throw null;
            }
            public enum DbModelBuilderVersion
            {
                Latest = 0,
                V4_1 = 1,
                V5_0_Net4 = 2,
                V5_0 = 3,
                V6_0 = 4,
            }
            [System.AttributeUsage((System.AttributeTargets)4, AllowMultiple = false)]
            public sealed class DbModelBuilderVersionAttribute : System.Attribute
            {
                public DbModelBuilderVersionAttribute(System.Data.Entity.DbModelBuilderVersion version) => throw null;
                public System.Data.Entity.DbModelBuilderVersion Version { get => throw null; }
            }
            public abstract class DbSet : System.Data.Entity.Infrastructure.DbQuery
            {
                public virtual object Add(object entity) => throw null;
                public virtual System.Collections.IEnumerable AddRange(System.Collections.IEnumerable entities) => throw null;
                public virtual object Attach(object entity) => throw null;
                public System.Data.Entity.DbSet<TEntity> Cast<TEntity>() where TEntity : class => throw null;
                public virtual object Create() => throw null;
                public virtual object Create(System.Type derivedEntityType) => throw null;
                protected DbSet() => throw null;
                public override bool Equals(object obj) => throw null;
                public virtual object Find(params object[] keyValues) => throw null;
                public virtual System.Threading.Tasks.Task<object> FindAsync(params object[] keyValues) => throw null;
                public virtual System.Threading.Tasks.Task<object> FindAsync(System.Threading.CancellationToken cancellationToken, params object[] keyValues) => throw null;
                public override int GetHashCode() => throw null;
                public System.Type GetType() => throw null;
                public virtual System.Collections.IList Local { get => throw null; }
                public virtual object Remove(object entity) => throw null;
                public virtual System.Collections.IEnumerable RemoveRange(System.Collections.IEnumerable entities) => throw null;
                public virtual System.Data.Entity.Infrastructure.DbSqlQuery SqlQuery(string sql, params object[] parameters) => throw null;
            }
            public class DbSet<TEntity> : System.Data.Entity.Infrastructure.DbQuery<TEntity>, System.Data.Entity.IDbSet<TEntity>, System.Collections.Generic.IEnumerable<TEntity>, System.Collections.IEnumerable, System.Linq.IQueryable<TEntity>, System.Linq.IQueryable where TEntity : class
            {
                public virtual TEntity Add(TEntity entity) => throw null;
                public virtual System.Collections.Generic.IEnumerable<TEntity> AddRange(System.Collections.Generic.IEnumerable<TEntity> entities) => throw null;
                public virtual TEntity Attach(TEntity entity) => throw null;
                public virtual TEntity Create() => throw null;
                public virtual TDerivedEntity Create<TDerivedEntity>() where TDerivedEntity : class, TEntity => throw null;
                protected DbSet() => throw null;
                public override bool Equals(object obj) => throw null;
                public virtual TEntity Find(params object[] keyValues) => throw null;
                public virtual System.Threading.Tasks.Task<TEntity> FindAsync(System.Threading.CancellationToken cancellationToken, params object[] keyValues) => throw null;
                public virtual System.Threading.Tasks.Task<TEntity> FindAsync(params object[] keyValues) => throw null;
                public override int GetHashCode() => throw null;
                public System.Type GetType() => throw null;
                public virtual System.Collections.ObjectModel.ObservableCollection<TEntity> Local { get => throw null; }
                public static implicit operator System.Data.Entity.DbSet(System.Data.Entity.DbSet<TEntity> entry) => throw null;
                public virtual TEntity Remove(TEntity entity) => throw null;
                public virtual System.Collections.Generic.IEnumerable<TEntity> RemoveRange(System.Collections.Generic.IEnumerable<TEntity> entities) => throw null;
                public virtual System.Data.Entity.Infrastructure.DbSqlQuery<TEntity> SqlQuery(string sql, params object[] parameters) => throw null;
            }
            public class DropCreateDatabaseAlways<TContext> : System.Data.Entity.IDatabaseInitializer<TContext> where TContext : System.Data.Entity.DbContext
            {
                public DropCreateDatabaseAlways() => throw null;
                public virtual void InitializeDatabase(TContext context) => throw null;
                protected virtual void Seed(TContext context) => throw null;
            }
            public class DropCreateDatabaseIfModelChanges<TContext> : System.Data.Entity.IDatabaseInitializer<TContext> where TContext : System.Data.Entity.DbContext
            {
                public DropCreateDatabaseIfModelChanges() => throw null;
                public virtual void InitializeDatabase(TContext context) => throw null;
                protected virtual void Seed(TContext context) => throw null;
            }
            [System.Flags]
            public enum EntityState
            {
                Detached = 1,
                Unchanged = 2,
                Added = 4,
                Deleted = 8,
                Modified = 16,
            }
            namespace Hierarchy
            {
                public abstract class DbHierarchyServices
                {
                    protected DbHierarchyServices() => throw null;
                    public abstract System.Data.Entity.Hierarchy.HierarchyId GetAncestor(int n);
                    public abstract System.Data.Entity.Hierarchy.HierarchyId GetDescendant(System.Data.Entity.Hierarchy.HierarchyId child1, System.Data.Entity.Hierarchy.HierarchyId child2);
                    public abstract short GetLevel();
                    public abstract System.Data.Entity.Hierarchy.HierarchyId GetReparentedValue(System.Data.Entity.Hierarchy.HierarchyId oldRoot, System.Data.Entity.Hierarchy.HierarchyId newRoot);
                    public static System.Data.Entity.Hierarchy.HierarchyId GetRoot() => throw null;
                    public abstract bool IsDescendantOf(System.Data.Entity.Hierarchy.HierarchyId parent);
                    public static System.Data.Entity.Hierarchy.HierarchyId Parse(string input) => throw null;
                }
                public class HierarchyId : System.IComparable
                {
                    public static int Compare(System.Data.Entity.Hierarchy.HierarchyId hid1, System.Data.Entity.Hierarchy.HierarchyId hid2) => throw null;
                    public int CompareTo(object obj) => throw null;
                    public HierarchyId() => throw null;
                    public HierarchyId(string hierarchyId) => throw null;
                    protected bool Equals(System.Data.Entity.Hierarchy.HierarchyId other) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public System.Data.Entity.Hierarchy.HierarchyId GetAncestor(int n) => throw null;
                    public System.Data.Entity.Hierarchy.HierarchyId GetDescendant(System.Data.Entity.Hierarchy.HierarchyId child1, System.Data.Entity.Hierarchy.HierarchyId child2) => throw null;
                    public override int GetHashCode() => throw null;
                    public short GetLevel() => throw null;
                    public System.Data.Entity.Hierarchy.HierarchyId GetReparentedValue(System.Data.Entity.Hierarchy.HierarchyId oldRoot, System.Data.Entity.Hierarchy.HierarchyId newRoot) => throw null;
                    public static System.Data.Entity.Hierarchy.HierarchyId GetRoot() => throw null;
                    public bool IsDescendantOf(System.Data.Entity.Hierarchy.HierarchyId parent) => throw null;
                    public static bool operator ==(System.Data.Entity.Hierarchy.HierarchyId hid1, System.Data.Entity.Hierarchy.HierarchyId hid2) => throw null;
                    public static bool operator >(System.Data.Entity.Hierarchy.HierarchyId hid1, System.Data.Entity.Hierarchy.HierarchyId hid2) => throw null;
                    public static bool operator >=(System.Data.Entity.Hierarchy.HierarchyId hid1, System.Data.Entity.Hierarchy.HierarchyId hid2) => throw null;
                    public static bool operator !=(System.Data.Entity.Hierarchy.HierarchyId hid1, System.Data.Entity.Hierarchy.HierarchyId hid2) => throw null;
                    public static bool operator <(System.Data.Entity.Hierarchy.HierarchyId hid1, System.Data.Entity.Hierarchy.HierarchyId hid2) => throw null;
                    public static bool operator <=(System.Data.Entity.Hierarchy.HierarchyId hid1, System.Data.Entity.Hierarchy.HierarchyId hid2) => throw null;
                    public static System.Data.Entity.Hierarchy.HierarchyId Parse(string input) => throw null;
                    public const string PathSeparator = default;
                    public override string ToString() => throw null;
                }
            }
            public interface IDatabaseInitializer<TContext> where TContext : System.Data.Entity.DbContext
            {
                void InitializeDatabase(TContext context);
            }
            public interface IDbSet<TEntity> : System.Collections.Generic.IEnumerable<TEntity>, System.Collections.IEnumerable, System.Linq.IQueryable<TEntity>, System.Linq.IQueryable where TEntity : class
            {
                TEntity Add(TEntity entity);
                TEntity Attach(TEntity entity);
                TEntity Create();
                TDerivedEntity Create<TDerivedEntity>() where TDerivedEntity : class, TEntity;
                TEntity Find(params object[] keyValues);
                System.Collections.ObjectModel.ObservableCollection<TEntity> Local { get; }
                TEntity Remove(TEntity entity);
            }
            namespace Infrastructure
            {
                namespace Annotations
                {
                    public abstract class AnnotationCodeGenerator
                    {
                        protected AnnotationCodeGenerator() => throw null;
                        public abstract void Generate(string annotationName, object annotation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer);
                        public virtual System.Collections.Generic.IEnumerable<string> GetExtraNamespaces(System.Collections.Generic.IEnumerable<string> annotationNames) => throw null;
                    }
                    public sealed class AnnotationValues
                    {
                        public AnnotationValues(object oldValue, object newValue) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public object NewValue { get => throw null; }
                        public object OldValue { get => throw null; }
                        public static bool operator ==(System.Data.Entity.Infrastructure.Annotations.AnnotationValues left, System.Data.Entity.Infrastructure.Annotations.AnnotationValues right) => throw null;
                        public static bool operator !=(System.Data.Entity.Infrastructure.Annotations.AnnotationValues left, System.Data.Entity.Infrastructure.Annotations.AnnotationValues right) => throw null;
                    }
                    public sealed class CompatibilityResult
                    {
                        public CompatibilityResult(bool isCompatible, string errorMessage) => throw null;
                        public string ErrorMessage { get => throw null; }
                        public bool IsCompatible { get => throw null; }
                        public static implicit operator bool(System.Data.Entity.Infrastructure.Annotations.CompatibilityResult result) => throw null;
                    }
                    public interface IMergeableAnnotation
                    {
                        System.Data.Entity.Infrastructure.Annotations.CompatibilityResult IsCompatibleWith(object other);
                        object MergeWith(object other);
                    }
                    public class IndexAnnotation : System.Data.Entity.Infrastructure.Annotations.IMergeableAnnotation
                    {
                        public const string AnnotationName = default;
                        public IndexAnnotation(System.ComponentModel.DataAnnotations.Schema.IndexAttribute indexAttribute) => throw null;
                        public IndexAnnotation(System.Collections.Generic.IEnumerable<System.ComponentModel.DataAnnotations.Schema.IndexAttribute> indexAttributes) => throw null;
                        public virtual System.Collections.Generic.IEnumerable<System.ComponentModel.DataAnnotations.Schema.IndexAttribute> Indexes { get => throw null; }
                        public virtual System.Data.Entity.Infrastructure.Annotations.CompatibilityResult IsCompatibleWith(object other) => throw null;
                        public virtual object MergeWith(object other) => throw null;
                        public override string ToString() => throw null;
                    }
                    public class IndexAnnotationSerializer : System.Data.Entity.Infrastructure.IMetadataAnnotationSerializer
                    {
                        public IndexAnnotationSerializer() => throw null;
                        public virtual object Deserialize(string name, string value) => throw null;
                        public virtual string Serialize(string name, object value) => throw null;
                    }
                }
                public class CommitFailedException : System.Data.DataException
                {
                    public CommitFailedException() => throw null;
                    public CommitFailedException(string message) => throw null;
                    public CommitFailedException(string message, System.Exception innerException) => throw null;
                    protected CommitFailedException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class CommitFailureHandler : System.Data.Entity.Infrastructure.TransactionHandler
                {
                    public override void BeganTransaction(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.BeginTransactionInterceptionContext interceptionContext) => throw null;
                    public override string BuildDatabaseInitializationScript() => throw null;
                    public virtual void ClearTransactionHistory() => throw null;
                    public System.Threading.Tasks.Task ClearTransactionHistoryAsync() => throw null;
                    public virtual System.Threading.Tasks.Task ClearTransactionHistoryAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public override void Committed(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext) => throw null;
                    public CommitFailureHandler() => throw null;
                    public CommitFailureHandler(System.Func<System.Data.Common.DbConnection, System.Data.Entity.Infrastructure.TransactionContext> transactionContextFactory) => throw null;
                    protected override void Dispose(bool disposing) => throw null;
                    public override void Disposed(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext) => throw null;
                    public static System.Data.Entity.Infrastructure.CommitFailureHandler FromContext(System.Data.Entity.DbContext context) => throw null;
                    public static System.Data.Entity.Infrastructure.CommitFailureHandler FromContext(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                    protected virtual System.Data.Entity.Infrastructure.IDbExecutionStrategy GetExecutionStrategy() => throw null;
                    public override void Initialize(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                    public override void Initialize(System.Data.Entity.DbContext context, System.Data.Common.DbConnection connection) => throw null;
                    protected virtual void MarkTransactionForPruning(System.Data.Entity.Infrastructure.TransactionRow transaction) => throw null;
                    public void PruneTransactionHistory() => throw null;
                    protected virtual void PruneTransactionHistory(bool force, bool useExecutionStrategy) => throw null;
                    public System.Threading.Tasks.Task PruneTransactionHistoryAsync() => throw null;
                    public System.Threading.Tasks.Task PruneTransactionHistoryAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    protected virtual System.Threading.Tasks.Task PruneTransactionHistoryAsync(bool force, bool useExecutionStrategy, System.Threading.CancellationToken cancellationToken) => throw null;
                    protected virtual int PruningLimit { get => throw null; }
                    public override void RolledBack(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext) => throw null;
                    protected System.Data.Entity.Infrastructure.TransactionContext TransactionContext { get => throw null; }
                    protected System.Collections.Generic.Dictionary<System.Data.Common.DbTransaction, System.Data.Entity.Infrastructure.TransactionRow> Transactions { get => throw null; }
                }
                public class DbChangeTracker
                {
                    public void DetectChanges() => throw null;
                    public System.Collections.Generic.IEnumerable<System.Data.Entity.Infrastructure.DbEntityEntry> Entries() => throw null;
                    public System.Collections.Generic.IEnumerable<System.Data.Entity.Infrastructure.DbEntityEntry<TEntity>> Entries<TEntity>() where TEntity : class => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Type GetType() => throw null;
                    public bool HasChanges() => throw null;
                    public override string ToString() => throw null;
                }
                public class DbCollectionEntry : System.Data.Entity.Infrastructure.DbMemberEntry
                {
                    public System.Data.Entity.Infrastructure.DbCollectionEntry<TEntity, TElement> Cast<TEntity, TElement>() where TEntity : class => throw null;
                    public override object CurrentValue { get => throw null; set { } }
                    public override System.Data.Entity.Infrastructure.DbEntityEntry EntityEntry { get => throw null; }
                    public bool IsLoaded { get => throw null; set { } }
                    public void Load() => throw null;
                    public System.Threading.Tasks.Task LoadAsync() => throw null;
                    public System.Threading.Tasks.Task LoadAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public override string Name { get => throw null; }
                    public System.Linq.IQueryable Query() => throw null;
                }
                public class DbCollectionEntry<TEntity, TElement> : System.Data.Entity.Infrastructure.DbMemberEntry<TEntity, System.Collections.Generic.ICollection<TElement>> where TEntity : class
                {
                    public override System.Collections.Generic.ICollection<TElement> CurrentValue { get => throw null; set { } }
                    public override System.Data.Entity.Infrastructure.DbEntityEntry<TEntity> EntityEntry { get => throw null; }
                    public bool IsLoaded { get => throw null; set { } }
                    public void Load() => throw null;
                    public System.Threading.Tasks.Task LoadAsync() => throw null;
                    public System.Threading.Tasks.Task LoadAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public override string Name { get => throw null; }
                    public static implicit operator System.Data.Entity.Infrastructure.DbCollectionEntry(System.Data.Entity.Infrastructure.DbCollectionEntry<TEntity, TElement> entry) => throw null;
                    public System.Linq.IQueryable<TElement> Query() => throw null;
                }
                public class DbCompiledModel
                {
                    public TContext CreateObjectContext<TContext>(System.Data.Common.DbConnection existingConnection) where TContext : System.Data.Entity.Core.Objects.ObjectContext => throw null;
                }
                public class DbComplexPropertyEntry : System.Data.Entity.Infrastructure.DbPropertyEntry
                {
                    public System.Data.Entity.Infrastructure.DbComplexPropertyEntry<TEntity, TComplexProperty> Cast<TEntity, TComplexProperty>() where TEntity : class => throw null;
                    public System.Data.Entity.Infrastructure.DbComplexPropertyEntry ComplexProperty(string propertyName) => throw null;
                    public System.Data.Entity.Infrastructure.DbPropertyEntry Property(string propertyName) => throw null;
                }
                public class DbComplexPropertyEntry<TEntity, TComplexProperty> : System.Data.Entity.Infrastructure.DbPropertyEntry<TEntity, TComplexProperty> where TEntity : class
                {
                    public System.Data.Entity.Infrastructure.DbComplexPropertyEntry ComplexProperty(string propertyName) => throw null;
                    public System.Data.Entity.Infrastructure.DbComplexPropertyEntry<TEntity, TNestedComplexProperty> ComplexProperty<TNestedComplexProperty>(string propertyName) => throw null;
                    public System.Data.Entity.Infrastructure.DbComplexPropertyEntry<TEntity, TNestedComplexProperty> ComplexProperty<TNestedComplexProperty>(System.Linq.Expressions.Expression<System.Func<TComplexProperty, TNestedComplexProperty>> property) => throw null;
                    public static implicit operator System.Data.Entity.Infrastructure.DbComplexPropertyEntry(System.Data.Entity.Infrastructure.DbComplexPropertyEntry<TEntity, TComplexProperty> entry) => throw null;
                    public System.Data.Entity.Infrastructure.DbPropertyEntry Property(string propertyName) => throw null;
                    public System.Data.Entity.Infrastructure.DbPropertyEntry<TEntity, TNestedProperty> Property<TNestedProperty>(string propertyName) => throw null;
                    public System.Data.Entity.Infrastructure.DbPropertyEntry<TEntity, TNestedProperty> Property<TNestedProperty>(System.Linq.Expressions.Expression<System.Func<TComplexProperty, TNestedProperty>> property) => throw null;
                }
                public class DbConnectionInfo
                {
                    public DbConnectionInfo(string connectionName) => throw null;
                    public DbConnectionInfo(string connectionString, string providerInvariantName) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Type GetType() => throw null;
                    public override string ToString() => throw null;
                }
                public enum DbConnectionStringOrigin
                {
                    Convention = 0,
                    Configuration = 1,
                    UserCode = 2,
                    DbContextInfo = 3,
                }
                public class DbContextConfiguration
                {
                    public bool AutoDetectChangesEnabled { get => throw null; set { } }
                    public bool DisableFilterOverProjectionSimplificationForCustomFunctions { get => throw null; set { } }
                    public bool EnsureTransactionsForFunctionsAndCommands { get => throw null; set { } }
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Type GetType() => throw null;
                    public bool LazyLoadingEnabled { get => throw null; set { } }
                    public bool ProxyCreationEnabled { get => throw null; set { } }
                    public override string ToString() => throw null;
                    public bool UseDatabaseNullSemantics { get => throw null; set { } }
                    public bool ValidateOnSaveEnabled { get => throw null; set { } }
                }
                public class DbContextInfo
                {
                    public virtual string ConnectionProviderName { get => throw null; }
                    public virtual string ConnectionString { get => throw null; }
                    public virtual string ConnectionStringName { get => throw null; }
                    public virtual System.Data.Entity.Infrastructure.DbConnectionStringOrigin ConnectionStringOrigin { get => throw null; }
                    public virtual System.Type ContextType { get => throw null; }
                    public virtual System.Data.Entity.DbContext CreateInstance() => throw null;
                    public DbContextInfo(System.Type contextType) => throw null;
                    public DbContextInfo(System.Type contextType, System.Data.Entity.Infrastructure.DbConnectionInfo connectionInfo) => throw null;
                    public DbContextInfo(System.Type contextType, System.Configuration.ConnectionStringSettingsCollection connectionStringSettings) => throw null;
                    public DbContextInfo(System.Type contextType, System.Configuration.Configuration config) => throw null;
                    public DbContextInfo(System.Type contextType, System.Configuration.Configuration config, System.Data.Entity.Infrastructure.DbConnectionInfo connectionInfo) => throw null;
                    public DbContextInfo(System.Type contextType, System.Data.Entity.Infrastructure.DbProviderInfo modelProviderInfo) => throw null;
                    public DbContextInfo(System.Type contextType, System.Configuration.Configuration config, System.Data.Entity.Infrastructure.DbProviderInfo modelProviderInfo) => throw null;
                    public virtual bool IsConstructible { get => throw null; }
                    public virtual System.Action<System.Data.Entity.DbModelBuilder> OnModelCreating { get => throw null; set { } }
                }
                public class DbEntityEntry
                {
                    public System.Data.Entity.Infrastructure.DbEntityEntry<TEntity> Cast<TEntity>() where TEntity : class => throw null;
                    public System.Data.Entity.Infrastructure.DbCollectionEntry Collection(string navigationProperty) => throw null;
                    public System.Data.Entity.Infrastructure.DbComplexPropertyEntry ComplexProperty(string propertyName) => throw null;
                    public System.Data.Entity.Infrastructure.DbPropertyValues CurrentValues { get => throw null; }
                    public object Entity { get => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public bool Equals(System.Data.Entity.Infrastructure.DbEntityEntry other) => throw null;
                    public System.Data.Entity.Infrastructure.DbPropertyValues GetDatabaseValues() => throw null;
                    public System.Threading.Tasks.Task<System.Data.Entity.Infrastructure.DbPropertyValues> GetDatabaseValuesAsync() => throw null;
                    public System.Threading.Tasks.Task<System.Data.Entity.Infrastructure.DbPropertyValues> GetDatabaseValuesAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Type GetType() => throw null;
                    public System.Data.Entity.Validation.DbEntityValidationResult GetValidationResult() => throw null;
                    public System.Data.Entity.Infrastructure.DbMemberEntry Member(string propertyName) => throw null;
                    public System.Data.Entity.Infrastructure.DbPropertyValues OriginalValues { get => throw null; }
                    public System.Data.Entity.Infrastructure.DbPropertyEntry Property(string propertyName) => throw null;
                    public System.Data.Entity.Infrastructure.DbReferenceEntry Reference(string navigationProperty) => throw null;
                    public void Reload() => throw null;
                    public System.Threading.Tasks.Task ReloadAsync() => throw null;
                    public System.Threading.Tasks.Task ReloadAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Data.Entity.EntityState State { get => throw null; set { } }
                    public override string ToString() => throw null;
                }
                public class DbEntityEntry<TEntity> where TEntity : class
                {
                    public System.Data.Entity.Infrastructure.DbCollectionEntry Collection(string navigationProperty) => throw null;
                    public System.Data.Entity.Infrastructure.DbCollectionEntry<TEntity, TElement> Collection<TElement>(string navigationProperty) where TElement : class => throw null;
                    public System.Data.Entity.Infrastructure.DbCollectionEntry<TEntity, TElement> Collection<TElement>(System.Linq.Expressions.Expression<System.Func<TEntity, System.Collections.Generic.ICollection<TElement>>> navigationProperty) where TElement : class => throw null;
                    public System.Data.Entity.Infrastructure.DbComplexPropertyEntry ComplexProperty(string propertyName) => throw null;
                    public System.Data.Entity.Infrastructure.DbComplexPropertyEntry<TEntity, TComplexProperty> ComplexProperty<TComplexProperty>(string propertyName) => throw null;
                    public System.Data.Entity.Infrastructure.DbComplexPropertyEntry<TEntity, TComplexProperty> ComplexProperty<TComplexProperty>(System.Linq.Expressions.Expression<System.Func<TEntity, TComplexProperty>> property) => throw null;
                    public System.Data.Entity.Infrastructure.DbPropertyValues CurrentValues { get => throw null; }
                    public TEntity Entity { get => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public bool Equals(System.Data.Entity.Infrastructure.DbEntityEntry<TEntity> other) => throw null;
                    public System.Data.Entity.Infrastructure.DbPropertyValues GetDatabaseValues() => throw null;
                    public System.Threading.Tasks.Task<System.Data.Entity.Infrastructure.DbPropertyValues> GetDatabaseValuesAsync() => throw null;
                    public System.Threading.Tasks.Task<System.Data.Entity.Infrastructure.DbPropertyValues> GetDatabaseValuesAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Type GetType() => throw null;
                    public System.Data.Entity.Validation.DbEntityValidationResult GetValidationResult() => throw null;
                    public System.Data.Entity.Infrastructure.DbMemberEntry Member(string propertyName) => throw null;
                    public System.Data.Entity.Infrastructure.DbMemberEntry<TEntity, TMember> Member<TMember>(string propertyName) => throw null;
                    public static implicit operator System.Data.Entity.Infrastructure.DbEntityEntry(System.Data.Entity.Infrastructure.DbEntityEntry<TEntity> entry) => throw null;
                    public System.Data.Entity.Infrastructure.DbPropertyValues OriginalValues { get => throw null; }
                    public System.Data.Entity.Infrastructure.DbPropertyEntry Property(string propertyName) => throw null;
                    public System.Data.Entity.Infrastructure.DbPropertyEntry<TEntity, TProperty> Property<TProperty>(string propertyName) => throw null;
                    public System.Data.Entity.Infrastructure.DbPropertyEntry<TEntity, TProperty> Property<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntity, TProperty>> property) => throw null;
                    public System.Data.Entity.Infrastructure.DbReferenceEntry Reference(string navigationProperty) => throw null;
                    public System.Data.Entity.Infrastructure.DbReferenceEntry<TEntity, TProperty> Reference<TProperty>(string navigationProperty) where TProperty : class => throw null;
                    public System.Data.Entity.Infrastructure.DbReferenceEntry<TEntity, TProperty> Reference<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntity, TProperty>> navigationProperty) where TProperty : class => throw null;
                    public void Reload() => throw null;
                    public System.Threading.Tasks.Task ReloadAsync() => throw null;
                    public System.Threading.Tasks.Task ReloadAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Data.Entity.EntityState State { get => throw null; set { } }
                    public override string ToString() => throw null;
                }
                public abstract class DbExecutionStrategy : System.Data.Entity.Infrastructure.IDbExecutionStrategy
                {
                    protected DbExecutionStrategy() => throw null;
                    protected DbExecutionStrategy(int maxRetryCount, System.TimeSpan maxDelay) => throw null;
                    public void Execute(System.Action operation) => throw null;
                    public TResult Execute<TResult>(System.Func<TResult> operation) => throw null;
                    public System.Threading.Tasks.Task ExecuteAsync(System.Func<System.Threading.Tasks.Task> operation, System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<TResult> ExecuteAsync<TResult>(System.Func<System.Threading.Tasks.Task<TResult>> operation, System.Threading.CancellationToken cancellationToken) => throw null;
                    protected virtual System.TimeSpan? GetNextDelay(System.Exception lastException) => throw null;
                    public bool RetriesOnFailure { get => throw null; }
                    protected abstract bool ShouldRetryOn(System.Exception exception);
                    protected static bool Suspended { get => throw null; set { } }
                    public static T UnwrapAndHandleException<T>(System.Exception exception, System.Func<System.Exception, T> exceptionHandler) => throw null;
                }
                public abstract class DbMemberEntry
                {
                    public System.Data.Entity.Infrastructure.DbMemberEntry<TEntity, TProperty> Cast<TEntity, TProperty>() where TEntity : class => throw null;
                    protected DbMemberEntry() => throw null;
                    public abstract object CurrentValue { get; set; }
                    public abstract System.Data.Entity.Infrastructure.DbEntityEntry EntityEntry { get; }
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Type GetType() => throw null;
                    public System.Collections.Generic.ICollection<System.Data.Entity.Validation.DbValidationError> GetValidationErrors() => throw null;
                    public abstract string Name { get; }
                    public override string ToString() => throw null;
                }
                public abstract class DbMemberEntry<TEntity, TProperty> where TEntity : class
                {
                    protected DbMemberEntry() => throw null;
                    public abstract TProperty CurrentValue { get; set; }
                    public abstract System.Data.Entity.Infrastructure.DbEntityEntry<TEntity> EntityEntry { get; }
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Type GetType() => throw null;
                    public System.Collections.Generic.ICollection<System.Data.Entity.Validation.DbValidationError> GetValidationErrors() => throw null;
                    public abstract string Name { get; }
                    public static implicit operator System.Data.Entity.Infrastructure.DbMemberEntry(System.Data.Entity.Infrastructure.DbMemberEntry<TEntity, TProperty> entry) => throw null;
                    public override string ToString() => throw null;
                }
                public class DbModel : System.Data.Entity.Core.Metadata.Edm.IEdmModelAdapter
                {
                    public System.Data.Entity.Infrastructure.DbCompiledModel Compile() => throw null;
                    public System.Data.Entity.Core.Metadata.Edm.EdmModel ConceptualModel { get => throw null; }
                    public System.Data.Entity.Core.Mapping.EntityContainerMapping ConceptualToStoreMapping { get => throw null; }
                    public System.Data.Entity.Infrastructure.DbProviderInfo ProviderInfo { get => throw null; }
                    public System.Data.Entity.Core.Common.DbProviderManifest ProviderManifest { get => throw null; }
                    public System.Data.Entity.Core.Metadata.Edm.EdmModel StoreModel { get => throw null; }
                }
                public abstract class DbModelStore
                {
                    protected DbModelStore() => throw null;
                    protected virtual string GetDefaultSchema(System.Type contextType) => throw null;
                    public abstract void Save(System.Type contextType, System.Data.Entity.Infrastructure.DbModel model);
                    public abstract System.Xml.Linq.XDocument TryGetEdmx(System.Type contextType);
                    public abstract System.Data.Entity.Infrastructure.DbCompiledModel TryLoad(System.Type contextType);
                }
                public class DbPropertyEntry : System.Data.Entity.Infrastructure.DbMemberEntry
                {
                    public System.Data.Entity.Infrastructure.DbPropertyEntry<TEntity, TProperty> Cast<TEntity, TProperty>() where TEntity : class => throw null;
                    public override object CurrentValue { get => throw null; set { } }
                    public override System.Data.Entity.Infrastructure.DbEntityEntry EntityEntry { get => throw null; }
                    public bool IsModified { get => throw null; set { } }
                    public override string Name { get => throw null; }
                    public object OriginalValue { get => throw null; set { } }
                    public System.Data.Entity.Infrastructure.DbComplexPropertyEntry ParentProperty { get => throw null; }
                }
                public class DbPropertyEntry<TEntity, TProperty> : System.Data.Entity.Infrastructure.DbMemberEntry<TEntity, TProperty> where TEntity : class
                {
                    public override TProperty CurrentValue { get => throw null; set { } }
                    public override System.Data.Entity.Infrastructure.DbEntityEntry<TEntity> EntityEntry { get => throw null; }
                    public bool IsModified { get => throw null; set { } }
                    public override string Name { get => throw null; }
                    public static implicit operator System.Data.Entity.Infrastructure.DbPropertyEntry(System.Data.Entity.Infrastructure.DbPropertyEntry<TEntity, TProperty> entry) => throw null;
                    public TProperty OriginalValue { get => throw null; set { } }
                    public System.Data.Entity.Infrastructure.DbComplexPropertyEntry ParentProperty { get => throw null; }
                }
                public class DbPropertyValues
                {
                    public System.Data.Entity.Infrastructure.DbPropertyValues Clone() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Type GetType() => throw null;
                    public TValue GetValue<TValue>(string propertyName) => throw null;
                    public System.Collections.Generic.IEnumerable<string> PropertyNames { get => throw null; }
                    public void SetValues(object obj) => throw null;
                    public void SetValues(System.Data.Entity.Infrastructure.DbPropertyValues propertyValues) => throw null;
                    public object this[string propertyName] { get => throw null; set { } }
                    public object ToObject() => throw null;
                    public override string ToString() => throw null;
                }
                public sealed class DbProviderInfo
                {
                    public DbProviderInfo(string providerInvariantName, string providerManifestToken) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public string ProviderInvariantName { get => throw null; }
                    public string ProviderManifestToken { get => throw null; }
                }
                public abstract class DbQuery : System.Data.Entity.Infrastructure.IDbAsyncEnumerable, System.Collections.IEnumerable, System.ComponentModel.IListSource, System.Linq.IOrderedQueryable, System.Linq.IQueryable
                {
                    public virtual System.Data.Entity.Infrastructure.DbQuery AsNoTracking() => throw null;
                    public virtual System.Data.Entity.Infrastructure.DbQuery AsStreaming() => throw null;
                    public System.Data.Entity.Infrastructure.DbQuery<TElement> Cast<TElement>() => throw null;
                    bool System.ComponentModel.IListSource.ContainsListCollection { get => throw null; }
                    public virtual System.Type ElementType { get => throw null; }
                    public override bool Equals(object obj) => throw null;
                    System.Linq.Expressions.Expression System.Linq.IQueryable.Expression { get => throw null; }
                    System.Data.Entity.Infrastructure.IDbAsyncEnumerator System.Data.Entity.Infrastructure.IDbAsyncEnumerable.GetAsyncEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public override int GetHashCode() => throw null;
                    System.Collections.IList System.ComponentModel.IListSource.GetList() => throw null;
                    public System.Type GetType() => throw null;
                    public virtual System.Data.Entity.Infrastructure.DbQuery Include(string path) => throw null;
                    System.Linq.IQueryProvider System.Linq.IQueryable.Provider { get => throw null; }
                    public string Sql { get => throw null; }
                    public override string ToString() => throw null;
                }
                public class DbQuery<TResult> : System.Data.Entity.Infrastructure.IDbAsyncEnumerable<TResult>, System.Data.Entity.Infrastructure.IDbAsyncEnumerable, System.Collections.Generic.IEnumerable<TResult>, System.Collections.IEnumerable, System.ComponentModel.IListSource, System.Linq.IOrderedQueryable<TResult>, System.Linq.IOrderedQueryable, System.Linq.IQueryable, System.Linq.IQueryable<TResult>
                {
                    public virtual System.Data.Entity.Infrastructure.DbQuery<TResult> AsNoTracking() => throw null;
                    public virtual System.Data.Entity.Infrastructure.DbQuery<TResult> AsStreaming() => throw null;
                    bool System.ComponentModel.IListSource.ContainsListCollection { get => throw null; }
                    System.Type System.Linq.IQueryable.ElementType { get => throw null; }
                    public override bool Equals(object obj) => throw null;
                    System.Linq.Expressions.Expression System.Linq.IQueryable.Expression { get => throw null; }
                    System.Data.Entity.Infrastructure.IDbAsyncEnumerator System.Data.Entity.Infrastructure.IDbAsyncEnumerable.GetAsyncEnumerator() => throw null;
                    System.Data.Entity.Infrastructure.IDbAsyncEnumerator<TResult> System.Data.Entity.Infrastructure.IDbAsyncEnumerable<TResult>.GetAsyncEnumerator() => throw null;
                    System.Collections.Generic.IEnumerator<TResult> System.Collections.Generic.IEnumerable<TResult>.GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public override int GetHashCode() => throw null;
                    System.Collections.IList System.ComponentModel.IListSource.GetList() => throw null;
                    public System.Type GetType() => throw null;
                    public virtual System.Data.Entity.Infrastructure.DbQuery<TResult> Include(string path) => throw null;
                    public static implicit operator System.Data.Entity.Infrastructure.DbQuery(System.Data.Entity.Infrastructure.DbQuery<TResult> entry) => throw null;
                    System.Linq.IQueryProvider System.Linq.IQueryable.Provider { get => throw null; }
                    public string Sql { get => throw null; }
                    public override string ToString() => throw null;
                }
                public class DbRawSqlQuery : System.Data.Entity.Infrastructure.IDbAsyncEnumerable, System.Collections.IEnumerable, System.ComponentModel.IListSource
                {
                    public virtual System.Data.Entity.Infrastructure.DbRawSqlQuery AsStreaming() => throw null;
                    bool System.ComponentModel.IListSource.ContainsListCollection { get => throw null; }
                    public override bool Equals(object obj) => throw null;
                    public virtual System.Threading.Tasks.Task ForEachAsync(System.Action<object> action) => throw null;
                    public virtual System.Threading.Tasks.Task ForEachAsync(System.Action<object> action, System.Threading.CancellationToken cancellationToken) => throw null;
                    System.Data.Entity.Infrastructure.IDbAsyncEnumerator System.Data.Entity.Infrastructure.IDbAsyncEnumerable.GetAsyncEnumerator() => throw null;
                    public virtual System.Collections.IEnumerator GetEnumerator() => throw null;
                    public override int GetHashCode() => throw null;
                    System.Collections.IList System.ComponentModel.IListSource.GetList() => throw null;
                    public System.Type GetType() => throw null;
                    public virtual System.Threading.Tasks.Task<System.Collections.Generic.List<object>> ToListAsync() => throw null;
                    public virtual System.Threading.Tasks.Task<System.Collections.Generic.List<object>> ToListAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public override string ToString() => throw null;
                }
                public class DbRawSqlQuery<TElement> : System.Data.Entity.Infrastructure.IDbAsyncEnumerable<TElement>, System.Data.Entity.Infrastructure.IDbAsyncEnumerable, System.Collections.Generic.IEnumerable<TElement>, System.Collections.IEnumerable, System.ComponentModel.IListSource
                {
                    public System.Threading.Tasks.Task<bool> AllAsync(System.Func<TElement, bool> predicate) => throw null;
                    public System.Threading.Tasks.Task<bool> AllAsync(System.Func<TElement, bool> predicate, System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<bool> AnyAsync() => throw null;
                    public System.Threading.Tasks.Task<bool> AnyAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<bool> AnyAsync(System.Func<TElement, bool> predicate) => throw null;
                    public System.Threading.Tasks.Task<bool> AnyAsync(System.Func<TElement, bool> predicate, System.Threading.CancellationToken cancellationToken) => throw null;
                    public virtual System.Data.Entity.Infrastructure.DbRawSqlQuery<TElement> AsStreaming() => throw null;
                    public System.Threading.Tasks.Task<bool> ContainsAsync(TElement value) => throw null;
                    public System.Threading.Tasks.Task<bool> ContainsAsync(TElement value, System.Threading.CancellationToken cancellationToken) => throw null;
                    bool System.ComponentModel.IListSource.ContainsListCollection { get => throw null; }
                    public System.Threading.Tasks.Task<int> CountAsync() => throw null;
                    public System.Threading.Tasks.Task<int> CountAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<int> CountAsync(System.Func<TElement, bool> predicate) => throw null;
                    public System.Threading.Tasks.Task<int> CountAsync(System.Func<TElement, bool> predicate, System.Threading.CancellationToken cancellationToken) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public System.Threading.Tasks.Task<TElement> FirstAsync() => throw null;
                    public System.Threading.Tasks.Task<TElement> FirstAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<TElement> FirstAsync(System.Func<TElement, bool> predicate) => throw null;
                    public System.Threading.Tasks.Task<TElement> FirstAsync(System.Func<TElement, bool> predicate, System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<TElement> FirstOrDefaultAsync() => throw null;
                    public System.Threading.Tasks.Task<TElement> FirstOrDefaultAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<TElement> FirstOrDefaultAsync(System.Func<TElement, bool> predicate) => throw null;
                    public System.Threading.Tasks.Task<TElement> FirstOrDefaultAsync(System.Func<TElement, bool> predicate, System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task ForEachAsync(System.Action<TElement> action) => throw null;
                    public System.Threading.Tasks.Task ForEachAsync(System.Action<TElement> action, System.Threading.CancellationToken cancellationToken) => throw null;
                    System.Data.Entity.Infrastructure.IDbAsyncEnumerator<TElement> System.Data.Entity.Infrastructure.IDbAsyncEnumerable<TElement>.GetAsyncEnumerator() => throw null;
                    System.Data.Entity.Infrastructure.IDbAsyncEnumerator System.Data.Entity.Infrastructure.IDbAsyncEnumerable.GetAsyncEnumerator() => throw null;
                    public virtual System.Collections.Generic.IEnumerator<TElement> GetEnumerator() => throw null;
                    System.Collections.IEnumerator System.Collections.IEnumerable.GetEnumerator() => throw null;
                    public override int GetHashCode() => throw null;
                    System.Collections.IList System.ComponentModel.IListSource.GetList() => throw null;
                    public System.Type GetType() => throw null;
                    public System.Threading.Tasks.Task<long> LongCountAsync() => throw null;
                    public System.Threading.Tasks.Task<long> LongCountAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<long> LongCountAsync(System.Func<TElement, bool> predicate) => throw null;
                    public System.Threading.Tasks.Task<long> LongCountAsync(System.Func<TElement, bool> predicate, System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<TElement> MaxAsync() => throw null;
                    public System.Threading.Tasks.Task<TElement> MaxAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<TElement> MinAsync() => throw null;
                    public System.Threading.Tasks.Task<TElement> MinAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<TElement> SingleAsync() => throw null;
                    public System.Threading.Tasks.Task<TElement> SingleAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<TElement> SingleAsync(System.Func<TElement, bool> predicate) => throw null;
                    public System.Threading.Tasks.Task<TElement> SingleAsync(System.Func<TElement, bool> predicate, System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<TElement> SingleOrDefaultAsync() => throw null;
                    public System.Threading.Tasks.Task<TElement> SingleOrDefaultAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<TElement> SingleOrDefaultAsync(System.Func<TElement, bool> predicate) => throw null;
                    public System.Threading.Tasks.Task<TElement> SingleOrDefaultAsync(System.Func<TElement, bool> predicate, System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<TElement[]> ToArrayAsync() => throw null;
                    public System.Threading.Tasks.Task<TElement[]> ToArrayAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<TKey, TElement>> ToDictionaryAsync<TKey>(System.Func<TElement, TKey> keySelector) => throw null;
                    public System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<TKey, TElement>> ToDictionaryAsync<TKey>(System.Func<TElement, TKey> keySelector, System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<TKey, TElement>> ToDictionaryAsync<TKey>(System.Func<TElement, TKey> keySelector, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
                    public System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<TKey, TElement>> ToDictionaryAsync<TKey>(System.Func<TElement, TKey> keySelector, System.Collections.Generic.IEqualityComparer<TKey> comparer, System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<TKey, TResult>> ToDictionaryAsync<TKey, TResult>(System.Func<TElement, TKey> keySelector, System.Func<TElement, TResult> elementSelector) => throw null;
                    public System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<TKey, TResult>> ToDictionaryAsync<TKey, TResult>(System.Func<TElement, TKey> keySelector, System.Func<TElement, TResult> elementSelector, System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<TKey, TResult>> ToDictionaryAsync<TKey, TResult>(System.Func<TElement, TKey> keySelector, System.Func<TElement, TResult> elementSelector, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
                    public System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<TKey, TResult>> ToDictionaryAsync<TKey, TResult>(System.Func<TElement, TKey> keySelector, System.Func<TElement, TResult> elementSelector, System.Collections.Generic.IEqualityComparer<TKey> comparer, System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<System.Collections.Generic.List<TElement>> ToListAsync() => throw null;
                    public System.Threading.Tasks.Task<System.Collections.Generic.List<TElement>> ToListAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public override string ToString() => throw null;
                }
                public class DbReferenceEntry : System.Data.Entity.Infrastructure.DbMemberEntry
                {
                    public System.Data.Entity.Infrastructure.DbReferenceEntry<TEntity, TProperty> Cast<TEntity, TProperty>() where TEntity : class => throw null;
                    public override object CurrentValue { get => throw null; set { } }
                    public override System.Data.Entity.Infrastructure.DbEntityEntry EntityEntry { get => throw null; }
                    public bool IsLoaded { get => throw null; set { } }
                    public void Load() => throw null;
                    public System.Threading.Tasks.Task LoadAsync() => throw null;
                    public System.Threading.Tasks.Task LoadAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public override string Name { get => throw null; }
                    public System.Linq.IQueryable Query() => throw null;
                }
                public class DbReferenceEntry<TEntity, TProperty> : System.Data.Entity.Infrastructure.DbMemberEntry<TEntity, TProperty> where TEntity : class
                {
                    public override TProperty CurrentValue { get => throw null; set { } }
                    public override System.Data.Entity.Infrastructure.DbEntityEntry<TEntity> EntityEntry { get => throw null; }
                    public bool IsLoaded { get => throw null; set { } }
                    public void Load() => throw null;
                    public System.Threading.Tasks.Task LoadAsync() => throw null;
                    public System.Threading.Tasks.Task LoadAsync(System.Threading.CancellationToken cancellationToken) => throw null;
                    public override string Name { get => throw null; }
                    public static implicit operator System.Data.Entity.Infrastructure.DbReferenceEntry(System.Data.Entity.Infrastructure.DbReferenceEntry<TEntity, TProperty> entry) => throw null;
                    public System.Linq.IQueryable<TProperty> Query() => throw null;
                }
                public class DbSqlQuery : System.Data.Entity.Infrastructure.DbRawSqlQuery
                {
                    public virtual System.Data.Entity.Infrastructure.DbSqlQuery AsNoTracking() => throw null;
                    public virtual System.Data.Entity.Infrastructure.DbSqlQuery AsStreaming() => throw null;
                    protected DbSqlQuery() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Type GetType() => throw null;
                    public override string ToString() => throw null;
                }
                public class DbSqlQuery<TEntity> : System.Data.Entity.Infrastructure.DbRawSqlQuery<TEntity> where TEntity : class
                {
                    public virtual System.Data.Entity.Infrastructure.DbSqlQuery<TEntity> AsNoTracking() => throw null;
                    public virtual System.Data.Entity.Infrastructure.DbSqlQuery<TEntity> AsStreaming() => throw null;
                    protected DbSqlQuery() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Type GetType() => throw null;
                    public override string ToString() => throw null;
                }
                public class DbUpdateConcurrencyException : System.Data.Entity.Infrastructure.DbUpdateException
                {
                    public DbUpdateConcurrencyException() => throw null;
                    public DbUpdateConcurrencyException(string message) => throw null;
                    public DbUpdateConcurrencyException(string message, System.Exception innerException) => throw null;
                    protected DbUpdateConcurrencyException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class DbUpdateException : System.Data.DataException
                {
                    public DbUpdateException() => throw null;
                    public DbUpdateException(string message) => throw null;
                    public DbUpdateException(string message, System.Exception innerException) => throw null;
                    protected DbUpdateException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public System.Collections.Generic.IEnumerable<System.Data.Entity.Infrastructure.DbEntityEntry> Entries { get => throw null; }
                    public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class DefaultDbModelStore : System.Data.Entity.Infrastructure.DbModelStore
                {
                    public DefaultDbModelStore(string directory) => throw null;
                    public string Directory { get => throw null; }
                    protected virtual bool FileIsValid(System.Type contextType, string filePath) => throw null;
                    protected virtual string GetFilePath(System.Type contextType) => throw null;
                    public override void Save(System.Type contextType, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                    public override System.Xml.Linq.XDocument TryGetEdmx(System.Type contextType) => throw null;
                    public override System.Data.Entity.Infrastructure.DbCompiledModel TryLoad(System.Type contextType) => throw null;
                }
                public class DefaultExecutionStrategy : System.Data.Entity.Infrastructure.IDbExecutionStrategy
                {
                    public DefaultExecutionStrategy() => throw null;
                    public void Execute(System.Action operation) => throw null;
                    public TResult Execute<TResult>(System.Func<TResult> operation) => throw null;
                    public System.Threading.Tasks.Task ExecuteAsync(System.Func<System.Threading.Tasks.Task> operation, System.Threading.CancellationToken cancellationToken) => throw null;
                    public System.Threading.Tasks.Task<TResult> ExecuteAsync<TResult>(System.Func<System.Threading.Tasks.Task<TResult>> operation, System.Threading.CancellationToken cancellationToken) => throw null;
                    public bool RetriesOnFailure { get => throw null; }
                }
                public class DefaultManifestTokenResolver : System.Data.Entity.Infrastructure.IManifestTokenResolver
                {
                    public DefaultManifestTokenResolver() => throw null;
                    public string ResolveManifestToken(System.Data.Common.DbConnection connection) => throw null;
                }
                namespace DependencyResolution
                {
                    public class DbConfigurationLoadedEventArgs : System.EventArgs
                    {
                        public void AddDefaultResolver(System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver resolver) => throw null;
                        public void AddDependencyResolver(System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver resolver, bool overrideConfigFile) => throw null;
                        public System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver DependencyResolver { get => throw null; }
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public void ReplaceService<TService>(System.Func<TService, object, TService> serviceInterceptor) => throw null;
                        public override string ToString() => throw null;
                    }
                    public static partial class DbDependencyResolverExtensions
                    {
                        public static T GetService<T>(this System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver resolver, object key) => throw null;
                        public static T GetService<T>(this System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver resolver) => throw null;
                        public static object GetService(this System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver resolver, System.Type type) => throw null;
                        public static System.Collections.Generic.IEnumerable<T> GetServices<T>(this System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver resolver, object key) => throw null;
                        public static System.Collections.Generic.IEnumerable<T> GetServices<T>(this System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver resolver) => throw null;
                        public static System.Collections.Generic.IEnumerable<object> GetServices(this System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver resolver, System.Type type) => throw null;
                    }
                    public class ExecutionStrategyResolver<T> : System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver where T : System.Data.Entity.Infrastructure.IDbExecutionStrategy
                    {
                        public ExecutionStrategyResolver(string providerInvariantName, string serverName, System.Func<T> getExecutionStrategy) => throw null;
                        public object GetService(System.Type type, object key) => throw null;
                        public System.Collections.Generic.IEnumerable<object> GetServices(System.Type type, object key) => throw null;
                    }
                    public interface IDbDependencyResolver
                    {
                        object GetService(System.Type type, object key);
                        System.Collections.Generic.IEnumerable<object> GetServices(System.Type type, object key);
                    }
                    public class SingletonDependencyResolver<T> : System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver where T : class
                    {
                        public SingletonDependencyResolver(T singletonInstance) => throw null;
                        public SingletonDependencyResolver(T singletonInstance, object key) => throw null;
                        public SingletonDependencyResolver(T singletonInstance, System.Func<object, bool> keyPredicate) => throw null;
                        public object GetService(System.Type type, object key) => throw null;
                        public System.Collections.Generic.IEnumerable<object> GetServices(System.Type type, object key) => throw null;
                    }
                    public class TransactionHandlerResolver : System.Data.Entity.Infrastructure.DependencyResolution.IDbDependencyResolver
                    {
                        public TransactionHandlerResolver(System.Func<System.Data.Entity.Infrastructure.TransactionHandler> transactionHandlerFactory, string providerInvariantName, string serverName) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public object GetService(System.Type type, object key) => throw null;
                        public System.Collections.Generic.IEnumerable<object> GetServices(System.Type type, object key) => throw null;
                    }
                }
                namespace Design
                {
                    public class AppConfigReader
                    {
                        public AppConfigReader(System.Configuration.Configuration configuration) => throw null;
                        public string GetProviderServices(string invariantName) => throw null;
                    }
                    public class Executor : System.MarshalByRefObject
                    {
                        public Executor(string assemblyFile, System.Collections.Generic.IDictionary<string, object> anonymousArguments) => throw null;
                        public class GetContextType : System.Data.Entity.Infrastructure.Design.Executor.OperationBase
                        {
                            public GetContextType(System.Data.Entity.Infrastructure.Design.Executor executor, object resultHandler, System.Collections.IDictionary args) : base(default(object)) => throw null;
                        }
                        public class GetDatabaseMigrations : System.Data.Entity.Infrastructure.Design.Executor.OperationBase
                        {
                            public GetDatabaseMigrations(System.Data.Entity.Infrastructure.Design.Executor executor, object resultHandler, System.Collections.IDictionary args) : base(default(object)) => throw null;
                        }
                        public abstract class OperationBase : System.MarshalByRefObject
                        {
                            protected static System.Data.Entity.Infrastructure.DbConnectionInfo CreateConnectionInfo(string connectionStringName, string connectionString, string connectionProviderName) => throw null;
                            protected OperationBase(object handler) => throw null;
                            protected virtual void Execute(System.Action action) => throw null;
                            protected virtual void Execute<T>(System.Func<T> action) => throw null;
                            protected virtual void Execute<T>(System.Func<System.Collections.Generic.IEnumerable<T>> action) => throw null;
                        }
                        public class Scaffold : System.Data.Entity.Infrastructure.Design.Executor.OperationBase
                        {
                            public Scaffold(System.Data.Entity.Infrastructure.Design.Executor executor, object resultHandler, System.Collections.IDictionary args) : base(default(object)) => throw null;
                        }
                        public class ScaffoldInitialCreate : System.Data.Entity.Infrastructure.Design.Executor.OperationBase
                        {
                            public ScaffoldInitialCreate(System.Data.Entity.Infrastructure.Design.Executor executor, object resultHandler, System.Collections.IDictionary args) : base(default(object)) => throw null;
                        }
                        public class ScriptUpdate : System.Data.Entity.Infrastructure.Design.Executor.OperationBase
                        {
                            public ScriptUpdate(System.Data.Entity.Infrastructure.Design.Executor executor, object resultHandler, System.Collections.IDictionary args) : base(default(object)) => throw null;
                        }
                        public class Update : System.Data.Entity.Infrastructure.Design.Executor.OperationBase
                        {
                            public Update(System.Data.Entity.Infrastructure.Design.Executor executor, object resultHandler, System.Collections.IDictionary args) : base(default(object)) => throw null;
                        }
                    }
                    public abstract class HandlerBase : System.MarshalByRefObject
                    {
                        protected HandlerBase() => throw null;
                        public virtual bool ImplementsContract(string interfaceName) => throw null;
                    }
                    public interface IReportHandler
                    {
                        void OnError(string message);
                        void OnInformation(string message);
                        void OnVerbose(string message);
                        void OnWarning(string message);
                    }
                    public interface IResultHandler
                    {
                        void SetResult(object value);
                    }
                    public interface IResultHandler2 : System.Data.Entity.Infrastructure.Design.IResultHandler
                    {
                        void SetError(string type, string message, string stackTrace);
                    }
                    public class ReportHandler : System.Data.Entity.Infrastructure.Design.HandlerBase, System.Data.Entity.Infrastructure.Design.IReportHandler
                    {
                        public ReportHandler(System.Action<string> errorHandler, System.Action<string> warningHandler, System.Action<string> informationHandler, System.Action<string> verboseHandler) => throw null;
                        public virtual void OnError(string message) => throw null;
                        public virtual void OnInformation(string message) => throw null;
                        public virtual void OnVerbose(string message) => throw null;
                        public virtual void OnWarning(string message) => throw null;
                    }
                    public class ResultHandler : System.Data.Entity.Infrastructure.Design.HandlerBase, System.Data.Entity.Infrastructure.Design.IResultHandler, System.Data.Entity.Infrastructure.Design.IResultHandler2
                    {
                        public ResultHandler() => throw null;
                        public virtual string ErrorMessage { get => throw null; }
                        public virtual string ErrorStackTrace { get => throw null; }
                        public virtual string ErrorType { get => throw null; }
                        public virtual bool HasResult { get => throw null; }
                        public virtual object Result { get => throw null; }
                        public virtual void SetError(string type, string message, string stackTrace) => throw null;
                        public virtual void SetResult(object value) => throw null;
                    }
                }
                public class EdmMetadata
                {
                    public EdmMetadata() => throw null;
                    public int Id { get => throw null; set { } }
                    public string ModelHash { get => throw null; set { } }
                    public static string TryGetModelHash(System.Data.Entity.DbContext context) => throw null;
                }
                public static class EdmxReader
                {
                    public static System.Data.Entity.Infrastructure.DbCompiledModel Read(System.Xml.XmlReader reader, string defaultSchema) => throw null;
                }
                public static class EdmxWriter
                {
                    public static void WriteEdmx(System.Data.Entity.DbContext context, System.Xml.XmlWriter writer) => throw null;
                    public static void WriteEdmx(System.Data.Entity.Infrastructure.DbModel model, System.Xml.XmlWriter writer) => throw null;
                }
                public class ExecutionStrategyKey
                {
                    public ExecutionStrategyKey(string providerInvariantName, string serverName) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public string ProviderInvariantName { get => throw null; }
                    public string ServerName { get => throw null; }
                }
                public interface IDbAsyncEnumerable
                {
                    System.Data.Entity.Infrastructure.IDbAsyncEnumerator GetAsyncEnumerator();
                }
                public interface IDbAsyncEnumerable<T> : System.Data.Entity.Infrastructure.IDbAsyncEnumerable
                {
                    System.Data.Entity.Infrastructure.IDbAsyncEnumerator<T> GetAsyncEnumerator();
                }
                public interface IDbAsyncEnumerator : System.IDisposable
                {
                    object Current { get; }
                    System.Threading.Tasks.Task<bool> MoveNextAsync(System.Threading.CancellationToken cancellationToken);
                }
                public interface IDbAsyncEnumerator<T> : System.Data.Entity.Infrastructure.IDbAsyncEnumerator, System.IDisposable
                {
                    T Current { get; }
                }
                public interface IDbAsyncQueryProvider : System.Linq.IQueryProvider
                {
                    System.Threading.Tasks.Task<object> ExecuteAsync(System.Linq.Expressions.Expression expression, System.Threading.CancellationToken cancellationToken);
                    System.Threading.Tasks.Task<TResult> ExecuteAsync<TResult>(System.Linq.Expressions.Expression expression, System.Threading.CancellationToken cancellationToken);
                }
                public interface IDbConnectionFactory
                {
                    System.Data.Common.DbConnection CreateConnection(string nameOrConnectionString);
                }
                public interface IDbContextFactory<TContext> where TContext : System.Data.Entity.DbContext
                {
                    TContext Create();
                }
                public interface IDbExecutionStrategy
                {
                    void Execute(System.Action operation);
                    TResult Execute<TResult>(System.Func<TResult> operation);
                    System.Threading.Tasks.Task ExecuteAsync(System.Func<System.Threading.Tasks.Task> operation, System.Threading.CancellationToken cancellationToken);
                    System.Threading.Tasks.Task<TResult> ExecuteAsync<TResult>(System.Func<System.Threading.Tasks.Task<TResult>> operation, System.Threading.CancellationToken cancellationToken);
                    bool RetriesOnFailure { get; }
                }
                public interface IDbModelCacheKey
                {
                    bool Equals(object other);
                    int GetHashCode();
                }
                public interface IDbModelCacheKeyProvider
                {
                    string CacheKey { get; }
                }
                public interface IDbProviderFactoryResolver
                {
                    System.Data.Common.DbProviderFactory ResolveProviderFactory(System.Data.Common.DbConnection connection);
                }
                public interface IManifestTokenResolver
                {
                    string ResolveManifestToken(System.Data.Common.DbConnection connection);
                }
                public interface IMetadataAnnotationSerializer
                {
                    object Deserialize(string name, string value);
                    string Serialize(string name, object value);
                }
                public class IncludeMetadataConvention : System.Data.Entity.ModelConfiguration.Conventions.Convention
                {
                    public IncludeMetadataConvention() => throw null;
                }
                namespace Interception
                {
                    public class BeginTransactionInterceptionContext : System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<System.Data.Common.DbTransaction>
                    {
                        public System.Data.Entity.Infrastructure.Interception.BeginTransactionInterceptionContext AsAsync() => throw null;
                        protected override System.Data.Entity.Infrastructure.Interception.DbInterceptionContext Clone() => throw null;
                        public BeginTransactionInterceptionContext() => throw null;
                        public BeginTransactionInterceptionContext(System.Data.Entity.Infrastructure.Interception.DbInterceptionContext copyFrom) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.IsolationLevel IsolationLevel { get => throw null; }
                        public override string ToString() => throw null;
                        public System.Data.Entity.Infrastructure.Interception.BeginTransactionInterceptionContext WithDbContext(System.Data.Entity.DbContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.BeginTransactionInterceptionContext WithIsolationLevel(System.Data.IsolationLevel isolationLevel) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.BeginTransactionInterceptionContext WithObjectContext(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                    }
                    public class DatabaseLogFormatter : System.Data.Entity.Infrastructure.Interception.IDbCommandInterceptor, System.Data.Entity.Infrastructure.Interception.IDbConnectionInterceptor, System.Data.Entity.Infrastructure.Interception.IDbInterceptor, System.Data.Entity.Infrastructure.Interception.IDbTransactionInterceptor
                    {
                        public virtual void BeganTransaction(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.BeginTransactionInterceptionContext interceptionContext) => throw null;
                        public virtual void BeginningTransaction(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.BeginTransactionInterceptionContext interceptionContext) => throw null;
                        public virtual void Closed(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext) => throw null;
                        public virtual void Closing(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext) => throw null;
                        public virtual void Committed(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext) => throw null;
                        public virtual void Committing(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext) => throw null;
                        public virtual void ConnectionGetting(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext<System.Data.Common.DbConnection> interceptionContext) => throw null;
                        public virtual void ConnectionGot(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext<System.Data.Common.DbConnection> interceptionContext) => throw null;
                        public virtual void ConnectionStringGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext) => throw null;
                        public virtual void ConnectionStringGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext) => throw null;
                        public virtual void ConnectionStringSet(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionPropertyInterceptionContext<string> interceptionContext) => throw null;
                        public virtual void ConnectionStringSetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionPropertyInterceptionContext<string> interceptionContext) => throw null;
                        public virtual void ConnectionTimeoutGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<int> interceptionContext) => throw null;
                        public virtual void ConnectionTimeoutGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<int> interceptionContext) => throw null;
                        protected System.Data.Entity.DbContext Context { get => throw null; }
                        public DatabaseLogFormatter(System.Action<string> writeAction) => throw null;
                        public DatabaseLogFormatter(System.Data.Entity.DbContext context, System.Action<string> writeAction) => throw null;
                        public virtual void DatabaseGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext) => throw null;
                        public virtual void DatabaseGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext) => throw null;
                        public virtual void DataSourceGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext) => throw null;
                        public virtual void DataSourceGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext) => throw null;
                        public virtual void Disposed(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext) => throw null;
                        public virtual void Disposed(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext) => throw null;
                        public virtual void Disposing(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext) => throw null;
                        public virtual void Disposing(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext) => throw null;
                        public virtual void EnlistedTransaction(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.EnlistTransactionInterceptionContext interceptionContext) => throw null;
                        public virtual void EnlistingTransaction(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.EnlistTransactionInterceptionContext interceptionContext) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public virtual void Executed<TResult>(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<TResult> interceptionContext) => throw null;
                        public virtual void Executing<TResult>(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<TResult> interceptionContext) => throw null;
                        public override int GetHashCode() => throw null;
                        protected System.Diagnostics.Stopwatch GetStopwatch(System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext interceptionContext) => throw null;
                        public System.Type GetType() => throw null;
                        public virtual void IsolationLevelGetting(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext<System.Data.IsolationLevel> interceptionContext) => throw null;
                        public virtual void IsolationLevelGot(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext<System.Data.IsolationLevel> interceptionContext) => throw null;
                        public virtual void LogCommand<TResult>(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<TResult> interceptionContext) => throw null;
                        public virtual void LogParameter<TResult>(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<TResult> interceptionContext, System.Data.Common.DbParameter parameter) => throw null;
                        public virtual void LogResult<TResult>(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<TResult> interceptionContext) => throw null;
                        public virtual void NonQueryExecuted(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<int> interceptionContext) => throw null;
                        public virtual void NonQueryExecuting(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<int> interceptionContext) => throw null;
                        public virtual void Opened(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext) => throw null;
                        public virtual void Opening(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext) => throw null;
                        public virtual void ReaderExecuted(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<System.Data.Common.DbDataReader> interceptionContext) => throw null;
                        public virtual void ReaderExecuting(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<System.Data.Common.DbDataReader> interceptionContext) => throw null;
                        public virtual void RolledBack(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext) => throw null;
                        public virtual void RollingBack(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext) => throw null;
                        public virtual void ScalarExecuted(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<object> interceptionContext) => throw null;
                        public virtual void ScalarExecuting(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<object> interceptionContext) => throw null;
                        public virtual void ServerVersionGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext) => throw null;
                        public virtual void ServerVersionGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext) => throw null;
                        public virtual void StateGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<System.Data.ConnectionState> interceptionContext) => throw null;
                        public virtual void StateGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<System.Data.ConnectionState> interceptionContext) => throw null;
                        protected System.Diagnostics.Stopwatch Stopwatch { get => throw null; }
                        public override string ToString() => throw null;
                        protected virtual void Write(string output) => throw null;
                    }
                    public class DatabaseLogger : System.Data.Entity.Infrastructure.Interception.IDbConfigurationInterceptor, System.Data.Entity.Infrastructure.Interception.IDbInterceptor, System.IDisposable
                    {
                        public DatabaseLogger() => throw null;
                        public DatabaseLogger(string path) => throw null;
                        public DatabaseLogger(string path, bool append) => throw null;
                        public void Dispose() => throw null;
                        protected virtual void Dispose(bool disposing) => throw null;
                        void System.Data.Entity.Infrastructure.Interception.IDbConfigurationInterceptor.Loaded(System.Data.Entity.Infrastructure.DependencyResolution.DbConfigurationLoadedEventArgs loadedEventArgs, System.Data.Entity.Infrastructure.Interception.DbConfigurationInterceptionContext interceptionContext) => throw null;
                        public void StartLogging() => throw null;
                        public void StopLogging() => throw null;
                    }
                    public class DbCommandDispatcher
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public virtual int NonQuery(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext interceptionContext) => throw null;
                        public virtual System.Threading.Tasks.Task<int> NonQueryAsync(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext interceptionContext, System.Threading.CancellationToken cancellationToken) => throw null;
                        public virtual System.Data.Common.DbDataReader Reader(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext interceptionContext) => throw null;
                        public virtual System.Threading.Tasks.Task<System.Data.Common.DbDataReader> ReaderAsync(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext interceptionContext, System.Threading.CancellationToken cancellationToken) => throw null;
                        public virtual object Scalar(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext interceptionContext) => throw null;
                        public virtual System.Threading.Tasks.Task<object> ScalarAsync(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext interceptionContext, System.Threading.CancellationToken cancellationToken) => throw null;
                        public override string ToString() => throw null;
                    }
                    public class DbCommandInterceptionContext : System.Data.Entity.Infrastructure.Interception.DbInterceptionContext
                    {
                        public System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext AsAsync() => throw null;
                        protected override System.Data.Entity.Infrastructure.Interception.DbInterceptionContext Clone() => throw null;
                        public System.Data.CommandBehavior CommandBehavior { get => throw null; }
                        public DbCommandInterceptionContext() => throw null;
                        public DbCommandInterceptionContext(System.Data.Entity.Infrastructure.Interception.DbInterceptionContext copyFrom) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext WithCommandBehavior(System.Data.CommandBehavior commandBehavior) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext WithDbContext(System.Data.Entity.DbContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext WithObjectContext(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                    }
                    public class DbCommandInterceptionContext<TResult> : System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext
                    {
                        public System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<TResult> AsAsync() => throw null;
                        protected override System.Data.Entity.Infrastructure.Interception.DbInterceptionContext Clone() => throw null;
                        public DbCommandInterceptionContext() => throw null;
                        public DbCommandInterceptionContext(System.Data.Entity.Infrastructure.Interception.DbInterceptionContext copyFrom) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public System.Exception Exception { get => throw null; set { } }
                        public object FindUserState(string key) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public bool IsExecutionSuppressed { get => throw null; }
                        public System.Exception OriginalException { get => throw null; }
                        public TResult OriginalResult { get => throw null; }
                        public TResult Result { get => throw null; set { } }
                        public void SetUserState(string key, object value) => throw null;
                        public void SuppressExecution() => throw null;
                        public System.Threading.Tasks.TaskStatus TaskStatus { get => throw null; }
                        public override string ToString() => throw null;
                        public object UserState { get => throw null; set { } }
                        public System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<TResult> WithCommandBehavior(System.Data.CommandBehavior commandBehavior) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<TResult> WithDbContext(System.Data.Entity.DbContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<TResult> WithObjectContext(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                    }
                    public class DbCommandInterceptor : System.Data.Entity.Infrastructure.Interception.IDbCommandInterceptor, System.Data.Entity.Infrastructure.Interception.IDbInterceptor
                    {
                        public DbCommandInterceptor() => throw null;
                        public virtual void NonQueryExecuted(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<int> interceptionContext) => throw null;
                        public virtual void NonQueryExecuting(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<int> interceptionContext) => throw null;
                        public virtual void ReaderExecuted(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<System.Data.Common.DbDataReader> interceptionContext) => throw null;
                        public virtual void ReaderExecuting(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<System.Data.Common.DbDataReader> interceptionContext) => throw null;
                        public virtual void ScalarExecuted(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<object> interceptionContext) => throw null;
                        public virtual void ScalarExecuting(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<object> interceptionContext) => throw null;
                    }
                    public class DbCommandTreeInterceptionContext : System.Data.Entity.Infrastructure.Interception.DbInterceptionContext
                    {
                        public System.Data.Entity.Infrastructure.Interception.DbCommandTreeInterceptionContext AsAsync() => throw null;
                        protected override System.Data.Entity.Infrastructure.Interception.DbInterceptionContext Clone() => throw null;
                        public DbCommandTreeInterceptionContext() => throw null;
                        public DbCommandTreeInterceptionContext(System.Data.Entity.Infrastructure.Interception.DbInterceptionContext copyFrom) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public object FindUserState(string key) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.Core.Common.CommandTrees.DbCommandTree OriginalResult { get => throw null; }
                        public System.Data.Entity.Core.Common.CommandTrees.DbCommandTree Result { get => throw null; set { } }
                        public void SetUserState(string key, object value) => throw null;
                        public override string ToString() => throw null;
                        public object UserState { get => throw null; set { } }
                        public System.Data.Entity.Infrastructure.Interception.DbCommandTreeInterceptionContext WithDbContext(System.Data.Entity.DbContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbCommandTreeInterceptionContext WithObjectContext(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                    }
                    public class DbConfigurationInterceptionContext : System.Data.Entity.Infrastructure.Interception.DbInterceptionContext
                    {
                        public System.Data.Entity.Infrastructure.Interception.DbConfigurationInterceptionContext AsAsync() => throw null;
                        protected override System.Data.Entity.Infrastructure.Interception.DbInterceptionContext Clone() => throw null;
                        public DbConfigurationInterceptionContext() => throw null;
                        public DbConfigurationInterceptionContext(System.Data.Entity.Infrastructure.Interception.DbInterceptionContext copyFrom) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbConfigurationInterceptionContext WithDbContext(System.Data.Entity.DbContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbConfigurationInterceptionContext WithObjectContext(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                    }
                    public class DbConnectionDispatcher
                    {
                        public virtual System.Data.Common.DbTransaction BeginTransaction(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.BeginTransactionInterceptionContext interceptionContext) => throw null;
                        public virtual void Close(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbInterceptionContext interceptionContext) => throw null;
                        public virtual void Dispose(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbInterceptionContext interceptionContext) => throw null;
                        public virtual void EnlistTransaction(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.EnlistTransactionInterceptionContext interceptionContext) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public virtual string GetConnectionString(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbInterceptionContext interceptionContext) => throw null;
                        public virtual int GetConnectionTimeout(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbInterceptionContext interceptionContext) => throw null;
                        public virtual string GetDatabase(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbInterceptionContext interceptionContext) => throw null;
                        public virtual string GetDataSource(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbInterceptionContext interceptionContext) => throw null;
                        public override int GetHashCode() => throw null;
                        public virtual string GetServerVersion(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbInterceptionContext interceptionContext) => throw null;
                        public virtual System.Data.ConnectionState GetState(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbInterceptionContext interceptionContext) => throw null;
                        public System.Type GetType() => throw null;
                        public virtual void Open(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbInterceptionContext interceptionContext) => throw null;
                        public virtual System.Threading.Tasks.Task OpenAsync(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbInterceptionContext interceptionContext, System.Threading.CancellationToken cancellationToken) => throw null;
                        public virtual void SetConnectionString(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionPropertyInterceptionContext<string> interceptionContext) => throw null;
                        public override string ToString() => throw null;
                    }
                    public class DbConnectionInterceptionContext : System.Data.Entity.Infrastructure.Interception.MutableInterceptionContext
                    {
                        public System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext AsAsync() => throw null;
                        protected override System.Data.Entity.Infrastructure.Interception.DbInterceptionContext Clone() => throw null;
                        public DbConnectionInterceptionContext() => throw null;
                        public DbConnectionInterceptionContext(System.Data.Entity.Infrastructure.Interception.DbInterceptionContext copyFrom) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext WithDbContext(System.Data.Entity.DbContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext WithObjectContext(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                    }
                    public class DbConnectionInterceptionContext<TResult> : System.Data.Entity.Infrastructure.Interception.MutableInterceptionContext<TResult>
                    {
                        public System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<TResult> AsAsync() => throw null;
                        protected override System.Data.Entity.Infrastructure.Interception.DbInterceptionContext Clone() => throw null;
                        public DbConnectionInterceptionContext() => throw null;
                        public DbConnectionInterceptionContext(System.Data.Entity.Infrastructure.Interception.DbInterceptionContext copyFrom) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<TResult> WithDbContext(System.Data.Entity.DbContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<TResult> WithObjectContext(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                    }
                    public class DbConnectionPropertyInterceptionContext<TValue> : System.Data.Entity.Infrastructure.Interception.PropertyInterceptionContext<TValue>
                    {
                        public System.Data.Entity.Infrastructure.Interception.DbConnectionPropertyInterceptionContext<TValue> AsAsync() => throw null;
                        protected override System.Data.Entity.Infrastructure.Interception.DbInterceptionContext Clone() => throw null;
                        public DbConnectionPropertyInterceptionContext() => throw null;
                        public DbConnectionPropertyInterceptionContext(System.Data.Entity.Infrastructure.Interception.DbInterceptionContext copyFrom) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbConnectionPropertyInterceptionContext<TValue> WithDbContext(System.Data.Entity.DbContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbConnectionPropertyInterceptionContext<TValue> WithObjectContext(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbConnectionPropertyInterceptionContext<TValue> WithValue(TValue value) => throw null;
                    }
                    public class DbDispatchers
                    {
                        public virtual System.Data.Entity.Infrastructure.Interception.DbCommandDispatcher Command { get => throw null; }
                        public virtual System.Data.Entity.Infrastructure.Interception.DbConnectionDispatcher Connection { get => throw null; }
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                        public virtual System.Data.Entity.Infrastructure.Interception.DbTransactionDispatcher Transaction { get => throw null; }
                    }
                    public static class DbInterception
                    {
                        public static void Add(System.Data.Entity.Infrastructure.Interception.IDbInterceptor interceptor) => throw null;
                        public static System.Data.Entity.Infrastructure.Interception.DbDispatchers Dispatch { get => throw null; }
                        public static void Remove(System.Data.Entity.Infrastructure.Interception.IDbInterceptor interceptor) => throw null;
                    }
                    public class DbInterceptionContext
                    {
                        public System.Data.Entity.Infrastructure.Interception.DbInterceptionContext AsAsync() => throw null;
                        protected virtual System.Data.Entity.Infrastructure.Interception.DbInterceptionContext Clone() => throw null;
                        public DbInterceptionContext() => throw null;
                        protected DbInterceptionContext(System.Data.Entity.Infrastructure.Interception.DbInterceptionContext copyFrom) => throw null;
                        public System.Collections.Generic.IEnumerable<System.Data.Entity.DbContext> DbContexts { get => throw null; }
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public bool IsAsync { get => throw null; }
                        public System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Objects.ObjectContext> ObjectContexts { get => throw null; }
                        public override string ToString() => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbInterceptionContext WithDbContext(System.Data.Entity.DbContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbInterceptionContext WithObjectContext(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                    }
                    public class DbTransactionDispatcher
                    {
                        public virtual void Commit(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbInterceptionContext interceptionContext) => throw null;
                        public virtual void Dispose(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbInterceptionContext interceptionContext) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public virtual System.Data.Common.DbConnection GetConnection(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbInterceptionContext interceptionContext) => throw null;
                        public override int GetHashCode() => throw null;
                        public virtual System.Data.IsolationLevel GetIsolationLevel(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbInterceptionContext interceptionContext) => throw null;
                        public System.Type GetType() => throw null;
                        public virtual void Rollback(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbInterceptionContext interceptionContext) => throw null;
                        public override string ToString() => throw null;
                    }
                    public class DbTransactionInterceptionContext : System.Data.Entity.Infrastructure.Interception.MutableInterceptionContext
                    {
                        public System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext AsAsync() => throw null;
                        protected override System.Data.Entity.Infrastructure.Interception.DbInterceptionContext Clone() => throw null;
                        public System.Data.Common.DbConnection Connection { get => throw null; }
                        public DbTransactionInterceptionContext() => throw null;
                        public DbTransactionInterceptionContext(System.Data.Entity.Infrastructure.Interception.DbInterceptionContext copyFrom) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext WithConnection(System.Data.Common.DbConnection connection) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext WithDbContext(System.Data.Entity.DbContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext WithObjectContext(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                    }
                    public class DbTransactionInterceptionContext<TResult> : System.Data.Entity.Infrastructure.Interception.MutableInterceptionContext<TResult>
                    {
                        public System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext<TResult> AsAsync() => throw null;
                        protected override System.Data.Entity.Infrastructure.Interception.DbInterceptionContext Clone() => throw null;
                        public DbTransactionInterceptionContext() => throw null;
                        public DbTransactionInterceptionContext(System.Data.Entity.Infrastructure.Interception.DbInterceptionContext copyFrom) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext<TResult> WithDbContext(System.Data.Entity.DbContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext<TResult> WithObjectContext(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                    }
                    public class EnlistTransactionInterceptionContext : System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext
                    {
                        public System.Data.Entity.Infrastructure.Interception.EnlistTransactionInterceptionContext AsAsync() => throw null;
                        protected override System.Data.Entity.Infrastructure.Interception.DbInterceptionContext Clone() => throw null;
                        public EnlistTransactionInterceptionContext() => throw null;
                        public EnlistTransactionInterceptionContext(System.Data.Entity.Infrastructure.Interception.DbInterceptionContext copyFrom) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                        public System.Transactions.Transaction Transaction { get => throw null; }
                        public System.Data.Entity.Infrastructure.Interception.EnlistTransactionInterceptionContext WithDbContext(System.Data.Entity.DbContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.EnlistTransactionInterceptionContext WithObjectContext(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.EnlistTransactionInterceptionContext WithTransaction(System.Transactions.Transaction transaction) => throw null;
                    }
                    public interface IDbCommandInterceptor : System.Data.Entity.Infrastructure.Interception.IDbInterceptor
                    {
                        void NonQueryExecuted(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<int> interceptionContext);
                        void NonQueryExecuting(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<int> interceptionContext);
                        void ReaderExecuted(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<System.Data.Common.DbDataReader> interceptionContext);
                        void ReaderExecuting(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<System.Data.Common.DbDataReader> interceptionContext);
                        void ScalarExecuted(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<object> interceptionContext);
                        void ScalarExecuting(System.Data.Common.DbCommand command, System.Data.Entity.Infrastructure.Interception.DbCommandInterceptionContext<object> interceptionContext);
                    }
                    public interface IDbCommandTreeInterceptor : System.Data.Entity.Infrastructure.Interception.IDbInterceptor
                    {
                        void TreeCreated(System.Data.Entity.Infrastructure.Interception.DbCommandTreeInterceptionContext interceptionContext);
                    }
                    public interface IDbConfigurationInterceptor : System.Data.Entity.Infrastructure.Interception.IDbInterceptor
                    {
                        void Loaded(System.Data.Entity.Infrastructure.DependencyResolution.DbConfigurationLoadedEventArgs loadedEventArgs, System.Data.Entity.Infrastructure.Interception.DbConfigurationInterceptionContext interceptionContext);
                    }
                    public interface IDbConnectionInterceptor : System.Data.Entity.Infrastructure.Interception.IDbInterceptor
                    {
                        void BeganTransaction(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.BeginTransactionInterceptionContext interceptionContext);
                        void BeginningTransaction(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.BeginTransactionInterceptionContext interceptionContext);
                        void Closed(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext);
                        void Closing(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext);
                        void ConnectionStringGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext);
                        void ConnectionStringGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext);
                        void ConnectionStringSet(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionPropertyInterceptionContext<string> interceptionContext);
                        void ConnectionStringSetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionPropertyInterceptionContext<string> interceptionContext);
                        void ConnectionTimeoutGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<int> interceptionContext);
                        void ConnectionTimeoutGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<int> interceptionContext);
                        void DatabaseGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext);
                        void DatabaseGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext);
                        void DataSourceGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext);
                        void DataSourceGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext);
                        void Disposed(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext);
                        void Disposing(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext);
                        void EnlistedTransaction(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.EnlistTransactionInterceptionContext interceptionContext);
                        void EnlistingTransaction(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.EnlistTransactionInterceptionContext interceptionContext);
                        void Opened(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext);
                        void Opening(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext);
                        void ServerVersionGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext);
                        void ServerVersionGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext);
                        void StateGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<System.Data.ConnectionState> interceptionContext);
                        void StateGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<System.Data.ConnectionState> interceptionContext);
                    }
                    public interface IDbInterceptor
                    {
                    }
                    public interface IDbTransactionInterceptor : System.Data.Entity.Infrastructure.Interception.IDbInterceptor
                    {
                        void Committed(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext);
                        void Committing(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext);
                        void ConnectionGetting(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext<System.Data.Common.DbConnection> interceptionContext);
                        void ConnectionGot(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext<System.Data.Common.DbConnection> interceptionContext);
                        void Disposed(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext);
                        void Disposing(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext);
                        void IsolationLevelGetting(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext<System.Data.IsolationLevel> interceptionContext);
                        void IsolationLevelGot(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext<System.Data.IsolationLevel> interceptionContext);
                        void RolledBack(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext);
                        void RollingBack(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext);
                    }
                    public abstract class MutableInterceptionContext : System.Data.Entity.Infrastructure.Interception.DbInterceptionContext
                    {
                        public System.Data.Entity.Infrastructure.Interception.MutableInterceptionContext AsAsync() => throw null;
                        protected MutableInterceptionContext() => throw null;
                        protected MutableInterceptionContext(System.Data.Entity.Infrastructure.Interception.DbInterceptionContext copyFrom) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public System.Exception Exception { get => throw null; set { } }
                        public object FindUserState(string key) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public bool IsExecutionSuppressed { get => throw null; }
                        public System.Exception OriginalException { get => throw null; }
                        public void SetUserState(string key, object value) => throw null;
                        public void SuppressExecution() => throw null;
                        public System.Threading.Tasks.TaskStatus TaskStatus { get => throw null; }
                        public override string ToString() => throw null;
                        public object UserState { get => throw null; set { } }
                        public System.Data.Entity.Infrastructure.Interception.MutableInterceptionContext WithDbContext(System.Data.Entity.DbContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.MutableInterceptionContext WithObjectContext(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                    }
                    public abstract class MutableInterceptionContext<TResult> : System.Data.Entity.Infrastructure.Interception.DbInterceptionContext
                    {
                        public System.Data.Entity.Infrastructure.Interception.MutableInterceptionContext<TResult> AsAsync() => throw null;
                        protected MutableInterceptionContext() => throw null;
                        protected MutableInterceptionContext(System.Data.Entity.Infrastructure.Interception.DbInterceptionContext copyFrom) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public System.Exception Exception { get => throw null; set { } }
                        public object FindUserState(string key) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public bool IsExecutionSuppressed { get => throw null; }
                        public System.Exception OriginalException { get => throw null; }
                        public TResult OriginalResult { get => throw null; }
                        public TResult Result { get => throw null; set { } }
                        public void SetUserState(string key, object value) => throw null;
                        public void SuppressExecution() => throw null;
                        public System.Threading.Tasks.TaskStatus TaskStatus { get => throw null; }
                        public override string ToString() => throw null;
                        public object UserState { get => throw null; set { } }
                        public System.Data.Entity.Infrastructure.Interception.MutableInterceptionContext<TResult> WithDbContext(System.Data.Entity.DbContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.MutableInterceptionContext<TResult> WithObjectContext(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                    }
                    public class PropertyInterceptionContext<TValue> : System.Data.Entity.Infrastructure.Interception.DbInterceptionContext
                    {
                        public System.Data.Entity.Infrastructure.Interception.PropertyInterceptionContext<TValue> AsAsync() => throw null;
                        protected override System.Data.Entity.Infrastructure.Interception.DbInterceptionContext Clone() => throw null;
                        public PropertyInterceptionContext() => throw null;
                        public PropertyInterceptionContext(System.Data.Entity.Infrastructure.Interception.DbInterceptionContext copyFrom) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public System.Exception Exception { get => throw null; set { } }
                        public object FindUserState(string key) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public bool IsExecutionSuppressed { get => throw null; }
                        public System.Exception OriginalException { get => throw null; }
                        public void SetUserState(string key, object value) => throw null;
                        public void SuppressExecution() => throw null;
                        public System.Threading.Tasks.TaskStatus TaskStatus { get => throw null; }
                        public override string ToString() => throw null;
                        public object UserState { get => throw null; set { } }
                        public TValue Value { get => throw null; }
                        public System.Data.Entity.Infrastructure.Interception.PropertyInterceptionContext<TValue> WithDbContext(System.Data.Entity.DbContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.PropertyInterceptionContext<TValue> WithObjectContext(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                        public System.Data.Entity.Infrastructure.Interception.PropertyInterceptionContext<TValue> WithValue(TValue value) => throw null;
                    }
                }
                public interface IObjectContextAdapter
                {
                    System.Data.Entity.Core.Objects.ObjectContext ObjectContext { get; }
                }
                public interface IProviderInvariantName
                {
                    string Name { get; }
                }
                public sealed class LocalDbConnectionFactory : System.Data.Entity.Infrastructure.IDbConnectionFactory
                {
                    public string BaseConnectionString { get => throw null; }
                    public System.Data.Common.DbConnection CreateConnection(string nameOrConnectionString) => throw null;
                    public LocalDbConnectionFactory() => throw null;
                    public LocalDbConnectionFactory(string localDbVersion) => throw null;
                    public LocalDbConnectionFactory(string localDbVersion, string baseConnectionString) => throw null;
                }
                namespace MappingViews
                {
                    public class DbMappingView
                    {
                        public DbMappingView(string entitySql) => throw null;
                        public string EntitySql { get => throw null; }
                    }
                    public abstract class DbMappingViewCache
                    {
                        protected DbMappingViewCache() => throw null;
                        public abstract System.Data.Entity.Infrastructure.MappingViews.DbMappingView GetView(System.Data.Entity.Core.Metadata.Edm.EntitySetBase extent);
                        public abstract string MappingHashValue { get; }
                    }
                    public abstract class DbMappingViewCacheFactory
                    {
                        public abstract System.Data.Entity.Infrastructure.MappingViews.DbMappingViewCache Create(string conceptualModelContainerName, string storeModelContainerName);
                        protected DbMappingViewCacheFactory() => throw null;
                    }
                    [System.AttributeUsage((System.AttributeTargets)1, AllowMultiple = true)]
                    public sealed class DbMappingViewCacheTypeAttribute : System.Attribute
                    {
                        public DbMappingViewCacheTypeAttribute(System.Type contextType, System.Type cacheType) => throw null;
                        public DbMappingViewCacheTypeAttribute(System.Type contextType, string cacheTypeName) => throw null;
                    }
                }
                public class ModelContainerConvention : System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.EntityContainer>, System.Data.Entity.ModelConfiguration.Conventions.IConvention
                {
                    public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.EntityContainer item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                }
                public class ModelNamespaceConvention : System.Data.Entity.ModelConfiguration.Conventions.Convention
                {
                }
                public sealed class ObjectReferenceEqualityComparer : System.Collections.Generic.IEqualityComparer<object>
                {
                    public ObjectReferenceEqualityComparer() => throw null;
                    public static System.Data.Entity.Infrastructure.ObjectReferenceEqualityComparer Default { get => throw null; }
                    bool System.Collections.Generic.IEqualityComparer<object>.Equals(object x, object y) => throw null;
                    int System.Collections.Generic.IEqualityComparer<object>.GetHashCode(object obj) => throw null;
                }
                namespace Pluralization
                {
                    public class CustomPluralizationEntry
                    {
                        public CustomPluralizationEntry(string singular, string plural) => throw null;
                        public string Plural { get => throw null; }
                        public string Singular { get => throw null; }
                    }
                    public sealed class EnglishPluralizationService : System.Data.Entity.Infrastructure.Pluralization.IPluralizationService
                    {
                        public EnglishPluralizationService() => throw null;
                        public EnglishPluralizationService(System.Collections.Generic.IEnumerable<System.Data.Entity.Infrastructure.Pluralization.CustomPluralizationEntry> userDictionaryEntries) => throw null;
                        public string Pluralize(string word) => throw null;
                        public string Singularize(string word) => throw null;
                    }
                    public interface IPluralizationService
                    {
                        string Pluralize(string word);
                        string Singularize(string word);
                    }
                }
                public sealed class ReplacementDbQueryWrapper<TElement>
                {
                    public System.Data.Entity.Core.Objects.ObjectQuery<TElement> Query { get => throw null; }
                }
                public sealed class RetryLimitExceededException : System.Data.Entity.Core.EntityException
                {
                    public RetryLimitExceededException() => throw null;
                    public RetryLimitExceededException(string message) => throw null;
                    public RetryLimitExceededException(string message, System.Exception innerException) => throw null;
                }
                public sealed class SqlCeConnectionFactory : System.Data.Entity.Infrastructure.IDbConnectionFactory
                {
                    public string BaseConnectionString { get => throw null; }
                    public System.Data.Common.DbConnection CreateConnection(string nameOrConnectionString) => throw null;
                    public SqlCeConnectionFactory(string providerInvariantName) => throw null;
                    public SqlCeConnectionFactory(string providerInvariantName, string databaseDirectory, string baseConnectionString) => throw null;
                    public string DatabaseDirectory { get => throw null; }
                    public string ProviderInvariantName { get => throw null; }
                }
                public sealed class SqlConnectionFactory : System.Data.Entity.Infrastructure.IDbConnectionFactory
                {
                    public string BaseConnectionString { get => throw null; }
                    public System.Data.Common.DbConnection CreateConnection(string nameOrConnectionString) => throw null;
                    public SqlConnectionFactory() => throw null;
                    public SqlConnectionFactory(string baseConnectionString) => throw null;
                }
                [System.AttributeUsage((System.AttributeTargets)132, AllowMultiple = false)]
                public sealed class SuppressDbSetInitializationAttribute : System.Attribute
                {
                    public SuppressDbSetInitializationAttribute() => throw null;
                }
                public abstract class TableExistenceChecker
                {
                    public abstract bool AnyModelTableExistsInDatabase(System.Data.Entity.Core.Objects.ObjectContext context, System.Data.Common.DbConnection connection, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EntitySet> modelTables, string edmMetadataContextTableName);
                    protected TableExistenceChecker() => throw null;
                    protected virtual string GetTableName(System.Data.Entity.Core.Metadata.Edm.EntitySet modelTable) => throw null;
                }
                public class TransactionContext : System.Data.Entity.DbContext
                {
                    public TransactionContext(System.Data.Common.DbConnection existingConnection) => throw null;
                    protected override void OnModelCreating(System.Data.Entity.DbModelBuilder modelBuilder) => throw null;
                    public virtual System.Data.Entity.IDbSet<System.Data.Entity.Infrastructure.TransactionRow> Transactions { get => throw null; set { } }
                }
                public abstract class TransactionHandler : System.Data.Entity.Infrastructure.Interception.IDbConnectionInterceptor, System.Data.Entity.Infrastructure.Interception.IDbInterceptor, System.Data.Entity.Infrastructure.Interception.IDbTransactionInterceptor, System.IDisposable
                {
                    public virtual void BeganTransaction(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.BeginTransactionInterceptionContext interceptionContext) => throw null;
                    public virtual void BeginningTransaction(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.BeginTransactionInterceptionContext interceptionContext) => throw null;
                    public abstract string BuildDatabaseInitializationScript();
                    public virtual void Closed(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext) => throw null;
                    public virtual void Closing(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext) => throw null;
                    public virtual void Committed(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext) => throw null;
                    public virtual void Committing(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext) => throw null;
                    public System.Data.Common.DbConnection Connection { get => throw null; }
                    public virtual void ConnectionGetting(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext<System.Data.Common.DbConnection> interceptionContext) => throw null;
                    public virtual void ConnectionGot(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext<System.Data.Common.DbConnection> interceptionContext) => throw null;
                    public virtual void ConnectionStringGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext) => throw null;
                    public virtual void ConnectionStringGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext) => throw null;
                    public virtual void ConnectionStringSet(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionPropertyInterceptionContext<string> interceptionContext) => throw null;
                    public virtual void ConnectionStringSetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionPropertyInterceptionContext<string> interceptionContext) => throw null;
                    public virtual void ConnectionTimeoutGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<int> interceptionContext) => throw null;
                    public virtual void ConnectionTimeoutGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<int> interceptionContext) => throw null;
                    protected TransactionHandler() => throw null;
                    public virtual void DatabaseGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext) => throw null;
                    public virtual void DatabaseGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext) => throw null;
                    public virtual void DataSourceGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext) => throw null;
                    public virtual void DataSourceGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext) => throw null;
                    public System.Data.Entity.DbContext DbContext { get => throw null; }
                    public void Dispose() => throw null;
                    protected virtual void Dispose(bool disposing) => throw null;
                    public virtual void Disposed(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext) => throw null;
                    public virtual void Disposed(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext) => throw null;
                    public virtual void Disposing(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext) => throw null;
                    public virtual void Disposing(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext) => throw null;
                    public virtual void EnlistedTransaction(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.EnlistTransactionInterceptionContext interceptionContext) => throw null;
                    public virtual void EnlistingTransaction(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.EnlistTransactionInterceptionContext interceptionContext) => throw null;
                    public virtual void Initialize(System.Data.Entity.Core.Objects.ObjectContext context) => throw null;
                    public virtual void Initialize(System.Data.Entity.DbContext context, System.Data.Common.DbConnection connection) => throw null;
                    protected bool IsDisposed { get => throw null; set { } }
                    public virtual void IsolationLevelGetting(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext<System.Data.IsolationLevel> interceptionContext) => throw null;
                    public virtual void IsolationLevelGot(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext<System.Data.IsolationLevel> interceptionContext) => throw null;
                    protected virtual bool MatchesParentContext(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbInterceptionContext interceptionContext) => throw null;
                    public System.Data.Entity.Core.Objects.ObjectContext ObjectContext { get => throw null; }
                    public virtual void Opened(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext) => throw null;
                    public virtual void Opening(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext interceptionContext) => throw null;
                    public virtual void RolledBack(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext) => throw null;
                    public virtual void RollingBack(System.Data.Common.DbTransaction transaction, System.Data.Entity.Infrastructure.Interception.DbTransactionInterceptionContext interceptionContext) => throw null;
                    public virtual void ServerVersionGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext) => throw null;
                    public virtual void ServerVersionGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<string> interceptionContext) => throw null;
                    public virtual void StateGetting(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<System.Data.ConnectionState> interceptionContext) => throw null;
                    public virtual void StateGot(System.Data.Common.DbConnection connection, System.Data.Entity.Infrastructure.Interception.DbConnectionInterceptionContext<System.Data.ConnectionState> interceptionContext) => throw null;
                }
                public class TransactionRow
                {
                    public System.DateTime CreationTime { get => throw null; set { } }
                    public TransactionRow() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Guid Id { get => throw null; set { } }
                }
                public class UnintentionalCodeFirstException : System.InvalidOperationException
                {
                    public UnintentionalCodeFirstException() => throw null;
                    protected UnintentionalCodeFirstException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public UnintentionalCodeFirstException(string message) => throw null;
                    public UnintentionalCodeFirstException(string message, System.Exception innerException) => throw null;
                }
            }
            public class MigrateDatabaseToLatestVersion<TContext, TMigrationsConfiguration> : System.Data.Entity.IDatabaseInitializer<TContext> where TContext : System.Data.Entity.DbContext where TMigrationsConfiguration : System.Data.Entity.Migrations.DbMigrationsConfiguration<TContext>, new()
            {
                public MigrateDatabaseToLatestVersion() => throw null;
                public MigrateDatabaseToLatestVersion(bool useSuppliedContext) => throw null;
                public MigrateDatabaseToLatestVersion(bool useSuppliedContext, TMigrationsConfiguration configuration) => throw null;
                public MigrateDatabaseToLatestVersion(string connectionStringName) => throw null;
                public virtual void InitializeDatabase(TContext context) => throw null;
            }
            namespace Migrations
            {
                namespace Builders
                {
                    public class ColumnBuilder
                    {
                        public System.Data.Entity.Migrations.Model.ColumnModel Binary(bool? nullable = default(bool?), int? maxLength = default(int?), bool? fixedLength = default(bool?), byte[] defaultValue = default(byte[]), string defaultValueSql = default(string), bool timestamp = default(bool), string name = default(string), string storeType = default(string), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        public System.Data.Entity.Migrations.Model.ColumnModel Boolean(bool? nullable = default(bool?), bool? defaultValue = default(bool?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        public System.Data.Entity.Migrations.Model.ColumnModel Byte(bool? nullable = default(bool?), bool identity = default(bool), byte? defaultValue = default(byte?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        public ColumnBuilder() => throw null;
                        public System.Data.Entity.Migrations.Model.ColumnModel DateTime(bool? nullable = default(bool?), byte? precision = default(byte?), System.DateTime? defaultValue = default(System.DateTime?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        public System.Data.Entity.Migrations.Model.ColumnModel DateTimeOffset(bool? nullable = default(bool?), byte? precision = default(byte?), System.DateTimeOffset? defaultValue = default(System.DateTimeOffset?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        public System.Data.Entity.Migrations.Model.ColumnModel Decimal(bool? nullable = default(bool?), byte? precision = default(byte?), byte? scale = default(byte?), decimal? defaultValue = default(decimal?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool identity = default(bool), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        public System.Data.Entity.Migrations.Model.ColumnModel Double(bool? nullable = default(bool?), double? defaultValue = default(double?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public System.Data.Entity.Migrations.Model.ColumnModel Geography(bool? nullable = default(bool?), System.Data.Entity.Spatial.DbGeography defaultValue = default(System.Data.Entity.Spatial.DbGeography), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        public System.Data.Entity.Migrations.Model.ColumnModel Geometry(bool? nullable = default(bool?), System.Data.Entity.Spatial.DbGeometry defaultValue = default(System.Data.Entity.Spatial.DbGeometry), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.Migrations.Model.ColumnModel Guid(bool? nullable = default(bool?), bool identity = default(bool), System.Guid? defaultValue = default(System.Guid?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        public System.Data.Entity.Migrations.Model.ColumnModel HierarchyId(bool? nullable = default(bool?), System.Data.Entity.Hierarchy.HierarchyId defaultValue = default(System.Data.Entity.Hierarchy.HierarchyId), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        public System.Data.Entity.Migrations.Model.ColumnModel Int(bool? nullable = default(bool?), bool identity = default(bool), int? defaultValue = default(int?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        public System.Data.Entity.Migrations.Model.ColumnModel Long(bool? nullable = default(bool?), bool identity = default(bool), long? defaultValue = default(long?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        protected object MemberwiseClone() => throw null;
                        public System.Data.Entity.Migrations.Model.ColumnModel Short(bool? nullable = default(bool?), bool identity = default(bool), short? defaultValue = default(short?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        public System.Data.Entity.Migrations.Model.ColumnModel Single(bool? nullable = default(bool?), float? defaultValue = default(float?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        public System.Data.Entity.Migrations.Model.ColumnModel String(bool? nullable = default(bool?), int? maxLength = default(int?), bool? fixedLength = default(bool?), bool? unicode = default(bool?), string defaultValue = default(string), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        public System.Data.Entity.Migrations.Model.ColumnModel Time(bool? nullable = default(bool?), byte? precision = default(byte?), System.TimeSpan? defaultValue = default(System.TimeSpan?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations = default(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues>)) => throw null;
                        public override string ToString() => throw null;
                    }
                    public class ParameterBuilder
                    {
                        public System.Data.Entity.Migrations.Model.ParameterModel Binary(int? maxLength = default(int?), bool? fixedLength = default(bool?), byte[] defaultValue = default(byte[]), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool outParameter = default(bool)) => throw null;
                        public System.Data.Entity.Migrations.Model.ParameterModel Boolean(bool? defaultValue = default(bool?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool outParameter = default(bool)) => throw null;
                        public System.Data.Entity.Migrations.Model.ParameterModel Byte(byte? defaultValue = default(byte?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool outParameter = default(bool)) => throw null;
                        public ParameterBuilder() => throw null;
                        public System.Data.Entity.Migrations.Model.ParameterModel DateTime(byte? precision = default(byte?), System.DateTime? defaultValue = default(System.DateTime?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool outParameter = default(bool)) => throw null;
                        public System.Data.Entity.Migrations.Model.ParameterModel DateTimeOffset(byte? precision = default(byte?), System.DateTimeOffset? defaultValue = default(System.DateTimeOffset?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool outParameter = default(bool)) => throw null;
                        public System.Data.Entity.Migrations.Model.ParameterModel Decimal(byte? precision = default(byte?), byte? scale = default(byte?), decimal? defaultValue = default(decimal?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool outParameter = default(bool)) => throw null;
                        public System.Data.Entity.Migrations.Model.ParameterModel Double(double? defaultValue = default(double?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool outParameter = default(bool)) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public System.Data.Entity.Migrations.Model.ParameterModel Geography(System.Data.Entity.Spatial.DbGeography defaultValue = default(System.Data.Entity.Spatial.DbGeography), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool outParameter = default(bool)) => throw null;
                        public System.Data.Entity.Migrations.Model.ParameterModel Geometry(System.Data.Entity.Spatial.DbGeometry defaultValue = default(System.Data.Entity.Spatial.DbGeometry), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool outParameter = default(bool)) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.Migrations.Model.ParameterModel Guid(System.Guid? defaultValue = default(System.Guid?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool outParameter = default(bool)) => throw null;
                        public System.Data.Entity.Migrations.Model.ParameterModel Int(int? defaultValue = default(int?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool outParameter = default(bool)) => throw null;
                        public System.Data.Entity.Migrations.Model.ParameterModel Long(long? defaultValue = default(long?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool outParameter = default(bool)) => throw null;
                        protected object MemberwiseClone() => throw null;
                        public System.Data.Entity.Migrations.Model.ParameterModel Short(short? defaultValue = default(short?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool outParameter = default(bool)) => throw null;
                        public System.Data.Entity.Migrations.Model.ParameterModel Single(float? defaultValue = default(float?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool outParameter = default(bool)) => throw null;
                        public System.Data.Entity.Migrations.Model.ParameterModel String(int? maxLength = default(int?), bool? fixedLength = default(bool?), bool? unicode = default(bool?), string defaultValue = default(string), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool outParameter = default(bool)) => throw null;
                        public System.Data.Entity.Migrations.Model.ParameterModel Time(byte? precision = default(byte?), System.TimeSpan? defaultValue = default(System.TimeSpan?), string defaultValueSql = default(string), string name = default(string), string storeType = default(string), bool outParameter = default(bool)) => throw null;
                        public override string ToString() => throw null;
                    }
                    public class TableBuilder<TColumns>
                    {
                        public TableBuilder(System.Data.Entity.Migrations.Model.CreateTableOperation createTableOperation, System.Data.Entity.Migrations.DbMigration migration) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public System.Data.Entity.Migrations.Builders.TableBuilder<TColumns> ForeignKey(string principalTable, System.Linq.Expressions.Expression<System.Func<TColumns, object>> dependentKeyExpression, bool cascadeDelete = default(bool), string name = default(string), object anonymousArguments = default(object)) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.Migrations.Builders.TableBuilder<TColumns> Index(System.Linq.Expressions.Expression<System.Func<TColumns, object>> indexExpression, string name = default(string), bool unique = default(bool), bool clustered = default(bool), object anonymousArguments = default(object)) => throw null;
                        protected object MemberwiseClone() => throw null;
                        public System.Data.Entity.Migrations.Builders.TableBuilder<TColumns> PrimaryKey(System.Linq.Expressions.Expression<System.Func<TColumns, object>> keyExpression, string name = default(string), bool clustered = default(bool), object anonymousArguments = default(object)) => throw null;
                        public override string ToString() => throw null;
                    }
                }
                public abstract class DbMigration : System.Data.Entity.Migrations.Infrastructure.IDbMigration
                {
                    protected void AddColumn(string table, string name, System.Func<System.Data.Entity.Migrations.Builders.ColumnBuilder, System.Data.Entity.Migrations.Model.ColumnModel> columnAction, object anonymousArguments = default(object)) => throw null;
                    protected void AddForeignKey(string dependentTable, string dependentColumn, string principalTable, string principalColumn = default(string), bool cascadeDelete = default(bool), string name = default(string), object anonymousArguments = default(object)) => throw null;
                    protected void AddForeignKey(string dependentTable, string[] dependentColumns, string principalTable, string[] principalColumns = default(string[]), bool cascadeDelete = default(bool), string name = default(string), object anonymousArguments = default(object)) => throw null;
                    void System.Data.Entity.Migrations.Infrastructure.IDbMigration.AddOperation(System.Data.Entity.Migrations.Model.MigrationOperation migrationOperation) => throw null;
                    protected void AddPrimaryKey(string table, string column, string name = default(string), bool clustered = default(bool), object anonymousArguments = default(object)) => throw null;
                    protected void AddPrimaryKey(string table, string[] columns, string name = default(string), bool clustered = default(bool), object anonymousArguments = default(object)) => throw null;
                    protected void AlterColumn(string table, string name, System.Func<System.Data.Entity.Migrations.Builders.ColumnBuilder, System.Data.Entity.Migrations.Model.ColumnModel> columnAction, object anonymousArguments = default(object)) => throw null;
                    public void AlterStoredProcedure(string name, string body, object anonymousArguments = default(object)) => throw null;
                    public void AlterStoredProcedure<TParameters>(string name, System.Func<System.Data.Entity.Migrations.Builders.ParameterBuilder, TParameters> parametersAction, string body, object anonymousArguments = default(object)) => throw null;
                    protected void AlterTableAnnotations<TColumns>(string name, System.Func<System.Data.Entity.Migrations.Builders.ColumnBuilder, TColumns> columnsAction, System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations, object anonymousArguments = default(object)) => throw null;
                    protected void CreateIndex(string table, string column, bool unique = default(bool), string name = default(string), bool clustered = default(bool), object anonymousArguments = default(object)) => throw null;
                    protected void CreateIndex(string table, string[] columns, bool unique = default(bool), string name = default(string), bool clustered = default(bool), object anonymousArguments = default(object)) => throw null;
                    public void CreateStoredProcedure(string name, string body, object anonymousArguments = default(object)) => throw null;
                    public void CreateStoredProcedure<TParameters>(string name, System.Func<System.Data.Entity.Migrations.Builders.ParameterBuilder, TParameters> parametersAction, string body, object anonymousArguments = default(object)) => throw null;
                    protected System.Data.Entity.Migrations.Builders.TableBuilder<TColumns> CreateTable<TColumns>(string name, System.Func<System.Data.Entity.Migrations.Builders.ColumnBuilder, TColumns> columnsAction, object anonymousArguments = default(object)) => throw null;
                    protected System.Data.Entity.Migrations.Builders.TableBuilder<TColumns> CreateTable<TColumns>(string name, System.Func<System.Data.Entity.Migrations.Builders.ColumnBuilder, TColumns> columnsAction, System.Collections.Generic.IDictionary<string, object> annotations, object anonymousArguments = default(object)) => throw null;
                    protected DbMigration() => throw null;
                    public virtual void Down() => throw null;
                    protected void DropColumn(string table, string name, object anonymousArguments = default(object)) => throw null;
                    protected void DropColumn(string table, string name, System.Collections.Generic.IDictionary<string, object> removedAnnotations, object anonymousArguments = default(object)) => throw null;
                    protected void DropForeignKey(string dependentTable, string name, object anonymousArguments = default(object)) => throw null;
                    protected void DropForeignKey(string dependentTable, string dependentColumn, string principalTable, object anonymousArguments = default(object)) => throw null;
                    protected void DropForeignKey(string dependentTable, string dependentColumn, string principalTable, string principalColumn, object anonymousArguments = default(object)) => throw null;
                    protected void DropForeignKey(string dependentTable, string[] dependentColumns, string principalTable, object anonymousArguments = default(object)) => throw null;
                    protected void DropIndex(string table, string name, object anonymousArguments = default(object)) => throw null;
                    protected void DropIndex(string table, string[] columns, object anonymousArguments = default(object)) => throw null;
                    protected void DropPrimaryKey(string table, string name, object anonymousArguments = default(object)) => throw null;
                    protected void DropPrimaryKey(string table, object anonymousArguments = default(object)) => throw null;
                    public void DropStoredProcedure(string name, object anonymousArguments = default(object)) => throw null;
                    protected void DropTable(string name, object anonymousArguments = default(object)) => throw null;
                    protected void DropTable(string name, System.Collections.Generic.IDictionary<string, System.Collections.Generic.IDictionary<string, object>> removedColumnAnnotations, object anonymousArguments = default(object)) => throw null;
                    protected void DropTable(string name, System.Collections.Generic.IDictionary<string, object> removedAnnotations, object anonymousArguments = default(object)) => throw null;
                    protected void DropTable(string name, System.Collections.Generic.IDictionary<string, object> removedAnnotations, System.Collections.Generic.IDictionary<string, System.Collections.Generic.IDictionary<string, object>> removedColumnAnnotations, object anonymousArguments = default(object)) => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Type GetType() => throw null;
                    protected object MemberwiseClone() => throw null;
                    protected void MoveStoredProcedure(string name, string newSchema, object anonymousArguments = default(object)) => throw null;
                    protected void MoveTable(string name, string newSchema, object anonymousArguments = default(object)) => throw null;
                    protected void RenameColumn(string table, string name, string newName, object anonymousArguments = default(object)) => throw null;
                    protected void RenameIndex(string table, string name, string newName, object anonymousArguments = default(object)) => throw null;
                    protected void RenameStoredProcedure(string name, string newName, object anonymousArguments = default(object)) => throw null;
                    protected void RenameTable(string name, string newName, object anonymousArguments = default(object)) => throw null;
                    protected void Sql(string sql, bool suppressTransaction = default(bool), object anonymousArguments = default(object)) => throw null;
                    protected void SqlFile(string sqlFile, bool suppressTransaction = default(bool), object anonymousArguments = default(object)) => throw null;
                    protected void SqlResource(string sqlResource, System.Reflection.Assembly resourceAssembly = default(System.Reflection.Assembly), bool suppressTransaction = default(bool), object anonymousArguments = default(object)) => throw null;
                    public override string ToString() => throw null;
                    public abstract void Up();
                }
                public class DbMigrationsConfiguration
                {
                    public bool AutomaticMigrationDataLossAllowed { get => throw null; set { } }
                    public bool AutomaticMigrationsEnabled { get => throw null; set { } }
                    public System.Data.Entity.Migrations.Design.MigrationCodeGenerator CodeGenerator { get => throw null; set { } }
                    public int? CommandTimeout { get => throw null; set { } }
                    public string ContextKey { get => throw null; set { } }
                    public System.Type ContextType { get => throw null; set { } }
                    public DbMigrationsConfiguration() => throw null;
                    public const string DefaultMigrationsDirectory = default;
                    public System.Func<System.Data.Common.DbConnection, string, System.Data.Entity.Migrations.History.HistoryContext> GetHistoryContextFactory(string providerInvariantName) => throw null;
                    public System.Data.Entity.Migrations.Sql.MigrationSqlGenerator GetSqlGenerator(string providerInvariantName) => throw null;
                    public System.Reflection.Assembly MigrationsAssembly { get => throw null; set { } }
                    public string MigrationsDirectory { get => throw null; set { } }
                    public string MigrationsNamespace { get => throw null; set { } }
                    public void SetHistoryContextFactory(string providerInvariantName, System.Func<System.Data.Common.DbConnection, string, System.Data.Entity.Migrations.History.HistoryContext> factory) => throw null;
                    public void SetSqlGenerator(string providerInvariantName, System.Data.Entity.Migrations.Sql.MigrationSqlGenerator migrationSqlGenerator) => throw null;
                    public System.Data.Entity.Infrastructure.DbConnectionInfo TargetDatabase { get => throw null; set { } }
                }
                public class DbMigrationsConfiguration<TContext> : System.Data.Entity.Migrations.DbMigrationsConfiguration where TContext : System.Data.Entity.DbContext
                {
                    public DbMigrationsConfiguration() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Type GetType() => throw null;
                    protected object MemberwiseClone() => throw null;
                    protected virtual void Seed(TContext context) => throw null;
                    public override string ToString() => throw null;
                }
                public class DbMigrator : System.Data.Entity.Migrations.Infrastructure.MigratorBase
                {
                    public override System.Data.Entity.Migrations.DbMigrationsConfiguration Configuration { get => throw null; }
                    public DbMigrator(System.Data.Entity.Migrations.DbMigrationsConfiguration configuration) : base(default(System.Data.Entity.Migrations.Infrastructure.MigratorBase)) => throw null;
                    public DbMigrator(System.Data.Entity.Migrations.DbMigrationsConfiguration configuration, System.Data.Entity.DbContext context) : base(default(System.Data.Entity.Migrations.Infrastructure.MigratorBase)) => throw null;
                    public override System.Collections.Generic.IEnumerable<string> GetDatabaseMigrations() => throw null;
                    public override System.Collections.Generic.IEnumerable<string> GetLocalMigrations() => throw null;
                    public override System.Collections.Generic.IEnumerable<string> GetPendingMigrations() => throw null;
                    public const string InitialDatabase = default;
                    public override void Update(string targetMigration) => throw null;
                }
                public static partial class DbSetMigrationsExtensions
                {
                    public static void AddOrUpdate<TEntity>(this System.Data.Entity.IDbSet<TEntity> set, params TEntity[] entities) where TEntity : class => throw null;
                    public static void AddOrUpdate<TEntity>(this System.Data.Entity.IDbSet<TEntity> set, System.Linq.Expressions.Expression<System.Func<TEntity, object>> identifierExpression, params TEntity[] entities) where TEntity : class => throw null;
                }
                namespace Design
                {
                    public class CSharpMigrationCodeGenerator : System.Data.Entity.Migrations.Design.MigrationCodeGenerator
                    {
                        public CSharpMigrationCodeGenerator() => throw null;
                        public override System.Data.Entity.Migrations.Design.ScaffoldedMigration Generate(string migrationId, System.Collections.Generic.IEnumerable<System.Data.Entity.Migrations.Model.MigrationOperation> operations, string sourceModel, string targetModel, string @namespace, string className) => throw null;
                        protected virtual string Generate(System.Collections.Generic.IEnumerable<System.Data.Entity.Migrations.Model.MigrationOperation> operations, string @namespace, string className) => throw null;
                        protected virtual string Generate(string migrationId, string sourceModel, string targetModel, string @namespace, string className) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.AddColumnOperation addColumnOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.DropColumnOperation dropColumnOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.AlterColumnOperation alterColumnOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.CreateProcedureOperation createProcedureOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.AlterProcedureOperation alterProcedureOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.ParameterModel parameterModel, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer, bool emitName = default(bool)) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.DropProcedureOperation dropProcedureOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.CreateTableOperation createTableOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.AlterTableOperation alterTableOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Collections.Generic.IEnumerable<string> columns, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.AddPrimaryKeyOperation addPrimaryKeyOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.DropPrimaryKeyOperation dropPrimaryKeyOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.AddForeignKeyOperation addForeignKeyOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.DropForeignKeyOperation dropForeignKeyOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.CreateIndexOperation createIndexOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.DropIndexOperation dropIndexOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.ColumnModel column, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer, bool emitName = default(bool)) => throw null;
                        protected virtual string Generate(byte[] defaultValue) => throw null;
                        protected virtual string Generate(System.DateTime defaultValue) => throw null;
                        protected virtual string Generate(System.DateTimeOffset defaultValue) => throw null;
                        protected virtual string Generate(decimal defaultValue) => throw null;
                        protected virtual string Generate(System.Guid defaultValue) => throw null;
                        protected virtual string Generate(long defaultValue) => throw null;
                        protected virtual string Generate(float defaultValue) => throw null;
                        protected virtual string Generate(string defaultValue) => throw null;
                        protected virtual string Generate(System.TimeSpan defaultValue) => throw null;
                        protected virtual string Generate(System.Data.Entity.Hierarchy.HierarchyId defaultValue) => throw null;
                        protected virtual string Generate(System.Data.Entity.Spatial.DbGeography defaultValue) => throw null;
                        protected virtual string Generate(System.Data.Entity.Spatial.DbGeometry defaultValue) => throw null;
                        protected virtual string Generate(object defaultValue) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.DropTableOperation dropTableOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.MoveTableOperation moveTableOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.MoveProcedureOperation moveProcedureOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.RenameTableOperation renameTableOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.RenameProcedureOperation renameProcedureOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.RenameColumnOperation renameColumnOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.RenameIndexOperation renameIndexOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.SqlOperation sqlOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void GenerateAnnotation(string name, object annotation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void GenerateAnnotations(System.Collections.Generic.IDictionary<string, object> annotations, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void GenerateAnnotations(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void GenerateInline(System.Data.Entity.Migrations.Model.AddPrimaryKeyOperation addPrimaryKeyOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void GenerateInline(System.Data.Entity.Migrations.Model.AddForeignKeyOperation addForeignKeyOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void GenerateInline(System.Data.Entity.Migrations.Model.CreateIndexOperation createIndexOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual string Quote(string identifier) => throw null;
                        protected virtual string ScrubName(string name) => throw null;
                        protected virtual string TranslateColumnType(System.Data.Entity.Core.Metadata.Edm.PrimitiveTypeKind primitiveTypeKind) => throw null;
                        protected virtual void WriteClassAttributes(System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer, bool designer) => throw null;
                        protected virtual void WriteClassEnd(string @namespace, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void WriteClassStart(string @namespace, string className, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer, string @base, bool designer = default(bool), System.Collections.Generic.IEnumerable<string> namespaces = default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                        protected virtual void WriteProperty(string name, string value, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                    }
                    public abstract class MigrationCodeGenerator
                    {
                        public virtual System.Collections.Generic.IDictionary<string, System.Func<System.Data.Entity.Infrastructure.Annotations.AnnotationCodeGenerator>> AnnotationGenerators { get => throw null; }
                        protected MigrationCodeGenerator() => throw null;
                        public abstract System.Data.Entity.Migrations.Design.ScaffoldedMigration Generate(string migrationId, System.Collections.Generic.IEnumerable<System.Data.Entity.Migrations.Model.MigrationOperation> operations, string sourceModel, string targetModel, string @namespace, string className);
                        protected virtual System.Collections.Generic.IEnumerable<string> GetDefaultNamespaces(bool designer = default(bool)) => throw null;
                        protected virtual System.Collections.Generic.IEnumerable<string> GetNamespaces(System.Collections.Generic.IEnumerable<System.Data.Entity.Migrations.Model.MigrationOperation> operations) => throw null;
                    }
                    public class MigrationScaffolder
                    {
                        public MigrationScaffolder(System.Data.Entity.Migrations.DbMigrationsConfiguration migrationsConfiguration) => throw null;
                        public string Namespace { get => throw null; set { } }
                        public virtual System.Data.Entity.Migrations.Design.ScaffoldedMigration Scaffold(string migrationName) => throw null;
                        public virtual System.Data.Entity.Migrations.Design.ScaffoldedMigration Scaffold(string migrationName, bool ignoreChanges) => throw null;
                        public virtual System.Data.Entity.Migrations.Design.ScaffoldedMigration ScaffoldInitialCreate() => throw null;
                    }
                    public class ScaffoldedMigration
                    {
                        public ScaffoldedMigration() => throw null;
                        public string DesignerCode { get => throw null; set { } }
                        public string Directory { get => throw null; set { } }
                        public bool IsRescaffold { get => throw null; set { } }
                        public string Language { get => throw null; set { } }
                        public string MigrationId { get => throw null; set { } }
                        public System.Collections.Generic.IDictionary<string, object> Resources { get => throw null; }
                        public string UserCode { get => throw null; set { } }
                    }
                    public class VisualBasicMigrationCodeGenerator : System.Data.Entity.Migrations.Design.MigrationCodeGenerator
                    {
                        public VisualBasicMigrationCodeGenerator() => throw null;
                        public override System.Data.Entity.Migrations.Design.ScaffoldedMigration Generate(string migrationId, System.Collections.Generic.IEnumerable<System.Data.Entity.Migrations.Model.MigrationOperation> operations, string sourceModel, string targetModel, string @namespace, string className) => throw null;
                        protected virtual string Generate(System.Collections.Generic.IEnumerable<System.Data.Entity.Migrations.Model.MigrationOperation> operations, string @namespace, string className) => throw null;
                        protected virtual string Generate(string migrationId, string sourceModel, string targetModel, string @namespace, string className) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.AddColumnOperation addColumnOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.DropColumnOperation dropColumnOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.AlterColumnOperation alterColumnOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.CreateProcedureOperation createProcedureOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.AlterProcedureOperation alterProcedureOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.ParameterModel parameterModel, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer, bool emitName = default(bool)) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.DropProcedureOperation dropProcedureOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.CreateTableOperation createTableOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.AlterTableOperation alterTableOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Collections.Generic.IEnumerable<string> columns, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.AddForeignKeyOperation addForeignKeyOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.DropForeignKeyOperation dropForeignKeyOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.AddPrimaryKeyOperation addPrimaryKeyOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.DropPrimaryKeyOperation dropPrimaryKeyOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.CreateIndexOperation createIndexOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.DropIndexOperation dropIndexOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.ColumnModel column, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer, bool emitName = default(bool)) => throw null;
                        protected virtual string Generate(byte[] defaultValue) => throw null;
                        protected virtual string Generate(System.DateTime defaultValue) => throw null;
                        protected virtual string Generate(System.DateTimeOffset defaultValue) => throw null;
                        protected virtual string Generate(decimal defaultValue) => throw null;
                        protected virtual string Generate(System.Guid defaultValue) => throw null;
                        protected virtual string Generate(long defaultValue) => throw null;
                        protected virtual string Generate(float defaultValue) => throw null;
                        protected virtual string Generate(string defaultValue) => throw null;
                        protected virtual string Generate(System.TimeSpan defaultValue) => throw null;
                        protected virtual string Generate(System.Data.Entity.Hierarchy.HierarchyId defaultValue) => throw null;
                        protected virtual string Generate(System.Data.Entity.Spatial.DbGeography defaultValue) => throw null;
                        protected virtual string Generate(System.Data.Entity.Spatial.DbGeometry defaultValue) => throw null;
                        protected virtual string Generate(object defaultValue) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.DropTableOperation dropTableOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.MoveTableOperation moveTableOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.MoveProcedureOperation moveProcedureOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.RenameTableOperation renameTableOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.RenameProcedureOperation renameProcedureOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.RenameColumnOperation renameColumnOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.RenameIndexOperation renameIndexOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void Generate(System.Data.Entity.Migrations.Model.SqlOperation sqlOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void GenerateAnnotation(string name, object annotation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void GenerateAnnotations(System.Collections.Generic.IDictionary<string, object> annotations, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void GenerateAnnotations(System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void GenerateInline(System.Data.Entity.Migrations.Model.AddPrimaryKeyOperation addPrimaryKeyOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void GenerateInline(System.Data.Entity.Migrations.Model.AddForeignKeyOperation addForeignKeyOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void GenerateInline(System.Data.Entity.Migrations.Model.CreateIndexOperation createIndexOperation, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual string Quote(string identifier) => throw null;
                        protected virtual string ScrubName(string name) => throw null;
                        protected virtual string TranslateColumnType(System.Data.Entity.Core.Metadata.Edm.PrimitiveTypeKind primitiveTypeKind) => throw null;
                        protected virtual void WriteClassAttributes(System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer, bool designer) => throw null;
                        protected virtual void WriteClassEnd(string @namespace, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                        protected virtual void WriteClassStart(string @namespace, string className, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer, string @base, bool designer = default(bool), System.Collections.Generic.IEnumerable<string> namespaces = default(System.Collections.Generic.IEnumerable<string>)) => throw null;
                        protected virtual void WriteProperty(string name, string value, System.Data.Entity.Migrations.Utilities.IndentedTextWriter writer) => throw null;
                    }
                }
                namespace History
                {
                    public class HistoryContext : System.Data.Entity.DbContext, System.Data.Entity.Infrastructure.IDbModelCacheKeyProvider
                    {
                        public virtual string CacheKey { get => throw null; }
                        public HistoryContext(System.Data.Common.DbConnection existingConnection, string defaultSchema) => throw null;
                        protected string DefaultSchema { get => throw null; }
                        public const string DefaultTableName = default;
                        public virtual System.Data.Entity.IDbSet<System.Data.Entity.Migrations.History.HistoryRow> History { get => throw null; set { } }
                        protected override void OnModelCreating(System.Data.Entity.DbModelBuilder modelBuilder) => throw null;
                    }
                    public class HistoryRow
                    {
                        public string ContextKey { get => throw null; set { } }
                        public HistoryRow() => throw null;
                        public string MigrationId { get => throw null; set { } }
                        public byte[] Model { get => throw null; set { } }
                        public string ProductVersion { get => throw null; set { } }
                    }
                }
                namespace Infrastructure
                {
                    public sealed class AutomaticDataLossException : System.Data.Entity.Migrations.Infrastructure.MigrationsException
                    {
                        public AutomaticDataLossException() => throw null;
                        public AutomaticDataLossException(string message) => throw null;
                        public AutomaticDataLossException(string message, System.Exception innerException) => throw null;
                    }
                    public sealed class AutomaticMigrationsDisabledException : System.Data.Entity.Migrations.Infrastructure.MigrationsException
                    {
                        public AutomaticMigrationsDisabledException() => throw null;
                        public AutomaticMigrationsDisabledException(string message) => throw null;
                        public AutomaticMigrationsDisabledException(string message, System.Exception innerException) => throw null;
                    }
                    public interface IDbMigration
                    {
                        void AddOperation(System.Data.Entity.Migrations.Model.MigrationOperation migrationOperation);
                    }
                    public interface IMigrationMetadata
                    {
                        string Id { get; }
                        string Source { get; }
                        string Target { get; }
                    }
                    public class MigrationsException : System.Exception
                    {
                        public MigrationsException() => throw null;
                        public MigrationsException(string message) => throw null;
                        public MigrationsException(string message, System.Exception innerException) => throw null;
                        protected MigrationsException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    }
                    public abstract class MigrationsLogger : System.MarshalByRefObject
                    {
                        protected MigrationsLogger() => throw null;
                        public abstract void Info(string message);
                        public abstract void Verbose(string message);
                        public abstract void Warning(string message);
                    }
                    public sealed class MigrationsPendingException : System.Data.Entity.Migrations.Infrastructure.MigrationsException
                    {
                        public MigrationsPendingException() => throw null;
                        public MigrationsPendingException(string message) => throw null;
                        public MigrationsPendingException(string message, System.Exception innerException) => throw null;
                    }
                    public abstract class MigratorBase
                    {
                        public virtual System.Data.Entity.Migrations.DbMigrationsConfiguration Configuration { get => throw null; }
                        protected MigratorBase(System.Data.Entity.Migrations.Infrastructure.MigratorBase innerMigrator) => throw null;
                        public virtual System.Collections.Generic.IEnumerable<string> GetDatabaseMigrations() => throw null;
                        public virtual System.Collections.Generic.IEnumerable<string> GetLocalMigrations() => throw null;
                        public virtual System.Collections.Generic.IEnumerable<string> GetPendingMigrations() => throw null;
                        public void Update() => throw null;
                        public virtual void Update(string targetMigration) => throw null;
                    }
                    public class MigratorLoggingDecorator : System.Data.Entity.Migrations.Infrastructure.MigratorBase
                    {
                        public MigratorLoggingDecorator(System.Data.Entity.Migrations.Infrastructure.MigratorBase innerMigrator, System.Data.Entity.Migrations.Infrastructure.MigrationsLogger logger) : base(default(System.Data.Entity.Migrations.Infrastructure.MigratorBase)) => throw null;
                    }
                    public class MigratorScriptingDecorator : System.Data.Entity.Migrations.Infrastructure.MigratorBase
                    {
                        public MigratorScriptingDecorator(System.Data.Entity.Migrations.Infrastructure.MigratorBase innerMigrator) : base(default(System.Data.Entity.Migrations.Infrastructure.MigratorBase)) => throw null;
                        public string ScriptUpdate(string sourceMigration, string targetMigration) => throw null;
                    }
                }
                namespace Model
                {
                    public class AddColumnOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public System.Data.Entity.Migrations.Model.ColumnModel Column { get => throw null; }
                        public AddColumnOperation(string table, System.Data.Entity.Migrations.Model.ColumnModel column, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                        public string Table { get => throw null; }
                    }
                    public class AddForeignKeyOperation : System.Data.Entity.Migrations.Model.ForeignKeyOperation
                    {
                        public bool CascadeDelete { get => throw null; set { } }
                        public virtual System.Data.Entity.Migrations.Model.CreateIndexOperation CreateCreateIndexOperation() => throw null;
                        public AddForeignKeyOperation(object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                        public System.Collections.Generic.IList<string> PrincipalColumns { get => throw null; }
                    }
                    public class AddPrimaryKeyOperation : System.Data.Entity.Migrations.Model.PrimaryKeyOperation
                    {
                        public AddPrimaryKeyOperation(object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                    }
                    public class AlterColumnOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public System.Data.Entity.Migrations.Model.ColumnModel Column { get => throw null; }
                        public AlterColumnOperation(string table, System.Data.Entity.Migrations.Model.ColumnModel column, bool isDestructiveChange, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public AlterColumnOperation(string table, System.Data.Entity.Migrations.Model.ColumnModel column, bool isDestructiveChange, System.Data.Entity.Migrations.Model.AlterColumnOperation inverse, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                        public string Table { get => throw null; }
                    }
                    public class AlterProcedureOperation : System.Data.Entity.Migrations.Model.ProcedureOperation
                    {
                        public AlterProcedureOperation(string name, string bodySql, object anonymousArguments = default(object)) : base(default(string), default(string), default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                    }
                    public class AlterTableOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public virtual System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> Annotations { get => throw null; }
                        public virtual System.Collections.Generic.IList<System.Data.Entity.Migrations.Model.ColumnModel> Columns { get => throw null; }
                        public AlterTableOperation(string name, System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> annotations, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                        public virtual string Name { get => throw null; }
                    }
                    public class ColumnModel : System.Data.Entity.Migrations.Model.PropertyModel
                    {
                        public System.Collections.Generic.IDictionary<string, System.Data.Entity.Infrastructure.Annotations.AnnotationValues> Annotations { get => throw null; set { } }
                        public virtual object ClrDefaultValue { get => throw null; }
                        public virtual System.Type ClrType { get => throw null; }
                        public ColumnModel(System.Data.Entity.Core.Metadata.Edm.PrimitiveTypeKind type) : base(default(System.Data.Entity.Core.Metadata.Edm.PrimitiveTypeKind), default(System.Data.Entity.Core.Metadata.Edm.TypeUsage)) => throw null;
                        public ColumnModel(System.Data.Entity.Core.Metadata.Edm.PrimitiveTypeKind type, System.Data.Entity.Core.Metadata.Edm.TypeUsage typeUsage) : base(default(System.Data.Entity.Core.Metadata.Edm.PrimitiveTypeKind), default(System.Data.Entity.Core.Metadata.Edm.TypeUsage)) => throw null;
                        public virtual bool IsIdentity { get => throw null; set { } }
                        public bool IsNarrowerThan(System.Data.Entity.Migrations.Model.ColumnModel column, System.Data.Entity.Core.Common.DbProviderManifest providerManifest) => throw null;
                        public virtual bool? IsNullable { get => throw null; set { } }
                        public virtual bool IsTimestamp { get => throw null; set { } }
                    }
                    public class CreateIndexOperation : System.Data.Entity.Migrations.Model.IndexOperation
                    {
                        public CreateIndexOperation(object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public bool IsClustered { get => throw null; set { } }
                        public override bool IsDestructiveChange { get => throw null; }
                        public bool IsUnique { get => throw null; set { } }
                    }
                    public class CreateProcedureOperation : System.Data.Entity.Migrations.Model.ProcedureOperation
                    {
                        public CreateProcedureOperation(string name, string bodySql, object anonymousArguments = default(object)) : base(default(string), default(string), default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                    }
                    public class CreateTableOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public virtual System.Collections.Generic.IDictionary<string, object> Annotations { get => throw null; }
                        public virtual System.Collections.Generic.IList<System.Data.Entity.Migrations.Model.ColumnModel> Columns { get => throw null; }
                        public CreateTableOperation(string name, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public CreateTableOperation(string name, System.Collections.Generic.IDictionary<string, object> annotations, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                        public virtual string Name { get => throw null; }
                        public System.Data.Entity.Migrations.Model.AddPrimaryKeyOperation PrimaryKey { get => throw null; set { } }
                    }
                    public class DropColumnOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public DropColumnOperation(string table, string name, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public DropColumnOperation(string table, string name, System.Collections.Generic.IDictionary<string, object> removedAnnotations, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public DropColumnOperation(string table, string name, System.Data.Entity.Migrations.Model.AddColumnOperation inverse, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public DropColumnOperation(string table, string name, System.Collections.Generic.IDictionary<string, object> removedAnnotations, System.Data.Entity.Migrations.Model.AddColumnOperation inverse, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                        public string Name { get => throw null; }
                        public System.Collections.Generic.IDictionary<string, object> RemovedAnnotations { get => throw null; }
                        public string Table { get => throw null; }
                    }
                    public class DropForeignKeyOperation : System.Data.Entity.Migrations.Model.ForeignKeyOperation
                    {
                        public virtual System.Data.Entity.Migrations.Model.DropIndexOperation CreateDropIndexOperation() => throw null;
                        public DropForeignKeyOperation(object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public DropForeignKeyOperation(System.Data.Entity.Migrations.Model.AddForeignKeyOperation inverse, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                    }
                    public class DropIndexOperation : System.Data.Entity.Migrations.Model.IndexOperation
                    {
                        public DropIndexOperation(object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public DropIndexOperation(System.Data.Entity.Migrations.Model.CreateIndexOperation inverse, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                    }
                    public class DropPrimaryKeyOperation : System.Data.Entity.Migrations.Model.PrimaryKeyOperation
                    {
                        public System.Data.Entity.Migrations.Model.CreateTableOperation CreateTableOperation { get => throw null; }
                        public DropPrimaryKeyOperation(object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                    }
                    public class DropProcedureOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public DropProcedureOperation(string name, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                        public virtual string Name { get => throw null; }
                    }
                    public class DropTableOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public DropTableOperation(string name, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public DropTableOperation(string name, System.Collections.Generic.IDictionary<string, object> removedAnnotations, System.Collections.Generic.IDictionary<string, System.Collections.Generic.IDictionary<string, object>> removedColumnAnnotations, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public DropTableOperation(string name, System.Data.Entity.Migrations.Model.CreateTableOperation inverse, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public DropTableOperation(string name, System.Collections.Generic.IDictionary<string, object> removedAnnotations, System.Collections.Generic.IDictionary<string, System.Collections.Generic.IDictionary<string, object>> removedColumnAnnotations, System.Data.Entity.Migrations.Model.CreateTableOperation inverse, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                        public virtual string Name { get => throw null; }
                        public virtual System.Collections.Generic.IDictionary<string, object> RemovedAnnotations { get => throw null; }
                        public System.Collections.Generic.IDictionary<string, System.Collections.Generic.IDictionary<string, object>> RemovedColumnAnnotations { get => throw null; }
                    }
                    public abstract class ForeignKeyOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        protected ForeignKeyOperation(object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public System.Collections.Generic.IList<string> DependentColumns { get => throw null; }
                        public string DependentTable { get => throw null; set { } }
                        public bool HasDefaultName { get => throw null; }
                        public string Name { get => throw null; set { } }
                        public string PrincipalTable { get => throw null; set { } }
                    }
                    public class HistoryOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbModificationCommandTree> CommandTrees { get => throw null; }
                        public HistoryOperation(System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbModificationCommandTree> commandTrees, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override bool IsDestructiveChange { get => throw null; }
                    }
                    public abstract class IndexOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public static string BuildDefaultName(System.Collections.Generic.IEnumerable<string> columns) => throw null;
                        public System.Collections.Generic.IList<string> Columns { get => throw null; }
                        protected IndexOperation(object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public bool HasDefaultName { get => throw null; }
                        public string Name { get => throw null; set { } }
                        public string Table { get => throw null; set { } }
                    }
                    public abstract class MigrationOperation
                    {
                        public System.Collections.Generic.IDictionary<string, object> AnonymousArguments { get => throw null; }
                        protected MigrationOperation(object anonymousArguments) => throw null;
                        public virtual System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public abstract bool IsDestructiveChange { get; }
                    }
                    public class MoveProcedureOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public MoveProcedureOperation(string name, string newSchema, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                        public virtual string Name { get => throw null; }
                        public virtual string NewSchema { get => throw null; }
                    }
                    public class MoveTableOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public string ContextKey { get => throw null; }
                        public System.Data.Entity.Migrations.Model.CreateTableOperation CreateTableOperation { get => throw null; }
                        public MoveTableOperation(string name, string newSchema, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                        public bool IsSystem { get => throw null; }
                        public virtual string Name { get => throw null; }
                        public virtual string NewSchema { get => throw null; }
                    }
                    public class NotSupportedOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public override bool IsDestructiveChange { get => throw null; }
                        internal NotSupportedOperation() : base(default(object)) { }
                    }
                    public class ParameterModel : System.Data.Entity.Migrations.Model.PropertyModel
                    {
                        public ParameterModel(System.Data.Entity.Core.Metadata.Edm.PrimitiveTypeKind type) : base(default(System.Data.Entity.Core.Metadata.Edm.PrimitiveTypeKind), default(System.Data.Entity.Core.Metadata.Edm.TypeUsage)) => throw null;
                        public ParameterModel(System.Data.Entity.Core.Metadata.Edm.PrimitiveTypeKind type, System.Data.Entity.Core.Metadata.Edm.TypeUsage typeUsage) : base(default(System.Data.Entity.Core.Metadata.Edm.PrimitiveTypeKind), default(System.Data.Entity.Core.Metadata.Edm.TypeUsage)) => throw null;
                        public bool IsOutParameter { get => throw null; set { } }
                    }
                    public abstract class PrimaryKeyOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public static string BuildDefaultName(string table) => throw null;
                        public System.Collections.Generic.IList<string> Columns { get => throw null; }
                        protected PrimaryKeyOperation(object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public bool HasDefaultName { get => throw null; }
                        public bool IsClustered { get => throw null; set { } }
                        public override bool IsDestructiveChange { get => throw null; }
                        public string Name { get => throw null; set { } }
                        public string Table { get => throw null; set { } }
                    }
                    public abstract class ProcedureOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public string BodySql { get => throw null; }
                        protected ProcedureOperation(string name, string bodySql, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override bool IsDestructiveChange { get => throw null; }
                        public virtual string Name { get => throw null; }
                        public virtual System.Collections.Generic.IList<System.Data.Entity.Migrations.Model.ParameterModel> Parameters { get => throw null; }
                    }
                    public abstract class PropertyModel
                    {
                        protected PropertyModel(System.Data.Entity.Core.Metadata.Edm.PrimitiveTypeKind type, System.Data.Entity.Core.Metadata.Edm.TypeUsage typeUsage) => throw null;
                        public virtual object DefaultValue { get => throw null; set { } }
                        public virtual string DefaultValueSql { get => throw null; set { } }
                        public virtual bool? IsFixedLength { get => throw null; set { } }
                        public virtual bool? IsUnicode { get => throw null; set { } }
                        public virtual int? MaxLength { get => throw null; set { } }
                        public virtual string Name { get => throw null; set { } }
                        public virtual byte? Precision { get => throw null; set { } }
                        public virtual byte? Scale { get => throw null; set { } }
                        public virtual string StoreType { get => throw null; set { } }
                        public virtual System.Data.Entity.Core.Metadata.Edm.PrimitiveTypeKind Type { get => throw null; }
                        public System.Data.Entity.Core.Metadata.Edm.TypeUsage TypeUsage { get => throw null; }
                    }
                    public class RenameColumnOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public RenameColumnOperation(string table, string name, string newName, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                        public virtual string Name { get => throw null; }
                        public virtual string NewName { get => throw null; set { } }
                        public virtual string Table { get => throw null; }
                    }
                    public class RenameIndexOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public RenameIndexOperation(string table, string name, string newName, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                        public virtual string Name { get => throw null; }
                        public virtual string NewName { get => throw null; set { } }
                        public virtual string Table { get => throw null; }
                    }
                    public class RenameProcedureOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public RenameProcedureOperation(string name, string newName, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                        public virtual string Name { get => throw null; }
                        public virtual string NewName { get => throw null; }
                    }
                    public class RenameTableOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public RenameTableOperation(string name, string newName, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override System.Data.Entity.Migrations.Model.MigrationOperation Inverse { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                        public virtual string Name { get => throw null; }
                        public virtual string NewName { get => throw null; set { } }
                    }
                    public class SqlOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public SqlOperation(string sql, object anonymousArguments = default(object)) : base(default(object)) => throw null;
                        public override bool IsDestructiveChange { get => throw null; }
                        public virtual string Sql { get => throw null; }
                        public virtual bool SuppressTransaction { get => throw null; set { } }
                    }
                    public class UpdateDatabaseOperation : System.Data.Entity.Migrations.Model.MigrationOperation
                    {
                        public void AddMigration(string migrationId, System.Collections.Generic.IList<System.Data.Entity.Migrations.Model.MigrationOperation> operations) => throw null;
                        public UpdateDatabaseOperation(System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbQueryCommandTree> historyQueryTrees) : base(default(object)) => throw null;
                        public System.Collections.Generic.IList<System.Data.Entity.Core.Common.CommandTrees.DbQueryCommandTree> HistoryQueryTrees { get => throw null; }
                        public override bool IsDestructiveChange { get => throw null; }
                        public class Migration
                        {
                            public string MigrationId { get => throw null; }
                            public System.Collections.Generic.IList<System.Data.Entity.Migrations.Model.MigrationOperation> Operations { get => throw null; }
                        }
                        public System.Collections.Generic.IList<System.Data.Entity.Migrations.Model.UpdateDatabaseOperation.Migration> Migrations { get => throw null; }
                    }
                }
                namespace Sql
                {
                    public abstract class MigrationSqlGenerator
                    {
                        protected virtual System.Data.Entity.Core.Metadata.Edm.TypeUsage BuildStoreTypeUsage(string storeTypeName, System.Data.Entity.Migrations.Model.PropertyModel propertyModel) => throw null;
                        protected MigrationSqlGenerator() => throw null;
                        public abstract System.Collections.Generic.IEnumerable<System.Data.Entity.Migrations.Sql.MigrationStatement> Generate(System.Collections.Generic.IEnumerable<System.Data.Entity.Migrations.Model.MigrationOperation> migrationOperations, string providerManifestToken);
                        public virtual string GenerateProcedureBody(System.Collections.Generic.ICollection<System.Data.Entity.Core.Common.CommandTrees.DbModificationCommandTree> commandTrees, string rowsAffectedParameter, string providerManifestToken) => throw null;
                        public virtual bool IsPermissionDeniedError(System.Exception exception) => throw null;
                        protected System.Data.Entity.Core.Common.DbProviderManifest ProviderManifest { get => throw null; set { } }
                    }
                    public class MigrationStatement
                    {
                        public string BatchTerminator { get => throw null; set { } }
                        public MigrationStatement() => throw null;
                        public string Sql { get => throw null; set { } }
                        public bool SuppressTransaction { get => throw null; set { } }
                    }
                }
                namespace Utilities
                {
                    public class IndentedTextWriter : System.IO.TextWriter
                    {
                        public override void Close() => throw null;
                        public IndentedTextWriter(System.IO.TextWriter writer) => throw null;
                        public IndentedTextWriter(System.IO.TextWriter writer, string tabString) => throw null;
                        public static readonly System.Globalization.CultureInfo Culture;
                        public virtual string CurrentIndentation() => throw null;
                        public const string DefaultTabString = default;
                        public override System.Text.Encoding Encoding { get => throw null; }
                        public override void Flush() => throw null;
                        public int Indent { get => throw null; set { } }
                        public System.IO.TextWriter InnerWriter { get => throw null; }
                        public override string NewLine { get => throw null; set { } }
                        protected virtual void OutputTabs() => throw null;
                        public override void Write(string value) => throw null;
                        public override void Write(bool value) => throw null;
                        public override void Write(char value) => throw null;
                        public override void Write(char[] buffer) => throw null;
                        public override void Write(char[] buffer, int index, int count) => throw null;
                        public override void Write(double value) => throw null;
                        public override void Write(float value) => throw null;
                        public override void Write(int value) => throw null;
                        public override void Write(long value) => throw null;
                        public override void Write(object value) => throw null;
                        public override void Write(string format, object arg0) => throw null;
                        public override void Write(string format, object arg0, object arg1) => throw null;
                        public override void Write(string format, params object[] arg) => throw null;
                        public override void WriteLine(string value) => throw null;
                        public override void WriteLine() => throw null;
                        public override void WriteLine(bool value) => throw null;
                        public override void WriteLine(char value) => throw null;
                        public override void WriteLine(char[] buffer) => throw null;
                        public override void WriteLine(char[] buffer, int index, int count) => throw null;
                        public override void WriteLine(double value) => throw null;
                        public override void WriteLine(float value) => throw null;
                        public override void WriteLine(int value) => throw null;
                        public override void WriteLine(long value) => throw null;
                        public override void WriteLine(object value) => throw null;
                        public override void WriteLine(string format, object arg0) => throw null;
                        public override void WriteLine(string format, object arg0, object arg1) => throw null;
                        public override void WriteLine(string format, params object[] arg) => throw null;
                        public override void WriteLine(uint value) => throw null;
                        public void WriteLineNoTabs(string value) => throw null;
                    }
                }
            }
            namespace ModelConfiguration
            {
                public class ComplexTypeConfiguration<TComplexType> : System.Data.Entity.ModelConfiguration.Configuration.StructuralTypeConfiguration<TComplexType> where TComplexType : class
                {
                    public ComplexTypeConfiguration() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Type GetType() => throw null;
                    public System.Data.Entity.ModelConfiguration.ComplexTypeConfiguration<TComplexType> Ignore<TProperty>(System.Linq.Expressions.Expression<System.Func<TComplexType, TProperty>> propertyExpression) => throw null;
                    public override string ToString() => throw null;
                }
                namespace Configuration
                {
                    public abstract class AssociationMappingConfiguration
                    {
                        protected AssociationMappingConfiguration() => throw null;
                    }
                    public class AssociationModificationStoredProcedureConfiguration<TEntityType> where TEntityType : class
                    {
                        public System.Data.Entity.ModelConfiguration.Configuration.AssociationModificationStoredProcedureConfiguration<TEntityType> Parameter<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty>> propertyExpression, string parameterName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.AssociationModificationStoredProcedureConfiguration<TEntityType> Parameter<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty?>> propertyExpression, string parameterName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.AssociationModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, string>> propertyExpression, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.AssociationModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, byte[]>> propertyExpression, string parameterName) => throw null;
                    }
                    public class BinaryPropertyConfiguration : System.Data.Entity.ModelConfiguration.Configuration.LengthPropertyConfiguration
                    {
                        public System.Data.Entity.ModelConfiguration.Configuration.BinaryPropertyConfiguration HasColumnAnnotation(string name, object value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.BinaryPropertyConfiguration HasColumnName(string columnName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.BinaryPropertyConfiguration HasColumnOrder(int? columnOrder) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.BinaryPropertyConfiguration HasColumnType(string columnType) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.BinaryPropertyConfiguration HasDatabaseGeneratedOption(System.ComponentModel.DataAnnotations.Schema.DatabaseGeneratedOption? databaseGeneratedOption) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.BinaryPropertyConfiguration HasMaxLength(int? value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.BinaryPropertyConfiguration IsConcurrencyToken() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.BinaryPropertyConfiguration IsConcurrencyToken(bool? concurrencyToken) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.BinaryPropertyConfiguration IsFixedLength() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.BinaryPropertyConfiguration IsMaxLength() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.BinaryPropertyConfiguration IsOptional() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.BinaryPropertyConfiguration IsRequired() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.BinaryPropertyConfiguration IsRowVersion() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.BinaryPropertyConfiguration IsVariableLength() => throw null;
                    }
                    public abstract class CascadableNavigationPropertyConfiguration
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                        public void WillCascadeOnDelete() => throw null;
                        public void WillCascadeOnDelete(bool value) => throw null;
                    }
                    public class ConfigurationRegistrar
                    {
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConfigurationRegistrar Add<TEntityType>(System.Data.Entity.ModelConfiguration.EntityTypeConfiguration<TEntityType> entityTypeConfiguration) where TEntityType : class => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConfigurationRegistrar Add<TComplexType>(System.Data.Entity.ModelConfiguration.ComplexTypeConfiguration<TComplexType> complexTypeConfiguration) where TComplexType : class => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConfigurationRegistrar AddFromAssembly(System.Reflection.Assembly assembly) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                    }
                    public class ConventionDeleteModificationStoredProcedureConfiguration : System.Data.Entity.ModelConfiguration.Configuration.ConventionModificationStoredProcedureConfiguration
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionDeleteModificationStoredProcedureConfiguration HasName(string procedureName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionDeleteModificationStoredProcedureConfiguration HasName(string procedureName, string schemaName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionDeleteModificationStoredProcedureConfiguration Parameter(string propertyName, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionDeleteModificationStoredProcedureConfiguration Parameter(System.Reflection.PropertyInfo propertyInfo, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionDeleteModificationStoredProcedureConfiguration RowsAffectedParameter(string parameterName) => throw null;
                        public override string ToString() => throw null;
                    }
                    public class ConventionInsertModificationStoredProcedureConfiguration : System.Data.Entity.ModelConfiguration.Configuration.ConventionModificationStoredProcedureConfiguration
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionInsertModificationStoredProcedureConfiguration HasName(string procedureName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionInsertModificationStoredProcedureConfiguration HasName(string procedureName, string schemaName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionInsertModificationStoredProcedureConfiguration Parameter(string propertyName, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionInsertModificationStoredProcedureConfiguration Parameter(System.Reflection.PropertyInfo propertyInfo, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionInsertModificationStoredProcedureConfiguration Result(string propertyName, string columnName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionInsertModificationStoredProcedureConfiguration Result(System.Reflection.PropertyInfo propertyInfo, string columnName) => throw null;
                        public override string ToString() => throw null;
                    }
                    public abstract class ConventionModificationStoredProcedureConfiguration
                    {
                    }
                    public class ConventionModificationStoredProceduresConfiguration
                    {
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionModificationStoredProceduresConfiguration Delete(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ConventionDeleteModificationStoredProcedureConfiguration> modificationStoredProcedureConfigurationAction) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionModificationStoredProceduresConfiguration Insert(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ConventionInsertModificationStoredProcedureConfiguration> modificationStoredProcedureConfigurationAction) => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionModificationStoredProceduresConfiguration Update(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ConventionUpdateModificationStoredProcedureConfiguration> modificationStoredProcedureConfigurationAction) => throw null;
                    }
                    public class ConventionPrimitivePropertyConfiguration
                    {
                        public virtual System.Reflection.PropertyInfo ClrPropertyInfo { get => throw null; }
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration HasColumnAnnotation(string name, object value) => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration HasColumnName(string columnName) => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration HasColumnOrder(int columnOrder) => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration HasColumnType(string columnType) => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration HasDatabaseGeneratedOption(System.ComponentModel.DataAnnotations.Schema.DatabaseGeneratedOption databaseGeneratedOption) => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration HasMaxLength(int maxLength) => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration HasParameterName(string parameterName) => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration HasPrecision(byte value) => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration HasPrecision(byte precision, byte scale) => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration IsConcurrencyToken() => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration IsConcurrencyToken(bool concurrencyToken) => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration IsFixedLength() => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration IsKey() => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration IsMaxLength() => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration IsOptional() => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration IsRequired() => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration IsRowVersion() => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration IsUnicode() => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration IsUnicode(bool unicode) => throw null;
                        public virtual System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration IsVariableLength() => throw null;
                        public override string ToString() => throw null;
                    }
                    public class ConventionsConfiguration
                    {
                        public void Add(params System.Data.Entity.ModelConfiguration.Conventions.IConvention[] conventions) => throw null;
                        public void Add<TConvention>() where TConvention : System.Data.Entity.ModelConfiguration.Conventions.IConvention, new() => throw null;
                        public void AddAfter<TExistingConvention>(System.Data.Entity.ModelConfiguration.Conventions.IConvention newConvention) where TExistingConvention : System.Data.Entity.ModelConfiguration.Conventions.IConvention => throw null;
                        public void AddBefore<TExistingConvention>(System.Data.Entity.ModelConfiguration.Conventions.IConvention newConvention) where TExistingConvention : System.Data.Entity.ModelConfiguration.Conventions.IConvention => throw null;
                        public void AddFromAssembly(System.Reflection.Assembly assembly) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public void Remove(params System.Data.Entity.ModelConfiguration.Conventions.IConvention[] conventions) => throw null;
                        public void Remove<TConvention>() where TConvention : System.Data.Entity.ModelConfiguration.Conventions.IConvention => throw null;
                        public override string ToString() => throw null;
                    }
                    public class ConventionTypeConfiguration
                    {
                        public System.Type ClrType { get => throw null; }
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration HasEntitySetName(string entitySetName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration HasKey(string propertyName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration HasKey(System.Reflection.PropertyInfo propertyInfo) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration HasKey(System.Collections.Generic.IEnumerable<string> propertyNames) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration HasKey(System.Collections.Generic.IEnumerable<System.Reflection.PropertyInfo> keyProperties) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration HasTableAnnotation(string name, object value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration Ignore() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration Ignore(string propertyName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration Ignore(System.Reflection.PropertyInfo propertyInfo) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration IsComplexType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration MapToStoredProcedures() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration MapToStoredProcedures(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ConventionModificationStoredProceduresConfiguration> modificationStoredProceduresConfigurationAction) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration Property(string propertyName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration Property(System.Reflection.PropertyInfo propertyInfo) => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration ToTable(string tableName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration ToTable(string tableName, string schemaName) => throw null;
                    }
                    public class ConventionTypeConfiguration<T> where T : class
                    {
                        public System.Type ClrType { get => throw null; }
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration<T> HasEntitySetName(string entitySetName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration<T> HasKey<TProperty>(System.Linq.Expressions.Expression<System.Func<T, TProperty>> keyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration<T> HasTableAnnotation(string name, object value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration<T> Ignore() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration<T> Ignore<TProperty>(System.Linq.Expressions.Expression<System.Func<T, TProperty>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration<T> IsComplexType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration<T> MapToStoredProcedures() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration<T> MapToStoredProcedures(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ModificationStoredProceduresConfiguration<T>> modificationStoredProceduresConfigurationAction) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration Property<TProperty>(System.Linq.Expressions.Expression<System.Func<T, TProperty>> propertyExpression) => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration<T> ToTable(string tableName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration<T> ToTable(string tableName, string schemaName) => throw null;
                    }
                    public class ConventionUpdateModificationStoredProcedureConfiguration : System.Data.Entity.ModelConfiguration.Configuration.ConventionModificationStoredProcedureConfiguration
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionUpdateModificationStoredProcedureConfiguration HasName(string procedureName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionUpdateModificationStoredProcedureConfiguration HasName(string procedureName, string schemaName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionUpdateModificationStoredProcedureConfiguration Parameter(string propertyName, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionUpdateModificationStoredProcedureConfiguration Parameter(System.Reflection.PropertyInfo propertyInfo, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionUpdateModificationStoredProcedureConfiguration Parameter(string propertyName, string currentValueParameterName, string originalValueParameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionUpdateModificationStoredProcedureConfiguration Parameter(System.Reflection.PropertyInfo propertyInfo, string currentValueParameterName, string originalValueParameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionUpdateModificationStoredProcedureConfiguration Result(string propertyName, string columnName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionUpdateModificationStoredProcedureConfiguration Result(System.Reflection.PropertyInfo propertyInfo, string columnName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ConventionUpdateModificationStoredProcedureConfiguration RowsAffectedParameter(string parameterName) => throw null;
                        public override string ToString() => throw null;
                    }
                    public class DateTimePropertyConfiguration : System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration
                    {
                        public System.Data.Entity.ModelConfiguration.Configuration.DateTimePropertyConfiguration HasColumnAnnotation(string name, object value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DateTimePropertyConfiguration HasColumnName(string columnName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DateTimePropertyConfiguration HasColumnOrder(int? columnOrder) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DateTimePropertyConfiguration HasColumnType(string columnType) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DateTimePropertyConfiguration HasDatabaseGeneratedOption(System.ComponentModel.DataAnnotations.Schema.DatabaseGeneratedOption? databaseGeneratedOption) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DateTimePropertyConfiguration HasPrecision(byte value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DateTimePropertyConfiguration IsConcurrencyToken() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DateTimePropertyConfiguration IsConcurrencyToken(bool? concurrencyToken) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DateTimePropertyConfiguration IsOptional() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DateTimePropertyConfiguration IsRequired() => throw null;
                    }
                    public class DecimalPropertyConfiguration : System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration
                    {
                        public System.Data.Entity.ModelConfiguration.Configuration.DecimalPropertyConfiguration HasColumnAnnotation(string name, object value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DecimalPropertyConfiguration HasColumnName(string columnName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DecimalPropertyConfiguration HasColumnOrder(int? columnOrder) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DecimalPropertyConfiguration HasColumnType(string columnType) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DecimalPropertyConfiguration HasDatabaseGeneratedOption(System.ComponentModel.DataAnnotations.Schema.DatabaseGeneratedOption? databaseGeneratedOption) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DecimalPropertyConfiguration HasPrecision(byte precision, byte scale) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DecimalPropertyConfiguration IsConcurrencyToken() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DecimalPropertyConfiguration IsConcurrencyToken(bool? concurrencyToken) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DecimalPropertyConfiguration IsOptional() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DecimalPropertyConfiguration IsRequired() => throw null;
                    }
                    public class DeleteModificationStoredProcedureConfiguration<TEntityType> : System.Data.Entity.ModelConfiguration.Configuration.ModificationStoredProcedureConfigurationBase where TEntityType : class
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DeleteModificationStoredProcedureConfiguration<TEntityType> HasName(string procedureName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DeleteModificationStoredProcedureConfiguration<TEntityType> HasName(string procedureName, string schemaName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DeleteModificationStoredProcedureConfiguration<TEntityType> Navigation<TPrincipalEntityType>(System.Linq.Expressions.Expression<System.Func<TPrincipalEntityType, TEntityType>> navigationPropertyExpression, System.Action<System.Data.Entity.ModelConfiguration.Configuration.AssociationModificationStoredProcedureConfiguration<TPrincipalEntityType>> associationModificationStoredProcedureConfigurationAction) where TPrincipalEntityType : class => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DeleteModificationStoredProcedureConfiguration<TEntityType> Navigation<TPrincipalEntityType>(System.Linq.Expressions.Expression<System.Func<TPrincipalEntityType, System.Collections.Generic.ICollection<TEntityType>>> navigationPropertyExpression, System.Action<System.Data.Entity.ModelConfiguration.Configuration.AssociationModificationStoredProcedureConfiguration<TPrincipalEntityType>> associationModificationStoredProcedureConfigurationAction) where TPrincipalEntityType : class => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DeleteModificationStoredProcedureConfiguration<TEntityType> Parameter<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty>> propertyExpression, string parameterName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DeleteModificationStoredProcedureConfiguration<TEntityType> Parameter<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty?>> propertyExpression, string parameterName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DeleteModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, string>> propertyExpression, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DeleteModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, byte[]>> propertyExpression, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DeleteModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, System.Data.Entity.Spatial.DbGeography>> propertyExpression, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DeleteModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, System.Data.Entity.Spatial.DbGeometry>> propertyExpression, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DeleteModificationStoredProcedureConfiguration<TEntityType> RowsAffectedParameter(string parameterName) => throw null;
                        public override string ToString() => throw null;
                    }
                    public class DependentNavigationPropertyConfiguration<TDependentEntityType> : System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyNavigationPropertyConfiguration where TDependentEntityType : class
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.CascadableNavigationPropertyConfiguration HasForeignKey<TKey>(System.Linq.Expressions.Expression<System.Func<TDependentEntityType, TKey>> foreignKeyExpression) => throw null;
                        public override string ToString() => throw null;
                    }
                    public class EntityMappingConfiguration<TEntityType> where TEntityType : class
                    {
                        public EntityMappingConfiguration() => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.EntityMappingConfiguration<TEntityType> HasTableAnnotation(string name, object value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.EntityMappingConfiguration<TEntityType> MapInheritedProperties() => throw null;
                        public void Properties<TObject>(System.Linq.Expressions.Expression<System.Func<TEntityType, TObject>> propertiesExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyMappingConfiguration Property<T>(System.Linq.Expressions.Expression<System.Func<TEntityType, T>> propertyExpression) where T : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyMappingConfiguration Property<T>(System.Linq.Expressions.Expression<System.Func<TEntityType, T?>> propertyExpression) where T : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyMappingConfiguration Property(System.Linq.Expressions.Expression<System.Func<TEntityType, System.Data.Entity.Spatial.DbGeometry>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyMappingConfiguration Property(System.Linq.Expressions.Expression<System.Func<TEntityType, System.Data.Entity.Spatial.DbGeography>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyMappingConfiguration Property(System.Linq.Expressions.Expression<System.Func<TEntityType, string>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyMappingConfiguration Property(System.Linq.Expressions.Expression<System.Func<TEntityType, byte[]>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyMappingConfiguration Property(System.Linq.Expressions.Expression<System.Func<TEntityType, decimal>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyMappingConfiguration Property(System.Linq.Expressions.Expression<System.Func<TEntityType, decimal?>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyMappingConfiguration Property(System.Linq.Expressions.Expression<System.Func<TEntityType, System.DateTime>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyMappingConfiguration Property(System.Linq.Expressions.Expression<System.Func<TEntityType, System.DateTime?>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyMappingConfiguration Property(System.Linq.Expressions.Expression<System.Func<TEntityType, System.DateTimeOffset>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyMappingConfiguration Property(System.Linq.Expressions.Expression<System.Func<TEntityType, System.DateTimeOffset?>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyMappingConfiguration Property(System.Linq.Expressions.Expression<System.Func<TEntityType, System.TimeSpan>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyMappingConfiguration Property(System.Linq.Expressions.Expression<System.Func<TEntityType, System.TimeSpan?>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ValueConditionConfiguration Requires(string discriminator) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.NotNullConditionConfiguration Requires<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty>> property) => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.EntityMappingConfiguration<TEntityType> ToTable(string tableName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.EntityMappingConfiguration<TEntityType> ToTable(string tableName, string schemaName) => throw null;
                    }
                    public sealed class ForeignKeyAssociationMappingConfiguration : System.Data.Entity.ModelConfiguration.Configuration.AssociationMappingConfiguration
                    {
                        public bool Equals(System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyAssociationMappingConfiguration other) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyAssociationMappingConfiguration HasColumnAnnotation(string keyColumnName, string annotationName, object value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyAssociationMappingConfiguration MapKey(params string[] keyColumnNames) => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyAssociationMappingConfiguration ToTable(string tableName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyAssociationMappingConfiguration ToTable(string tableName, string schemaName) => throw null;
                    }
                    public class ForeignKeyNavigationPropertyConfiguration : System.Data.Entity.ModelConfiguration.Configuration.CascadableNavigationPropertyConfiguration
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.CascadableNavigationPropertyConfiguration Map(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyAssociationMappingConfiguration> configurationAction) => throw null;
                        public override string ToString() => throw null;
                    }
                    public class IndexConfiguration
                    {
                        public System.Data.Entity.ModelConfiguration.Configuration.IndexConfiguration HasName(string name) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.IndexConfiguration IsClustered() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.IndexConfiguration IsClustered(bool clustered) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.IndexConfiguration IsUnique() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.IndexConfiguration IsUnique(bool unique) => throw null;
                    }
                    public class InsertModificationStoredProcedureConfiguration<TEntityType> : System.Data.Entity.ModelConfiguration.Configuration.ModificationStoredProcedureConfigurationBase where TEntityType : class
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType> HasName(string procedureName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType> HasName(string procedureName, string schemaName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType> Navigation<TPrincipalEntityType>(System.Linq.Expressions.Expression<System.Func<TPrincipalEntityType, TEntityType>> navigationPropertyExpression, System.Action<System.Data.Entity.ModelConfiguration.Configuration.AssociationModificationStoredProcedureConfiguration<TPrincipalEntityType>> associationModificationStoredProcedureConfigurationAction) where TPrincipalEntityType : class => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType> Navigation<TPrincipalEntityType>(System.Linq.Expressions.Expression<System.Func<TPrincipalEntityType, System.Collections.Generic.ICollection<TEntityType>>> navigationPropertyExpression, System.Action<System.Data.Entity.ModelConfiguration.Configuration.AssociationModificationStoredProcedureConfiguration<TPrincipalEntityType>> associationModificationStoredProcedureConfigurationAction) where TPrincipalEntityType : class => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType> Parameter<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty>> propertyExpression, string parameterName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType> Parameter<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty?>> propertyExpression, string parameterName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, string>> propertyExpression, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, byte[]>> propertyExpression, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, System.Data.Entity.Spatial.DbGeography>> propertyExpression, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, System.Data.Entity.Spatial.DbGeometry>> propertyExpression, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType> Result<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty>> propertyExpression, string columnName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType> Result<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty?>> propertyExpression, string columnName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType> Result(System.Linq.Expressions.Expression<System.Func<TEntityType, string>> propertyExpression, string columnName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType> Result(System.Linq.Expressions.Expression<System.Func<TEntityType, byte[]>> propertyExpression, string columnName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType> Result(System.Linq.Expressions.Expression<System.Func<TEntityType, System.Data.Entity.Spatial.DbGeography>> propertyExpression, string columnName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType> Result(System.Linq.Expressions.Expression<System.Func<TEntityType, System.Data.Entity.Spatial.DbGeometry>> propertyExpression, string columnName) => throw null;
                        public override string ToString() => throw null;
                    }
                    public abstract class LengthColumnConfiguration : System.Data.Entity.ModelConfiguration.Configuration.PrimitiveColumnConfiguration
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.LengthColumnConfiguration HasMaxLength(int? value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.LengthColumnConfiguration IsFixedLength() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.LengthColumnConfiguration IsMaxLength() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.LengthColumnConfiguration IsVariableLength() => throw null;
                        public override string ToString() => throw null;
                    }
                    public abstract class LengthPropertyConfiguration : System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration
                    {
                        public System.Data.Entity.ModelConfiguration.Configuration.LengthPropertyConfiguration HasMaxLength(int? value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.LengthPropertyConfiguration IsFixedLength() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.LengthPropertyConfiguration IsMaxLength() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.LengthPropertyConfiguration IsVariableLength() => throw null;
                    }
                    public class ManyNavigationPropertyConfiguration<TEntityType, TTargetEntityType> where TEntityType : class where TTargetEntityType : class
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyNavigationPropertyConfiguration<TEntityType, TTargetEntityType> WithMany(System.Linq.Expressions.Expression<System.Func<TTargetEntityType, System.Collections.Generic.ICollection<TEntityType>>> navigationPropertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyNavigationPropertyConfiguration<TEntityType, TTargetEntityType> WithMany() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DependentNavigationPropertyConfiguration<TTargetEntityType> WithOptional(System.Linq.Expressions.Expression<System.Func<TTargetEntityType, TEntityType>> navigationPropertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DependentNavigationPropertyConfiguration<TTargetEntityType> WithOptional() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DependentNavigationPropertyConfiguration<TTargetEntityType> WithRequired(System.Linq.Expressions.Expression<System.Func<TTargetEntityType, TEntityType>> navigationPropertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DependentNavigationPropertyConfiguration<TTargetEntityType> WithRequired() => throw null;
                    }
                    public sealed class ManyToManyAssociationMappingConfiguration : System.Data.Entity.ModelConfiguration.Configuration.AssociationMappingConfiguration
                    {
                        public bool Equals(System.Data.Entity.ModelConfiguration.Configuration.ManyToManyAssociationMappingConfiguration other) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyAssociationMappingConfiguration HasTableAnnotation(string name, object value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyAssociationMappingConfiguration MapLeftKey(params string[] keyColumnNames) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyAssociationMappingConfiguration MapRightKey(params string[] keyColumnNames) => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyAssociationMappingConfiguration ToTable(string tableName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyAssociationMappingConfiguration ToTable(string tableName, string schemaName) => throw null;
                    }
                    public class ManyToManyModificationStoredProcedureConfiguration<TEntityType, TTargetEntityType> : System.Data.Entity.ModelConfiguration.Configuration.ModificationStoredProcedureConfigurationBase where TEntityType : class where TTargetEntityType : class
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyModificationStoredProcedureConfiguration<TEntityType, TTargetEntityType> HasName(string procedureName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyModificationStoredProcedureConfiguration<TEntityType, TTargetEntityType> HasName(string procedureName, string schemaName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyModificationStoredProcedureConfiguration<TEntityType, TTargetEntityType> LeftKeyParameter<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty>> propertyExpression, string parameterName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyModificationStoredProcedureConfiguration<TEntityType, TTargetEntityType> LeftKeyParameter<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty?>> propertyExpression, string parameterName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyModificationStoredProcedureConfiguration<TEntityType, TTargetEntityType> LeftKeyParameter(System.Linq.Expressions.Expression<System.Func<TEntityType, string>> propertyExpression, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyModificationStoredProcedureConfiguration<TEntityType, TTargetEntityType> LeftKeyParameter(System.Linq.Expressions.Expression<System.Func<TEntityType, byte[]>> propertyExpression, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyModificationStoredProcedureConfiguration<TEntityType, TTargetEntityType> RightKeyParameter<TProperty>(System.Linq.Expressions.Expression<System.Func<TTargetEntityType, TProperty>> propertyExpression, string parameterName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyModificationStoredProcedureConfiguration<TEntityType, TTargetEntityType> RightKeyParameter<TProperty>(System.Linq.Expressions.Expression<System.Func<TTargetEntityType, TProperty?>> propertyExpression, string parameterName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyModificationStoredProcedureConfiguration<TEntityType, TTargetEntityType> RightKeyParameter(System.Linq.Expressions.Expression<System.Func<TTargetEntityType, string>> propertyExpression, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyModificationStoredProcedureConfiguration<TEntityType, TTargetEntityType> RightKeyParameter(System.Linq.Expressions.Expression<System.Func<TTargetEntityType, byte[]>> propertyExpression, string parameterName) => throw null;
                        public override string ToString() => throw null;
                    }
                    public class ManyToManyModificationStoredProceduresConfiguration<TEntityType, TTargetEntityType> where TEntityType : class where TTargetEntityType : class
                    {
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyModificationStoredProceduresConfiguration<TEntityType, TTargetEntityType> Delete(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ManyToManyModificationStoredProcedureConfiguration<TEntityType, TTargetEntityType>> modificationStoredProcedureConfigurationAction) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyModificationStoredProceduresConfiguration<TEntityType, TTargetEntityType> Insert(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ManyToManyModificationStoredProcedureConfiguration<TEntityType, TTargetEntityType>> modificationStoredProcedureConfigurationAction) => throw null;
                        public override string ToString() => throw null;
                    }
                    public class ManyToManyNavigationPropertyConfiguration<TEntityType, TTargetEntityType> where TEntityType : class where TTargetEntityType : class
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyNavigationPropertyConfiguration<TEntityType, TTargetEntityType> Map(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ManyToManyAssociationMappingConfiguration> configurationAction) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyNavigationPropertyConfiguration<TEntityType, TTargetEntityType> MapToStoredProcedures() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ManyToManyNavigationPropertyConfiguration<TEntityType, TTargetEntityType> MapToStoredProcedures(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ManyToManyModificationStoredProceduresConfiguration<TEntityType, TTargetEntityType>> modificationStoredProcedureMappingConfigurationAction) => throw null;
                        public override string ToString() => throw null;
                    }
                    public abstract class ModificationStoredProcedureConfigurationBase
                    {
                    }
                    public class ModificationStoredProceduresConfiguration<TEntityType> where TEntityType : class
                    {
                        public System.Data.Entity.ModelConfiguration.Configuration.ModificationStoredProceduresConfiguration<TEntityType> Delete(System.Action<System.Data.Entity.ModelConfiguration.Configuration.DeleteModificationStoredProcedureConfiguration<TEntityType>> modificationStoredProcedureConfigurationAction) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ModificationStoredProceduresConfiguration<TEntityType> Insert(System.Action<System.Data.Entity.ModelConfiguration.Configuration.InsertModificationStoredProcedureConfiguration<TEntityType>> modificationStoredProcedureConfigurationAction) => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ModificationStoredProceduresConfiguration<TEntityType> Update(System.Action<System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType>> modificationStoredProcedureConfigurationAction) => throw null;
                    }
                    public class NotNullConditionConfiguration
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public void HasValue() => throw null;
                        public override string ToString() => throw null;
                    }
                    public class OptionalNavigationPropertyConfiguration<TEntityType, TTargetEntityType> where TEntityType : class where TTargetEntityType : class
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DependentNavigationPropertyConfiguration<TEntityType> WithMany(System.Linq.Expressions.Expression<System.Func<TTargetEntityType, System.Collections.Generic.ICollection<TEntityType>>> navigationPropertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DependentNavigationPropertyConfiguration<TEntityType> WithMany() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyNavigationPropertyConfiguration WithOptionalDependent(System.Linq.Expressions.Expression<System.Func<TTargetEntityType, TEntityType>> navigationPropertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyNavigationPropertyConfiguration WithOptionalDependent() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyNavigationPropertyConfiguration WithOptionalPrincipal(System.Linq.Expressions.Expression<System.Func<TTargetEntityType, TEntityType>> navigationPropertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyNavigationPropertyConfiguration WithOptionalPrincipal() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyNavigationPropertyConfiguration WithRequired(System.Linq.Expressions.Expression<System.Func<TTargetEntityType, TEntityType>> navigationPropertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyNavigationPropertyConfiguration WithRequired() => throw null;
                    }
                    public class PrimaryKeyIndexConfiguration
                    {
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimaryKeyIndexConfiguration HasName(string name) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimaryKeyIndexConfiguration IsClustered() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimaryKeyIndexConfiguration IsClustered(bool clustered) => throw null;
                    }
                    public class PrimitiveColumnConfiguration
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitiveColumnConfiguration HasColumnOrder(int? columnOrder) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitiveColumnConfiguration HasColumnType(string columnType) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitiveColumnConfiguration IsOptional() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitiveColumnConfiguration IsRequired() => throw null;
                        public override string ToString() => throw null;
                    }
                    public class PrimitivePropertyConfiguration
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration HasColumnAnnotation(string name, object value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration HasColumnName(string columnName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration HasColumnOrder(int? columnOrder) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration HasColumnType(string columnType) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration HasDatabaseGeneratedOption(System.ComponentModel.DataAnnotations.Schema.DatabaseGeneratedOption? databaseGeneratedOption) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration HasParameterName(string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration IsConcurrencyToken() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration IsConcurrencyToken(bool? concurrencyToken) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration IsOptional() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration IsRequired() => throw null;
                        public override string ToString() => throw null;
                    }
                    public class PropertyConventionConfiguration
                    {
                        public void Configure(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration> propertyConfigurationAction) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyConventionWithHavingConfiguration<T> Having<T>(System.Func<System.Reflection.PropertyInfo, T> capturingPredicate) where T : class => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyConventionConfiguration Where(System.Func<System.Reflection.PropertyInfo, bool> predicate) => throw null;
                    }
                    public class PropertyConventionWithHavingConfiguration<T> where T : class
                    {
                        public void Configure(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration, T> propertyConfigurationAction) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                    }
                    public class PropertyMappingConfiguration
                    {
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyMappingConfiguration HasColumnAnnotation(string name, object value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyMappingConfiguration HasColumnName(string columnName) => throw null;
                    }
                    public class RequiredNavigationPropertyConfiguration<TEntityType, TTargetEntityType> where TEntityType : class where TTargetEntityType : class
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DependentNavigationPropertyConfiguration<TEntityType> WithMany(System.Linq.Expressions.Expression<System.Func<TTargetEntityType, System.Collections.Generic.ICollection<TEntityType>>> navigationPropertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DependentNavigationPropertyConfiguration<TEntityType> WithMany() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyNavigationPropertyConfiguration WithOptional(System.Linq.Expressions.Expression<System.Func<TTargetEntityType, TEntityType>> navigationPropertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyNavigationPropertyConfiguration WithOptional() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyNavigationPropertyConfiguration WithRequiredDependent(System.Linq.Expressions.Expression<System.Func<TTargetEntityType, TEntityType>> navigationPropertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyNavigationPropertyConfiguration WithRequiredDependent() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyNavigationPropertyConfiguration WithRequiredPrincipal(System.Linq.Expressions.Expression<System.Func<TTargetEntityType, TEntityType>> navigationPropertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.ForeignKeyNavigationPropertyConfiguration WithRequiredPrincipal() => throw null;
                    }
                    public class StringColumnConfiguration : System.Data.Entity.ModelConfiguration.Configuration.LengthColumnConfiguration
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringColumnConfiguration HasColumnOrder(int? columnOrder) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringColumnConfiguration HasColumnType(string columnType) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringColumnConfiguration HasMaxLength(int? value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringColumnConfiguration IsFixedLength() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringColumnConfiguration IsMaxLength() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringColumnConfiguration IsOptional() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringColumnConfiguration IsRequired() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringColumnConfiguration IsUnicode() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringColumnConfiguration IsUnicode(bool? unicode) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringColumnConfiguration IsVariableLength() => throw null;
                        public override string ToString() => throw null;
                    }
                    public class StringPropertyConfiguration : System.Data.Entity.ModelConfiguration.Configuration.LengthPropertyConfiguration
                    {
                        public System.Data.Entity.ModelConfiguration.Configuration.StringPropertyConfiguration HasColumnAnnotation(string name, object value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringPropertyConfiguration HasColumnName(string columnName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringPropertyConfiguration HasColumnOrder(int? columnOrder) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringPropertyConfiguration HasColumnType(string columnType) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringPropertyConfiguration HasDatabaseGeneratedOption(System.ComponentModel.DataAnnotations.Schema.DatabaseGeneratedOption? databaseGeneratedOption) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringPropertyConfiguration HasMaxLength(int? value) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringPropertyConfiguration IsConcurrencyToken() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringPropertyConfiguration IsConcurrencyToken(bool? concurrencyToken) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringPropertyConfiguration IsFixedLength() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringPropertyConfiguration IsMaxLength() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringPropertyConfiguration IsOptional() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringPropertyConfiguration IsRequired() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringPropertyConfiguration IsUnicode() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringPropertyConfiguration IsUnicode(bool? unicode) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringPropertyConfiguration IsVariableLength() => throw null;
                    }
                    public abstract class StructuralTypeConfiguration<TStructuralType> where TStructuralType : class
                    {
                        protected StructuralTypeConfiguration() => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration Property<T>(System.Linq.Expressions.Expression<System.Func<TStructuralType, T>> propertyExpression) where T : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration Property<T>(System.Linq.Expressions.Expression<System.Func<TStructuralType, T?>> propertyExpression) where T : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration Property(System.Linq.Expressions.Expression<System.Func<TStructuralType, System.Data.Entity.Hierarchy.HierarchyId>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration Property(System.Linq.Expressions.Expression<System.Func<TStructuralType, System.Data.Entity.Spatial.DbGeometry>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitivePropertyConfiguration Property(System.Linq.Expressions.Expression<System.Func<TStructuralType, System.Data.Entity.Spatial.DbGeography>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringPropertyConfiguration Property(System.Linq.Expressions.Expression<System.Func<TStructuralType, string>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.BinaryPropertyConfiguration Property(System.Linq.Expressions.Expression<System.Func<TStructuralType, byte[]>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DecimalPropertyConfiguration Property(System.Linq.Expressions.Expression<System.Func<TStructuralType, decimal>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DecimalPropertyConfiguration Property(System.Linq.Expressions.Expression<System.Func<TStructuralType, decimal?>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DateTimePropertyConfiguration Property(System.Linq.Expressions.Expression<System.Func<TStructuralType, System.DateTime>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DateTimePropertyConfiguration Property(System.Linq.Expressions.Expression<System.Func<TStructuralType, System.DateTime?>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DateTimePropertyConfiguration Property(System.Linq.Expressions.Expression<System.Func<TStructuralType, System.DateTimeOffset>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DateTimePropertyConfiguration Property(System.Linq.Expressions.Expression<System.Func<TStructuralType, System.DateTimeOffset?>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DateTimePropertyConfiguration Property(System.Linq.Expressions.Expression<System.Func<TStructuralType, System.TimeSpan>> propertyExpression) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.DateTimePropertyConfiguration Property(System.Linq.Expressions.Expression<System.Func<TStructuralType, System.TimeSpan?>> propertyExpression) => throw null;
                        public override string ToString() => throw null;
                    }
                    public class TypeConventionConfiguration
                    {
                        public void Configure(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration> entityConfigurationAction) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.TypeConventionWithHavingConfiguration<T> Having<T>(System.Func<System.Type, T> capturingPredicate) where T : class => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.TypeConventionConfiguration Where(System.Func<System.Type, bool> predicate) => throw null;
                    }
                    public class TypeConventionConfiguration<T> where T : class
                    {
                        public void Configure(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration<T>> entityConfigurationAction) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.TypeConventionWithHavingConfiguration<T, TValue> Having<TValue>(System.Func<System.Type, TValue> capturingPredicate) where TValue : class => throw null;
                        public override string ToString() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.TypeConventionConfiguration<T> Where(System.Func<System.Type, bool> predicate) => throw null;
                    }
                    public class TypeConventionWithHavingConfiguration<T> where T : class
                    {
                        public void Configure(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration, T> entityConfigurationAction) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                    }
                    public class TypeConventionWithHavingConfiguration<T, TValue> where T : class where TValue : class
                    {
                        public void Configure(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration<T>, TValue> entityConfigurationAction) => throw null;
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public override string ToString() => throw null;
                    }
                    public class UpdateModificationStoredProcedureConfiguration<TEntityType> : System.Data.Entity.ModelConfiguration.Configuration.ModificationStoredProcedureConfigurationBase where TEntityType : class
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> HasName(string procedureName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> HasName(string procedureName, string schemaName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Navigation<TPrincipalEntityType>(System.Linq.Expressions.Expression<System.Func<TPrincipalEntityType, TEntityType>> navigationPropertyExpression, System.Action<System.Data.Entity.ModelConfiguration.Configuration.AssociationModificationStoredProcedureConfiguration<TPrincipalEntityType>> associationModificationStoredProcedureConfigurationAction) where TPrincipalEntityType : class => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Navigation<TPrincipalEntityType>(System.Linq.Expressions.Expression<System.Func<TPrincipalEntityType, System.Collections.Generic.ICollection<TEntityType>>> navigationPropertyExpression, System.Action<System.Data.Entity.ModelConfiguration.Configuration.AssociationModificationStoredProcedureConfiguration<TPrincipalEntityType>> associationModificationStoredProcedureConfigurationAction) where TPrincipalEntityType : class => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Parameter<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty>> propertyExpression, string parameterName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Parameter<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty?>> propertyExpression, string parameterName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, string>> propertyExpression, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, byte[]>> propertyExpression, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, System.Data.Entity.Spatial.DbGeography>> propertyExpression, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, System.Data.Entity.Spatial.DbGeometry>> propertyExpression, string parameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Parameter<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty>> propertyExpression, string currentValueParameterName, string originalValueParameterName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Parameter<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty?>> propertyExpression, string currentValueParameterName, string originalValueParameterName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, string>> propertyExpression, string currentValueParameterName, string originalValueParameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, byte[]>> propertyExpression, string currentValueParameterName, string originalValueParameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, System.Data.Entity.Spatial.DbGeography>> propertyExpression, string currentValueParameterName, string originalValueParameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Parameter(System.Linq.Expressions.Expression<System.Func<TEntityType, System.Data.Entity.Spatial.DbGeometry>> propertyExpression, string currentValueParameterName, string originalValueParameterName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Result<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty>> propertyExpression, string columnName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Result<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty?>> propertyExpression, string columnName) where TProperty : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Result(System.Linq.Expressions.Expression<System.Func<TEntityType, string>> propertyExpression, string columnName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Result(System.Linq.Expressions.Expression<System.Func<TEntityType, byte[]>> propertyExpression, string columnName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Result(System.Linq.Expressions.Expression<System.Func<TEntityType, System.Data.Entity.Spatial.DbGeography>> propertyExpression, string columnName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> Result(System.Linq.Expressions.Expression<System.Func<TEntityType, System.Data.Entity.Spatial.DbGeometry>> propertyExpression, string columnName) => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.UpdateModificationStoredProcedureConfiguration<TEntityType> RowsAffectedParameter(string parameterName) => throw null;
                        public override string ToString() => throw null;
                    }
                    public class ValueConditionConfiguration
                    {
                        public override bool Equals(object obj) => throw null;
                        public override int GetHashCode() => throw null;
                        public System.Type GetType() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitiveColumnConfiguration HasValue<T>(T value) where T : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PrimitiveColumnConfiguration HasValue<T>(T? value) where T : struct => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.StringColumnConfiguration HasValue(string value) => throw null;
                        public override string ToString() => throw null;
                    }
                }
                namespace Conventions
                {
                    public class AssociationInverseDiscoveryConvention : System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.EdmModel>, System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.EdmModel item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public AssociationInverseDiscoveryConvention() => throw null;
                    }
                    public class AttributeToColumnAnnotationConvention<TAttribute, TAnnotation> : System.Data.Entity.ModelConfiguration.Conventions.Convention where TAttribute : System.Attribute
                    {
                        public AttributeToColumnAnnotationConvention(string annotationName, System.Func<System.Reflection.PropertyInfo, System.Collections.Generic.IList<TAttribute>, TAnnotation> annotationFactory) => throw null;
                    }
                    public class AttributeToTableAnnotationConvention<TAttribute, TAnnotation> : System.Data.Entity.ModelConfiguration.Conventions.Convention where TAttribute : System.Attribute
                    {
                        public AttributeToTableAnnotationConvention(string annotationName, System.Func<System.Type, System.Collections.Generic.IList<TAttribute>, TAnnotation> annotationFactory) => throw null;
                    }
                    public class ColumnAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.PrimitivePropertyAttributeConfigurationConvention<System.ComponentModel.DataAnnotations.Schema.ColumnAttribute>
                    {
                        public override void Apply(System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration configuration, System.ComponentModel.DataAnnotations.Schema.ColumnAttribute attribute) => throw null;
                        public ColumnAttributeConvention() => throw null;
                    }
                    public class ColumnOrderingConvention : System.Data.Entity.ModelConfiguration.Conventions.IConvention, System.Data.Entity.ModelConfiguration.Conventions.IStoreModelConvention<System.Data.Entity.Core.Metadata.Edm.EntityType>
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.EntityType item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public ColumnOrderingConvention() => throw null;
                        protected virtual void ValidateColumns(System.Data.Entity.Core.Metadata.Edm.EntityType table, string tableName) => throw null;
                    }
                    public class ColumnOrderingConventionStrict : System.Data.Entity.ModelConfiguration.Conventions.ColumnOrderingConvention
                    {
                        public ColumnOrderingConventionStrict() => throw null;
                        protected override void ValidateColumns(System.Data.Entity.Core.Metadata.Edm.EntityType table, string tableName) => throw null;
                    }
                    public class ComplexTypeAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.TypeAttributeConfigurationConvention<System.ComponentModel.DataAnnotations.Schema.ComplexTypeAttribute>
                    {
                        public override void Apply(System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration configuration, System.ComponentModel.DataAnnotations.Schema.ComplexTypeAttribute attribute) => throw null;
                        public ComplexTypeAttributeConvention() => throw null;
                    }
                    public class ComplexTypeDiscoveryConvention : System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.EdmModel>, System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.EdmModel item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public ComplexTypeDiscoveryConvention() => throw null;
                    }
                    public class ConcurrencyCheckAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.PrimitivePropertyAttributeConfigurationConvention<System.ComponentModel.DataAnnotations.ConcurrencyCheckAttribute>
                    {
                        public override void Apply(System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration configuration, System.ComponentModel.DataAnnotations.ConcurrencyCheckAttribute attribute) => throw null;
                        public ConcurrencyCheckAttributeConvention() => throw null;
                    }
                    public class Convention : System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public Convention() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyConventionConfiguration Properties() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.PropertyConventionConfiguration Properties<T>() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.TypeConventionConfiguration Types() => throw null;
                        public System.Data.Entity.ModelConfiguration.Configuration.TypeConventionConfiguration<T> Types<T>() where T : class => throw null;
                    }
                    public class DatabaseGeneratedAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.PrimitivePropertyAttributeConfigurationConvention<System.ComponentModel.DataAnnotations.Schema.DatabaseGeneratedAttribute>
                    {
                        public override void Apply(System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration configuration, System.ComponentModel.DataAnnotations.Schema.DatabaseGeneratedAttribute attribute) => throw null;
                        public DatabaseGeneratedAttributeConvention() => throw null;
                    }
                    public class DecimalPropertyConvention : System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.EdmProperty>, System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.EdmProperty item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public DecimalPropertyConvention() => throw null;
                        public DecimalPropertyConvention(byte precision, byte scale) => throw null;
                    }
                    public class DeclaredPropertyOrderingConvention : System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.EntityType>, System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.EntityType item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public DeclaredPropertyOrderingConvention() => throw null;
                    }
                    public class ForeignKeyAssociationMultiplicityConvention : System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.AssociationType>, System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.AssociationType item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public ForeignKeyAssociationMultiplicityConvention() => throw null;
                    }
                    public abstract class ForeignKeyDiscoveryConvention : System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.AssociationType>, System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.AssociationType item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        protected ForeignKeyDiscoveryConvention() => throw null;
                        protected abstract bool MatchDependentKeyProperty(System.Data.Entity.Core.Metadata.Edm.AssociationType associationType, System.Data.Entity.Core.Metadata.Edm.AssociationEndMember dependentAssociationEnd, System.Data.Entity.Core.Metadata.Edm.EdmProperty dependentProperty, System.Data.Entity.Core.Metadata.Edm.EntityType principalEntityType, System.Data.Entity.Core.Metadata.Edm.EdmProperty principalKeyProperty);
                        protected virtual bool SupportsMultipleAssociations { get => throw null; }
                    }
                    public class ForeignKeyIndexConvention : System.Data.Entity.ModelConfiguration.Conventions.IConvention, System.Data.Entity.ModelConfiguration.Conventions.IStoreModelConvention<System.Data.Entity.Core.Metadata.Edm.AssociationType>
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.AssociationType item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public ForeignKeyIndexConvention() => throw null;
                    }
                    public class ForeignKeyNavigationPropertyAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.NavigationProperty>, System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.NavigationProperty item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public ForeignKeyNavigationPropertyAttributeConvention() => throw null;
                    }
                    public class ForeignKeyPrimitivePropertyAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.PropertyAttributeConfigurationConvention<System.ComponentModel.DataAnnotations.Schema.ForeignKeyAttribute>
                    {
                        public override void Apply(System.Reflection.PropertyInfo memberInfo, System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration configuration, System.ComponentModel.DataAnnotations.Schema.ForeignKeyAttribute attribute) => throw null;
                        public ForeignKeyPrimitivePropertyAttributeConvention() => throw null;
                    }
                    public interface IConceptualModelConvention<T> : System.Data.Entity.ModelConfiguration.Conventions.IConvention where T : System.Data.Entity.Core.Metadata.Edm.MetadataItem
                    {
                        void Apply(T item, System.Data.Entity.Infrastructure.DbModel model);
                    }
                    public interface IConvention
                    {
                    }
                    public class IdKeyDiscoveryConvention : System.Data.Entity.ModelConfiguration.Conventions.KeyDiscoveryConvention
                    {
                        public IdKeyDiscoveryConvention() => throw null;
                        protected override System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmProperty> MatchKeyProperty(System.Data.Entity.Core.Metadata.Edm.EntityType entityType, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmProperty> primitiveProperties) => throw null;
                    }
                    public class IndexAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.AttributeToColumnAnnotationConvention<System.ComponentModel.DataAnnotations.Schema.IndexAttribute, System.Data.Entity.Infrastructure.Annotations.IndexAnnotation>
                    {
                        public IndexAttributeConvention() : base(default(string), default(System.Func<System.Reflection.PropertyInfo, System.Collections.Generic.IList<System.ComponentModel.DataAnnotations.Schema.IndexAttribute>, System.Data.Entity.Infrastructure.Annotations.IndexAnnotation>)) => throw null;
                    }
                    public class InversePropertyAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.PropertyAttributeConfigurationConvention<System.ComponentModel.DataAnnotations.Schema.InversePropertyAttribute>
                    {
                        public override void Apply(System.Reflection.PropertyInfo memberInfo, System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration configuration, System.ComponentModel.DataAnnotations.Schema.InversePropertyAttribute attribute) => throw null;
                        public InversePropertyAttributeConvention() => throw null;
                    }
                    public interface IStoreModelConvention<T> : System.Data.Entity.ModelConfiguration.Conventions.IConvention where T : System.Data.Entity.Core.Metadata.Edm.MetadataItem
                    {
                        void Apply(T item, System.Data.Entity.Infrastructure.DbModel model);
                    }
                    public class KeyAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.Convention
                    {
                        public KeyAttributeConvention() => throw null;
                    }
                    public abstract class KeyDiscoveryConvention : System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.EntityType>, System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.EntityType item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        protected KeyDiscoveryConvention() => throw null;
                        protected abstract System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmProperty> MatchKeyProperty(System.Data.Entity.Core.Metadata.Edm.EntityType entityType, System.Collections.Generic.IEnumerable<System.Data.Entity.Core.Metadata.Edm.EdmProperty> primitiveProperties);
                    }
                    public class ManyToManyCascadeDeleteConvention : System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public ManyToManyCascadeDeleteConvention() => throw null;
                    }
                    public class MappingInheritedPropertiesSupportConvention : System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public MappingInheritedPropertiesSupportConvention() => throw null;
                    }
                    public class MaxLengthAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.PrimitivePropertyAttributeConfigurationConvention<System.ComponentModel.DataAnnotations.MaxLengthAttribute>
                    {
                        public override void Apply(System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration configuration, System.ComponentModel.DataAnnotations.MaxLengthAttribute attribute) => throw null;
                        public MaxLengthAttributeConvention() => throw null;
                    }
                    public class NavigationPropertyNameForeignKeyDiscoveryConvention : System.Data.Entity.ModelConfiguration.Conventions.ForeignKeyDiscoveryConvention
                    {
                        public NavigationPropertyNameForeignKeyDiscoveryConvention() => throw null;
                        protected override bool MatchDependentKeyProperty(System.Data.Entity.Core.Metadata.Edm.AssociationType associationType, System.Data.Entity.Core.Metadata.Edm.AssociationEndMember dependentAssociationEnd, System.Data.Entity.Core.Metadata.Edm.EdmProperty dependentProperty, System.Data.Entity.Core.Metadata.Edm.EntityType principalEntityType, System.Data.Entity.Core.Metadata.Edm.EdmProperty principalKeyProperty) => throw null;
                        protected override bool SupportsMultipleAssociations { get => throw null; }
                    }
                    public class NotMappedPropertyAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.PropertyAttributeConfigurationConvention<System.ComponentModel.DataAnnotations.Schema.NotMappedAttribute>
                    {
                        public override void Apply(System.Reflection.PropertyInfo memberInfo, System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration configuration, System.ComponentModel.DataAnnotations.Schema.NotMappedAttribute attribute) => throw null;
                        public NotMappedPropertyAttributeConvention() => throw null;
                    }
                    public class NotMappedTypeAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.TypeAttributeConfigurationConvention<System.ComponentModel.DataAnnotations.Schema.NotMappedAttribute>
                    {
                        public override void Apply(System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration configuration, System.ComponentModel.DataAnnotations.Schema.NotMappedAttribute attribute) => throw null;
                        public NotMappedTypeAttributeConvention() => throw null;
                    }
                    public class OneToManyCascadeDeleteConvention : System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.AssociationType>, System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.AssociationType item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public OneToManyCascadeDeleteConvention() => throw null;
                    }
                    public class OneToOneConstraintIntroductionConvention : System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.AssociationType>, System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.AssociationType item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public OneToOneConstraintIntroductionConvention() => throw null;
                    }
                    public class PluralizingEntitySetNameConvention : System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.EntitySet>, System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.EntitySet item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public PluralizingEntitySetNameConvention() => throw null;
                    }
                    public class PluralizingTableNameConvention : System.Data.Entity.ModelConfiguration.Conventions.IConvention, System.Data.Entity.ModelConfiguration.Conventions.IStoreModelConvention<System.Data.Entity.Core.Metadata.Edm.EntityType>
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.EntityType item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public PluralizingTableNameConvention() => throw null;
                    }
                    public class PrimaryKeyNameForeignKeyDiscoveryConvention : System.Data.Entity.ModelConfiguration.Conventions.ForeignKeyDiscoveryConvention
                    {
                        public PrimaryKeyNameForeignKeyDiscoveryConvention() => throw null;
                        protected override bool MatchDependentKeyProperty(System.Data.Entity.Core.Metadata.Edm.AssociationType associationType, System.Data.Entity.Core.Metadata.Edm.AssociationEndMember dependentAssociationEnd, System.Data.Entity.Core.Metadata.Edm.EdmProperty dependentProperty, System.Data.Entity.Core.Metadata.Edm.EntityType principalEntityType, System.Data.Entity.Core.Metadata.Edm.EdmProperty principalKeyProperty) => throw null;
                    }
                    public abstract class PrimitivePropertyAttributeConfigurationConvention<TAttribute> : System.Data.Entity.ModelConfiguration.Conventions.Convention where TAttribute : System.Attribute
                    {
                        public abstract void Apply(System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration configuration, TAttribute attribute);
                        protected PrimitivePropertyAttributeConfigurationConvention() => throw null;
                    }
                    public abstract class PropertyAttributeConfigurationConvention<TAttribute> : System.Data.Entity.ModelConfiguration.Conventions.Convention where TAttribute : System.Attribute
                    {
                        public abstract void Apply(System.Reflection.PropertyInfo memberInfo, System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration configuration, TAttribute attribute);
                        protected PropertyAttributeConfigurationConvention() => throw null;
                    }
                    public class PropertyMaxLengthConvention : System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.EntityType>, System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.ComplexType>, System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.AssociationType>, System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.EntityType item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.ComplexType item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.AssociationType item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public PropertyMaxLengthConvention() => throw null;
                        public PropertyMaxLengthConvention(int length) => throw null;
                    }
                    public class RequiredNavigationPropertyAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.Convention
                    {
                        public RequiredNavigationPropertyAttributeConvention() => throw null;
                    }
                    public class RequiredPrimitivePropertyAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.PrimitivePropertyAttributeConfigurationConvention<System.ComponentModel.DataAnnotations.RequiredAttribute>
                    {
                        public override void Apply(System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration configuration, System.ComponentModel.DataAnnotations.RequiredAttribute attribute) => throw null;
                        public RequiredPrimitivePropertyAttributeConvention() => throw null;
                    }
                    public class SqlCePropertyMaxLengthConvention : System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.EntityType>, System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.ComplexType>, System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.EntityType item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.ComplexType item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public SqlCePropertyMaxLengthConvention() => throw null;
                        public SqlCePropertyMaxLengthConvention(int length) => throw null;
                    }
                    public class StoreGeneratedIdentityKeyConvention : System.Data.Entity.ModelConfiguration.Conventions.IConceptualModelConvention<System.Data.Entity.Core.Metadata.Edm.EntityType>, System.Data.Entity.ModelConfiguration.Conventions.IConvention
                    {
                        public virtual void Apply(System.Data.Entity.Core.Metadata.Edm.EntityType item, System.Data.Entity.Infrastructure.DbModel model) => throw null;
                        public StoreGeneratedIdentityKeyConvention() => throw null;
                    }
                    public class StringLengthAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.PrimitivePropertyAttributeConfigurationConvention<System.ComponentModel.DataAnnotations.StringLengthAttribute>
                    {
                        public override void Apply(System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration configuration, System.ComponentModel.DataAnnotations.StringLengthAttribute attribute) => throw null;
                        public StringLengthAttributeConvention() => throw null;
                    }
                    public class TableAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.TypeAttributeConfigurationConvention<System.ComponentModel.DataAnnotations.Schema.TableAttribute>
                    {
                        public override void Apply(System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration configuration, System.ComponentModel.DataAnnotations.Schema.TableAttribute attribute) => throw null;
                        public TableAttributeConvention() => throw null;
                    }
                    public class TimestampAttributeConvention : System.Data.Entity.ModelConfiguration.Conventions.PrimitivePropertyAttributeConfigurationConvention<System.ComponentModel.DataAnnotations.TimestampAttribute>
                    {
                        public override void Apply(System.Data.Entity.ModelConfiguration.Configuration.ConventionPrimitivePropertyConfiguration configuration, System.ComponentModel.DataAnnotations.TimestampAttribute attribute) => throw null;
                        public TimestampAttributeConvention() => throw null;
                    }
                    public abstract class TypeAttributeConfigurationConvention<TAttribute> : System.Data.Entity.ModelConfiguration.Conventions.Convention where TAttribute : System.Attribute
                    {
                        public abstract void Apply(System.Data.Entity.ModelConfiguration.Configuration.ConventionTypeConfiguration configuration, TAttribute attribute);
                        protected TypeAttributeConfigurationConvention() => throw null;
                    }
                    public class TypeNameForeignKeyDiscoveryConvention : System.Data.Entity.ModelConfiguration.Conventions.ForeignKeyDiscoveryConvention
                    {
                        public TypeNameForeignKeyDiscoveryConvention() => throw null;
                        protected override bool MatchDependentKeyProperty(System.Data.Entity.Core.Metadata.Edm.AssociationType associationType, System.Data.Entity.Core.Metadata.Edm.AssociationEndMember dependentAssociationEnd, System.Data.Entity.Core.Metadata.Edm.EdmProperty dependentProperty, System.Data.Entity.Core.Metadata.Edm.EntityType principalEntityType, System.Data.Entity.Core.Metadata.Edm.EdmProperty principalKeyProperty) => throw null;
                    }
                }
                public class EntityTypeConfiguration<TEntityType> : System.Data.Entity.ModelConfiguration.Configuration.StructuralTypeConfiguration<TEntityType> where TEntityType : class
                {
                    public EntityTypeConfiguration() => throw null;
                    public override bool Equals(object obj) => throw null;
                    public override int GetHashCode() => throw null;
                    public System.Type GetType() => throw null;
                    public System.Data.Entity.ModelConfiguration.EntityTypeConfiguration<TEntityType> HasEntitySetName(string entitySetName) => throw null;
                    public System.Data.Entity.ModelConfiguration.Configuration.IndexConfiguration HasIndex<TIndex>(System.Linq.Expressions.Expression<System.Func<TEntityType, TIndex>> indexExpression) => throw null;
                    public System.Data.Entity.ModelConfiguration.EntityTypeConfiguration<TEntityType> HasKey<TKey>(System.Linq.Expressions.Expression<System.Func<TEntityType, TKey>> keyExpression) => throw null;
                    public System.Data.Entity.ModelConfiguration.EntityTypeConfiguration<TEntityType> HasKey<TKey>(System.Linq.Expressions.Expression<System.Func<TEntityType, TKey>> keyExpression, System.Action<System.Data.Entity.ModelConfiguration.Configuration.PrimaryKeyIndexConfiguration> buildAction) => throw null;
                    public System.Data.Entity.ModelConfiguration.Configuration.ManyNavigationPropertyConfiguration<TEntityType, TTargetEntity> HasMany<TTargetEntity>(System.Linq.Expressions.Expression<System.Func<TEntityType, System.Collections.Generic.ICollection<TTargetEntity>>> navigationPropertyExpression) where TTargetEntity : class => throw null;
                    public System.Data.Entity.ModelConfiguration.Configuration.OptionalNavigationPropertyConfiguration<TEntityType, TTargetEntity> HasOptional<TTargetEntity>(System.Linq.Expressions.Expression<System.Func<TEntityType, TTargetEntity>> navigationPropertyExpression) where TTargetEntity : class => throw null;
                    public System.Data.Entity.ModelConfiguration.Configuration.RequiredNavigationPropertyConfiguration<TEntityType, TTargetEntity> HasRequired<TTargetEntity>(System.Linq.Expressions.Expression<System.Func<TEntityType, TTargetEntity>> navigationPropertyExpression) where TTargetEntity : class => throw null;
                    public System.Data.Entity.ModelConfiguration.EntityTypeConfiguration<TEntityType> HasTableAnnotation(string name, object value) => throw null;
                    public System.Data.Entity.ModelConfiguration.EntityTypeConfiguration<TEntityType> Ignore<TProperty>(System.Linq.Expressions.Expression<System.Func<TEntityType, TProperty>> propertyExpression) => throw null;
                    public System.Data.Entity.ModelConfiguration.EntityTypeConfiguration<TEntityType> Map(System.Action<System.Data.Entity.ModelConfiguration.Configuration.EntityMappingConfiguration<TEntityType>> entityMappingConfigurationAction) => throw null;
                    public System.Data.Entity.ModelConfiguration.EntityTypeConfiguration<TEntityType> Map<TDerived>(System.Action<System.Data.Entity.ModelConfiguration.Configuration.EntityMappingConfiguration<TDerived>> derivedTypeMapConfigurationAction) where TDerived : class, TEntityType => throw null;
                    public System.Data.Entity.ModelConfiguration.EntityTypeConfiguration<TEntityType> MapToStoredProcedures() => throw null;
                    public System.Data.Entity.ModelConfiguration.EntityTypeConfiguration<TEntityType> MapToStoredProcedures(System.Action<System.Data.Entity.ModelConfiguration.Configuration.ModificationStoredProceduresConfiguration<TEntityType>> modificationStoredProcedureMappingConfigurationAction) => throw null;
                    public override string ToString() => throw null;
                    public System.Data.Entity.ModelConfiguration.EntityTypeConfiguration<TEntityType> ToTable(string tableName) => throw null;
                    public System.Data.Entity.ModelConfiguration.EntityTypeConfiguration<TEntityType> ToTable(string tableName, string schemaName) => throw null;
                }
                public class ModelValidationException : System.Exception
                {
                    public ModelValidationException() => throw null;
                    public ModelValidationException(string message) => throw null;
                    public ModelValidationException(string message, System.Exception innerException) => throw null;
                    protected ModelValidationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
            }
            public class NullDatabaseInitializer<TContext> : System.Data.Entity.IDatabaseInitializer<TContext> where TContext : System.Data.Entity.DbContext
            {
                public NullDatabaseInitializer() => throw null;
                public virtual void InitializeDatabase(TContext context) => throw null;
            }
            public static partial class ObservableCollectionExtensions
            {
                public static System.ComponentModel.BindingList<T> ToBindingList<T>(this System.Collections.ObjectModel.ObservableCollection<T> source) where T : class => throw null;
            }
            public static partial class QueryableExtensions
            {
                public static System.Threading.Tasks.Task<bool> AllAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
                public static System.Threading.Tasks.Task<bool> AllAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<bool> AnyAsync<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
                public static System.Threading.Tasks.Task<bool> AnyAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<bool> AnyAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
                public static System.Threading.Tasks.Task<bool> AnyAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Linq.IQueryable<T> AsNoTracking<T>(this System.Linq.IQueryable<T> source) where T : class => throw null;
                public static System.Linq.IQueryable AsNoTracking(this System.Linq.IQueryable source) => throw null;
                public static System.Linq.IQueryable<T> AsStreaming<T>(this System.Linq.IQueryable<T> source) => throw null;
                public static System.Linq.IQueryable AsStreaming(this System.Linq.IQueryable source) => throw null;
                public static System.Threading.Tasks.Task<double> AverageAsync(this System.Linq.IQueryable<int> source) => throw null;
                public static System.Threading.Tasks.Task<double> AverageAsync(this System.Linq.IQueryable<int> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<double?> AverageAsync(this System.Linq.IQueryable<int?> source) => throw null;
                public static System.Threading.Tasks.Task<double?> AverageAsync(this System.Linq.IQueryable<int?> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<double> AverageAsync(this System.Linq.IQueryable<long> source) => throw null;
                public static System.Threading.Tasks.Task<double> AverageAsync(this System.Linq.IQueryable<long> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<double?> AverageAsync(this System.Linq.IQueryable<long?> source) => throw null;
                public static System.Threading.Tasks.Task<double?> AverageAsync(this System.Linq.IQueryable<long?> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<float> AverageAsync(this System.Linq.IQueryable<float> source) => throw null;
                public static System.Threading.Tasks.Task<float> AverageAsync(this System.Linq.IQueryable<float> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<float?> AverageAsync(this System.Linq.IQueryable<float?> source) => throw null;
                public static System.Threading.Tasks.Task<float?> AverageAsync(this System.Linq.IQueryable<float?> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<double> AverageAsync(this System.Linq.IQueryable<double> source) => throw null;
                public static System.Threading.Tasks.Task<double> AverageAsync(this System.Linq.IQueryable<double> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<double?> AverageAsync(this System.Linq.IQueryable<double?> source) => throw null;
                public static System.Threading.Tasks.Task<double?> AverageAsync(this System.Linq.IQueryable<double?> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<decimal> AverageAsync(this System.Linq.IQueryable<decimal> source) => throw null;
                public static System.Threading.Tasks.Task<decimal> AverageAsync(this System.Linq.IQueryable<decimal> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<decimal?> AverageAsync(this System.Linq.IQueryable<decimal?> source) => throw null;
                public static System.Threading.Tasks.Task<decimal?> AverageAsync(this System.Linq.IQueryable<decimal?> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<double> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int>> selector) => throw null;
                public static System.Threading.Tasks.Task<double> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<double?> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int?>> selector) => throw null;
                public static System.Threading.Tasks.Task<double?> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int?>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<double> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, long>> selector) => throw null;
                public static System.Threading.Tasks.Task<double> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, long>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<double?> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, long?>> selector) => throw null;
                public static System.Threading.Tasks.Task<double?> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, long?>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<float> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, float>> selector) => throw null;
                public static System.Threading.Tasks.Task<float> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, float>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<float?> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, float?>> selector) => throw null;
                public static System.Threading.Tasks.Task<float?> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, float?>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<double> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, double>> selector) => throw null;
                public static System.Threading.Tasks.Task<double> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, double>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<double?> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, double?>> selector) => throw null;
                public static System.Threading.Tasks.Task<double?> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, double?>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<decimal> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, decimal>> selector) => throw null;
                public static System.Threading.Tasks.Task<decimal> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, decimal>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<decimal?> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, decimal?>> selector) => throw null;
                public static System.Threading.Tasks.Task<decimal?> AverageAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, decimal?>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<bool> ContainsAsync<TSource>(this System.Linq.IQueryable<TSource> source, TSource item) => throw null;
                public static System.Threading.Tasks.Task<bool> ContainsAsync<TSource>(this System.Linq.IQueryable<TSource> source, TSource item, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<int> CountAsync<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
                public static System.Threading.Tasks.Task<int> CountAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<int> CountAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
                public static System.Threading.Tasks.Task<int> CountAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<TSource> FirstAsync<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
                public static System.Threading.Tasks.Task<TSource> FirstAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<TSource> FirstAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
                public static System.Threading.Tasks.Task<TSource> FirstAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<TSource> FirstOrDefaultAsync<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
                public static System.Threading.Tasks.Task<TSource> FirstOrDefaultAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<TSource> FirstOrDefaultAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
                public static System.Threading.Tasks.Task<TSource> FirstOrDefaultAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task ForEachAsync(this System.Linq.IQueryable source, System.Action<object> action) => throw null;
                public static System.Threading.Tasks.Task ForEachAsync(this System.Linq.IQueryable source, System.Action<object> action, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task ForEachAsync<T>(this System.Linq.IQueryable<T> source, System.Action<T> action) => throw null;
                public static System.Threading.Tasks.Task ForEachAsync<T>(this System.Linq.IQueryable<T> source, System.Action<T> action, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Linq.IQueryable<T> Include<T>(this System.Linq.IQueryable<T> source, string path) => throw null;
                public static System.Linq.IQueryable Include(this System.Linq.IQueryable source, string path) => throw null;
                public static System.Linq.IQueryable<T> Include<T, TProperty>(this System.Linq.IQueryable<T> source, System.Linq.Expressions.Expression<System.Func<T, TProperty>> path) => throw null;
                public static void Load(this System.Linq.IQueryable source) => throw null;
                public static System.Threading.Tasks.Task LoadAsync(this System.Linq.IQueryable source) => throw null;
                public static System.Threading.Tasks.Task LoadAsync(this System.Linq.IQueryable source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<long> LongCountAsync<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
                public static System.Threading.Tasks.Task<long> LongCountAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<long> LongCountAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
                public static System.Threading.Tasks.Task<long> LongCountAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<TSource> MaxAsync<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
                public static System.Threading.Tasks.Task<TSource> MaxAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<TResult> MaxAsync<TSource, TResult>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TResult>> selector) => throw null;
                public static System.Threading.Tasks.Task<TResult> MaxAsync<TSource, TResult>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TResult>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<TSource> MinAsync<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
                public static System.Threading.Tasks.Task<TSource> MinAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<TResult> MinAsync<TSource, TResult>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TResult>> selector) => throw null;
                public static System.Threading.Tasks.Task<TResult> MinAsync<TSource, TResult>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, TResult>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<TSource> SingleAsync<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
                public static System.Threading.Tasks.Task<TSource> SingleAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<TSource> SingleAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
                public static System.Threading.Tasks.Task<TSource> SingleAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<TSource> SingleOrDefaultAsync<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
                public static System.Threading.Tasks.Task<TSource> SingleOrDefaultAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<TSource> SingleOrDefaultAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate) => throw null;
                public static System.Threading.Tasks.Task<TSource> SingleOrDefaultAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, bool>> predicate, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Linq.IQueryable<TSource> Skip<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<int>> countAccessor) => throw null;
                public static System.Threading.Tasks.Task<int> SumAsync(this System.Linq.IQueryable<int> source) => throw null;
                public static System.Threading.Tasks.Task<int> SumAsync(this System.Linq.IQueryable<int> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<int?> SumAsync(this System.Linq.IQueryable<int?> source) => throw null;
                public static System.Threading.Tasks.Task<int?> SumAsync(this System.Linq.IQueryable<int?> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<long> SumAsync(this System.Linq.IQueryable<long> source) => throw null;
                public static System.Threading.Tasks.Task<long> SumAsync(this System.Linq.IQueryable<long> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<long?> SumAsync(this System.Linq.IQueryable<long?> source) => throw null;
                public static System.Threading.Tasks.Task<long?> SumAsync(this System.Linq.IQueryable<long?> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<float> SumAsync(this System.Linq.IQueryable<float> source) => throw null;
                public static System.Threading.Tasks.Task<float> SumAsync(this System.Linq.IQueryable<float> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<float?> SumAsync(this System.Linq.IQueryable<float?> source) => throw null;
                public static System.Threading.Tasks.Task<float?> SumAsync(this System.Linq.IQueryable<float?> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<double> SumAsync(this System.Linq.IQueryable<double> source) => throw null;
                public static System.Threading.Tasks.Task<double> SumAsync(this System.Linq.IQueryable<double> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<double?> SumAsync(this System.Linq.IQueryable<double?> source) => throw null;
                public static System.Threading.Tasks.Task<double?> SumAsync(this System.Linq.IQueryable<double?> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<decimal> SumAsync(this System.Linq.IQueryable<decimal> source) => throw null;
                public static System.Threading.Tasks.Task<decimal> SumAsync(this System.Linq.IQueryable<decimal> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<decimal?> SumAsync(this System.Linq.IQueryable<decimal?> source) => throw null;
                public static System.Threading.Tasks.Task<decimal?> SumAsync(this System.Linq.IQueryable<decimal?> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<int> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int>> selector) => throw null;
                public static System.Threading.Tasks.Task<int> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<int?> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int?>> selector) => throw null;
                public static System.Threading.Tasks.Task<int?> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, int?>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<long> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, long>> selector) => throw null;
                public static System.Threading.Tasks.Task<long> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, long>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<long?> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, long?>> selector) => throw null;
                public static System.Threading.Tasks.Task<long?> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, long?>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<float> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, float>> selector) => throw null;
                public static System.Threading.Tasks.Task<float> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, float>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<float?> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, float?>> selector) => throw null;
                public static System.Threading.Tasks.Task<float?> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, float?>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<double> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, double>> selector) => throw null;
                public static System.Threading.Tasks.Task<double> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, double>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<double?> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, double?>> selector) => throw null;
                public static System.Threading.Tasks.Task<double?> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, double?>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<decimal> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, decimal>> selector) => throw null;
                public static System.Threading.Tasks.Task<decimal> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, decimal>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<decimal?> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, decimal?>> selector) => throw null;
                public static System.Threading.Tasks.Task<decimal?> SumAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<TSource, decimal?>> selector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Linq.IQueryable<TSource> Take<TSource>(this System.Linq.IQueryable<TSource> source, System.Linq.Expressions.Expression<System.Func<int>> countAccessor) => throw null;
                public static System.Threading.Tasks.Task<TSource[]> ToArrayAsync<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
                public static System.Threading.Tasks.Task<TSource[]> ToArrayAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<TKey, TSource>> ToDictionaryAsync<TSource, TKey>(this System.Linq.IQueryable<TSource> source, System.Func<TSource, TKey> keySelector) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<TKey, TSource>> ToDictionaryAsync<TSource, TKey>(this System.Linq.IQueryable<TSource> source, System.Func<TSource, TKey> keySelector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<TKey, TSource>> ToDictionaryAsync<TSource, TKey>(this System.Linq.IQueryable<TSource> source, System.Func<TSource, TKey> keySelector, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<TKey, TSource>> ToDictionaryAsync<TSource, TKey>(this System.Linq.IQueryable<TSource> source, System.Func<TSource, TKey> keySelector, System.Collections.Generic.IEqualityComparer<TKey> comparer, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<TKey, TElement>> ToDictionaryAsync<TSource, TKey, TElement>(this System.Linq.IQueryable<TSource> source, System.Func<TSource, TKey> keySelector, System.Func<TSource, TElement> elementSelector) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<TKey, TElement>> ToDictionaryAsync<TSource, TKey, TElement>(this System.Linq.IQueryable<TSource> source, System.Func<TSource, TKey> keySelector, System.Func<TSource, TElement> elementSelector, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<TKey, TElement>> ToDictionaryAsync<TSource, TKey, TElement>(this System.Linq.IQueryable<TSource> source, System.Func<TSource, TKey> keySelector, System.Func<TSource, TElement> elementSelector, System.Collections.Generic.IEqualityComparer<TKey> comparer) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.Dictionary<TKey, TElement>> ToDictionaryAsync<TSource, TKey, TElement>(this System.Linq.IQueryable<TSource> source, System.Func<TSource, TKey> keySelector, System.Func<TSource, TElement> elementSelector, System.Collections.Generic.IEqualityComparer<TKey> comparer, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.List<object>> ToListAsync(this System.Linq.IQueryable source) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.List<object>> ToListAsync(this System.Linq.IQueryable source, System.Threading.CancellationToken cancellationToken) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.List<TSource>> ToListAsync<TSource>(this System.Linq.IQueryable<TSource> source) => throw null;
                public static System.Threading.Tasks.Task<System.Collections.Generic.List<TSource>> ToListAsync<TSource>(this System.Linq.IQueryable<TSource> source, System.Threading.CancellationToken cancellationToken) => throw null;
            }
            namespace Spatial
            {
                public class DbGeography
                {
                    public double? Area { get => throw null; }
                    public byte[] AsBinary() => throw null;
                    public string AsGml() => throw null;
                    public virtual string AsText() => throw null;
                    public System.Data.Entity.Spatial.DbGeography Buffer(double? distance) => throw null;
                    public int CoordinateSystemId { get => throw null; }
                    public static int DefaultCoordinateSystemId { get => throw null; }
                    public System.Data.Entity.Spatial.DbGeography Difference(System.Data.Entity.Spatial.DbGeography other) => throw null;
                    public int Dimension { get => throw null; }
                    public bool Disjoint(System.Data.Entity.Spatial.DbGeography other) => throw null;
                    public double? Distance(System.Data.Entity.Spatial.DbGeography other) => throw null;
                    public System.Data.Entity.Spatial.DbGeography ElementAt(int index) => throw null;
                    public int? ElementCount { get => throw null; }
                    public double? Elevation { get => throw null; }
                    public System.Data.Entity.Spatial.DbGeography EndPoint { get => throw null; }
                    public static System.Data.Entity.Spatial.DbGeography FromBinary(byte[] wellKnownBinary) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography FromBinary(byte[] wellKnownBinary, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography FromGml(string geographyMarkup) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography FromGml(string geographyMarkup, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography FromText(string wellKnownText) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography FromText(string wellKnownText, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography GeographyCollectionFromBinary(byte[] geographyCollectionWellKnownBinary, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography GeographyCollectionFromText(string geographyCollectionWellKnownText, int coordinateSystemId) => throw null;
                    public System.Data.Entity.Spatial.DbGeography Intersection(System.Data.Entity.Spatial.DbGeography other) => throw null;
                    public bool Intersects(System.Data.Entity.Spatial.DbGeography other) => throw null;
                    public bool? IsClosed { get => throw null; }
                    public bool IsEmpty { get => throw null; }
                    public double? Latitude { get => throw null; }
                    public double? Length { get => throw null; }
                    public static System.Data.Entity.Spatial.DbGeography LineFromBinary(byte[] lineWellKnownBinary, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography LineFromText(string lineWellKnownText, int coordinateSystemId) => throw null;
                    public double? Longitude { get => throw null; }
                    public double? Measure { get => throw null; }
                    public static System.Data.Entity.Spatial.DbGeography MultiLineFromBinary(byte[] multiLineWellKnownBinary, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography MultiLineFromText(string multiLineWellKnownText, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography MultiPointFromBinary(byte[] multiPointWellKnownBinary, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography MultiPointFromText(string multiPointWellKnownText, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography MultiPolygonFromBinary(byte[] multiPolygonWellKnownBinary, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography MultiPolygonFromText(string multiPolygonWellKnownText, int coordinateSystemId) => throw null;
                    public System.Data.Entity.Spatial.DbGeography PointAt(int index) => throw null;
                    public int? PointCount { get => throw null; }
                    public static System.Data.Entity.Spatial.DbGeography PointFromBinary(byte[] pointWellKnownBinary, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography PointFromText(string pointWellKnownText, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography PolygonFromBinary(byte[] polygonWellKnownBinary, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeography PolygonFromText(string polygonWellKnownText, int coordinateSystemId) => throw null;
                    public virtual System.Data.Entity.Spatial.DbSpatialServices Provider { get => throw null; }
                    public object ProviderValue { get => throw null; }
                    public bool SpatialEquals(System.Data.Entity.Spatial.DbGeography other) => throw null;
                    public string SpatialTypeName { get => throw null; }
                    public System.Data.Entity.Spatial.DbGeography StartPoint { get => throw null; }
                    public System.Data.Entity.Spatial.DbGeography SymmetricDifference(System.Data.Entity.Spatial.DbGeography other) => throw null;
                    public override string ToString() => throw null;
                    public System.Data.Entity.Spatial.DbGeography Union(System.Data.Entity.Spatial.DbGeography other) => throw null;
                    public System.Data.Entity.Spatial.DbGeographyWellKnownValue WellKnownValue { get => throw null; set { } }
                }
                public sealed class DbGeographyWellKnownValue
                {
                    public int CoordinateSystemId { get => throw null; set { } }
                    public DbGeographyWellKnownValue() => throw null;
                    public byte[] WellKnownBinary { get => throw null; set { } }
                    public string WellKnownText { get => throw null; set { } }
                }
                public class DbGeometry
                {
                    public double? Area { get => throw null; }
                    public byte[] AsBinary() => throw null;
                    public string AsGml() => throw null;
                    public virtual string AsText() => throw null;
                    public System.Data.Entity.Spatial.DbGeometry Boundary { get => throw null; }
                    public System.Data.Entity.Spatial.DbGeometry Buffer(double? distance) => throw null;
                    public System.Data.Entity.Spatial.DbGeometry Centroid { get => throw null; }
                    public bool Contains(System.Data.Entity.Spatial.DbGeometry other) => throw null;
                    public System.Data.Entity.Spatial.DbGeometry ConvexHull { get => throw null; }
                    public int CoordinateSystemId { get => throw null; }
                    public bool Crosses(System.Data.Entity.Spatial.DbGeometry other) => throw null;
                    public static int DefaultCoordinateSystemId { get => throw null; }
                    public System.Data.Entity.Spatial.DbGeometry Difference(System.Data.Entity.Spatial.DbGeometry other) => throw null;
                    public int Dimension { get => throw null; }
                    public bool Disjoint(System.Data.Entity.Spatial.DbGeometry other) => throw null;
                    public double? Distance(System.Data.Entity.Spatial.DbGeometry other) => throw null;
                    public System.Data.Entity.Spatial.DbGeometry ElementAt(int index) => throw null;
                    public int? ElementCount { get => throw null; }
                    public double? Elevation { get => throw null; }
                    public System.Data.Entity.Spatial.DbGeometry EndPoint { get => throw null; }
                    public System.Data.Entity.Spatial.DbGeometry Envelope { get => throw null; }
                    public System.Data.Entity.Spatial.DbGeometry ExteriorRing { get => throw null; }
                    public static System.Data.Entity.Spatial.DbGeometry FromBinary(byte[] wellKnownBinary) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry FromBinary(byte[] wellKnownBinary, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry FromGml(string geometryMarkup) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry FromGml(string geometryMarkup, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry FromText(string wellKnownText) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry FromText(string wellKnownText, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry GeometryCollectionFromBinary(byte[] geometryCollectionWellKnownBinary, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry GeometryCollectionFromText(string geometryCollectionWellKnownText, int coordinateSystemId) => throw null;
                    public System.Data.Entity.Spatial.DbGeometry InteriorRingAt(int index) => throw null;
                    public int? InteriorRingCount { get => throw null; }
                    public System.Data.Entity.Spatial.DbGeometry Intersection(System.Data.Entity.Spatial.DbGeometry other) => throw null;
                    public bool Intersects(System.Data.Entity.Spatial.DbGeometry other) => throw null;
                    public bool? IsClosed { get => throw null; }
                    public bool IsEmpty { get => throw null; }
                    public bool? IsRing { get => throw null; }
                    public bool IsSimple { get => throw null; }
                    public bool IsValid { get => throw null; }
                    public double? Length { get => throw null; }
                    public static System.Data.Entity.Spatial.DbGeometry LineFromBinary(byte[] lineWellKnownBinary, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry LineFromText(string lineWellKnownText, int coordinateSystemId) => throw null;
                    public double? Measure { get => throw null; }
                    public static System.Data.Entity.Spatial.DbGeometry MultiLineFromBinary(byte[] multiLineWellKnownBinary, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry MultiLineFromText(string multiLineWellKnownText, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry MultiPointFromBinary(byte[] multiPointWellKnownBinary, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry MultiPointFromText(string multiPointWellKnownText, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry MultiPolygonFromBinary(byte[] multiPolygonWellKnownBinary, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry MultiPolygonFromText(string multiPolygonWellKnownText, int coordinateSystemId) => throw null;
                    public bool Overlaps(System.Data.Entity.Spatial.DbGeometry other) => throw null;
                    public System.Data.Entity.Spatial.DbGeometry PointAt(int index) => throw null;
                    public int? PointCount { get => throw null; }
                    public static System.Data.Entity.Spatial.DbGeometry PointFromBinary(byte[] pointWellKnownBinary, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry PointFromText(string pointWellKnownText, int coordinateSystemId) => throw null;
                    public System.Data.Entity.Spatial.DbGeometry PointOnSurface { get => throw null; }
                    public static System.Data.Entity.Spatial.DbGeometry PolygonFromBinary(byte[] polygonWellKnownBinary, int coordinateSystemId) => throw null;
                    public static System.Data.Entity.Spatial.DbGeometry PolygonFromText(string polygonWellKnownText, int coordinateSystemId) => throw null;
                    public virtual System.Data.Entity.Spatial.DbSpatialServices Provider { get => throw null; }
                    public object ProviderValue { get => throw null; }
                    public bool Relate(System.Data.Entity.Spatial.DbGeometry other, string matrix) => throw null;
                    public bool SpatialEquals(System.Data.Entity.Spatial.DbGeometry other) => throw null;
                    public string SpatialTypeName { get => throw null; }
                    public System.Data.Entity.Spatial.DbGeometry StartPoint { get => throw null; }
                    public System.Data.Entity.Spatial.DbGeometry SymmetricDifference(System.Data.Entity.Spatial.DbGeometry other) => throw null;
                    public override string ToString() => throw null;
                    public bool Touches(System.Data.Entity.Spatial.DbGeometry other) => throw null;
                    public System.Data.Entity.Spatial.DbGeometry Union(System.Data.Entity.Spatial.DbGeometry other) => throw null;
                    public System.Data.Entity.Spatial.DbGeometryWellKnownValue WellKnownValue { get => throw null; set { } }
                    public bool Within(System.Data.Entity.Spatial.DbGeometry other) => throw null;
                    public double? XCoordinate { get => throw null; }
                    public double? YCoordinate { get => throw null; }
                }
                public sealed class DbGeometryWellKnownValue
                {
                    public int CoordinateSystemId { get => throw null; set { } }
                    public DbGeometryWellKnownValue() => throw null;
                    public byte[] WellKnownBinary { get => throw null; set { } }
                    public string WellKnownText { get => throw null; set { } }
                }
                public abstract class DbSpatialDataReader
                {
                    protected DbSpatialDataReader() => throw null;
                    public abstract System.Data.Entity.Spatial.DbGeography GetGeography(int ordinal);
                    public virtual System.Threading.Tasks.Task<System.Data.Entity.Spatial.DbGeography> GetGeographyAsync(int ordinal, System.Threading.CancellationToken cancellationToken) => throw null;
                    public abstract System.Data.Entity.Spatial.DbGeometry GetGeometry(int ordinal);
                    public virtual System.Threading.Tasks.Task<System.Data.Entity.Spatial.DbGeometry> GetGeometryAsync(int ordinal, System.Threading.CancellationToken cancellationToken) => throw null;
                    public abstract bool IsGeographyColumn(int ordinal);
                    public abstract bool IsGeometryColumn(int ordinal);
                }
                public abstract class DbSpatialServices
                {
                    public abstract byte[] AsBinary(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract byte[] AsBinary(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract string AsGml(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract string AsGml(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract string AsText(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract string AsText(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public virtual string AsTextIncludingElevationAndMeasure(System.Data.Entity.Spatial.DbGeography geographyValue) => throw null;
                    public virtual string AsTextIncludingElevationAndMeasure(System.Data.Entity.Spatial.DbGeometry geometryValue) => throw null;
                    public abstract System.Data.Entity.Spatial.DbGeography Buffer(System.Data.Entity.Spatial.DbGeography geographyValue, double distance);
                    public abstract System.Data.Entity.Spatial.DbGeometry Buffer(System.Data.Entity.Spatial.DbGeometry geometryValue, double distance);
                    public abstract bool Contains(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry);
                    protected static System.Data.Entity.Spatial.DbGeography CreateGeography(System.Data.Entity.Spatial.DbSpatialServices spatialServices, object providerValue) => throw null;
                    protected static System.Data.Entity.Spatial.DbGeometry CreateGeometry(System.Data.Entity.Spatial.DbSpatialServices spatialServices, object providerValue) => throw null;
                    public abstract object CreateProviderValue(System.Data.Entity.Spatial.DbGeographyWellKnownValue wellKnownValue);
                    public abstract object CreateProviderValue(System.Data.Entity.Spatial.DbGeometryWellKnownValue wellKnownValue);
                    public abstract System.Data.Entity.Spatial.DbGeographyWellKnownValue CreateWellKnownValue(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract System.Data.Entity.Spatial.DbGeometryWellKnownValue CreateWellKnownValue(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract bool Crosses(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry);
                    protected DbSpatialServices() => throw null;
                    public static System.Data.Entity.Spatial.DbSpatialServices Default { get => throw null; }
                    public abstract System.Data.Entity.Spatial.DbGeography Difference(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography otherGeography);
                    public abstract System.Data.Entity.Spatial.DbGeometry Difference(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry);
                    public abstract bool Disjoint(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography otherGeography);
                    public abstract bool Disjoint(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry);
                    public abstract double Distance(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography otherGeography);
                    public abstract double Distance(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry);
                    public abstract System.Data.Entity.Spatial.DbGeography ElementAt(System.Data.Entity.Spatial.DbGeography geographyValue, int index);
                    public abstract System.Data.Entity.Spatial.DbGeometry ElementAt(System.Data.Entity.Spatial.DbGeometry geometryValue, int index);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyCollectionFromBinary(byte[] geographyCollectionWellKnownBinary, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyCollectionFromText(string geographyCollectionWellKnownText, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyFromBinary(byte[] wellKnownBinary);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyFromBinary(byte[] wellKnownBinary, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyFromGml(string geographyMarkup);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyFromGml(string geographyMarkup, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyFromProviderValue(object providerValue);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyFromText(string wellKnownText);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyFromText(string wellKnownText, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyLineFromBinary(byte[] lineWellKnownBinary, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyLineFromText(string lineWellKnownText, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyMultiLineFromBinary(byte[] multiLineWellKnownBinary, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyMultiLineFromText(string multiLineWellKnownText, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyMultiPointFromBinary(byte[] multiPointWellKnownBinary, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyMultiPointFromText(string multiPointWellKnownText, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyMultiPolygonFromBinary(byte[] multiPolygonWellKnownBinary, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyMultiPolygonFromText(string multiPolygonKnownText, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyPointFromBinary(byte[] pointWellKnownBinary, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyPointFromText(string pointWellKnownText, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyPolygonFromBinary(byte[] polygonWellKnownBinary, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeography GeographyPolygonFromText(string polygonWellKnownText, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryCollectionFromBinary(byte[] geometryCollectionWellKnownBinary, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryCollectionFromText(string geometryCollectionWellKnownText, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryFromBinary(byte[] wellKnownBinary);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryFromBinary(byte[] wellKnownBinary, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryFromGml(string geometryMarkup);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryFromGml(string geometryMarkup, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryFromProviderValue(object providerValue);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryFromText(string wellKnownText);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryFromText(string wellKnownText, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryLineFromBinary(byte[] lineWellKnownBinary, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryLineFromText(string lineWellKnownText, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryMultiLineFromBinary(byte[] multiLineWellKnownBinary, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryMultiLineFromText(string multiLineWellKnownText, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryMultiPointFromBinary(byte[] multiPointWellKnownBinary, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryMultiPointFromText(string multiPointWellKnownText, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryMultiPolygonFromBinary(byte[] multiPolygonWellKnownBinary, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryMultiPolygonFromText(string multiPolygonKnownText, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryPointFromBinary(byte[] pointWellKnownBinary, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryPointFromText(string pointWellKnownText, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryPolygonFromBinary(byte[] polygonWellKnownBinary, int coordinateSystemId);
                    public abstract System.Data.Entity.Spatial.DbGeometry GeometryPolygonFromText(string polygonWellKnownText, int coordinateSystemId);
                    public abstract double? GetArea(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract double? GetArea(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract System.Data.Entity.Spatial.DbGeometry GetBoundary(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract System.Data.Entity.Spatial.DbGeometry GetCentroid(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract System.Data.Entity.Spatial.DbGeometry GetConvexHull(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract int GetCoordinateSystemId(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract int GetCoordinateSystemId(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract int GetDimension(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract int GetDimension(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract int? GetElementCount(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract int? GetElementCount(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract double? GetElevation(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract double? GetElevation(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract System.Data.Entity.Spatial.DbGeography GetEndPoint(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract System.Data.Entity.Spatial.DbGeometry GetEndPoint(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract System.Data.Entity.Spatial.DbGeometry GetEnvelope(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract System.Data.Entity.Spatial.DbGeometry GetExteriorRing(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract int? GetInteriorRingCount(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract bool? GetIsClosed(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract bool? GetIsClosed(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract bool GetIsEmpty(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract bool GetIsEmpty(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract bool? GetIsRing(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract bool GetIsSimple(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract bool GetIsValid(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract double? GetLatitude(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract double? GetLength(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract double? GetLength(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract double? GetLongitude(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract double? GetMeasure(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract double? GetMeasure(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract int? GetPointCount(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract int? GetPointCount(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract System.Data.Entity.Spatial.DbGeometry GetPointOnSurface(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract string GetSpatialTypeName(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract string GetSpatialTypeName(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract System.Data.Entity.Spatial.DbGeography GetStartPoint(System.Data.Entity.Spatial.DbGeography geographyValue);
                    public abstract System.Data.Entity.Spatial.DbGeometry GetStartPoint(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract double? GetXCoordinate(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract double? GetYCoordinate(System.Data.Entity.Spatial.DbGeometry geometryValue);
                    public abstract System.Data.Entity.Spatial.DbGeometry InteriorRingAt(System.Data.Entity.Spatial.DbGeometry geometryValue, int index);
                    public abstract System.Data.Entity.Spatial.DbGeography Intersection(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography otherGeography);
                    public abstract System.Data.Entity.Spatial.DbGeometry Intersection(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry);
                    public abstract bool Intersects(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography otherGeography);
                    public abstract bool Intersects(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry);
                    public virtual bool NativeTypesAvailable { get => throw null; }
                    public abstract bool Overlaps(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry);
                    public abstract System.Data.Entity.Spatial.DbGeography PointAt(System.Data.Entity.Spatial.DbGeography geographyValue, int index);
                    public abstract System.Data.Entity.Spatial.DbGeometry PointAt(System.Data.Entity.Spatial.DbGeometry geometryValue, int index);
                    public abstract bool Relate(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry, string matrix);
                    public abstract bool SpatialEquals(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography otherGeography);
                    public abstract bool SpatialEquals(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry);
                    public abstract System.Data.Entity.Spatial.DbGeography SymmetricDifference(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography otherGeography);
                    public abstract System.Data.Entity.Spatial.DbGeometry SymmetricDifference(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry);
                    public abstract bool Touches(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry);
                    public abstract System.Data.Entity.Spatial.DbGeography Union(System.Data.Entity.Spatial.DbGeography geographyValue, System.Data.Entity.Spatial.DbGeography otherGeography);
                    public abstract System.Data.Entity.Spatial.DbGeometry Union(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry);
                    public abstract bool Within(System.Data.Entity.Spatial.DbGeometry geometryValue, System.Data.Entity.Spatial.DbGeometry otherGeometry);
                }
            }
            public enum TransactionalBehavior
            {
                EnsureTransaction = 0,
                DoNotEnsureTransaction = 1,
            }
            namespace Utilities
            {
                public static partial class TaskExtensions
                {
                    public struct CultureAwaiter<T> : System.Runtime.CompilerServices.ICriticalNotifyCompletion, System.Runtime.CompilerServices.INotifyCompletion
                    {
                        public CultureAwaiter(System.Threading.Tasks.Task<T> task) => throw null;
                        public System.Data.Entity.Utilities.TaskExtensions.CultureAwaiter<T> GetAwaiter() => throw null;
                        public T GetResult() => throw null;
                        public bool IsCompleted { get => throw null; }
                        public void OnCompleted(System.Action continuation) => throw null;
                        public void UnsafeOnCompleted(System.Action continuation) => throw null;
                    }
                    public struct CultureAwaiter : System.Runtime.CompilerServices.ICriticalNotifyCompletion, System.Runtime.CompilerServices.INotifyCompletion
                    {
                        public CultureAwaiter(System.Threading.Tasks.Task task) => throw null;
                        public System.Data.Entity.Utilities.TaskExtensions.CultureAwaiter GetAwaiter() => throw null;
                        public void GetResult() => throw null;
                        public bool IsCompleted { get => throw null; }
                        public void OnCompleted(System.Action continuation) => throw null;
                        public void UnsafeOnCompleted(System.Action continuation) => throw null;
                    }
                    public static System.Data.Entity.Utilities.TaskExtensions.CultureAwaiter<T> WithCurrentCulture<T>(this System.Threading.Tasks.Task<T> task) => throw null;
                    public static System.Data.Entity.Utilities.TaskExtensions.CultureAwaiter WithCurrentCulture(this System.Threading.Tasks.Task task) => throw null;
                }
            }
            namespace Validation
            {
                public class DbEntityValidationException : System.Data.DataException
                {
                    public DbEntityValidationException() => throw null;
                    public DbEntityValidationException(string message) => throw null;
                    public DbEntityValidationException(string message, System.Collections.Generic.IEnumerable<System.Data.Entity.Validation.DbEntityValidationResult> entityValidationResults) => throw null;
                    public DbEntityValidationException(string message, System.Exception innerException) => throw null;
                    public DbEntityValidationException(string message, System.Collections.Generic.IEnumerable<System.Data.Entity.Validation.DbEntityValidationResult> entityValidationResults, System.Exception innerException) => throw null;
                    protected DbEntityValidationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                    public System.Collections.Generic.IEnumerable<System.Data.Entity.Validation.DbEntityValidationResult> EntityValidationErrors { get => throw null; }
                    public override void GetObjectData(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class DbEntityValidationResult
                {
                    public DbEntityValidationResult(System.Data.Entity.Infrastructure.DbEntityEntry entry, System.Collections.Generic.IEnumerable<System.Data.Entity.Validation.DbValidationError> validationErrors) => throw null;
                    public System.Data.Entity.Infrastructure.DbEntityEntry Entry { get => throw null; }
                    public bool IsValid { get => throw null; }
                    public System.Collections.Generic.ICollection<System.Data.Entity.Validation.DbValidationError> ValidationErrors { get => throw null; }
                }
                public class DbUnexpectedValidationException : System.Data.DataException
                {
                    public DbUnexpectedValidationException() => throw null;
                    public DbUnexpectedValidationException(string message) => throw null;
                    public DbUnexpectedValidationException(string message, System.Exception innerException) => throw null;
                    protected DbUnexpectedValidationException(System.Runtime.Serialization.SerializationInfo info, System.Runtime.Serialization.StreamingContext context) => throw null;
                }
                public class DbValidationError
                {
                    public DbValidationError(string propertyName, string errorMessage) => throw null;
                    public string ErrorMessage { get => throw null; }
                    public string PropertyName { get => throw null; }
                }
            }
        }
    }
}
