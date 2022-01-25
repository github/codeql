/**
 * Classes modeling EntityFramework and EntityFrameworkCore.
 */

import csharp
private import DataFlow
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.data.Entity
private import semmle.code.csharp.frameworks.system.collections.Generic
private import semmle.code.csharp.frameworks.Sql
private import semmle.code.csharp.dataflow.FlowSummary
private import semmle.code.csharp.dataflow.ExternalFlow
private import semmle.code.csharp.dataflow.internal.DataFlowPrivate as DataFlowPrivate

/**
 * Definitions relating to the `System.ComponentModel.DataAnnotations`
 * namespace.
 */
module DataAnnotations {
  /** The `NotMappedAttribute` attribute. */
  class NotMappedAttribute extends Attribute {
    NotMappedAttribute() {
      this.getType()
          .hasQualifiedName("System.ComponentModel.DataAnnotations.Schema.NotMappedAttribute")
    }
  }
}

/** Holds if `a` has the `[NotMapped]` attribute */
private predicate isNotMapped(Attributable a) {
  a.getAnAttribute() instanceof DataAnnotations::NotMappedAttribute
}

/**
 * Definitions relating to the `Microsoft.EntityFrameworkCore` or
 * `System.Data.Entity` namespaces.
 */
module EntityFramework {
  /** An EF6 or EFCore namespace. */
  class EFNamespace extends Namespace {
    EFNamespace() {
      this.getQualifiedName() = "Microsoft.EntityFrameworkCore"
      or
      this.getQualifiedName() = "System.Data.Entity"
    }
  }

  /** A taint source where the data has come from a mapped property stored in the database. */
  class StoredFlowSource extends DataFlow::Node {
    StoredFlowSource() {
      this.asExpr() = any(PropertyRead read | read.getTarget() instanceof MappedProperty)
    }
  }

  private class EFClass extends Class {
    EFClass() { this.getDeclaringNamespace() instanceof EFNamespace }
  }

  /** The class `Microsoft.EntityFrameworkCore.DbContext` or `System.Data.Entity.DbContext`. */
  class DbContext extends EFClass {
    DbContext() { this.getName() = "DbContext" }

    /** Gets a `Find` or `FindAsync` method in the `DbContext`. */
    Method getAFindMethod() {
      result = this.getAMethod("Find")
      or
      result = this.getAMethod("FindAsync")
    }

    /** Gets an `Update` method in the `DbContext`. */
    Method getAnUpdateMethod() { result = this.getAMethod("Update") }
  }

  /** The class `Microsoft.EntityFrameworkCore.DbSet<>` or `System.Data.Entity.DbSet<>`. */
  class DbSet extends EFClass, UnboundGenericClass {
    DbSet() { this.getName() = "DbSet<>" }

    /** Gets a method that adds or updates entities in a DB set. */
    Method getAnAddOrUpdateMethod(boolean range) {
      exists(string name | result = this.getAMethod(name) |
        name in ["Add", "AddAsync", "Attach", "Update"] and
        range = false
        or
        name in ["AddRange", "AddRangeAsync", "AttachRange", "UpdateRange"] and
        range = true
      )
    }
  }

  /** A flow summary for EntityFramework. */
  abstract class EFSummarizedCallable extends SummarizedCallable { }

  private class DbSetAddOrUpdateRequiredSummaryComponentStack extends RequiredSummaryComponentStack {
    override predicate required(SummaryComponent head, SummaryComponentStack tail) {
      head = SummaryComponent::element() and
      tail = SummaryComponentStack::argument([-1, 0])
    }
  }

  private class DbSetAddOrUpdate extends EFSummarizedCallable {
    private boolean range;

    DbSetAddOrUpdate() { this = any(DbSet c).getAnAddOrUpdateMethod(range) }

    override predicate propagatesFlow(
      SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
    ) {
      (
        if range = true
        then input = SummaryComponentStack::elementOf(SummaryComponentStack::argument(0))
        else input = SummaryComponentStack::argument(0)
      ) and
      output = SummaryComponentStack::elementOf(SummaryComponentStack::qualifier()) and
      preservesValue = true
    }
  }

  /** The class `Microsoft.EntityFrameworkCore.DbQuery<>` or `System.Data.Entity.DbQuery<>`. */
  class DbQuery extends EFClass, UnboundGenericClass {
    DbQuery() { this.hasName("DbQuery<>") }
  }

