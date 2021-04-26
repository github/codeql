/**
 * Provides classes and predicates for working with the Spring JDBC framework.
 */

import java
import semmle.code.java.dataflow.ExternalFlow

/** The class `org.springframework.jdbc.core.JdbcTemplate`. */
class JdbcTemplate extends RefType {
  JdbcTemplate() { this.hasQualifiedName("org.springframework.jdbc.core", "JdbcTemplate") }
}

private class SqlSinkCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;spec;kind"
        "org.springframework.jdbc.core;JdbcTemplate;false;batchUpdate;(String[]);;ArrayElement of Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;batchUpdate;;;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;execute;;;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;update;;;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;query;;;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;queryForList;;;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;queryForMap;;;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;queryForObject;;;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;queryForRowSet;;;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;queryForStream;;;Argument[0];sql"
      ]
  }
}
