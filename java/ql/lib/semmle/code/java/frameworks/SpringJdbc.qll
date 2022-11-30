/**
 * Provides classes and predicates for working with the Spring JDBC framework.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

/** The class `org.springframework.jdbc.core.JdbcTemplate`. */
class JdbcTemplate extends RefType {
  JdbcTemplate() { this.hasQualifiedName("org.springframework.jdbc.core", "JdbcTemplate") }
}