  /** A generic type or method that takes a mapped type as its type argument. */
  private predicate usesMappedType(UnboundGeneric g) {
    g instanceof DbSet
    or
    g instanceof DbQuery
    or
    exists(DbContext db |
      g = db.getAnUpdateMethod()
      or
      g = db.getAFindMethod()
    )
  }

  /** A type that is mapped to database table, or used as a query. */
  class MappedType extends ValueOrRefType {
    MappedType() {
      not this instanceof ObjectType and
      not this instanceof StringType and
      not this instanceof ValueType and
      (
        exists(UnboundGeneric g | usesMappedType(g) |
          this = g.getAConstructedGeneric().getATypeArgument()
        )
        or
        this.getASubType() instanceof MappedType
      )
    }
  }

  /** A property that is potentially stored and retrieved from a database. */
  class MappedProperty extends Property {
    MappedProperty() {
      this = any(MappedType t).getAMember() and
      this.isPublic() and
      not isNotMapped(this)
    }
  }

  /** The struct `Microsoft.EntityFrameworkCore.RawSqlString`. */
  private class RawSqlStringStruct extends Struct {
    RawSqlStringStruct() { this.getQualifiedName() = "Microsoft.EntityFrameworkCore.RawSqlString" }

    /** Gets a conversion operator from `string` to `RawSqlString`. */
    ConversionOperator getAConversionTo() {
      result = this.getAMember() and
      result.getTargetType() instanceof RawSqlStringStruct and
      result.getSourceType() instanceof StringType
    }
  }

  private class RawSqlStringConstructorSummarizedCallable extends EFSummarizedCallable {
    RawSqlStringConstructorSummarizedCallable() {
      exists(RawSqlStringStruct s |
        this = s.getAConstructor() and
        this.getNumberOfParameters() > 0
      )
    }

    override predicate propagatesFlow(
      SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
    ) {
      input = SummaryComponentStack::argument(0) and
      output = SummaryComponentStack::return() and
      preservesValue = false
    }
  }

  private class RawSqlStringConversionSummarizedCallable extends EFSummarizedCallable {
    RawSqlStringConversionSummarizedCallable() {
      exists(RawSqlStringStruct s | this = s.getAConversionTo())
    }

    override predicate propagatesFlow(
      SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
    ) {
      input = SummaryComponentStack::argument(0) and
      output = SummaryComponentStack::return() and
      preservesValue = false
    }
  }

  /**
   * A parameter that accepts raw SQL. Parameters of type `System.FormattableString`
   * are not included as they are not vulnerable to SQL injection.
   */
  private class SqlParameter extends Parameter {
    SqlParameter() {
      this.getType() instanceof StringType and
      (
        exists(Callable c | this = c.getParameter(0) | c.getName().matches("%Sql"))
        or
        this.getName() = "sql"
      ) and
      this.getCallable().getDeclaringType().getDeclaringNamespace().getParentNamespace*() instanceof
        EFNamespace
      or
      this.getType() instanceof RawSqlStringStruct
      or
      this = any(RawSqlStringStruct s).getAConstructor().getAParameter()
      or
      this = any(RawSqlStringStruct s).getAConversionTo().getAParameter()
    }
  }

  /** A call to a method in EntityFrameworkCore that executes SQL. */
  class EntityFrameworkCoreSqlSink extends SqlExpr, Call {
    SqlParameter sqlParam;

    EntityFrameworkCoreSqlSink() { this.getTarget().getAParameter() = sqlParam }

    override Expr getSql() { result = this.getArgumentForParameter(sqlParam) }
  }

  /** The sink method `System.Data.Entity.DbSet.SqlQuery`. */
  private class SystemDataEntityDbSetSqlQuerySinkModelCsv extends SinkModelCsv {
    override predicate row(string row) {
      row =
        "System.Data.Entity;DbSet;false;SqlQuery;(System.String,System.Object[]);;Argument[0];sql"
    }
  }

