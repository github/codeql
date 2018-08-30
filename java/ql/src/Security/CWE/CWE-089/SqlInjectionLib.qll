/** Definitions used by the queries for database query injection. */

import semmle.code.java.Expr
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.android.SQLite
import semmle.code.java.frameworks.javaee.Persistence

/** A sink for database query language injection vulnerabilities. */
abstract class QueryInjectionSink extends DataFlow::ExprNode {}

/** A sink for SQL injection vulnerabilities. */
class SqlInjectionSink extends QueryInjectionSink {
  SqlInjectionSink() {
    this.getExpr() instanceof SqlExpr or
    exists(SQLiteRunner s, MethodAccess m | m.getMethod() = s |
      m.getArgument(s.sqlIndex()) = this.getExpr()
    )
  }
}

/** A sink for Java Persistence Query Language injection vulnerabilities. */
class PersistenceQueryInjectionSink extends QueryInjectionSink {
  PersistenceQueryInjectionSink() {
    // the query (first) argument to a `createQuery` or `createNativeQuery` method on `EntityManager`
    exists(MethodAccess call, TypeEntityManager em | call.getArgument(0) = this.getExpr() |
      call.getMethod() = em.getACreateQueryMethod() or
      call.getMethod() = em.getACreateNativeQueryMethod()
      // note: `createNamedQuery` is safe, as it takes only the query name,
      // and named queries can only be constructed using constants as the query text
    )
  }
}

private class QueryInjectionFlowConfig extends TaintTracking::Configuration {
  QueryInjectionFlowConfig() { this = "SqlInjectionLib::QueryInjectionFlowConfig" }
  override predicate isSource(DataFlow::Node src) { src instanceof RemoteUserInput }
  override predicate isSink(DataFlow::Node sink) { sink instanceof QueryInjectionSink }
  override predicate isSanitizer(DataFlow::Node node) { node.getType() instanceof PrimitiveType or node.getType() instanceof BoxedType }
}

/**
 * Implementation of `SqlTainted.ql`. This is extracted to a QLL so that it
 * can be excluded from `SqlUnescaped.ql` to avoid overlapping results.
 */
predicate queryTaintedBy(QueryInjectionSink query, RemoteUserInput source) {
  exists(QueryInjectionFlowConfig conf |
    conf.hasFlow(source, query)
  )
}
