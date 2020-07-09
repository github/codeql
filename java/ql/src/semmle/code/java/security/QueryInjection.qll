/** Definitions used by the queries for database query injection. */

import java
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.frameworks.android.SQLite
import semmle.code.java.frameworks.javaee.Persistence
import semmle.code.java.frameworks.SpringJdbc
import semmle.code.java.frameworks.MyBatis
import semmle.code.java.frameworks.Hibernate

/** A sink for database query language injection vulnerabilities. */
abstract class QueryInjectionSink extends DataFlow::ExprNode { }

/** A sink for SQL injection vulnerabilities. */
private class SqlInjectionSink extends QueryInjectionSink {
  SqlInjectionSink() {
    this.getExpr() instanceof SqlExpr
    or
    exists(MethodAccess ma, Method m, int index |
      ma.getMethod() = m and
      ma.getArgument(index) = this.getExpr()
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
    )
  }
}

/** A sink for Java Persistence Query Language injection vulnerabilities. */
private class PersistenceQueryInjectionSink extends QueryInjectionSink {
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