  /** A sink method in `System.Data.Entity.Database` that executes SQL. */
  private class SystemDataEntityDatabaseSinkModelCsv extends SinkModelCsv {
    override predicate row(string row) {
      row =
        [
          "System.Data.Entity;Database;false;SqlQuery;(System.Type,System.String,System.Object[]);;Argument[1];sql",
          "System.Data.Entity;Database;false;SqlQuery<>;(System.String,System.Object[]);;Argument[0];sql",
          "System.Data.Entity;Database;false;ExecuteSqlCommand;(System.String,System.Object[]);;Argument[0];sql",
          "System.Data.Entity;Database;false;ExecuteSqlCommand;(System.Data.Entity.TransactionalBehavior,System.String,System.Object[]);;Argument[1];sql",
          "System.Data.Entity;Database;false;ExecuteSqlCommandAsync;(System.Data.Entity.TransactionalBehavior,System.String,System.Threading.CancellationToken,System.Object[]);;Argument[1];sql",
          "System.Data.Entity;Database;false;ExecuteSqlCommandAsync;(System.String,System.Threading.CancellationToken,System.Object[]);;Argument[0];sql",
          "System.Data.Entity;Database;false;ExecuteSqlCommandAsync;(System.String,System.Object[]);;Argument[0];sql",
          "System.Data.Entity;Database;false;ExecuteSqlCommandAsync;(System.Data.Entity.TransactionalBehavior,System.String,System.Object[]);;Argument[1];sql"
        ]
    }
  }

  /** Holds if `t` is compatible with a DB column type. */
  private predicate isColumnType(Type t) {
    t instanceof SimpleType
    or
    t instanceof StringType
    or
    t instanceof Enum
    or
    t instanceof SystemDateTimeStruct
    or
    isColumnType(t.(NullableType).getUnderlyingType())
  }

  /** A DB Context. */
  private class DbContextClass extends Class {
    DbContextClass() { this.getBaseClass*().getUnboundDeclaration() instanceof DbContext }

    /**
     * Gets a `DbSet<elementType>` property belonging to this DB context.
     *
     * For example `Persons` with `elementType = Person` in
     *
     * ```csharp
     * class MyContext : DbContext
     * {
     *     public virtual DbSet<Person> Persons { get; set; }
     *     public virtual DbSet<Address> Addresses { get; set; }
     * }
     * ```
     */
    private Property getADbSetProperty(Class elementType) {
      exists(ConstructedClass c |
        result.getType() = c and
        c.getUnboundDeclaration() instanceof DbSet and
        elementType = c.getTypeArgument(0) and
        this.hasMember(any(Property p | result = p.getUnboundDeclaration())) and
        not isNotMapped([result.(Attributable), elementType])
      )
    }

    /**
     * Holds if `[c2, c1]` is part of a valid access path starting from a `DbSet<T>`
     * property belonging to this DB context. `t1` is the type of `c1` and `t2` is
     * the type of `c2`.
     *
     * If `t2` is a column type, `c2` will be included in the model (see
     * https://docs.microsoft.com/en-us/ef/core/modeling/entity-types?tabs=data-annotations).
     */
    private predicate step(Content c1, Type t1, Content c2, Type t2, int dist) {
      exists(Property p1 |
        p1 = this.getADbSetProperty(t2) and
        c1.(PropertyContent).getProperty() = p1 and
        t1 = p1.getType() and
        c2 instanceof ElementContent and
        dist = 0
      )
      or
      this.step(_, _, c1, t1, dist - 1) and
      dist < DataFlowPrivate::accessPathLimit() - 1 and
      not isNotMapped(t2) and
      (
        // Navigation property (https://docs.microsoft.com/en-us/ef/ef6/fundamentals/relationships)
        exists(Property p2 |
          p2.getDeclaringType().(Class) = t1 and
          not isColumnType(t1) and
          c2.(PropertyContent).getProperty() = p2 and
          t2 = p2.getType() and
          not isNotMapped(p2)
        )
        or
        exists(ConstructedInterface ci |
          c1 instanceof PropertyContent and
          t1.(ValueOrRefType).getABaseType*() = ci and
          not t1 instanceof StringType and
          ci.getUnboundDeclaration() instanceof SystemCollectionsGenericIEnumerableTInterface and
          c2 instanceof ElementContent and
          t2 = ci.getTypeArgument(0)
        )
      )
    }

