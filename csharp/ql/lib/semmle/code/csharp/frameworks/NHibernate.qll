/**
 * Classes for modeling NHibernate.
 */

import csharp
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.frameworks.Sql
private import semmle.code.csharp.security.dataflow.flowsources.Stored as Stored

/** Definitions relating to the `NHibernate` package. */
module NHibernate {
  /** A class that is mapped to the database. */
  abstract class MappedClass extends Class { }

  /** The interface `NHibernamte.ISession`. */
  class ISessionInterface extends Interface {
    ISessionInterface() { this.hasFullyQualifiedName("NHibernate", "ISession") }

    /** Gets a parameter that uses a mapped object. */
    Parameter getAMappedObjectParameter() {
      exists(Callable c |
        result.getType() instanceof ObjectType and
        c = this.getAMethod() and
        result = c.getAParameter() and
        result.getName() = "obj"
      )
    }

    /** Gets a type parameter that specifies a mapped class. */
    TypeParameter getAMappedObjectTp() {
      exists(string methodName | methodName = ["Load`1", "Merge`1", "Get`1", "Query`1"] |
        result = this.getAMethod(methodName).(UnboundGenericMethod).getTypeParameter(0)
      )
    }
  }

  /** A mapped class that is mapped because it is used as a type argument. */
  private class MappedByTypeArgument extends MappedClass {
    MappedByTypeArgument() {
      this = any(ISessionInterface si).getAMappedObjectTp().getASuppliedType()
    }
  }

  /** A mapped class that is mapped because it is passed as a parameter. */
  private class MappedByParam extends MappedClass {
    MappedByParam() {
      exists(ISessionInterface si, Expr e, MethodCall c, Parameter p |
        p = si.getAMappedObjectParameter() and
        e = c.getArgumentForParameter(p) and
        this = e.getType()
      ) and
      not this instanceof ObjectType and
      not this.getABaseInterface*() instanceof SystemCollectionsIEnumerableInterface and
      not this instanceof SystemTypeClass
    }
  }

  /** A property that is persisted in the database. */
  class MappedProperty extends Property {
    MappedProperty() {
      this.getDeclaringType() instanceof MappedClass and
      this.isPublic()
    }
  }

  /** A parameter that is interpreted as SQL. */
  class SqlParameter extends Parameter {
    SqlParameter() {
      this.getType() instanceof StringType and
      (this.getName() = "sql" or this.getName() = "sqlString" or this.getName() = "query") and
      this.getCallable()
          .getDeclaringType()
          .getDeclaringNamespace()
          .getParentNamespace*()
          .hasFullyQualifiedName("", "NHibernate")
    }
  }

  /** A call to a method in NHibernate that executes SQL. */
  class NHibernateSqlSink extends SqlExpr, Call {
    SqlParameter sqlParam;

    NHibernateSqlSink() { this.getTarget().getAParameter() = sqlParam }

    override Expr getSql() { result = this.getArgumentForParameter(sqlParam) }
  }

  /** A taint source where the data has come from a mapped property stored in the database. */
  class StoredFlowSource extends Stored::DatabaseInputSource {
    StoredFlowSource() {
      this.asExpr() = any(PropertyRead read | read.getTarget() instanceof MappedProperty)
    }

    override string getSourceType() { result = "ORM mapped property" }
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
