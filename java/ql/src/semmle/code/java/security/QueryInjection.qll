/** Provides classes to reason about database query language injection vulnerabilities. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.frameworks.Jdbc
import semmle.code.java.frameworks.jOOQ
import semmle.code.java.frameworks.android.SQLite
import semmle.code.java.frameworks.javaee.Persistence
import semmle.code.java.frameworks.SpringJdbc
import semmle.code.java.frameworks.MyBatis
import semmle.code.java.frameworks.Hibernate

/** A sink for database query language injection vulnerabilities. */
abstract class QueryInjectionSink extends DataFlow::Node { }

/**
 * A unit class for adding additional taint steps.
 *
 * Extend this class to add additional taint steps that should apply to the SQL
 * injection taint configuration.
 */
class AdditionalQueryInjectionTaintStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a taint
   * step for SQL injection taint configurations.
   */
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

/** A sink for SQL injection vulnerabilities. */
private class SqlInjectionSink extends QueryInjectionSink {
  SqlInjectionSink() {
    this.asExpr() instanceof SqlExpr
    or
    exists(MethodAccess ma, Method m, int index |
      ma.getMethod() = m and
      if index = -1
      then this.asExpr() = ma.getQualifier()
      else ma.getArgument(index) = this.asExpr()
    |
      index = m.(SQLiteRunner).sqlIndex()
      or
      m instanceof BatchUpdateVarargsMethod
      or
      index = 0 and jdbcSqlMethod(m)
      or
      index = 0 and mybatisSqlMethod(m)
      or
      index = 0 and hibernateSqlMethod(m)
      or
      index = 0 and jOOQSqlMethod(m)
    )
  }
}

/** A sink for Java Persistence Query Language injection vulnerabilities. */
private class PersistenceQueryInjectionSink extends QueryInjectionSink {
  PersistenceQueryInjectionSink() {
    // the query (first) argument to a `createQuery` or `createNativeQuery` method on `EntityManager`
    exists(MethodAccess call, TypeEntityManager em | call.getArgument(0) = this.asExpr() |
      call.getMethod() = em.getACreateQueryMethod() or
      call.getMethod() = em.getACreateNativeQueryMethod()
      // note: `createNamedQuery` is safe, as it takes only the query name,
      // and named queries can only be constructed using constants as the query text
    )
  }
}

/** A sink for MongoDB injection vulnerabilities. */
private class MongoDbInjectionSink extends QueryInjectionSink {
  MongoDbInjectionSink() {
    exists(MethodAccess call |
      call.getMethod().getDeclaringType().hasQualifiedName("com.mongodb", "BasicDBObject") and
      call.getMethod().hasName("parse") and
      this.asExpr() = call.getArgument(0)
    )
    or
    exists(CastExpr c |
      c.getExpr() = this.asExpr() and
      c.getTypeExpr().getType().(RefType).hasQualifiedName("com.mongodb", "DBObject")
    )
  }
}

private class MongoJsonStep extends AdditionalQueryInjectionTaintStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(MethodAccess ma |
      ma.getMethod().getDeclaringType().hasQualifiedName("com.mongodb.util", "JSON") and
      ma.getMethod().hasName("parse") and
      ma.getArgument(0) = node1.asExpr() and
      ma = node2.asExpr()
    )
  }
}