    /**
     * Gets a property belonging to the model of this DB context, which is mapped
     * directly to a column in the underlying DB.
     *
     * For example the `Name` and `Id` properties of `Person`, but not `Title`
     * as it is explicitly unmapped, in
     *
     * ```csharp
     * class Person
     * {
     *     public int Id { get; set; }
     *     public string Name { get; set; }
     *
     *     [NotMapped]
     *     public string Title { get; set; }
     * }
     *
     * class MyContext : DbContext
     * {
     *     public virtual DbSet<Person> Persons { get; set; }
     *     public virtual DbSet<Address> Addresses { get; set; }
     * }
     * ```
     */
    Property getAColumnProperty(int dist) {
      exists(PropertyContent c, Type t |
        this.step(_, _, c, t, dist) and
        c.getProperty() = result and
        isColumnType(t)
      )
    }

    private predicate stepRev(Content c1, Type t1, Content c2, Type t2, int dist) {
      this.step(c1, t1, c2, t2, dist) and
      c2.(PropertyContent).getProperty() = this.getAColumnProperty(dist)
      or
      this.stepRev(c2, t2, _, _, dist + 1) and
      this.step(c1, t1, c2, t2, dist)
    }

    /** Gets a `SaveChanges[Async]` method. */
    pragma[nomagic]
    Method getASaveChanges() {
      this.hasMethod(result) and
      result.getName().matches("SaveChanges%")
    }

    /** Holds if component stack `head :: tail` is required for the input specification. */
    predicate requiresComponentStackIn(
      Content head, Type headType, SummaryComponentStack tail, int dist
    ) {
      tail = SummaryComponentStack::qualifier() and
      this.stepRev(head, headType, _, _, 0) and
      dist = -1
      or
      exists(Content tailHead, Type tailType, SummaryComponentStack tailTail |
        this.requiresComponentStackIn(tailHead, tailType, tailTail, dist - 1) and
        tail = SummaryComponentStack::push(SummaryComponent::content(tailHead), tailTail) and
        this.stepRev(tailHead, tailType, head, headType, dist)
      )
    }

    /** Holds if component stack `head :: tail` is required for the output specification. */
    predicate requiresComponentStackOut(
      Content head, Type headType, SummaryComponentStack tail, int dist
    ) {
      exists(Property dbSetProp, PropertyContent c1 |
        dbSetProp = this.getADbSetProperty(headType) and
        this.stepRev(c1, _, head, headType, 0) and
        c1.getProperty() = dbSetProp and
        tail = SummaryComponentStack::jump(dbSetProp.getGetter()) and
        dist = 0
      )
      or
      exists(Content tailHead, SummaryComponentStack tailTail, Type tailType |
        this.requiresComponentStackOut(tailHead, tailType, tailTail, dist - 1) and
        tail = SummaryComponentStack::push(SummaryComponent::content(tailHead), tailTail) and
        this.stepRev(tailHead, tailType, head, headType, dist)
      )
    }
  }

  private class DbContextSaveChanges extends EFSummarizedCallable {
    private DbContextClass c;

    DbContextSaveChanges() { this = c.getASaveChanges() }

    pragma[noinline]
    private predicate input(SummaryComponentStack input, Property mapped) {
      exists(PropertyContent head, SummaryComponentStack tail |
        c.requiresComponentStackIn(head, _, tail, _) and
        head.getProperty() = mapped and
        mapped = c.getAColumnProperty(_) and
        input = SummaryComponentStack::push(SummaryComponent::content(head), tail)
      )
    }

    pragma[noinline]
    private predicate output(SummaryComponentStack output, Property mapped) {
      exists(PropertyContent head, SummaryComponentStack tail |
        c.requiresComponentStackOut(head, _, tail, _) and
        head.getProperty() = mapped and
        mapped = c.getAColumnProperty(_) and
        output = SummaryComponentStack::push(SummaryComponent::content(head), tail)
      )
    }

    override predicate propagatesFlow(
      SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
    ) {
      exists(Property mapped |
        preservesValue = true and
        this.input(input, mapped) and
        this.output(output, mapped)
      )
    }
  }

  private class DbContextSaveChangesRequiredSummaryComponentStack extends RequiredSummaryComponentStack {
    override predicate required(SummaryComponent head, SummaryComponentStack tail) {
      exists(Content c | head = SummaryComponent::content(c) |
        any(DbContextClass cls).requiresComponentStackIn(c, _, tail, _)
        or
        any(DbContextClass cls).requiresComponentStackOut(c, _, tail, _)
      )
    }
  }
}
