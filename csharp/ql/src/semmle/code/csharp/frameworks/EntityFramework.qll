/**
 * Classes modelling EntityFramework and EntityFrameworkCore.
 */

import csharp
private import DataFlow
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.data.Entity
private import semmle.code.csharp.frameworks.system.collections.Generic
private import semmle.code.csharp.frameworks.Sql
private import semmle.code.csharp.dataflow.FlowSummary

/**
 * Definitions relating to the `System.ComponentModel.DataAnnotations`
 * namespace.
 */
module DataAnnotations {
  /** The `NotMappedAttribute` attribute. */
  class NotMappedAttribute extends Attribute {
    NotMappedAttribute() {
      this
          .getType()
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
    SummarizableMethod getAnAddOrUpdateMethod(boolean range) {
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

  private class DbSetAddOrUpdate extends EFSummarizedCallable {
    private boolean range;

    DbSetAddOrUpdate() { this = any(DbSet c).getAnAddOrUpdateMethod(range) }

    override predicate propagatesFlow(
      SummaryInput input, ContentList inputContents, SummaryOutput output,
      ContentList outputContents, boolean preservesValue
    ) {
      input = SummaryInput::parameter(0) and
      (
        if range = true
        then inputContents = ContentList::element()
        else inputContents = ContentList::empty()
      ) and
      output = SummaryOutput::thisParameter() and
      outputContents = ContentList::element() and
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

  private class RawSqlStringSummarizedCallable extends EFSummarizedCallable {
    private SummaryInput input_;
    private SummaryOutput output_;
    private boolean preservesValue_;

    RawSqlStringSummarizedCallable() {
      exists(RawSqlStringStruct s |
        this = s.getAConstructor() and
        input_ = SummaryInput::parameter(0) and
        this.getNumberOfParameters() > 0 and
        output_ = SummaryOutput::return() and
        preservesValue_ = false
        or
        this = s.getAConversionTo() and
        input_ = SummaryInput::parameter(0) and
        output_ = SummaryOutput::return() and
        preservesValue_ = false
      )
    }

    override predicate propagatesFlow(
      SummaryInput input, SummaryOutput output, boolean preservesValue
    ) {
      input = input_ and
      output = output_ and
      preservesValue = preservesValue_
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

  /** A call to `System.Data.Entity.DbSet.SqlQuery`. */
  class SystemDataEntityDbSetSqlExpr extends SqlExpr, MethodCall {
    SystemDataEntityDbSetSqlExpr() {
      this.getTarget() = any(SystemDataEntity::DbSet dbSet).getSqlQueryMethod()
    }

    override Expr getSql() { result = this.getArgumentForName("sql") }
  }

  /** A call to a method in `System.Data.Entity.Database` that executes SQL. */
  class SystemDataEntityDatabaseSqlExpr extends SqlExpr, MethodCall {
    SystemDataEntityDatabaseSqlExpr() {
      exists(SystemDataEntity::Database db |
        this.getTarget() = db.getSqlQueryMethod() or
        this.getTarget() = db.getExecuteSqlCommandMethod() or
        this.getTarget() = db.getExecuteSqlCommandAsyncMethod()
      )
    }

    override Expr getSql() { result = this.getArgumentForName("sql") }
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
    DbContextClass() { this.getBaseClass*().getSourceDeclaration() instanceof DbContext }

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
        c.getSourceDeclaration() instanceof DbSet and
        elementType = c.getTypeArgument(0) and
        this.hasMember(any(Property p | result = p.getSourceDeclaration())) and
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
    private predicate step(Content c1, Type t1, Content c2, Type t2) {
      exists(Property p1 |
        p1 = this.getADbSetProperty(t2) and
        c1.(PropertyContent).getProperty() = p1 and
        t1 = p1.getType() and
        c2 instanceof ElementContent
      )
      or
      step(_, _, c1, t1) and
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
          ci.getSourceDeclaration() instanceof SystemCollectionsGenericIEnumerableTInterface and
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
    private Property getAColumnProperty() {
      exists(PropertyContent c, Type t |
        this.step(_, _, c, t) and
        c.getProperty() = result and
        isColumnType(t)
      )
    }

    /** Gets a `SaveChanges[Async]` method. */
    pragma[nomagic]
    SummarizableMethod getASaveChanges() {
      this.hasMethod(result) and
      result.getName().matches("SaveChanges%")
    }

    /** Holds if content list `head :: tail` is required. */
    predicate requiresContentList(
      Content head, Type headType, ContentList tail, Type tailType, Property last
    ) {
      exists(PropertyContent p |
        last = this.getAColumnProperty() and
        p.getProperty() = last and
        tail = ContentList::singleton(p) and
        this.step(head, headType, p, tailType)
      )
      or
      exists(Content tailHead, ContentList tailTail |
        this.requiresContentList(tailHead, tailType, tailTail, _, last) and
        tail = ContentList::cons(tailHead, tailTail) and
        this.step(head, headType, tailHead, tailType)
      )
    }

    /**
     * Holds if the access path obtained by concatenating `head` onto `tail`
     * is a path from `dbSet` (which is a `DbSet<T>` property belonging to
     * this DB context) to `last`, which is a property that is mapped directly
     * to a column in the underlying DB.
     */
    pragma[noinline]
    predicate pathFromDbSetToDbProperty(
      Property dbSet, PropertyContent head, ContentList tail, Property last
    ) {
      this.requiresContentList(head, _, tail, _, last) and
      head.getProperty() = dbSet and
      dbSet = this.getADbSetProperty(_)
    }
  }

  private class DbContextSaveChanges extends EFSummarizedCallable {
    private DbContextClass c;

    DbContextSaveChanges() { this = c.getASaveChanges() }

    override predicate requiresContentList(Content head, ContentList tail) {
      c.requiresContentList(head, _, tail, _, _)
    }

    override predicate propagatesFlow(
      SummaryInput input, ContentList inputContents, SummaryOutput output,
      ContentList outputContents, boolean preservesValue
    ) {
      exists(Property mapped |
        preservesValue = true and
        exists(PropertyContent sourceHead, ContentList sourceTail |
          input = SummaryInput::thisParameter() and
          c.pathFromDbSetToDbProperty(_, sourceHead, sourceTail, mapped) and
          inputContents = ContentList::cons(sourceHead, sourceTail)
        ) and
        exists(Property dbSetProp |
          output = SummaryOutput::jump(dbSetProp.getGetter(), SummaryOutput::return()) and
          c.pathFromDbSetToDbProperty(dbSetProp, _, outputContents, mapped)
        )
      )
    }
  }
}
