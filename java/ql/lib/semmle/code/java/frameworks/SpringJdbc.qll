/**
 * Provides classes and predicates for working with the Spring JDBC framework.
 */
overlay[local?]
module;

import java

/** The class `org.springframework.jdbc.core.JdbcTemplate`. */
class JdbcTemplate extends RefType {
  JdbcTemplate() { this.hasQualifiedName("org.springframework.jdbc.core", "JdbcTemplate") }
}
