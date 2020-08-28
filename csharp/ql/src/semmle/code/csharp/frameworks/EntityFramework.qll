/**
 * Classes modelling EntityFramework and EntityFrameworkCore.
 */

import csharp
private import semmle.code.csharp.frameworks.system.data.Entity
private import semmle.code.csharp.frameworks.system.collections.Generic
private import semmle.code.csharp.frameworks.Sql
private import semmle.code.csharp.dataflow.LibraryTypeDataFlow

/**
 * Definitions relating to the `System.ComponentModel.DataAnnotations`
 * namespace.
 */
module DataAnnotations {
  /** Class for `NotMappedAttribute`. */
  class NotMappedAttribute extends Attribute {
    NotMappedAttribute() {
      this
          .getType()
          .hasQualifiedName("System.ComponentModel.DataAnnotations.Schema.NotMappedAttribute")
    }
  }
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
      not this.getAnAttribute() instanceof DataAnnotations::NotMappedAttribute
    }
  }

  /** The struct `Microsoft.EntityFrameworkCore.RawSqlString`. */
  class RawSqlStringStruct extends Struct, LibraryTypeDataFlow {
    RawSqlStringStruct() { this.getQualifiedName() = "Microsoft.EntityFrameworkCore.RawSqlString" }

    override predicate callableFlow(
      CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c,
      boolean preservesValue
    ) {
      c = this.getAConstructor() and
      source.(CallableFlowSourceArg).getArgumentIndex() = 0 and
      sink instanceof CallableFlowSinkReturn and
      preservesValue = false
      or
      c = this.getAConversionTo() and
      source.(CallableFlowSourceArg).getArgumentIndex() = 0 and
      sink instanceof CallableFlowSinkReturn and
      preservesValue = false
    }

    /** Gets a conversion operator from `string` to `RawSqlString`. */
    ConversionOperator getAConversionTo() {
      result = this.getAMember() and
      result.getTargetType() instanceof RawSqlStringStruct and
      result.getSourceType() instanceof StringType
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

  /**
   * A dataflow node whereby data flows from a property write to a property read
   * via some database. The assumption is that all writes can flow to all reads.
   */
  class MappedPropertyJumpNode extends DataFlow::NonLocalJumpNode {
    MappedProperty property;

    MappedPropertyJumpNode() { this.asExpr() = property.getAnAssignedValue() }

    override DataFlow::Node getAJumpSuccessor(boolean preservesValue) {
      result.asExpr().(PropertyRead).getTarget() = property and
      preservesValue = false
    }
  }
}
