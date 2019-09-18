/**
 * Provides classes and predicates for working with the Spring JDBC framework.
 */

import java

/** The class `org.springframework.jdbc.core.JdbcTemplate`. */
class JdbcTemplate extends RefType {
  JdbcTemplate() { this.hasQualifiedName("org.springframework.jdbc.core", "JdbcTemplate") }
}

/**
 * Holds if `m` is a method on `JdbcTemplate` taking an SQL string as its first
 * argument.
 */
predicate jdbcSqlMethod(Method m) {
  m.getDeclaringType() instanceof JdbcTemplate and
  m.getParameterType(0) instanceof TypeString and
  (
    m.hasName("batchUpdate") or
    m.hasName("execute") or
    m.getName().matches("query%") or
    m.hasName("update")
  )
}

/** The method `JdbcTemplate.batchUpdate(String... sql)` */
class BatchUpdateVarargsMethod extends Method {
  BatchUpdateVarargsMethod() {
    this.getDeclaringType() instanceof JdbcTemplate and
    this.hasName("batchUpdate") and
    this.getParameterType(0).(Array).getComponentType() instanceof TypeString and
    this.getParameter(0).isVarargs()
  }
}
