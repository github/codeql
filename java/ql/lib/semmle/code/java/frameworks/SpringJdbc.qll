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
        "org.springframework.jdbc.core;JdbcTemplate;false;batchUpdate;(String[]);;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;batchUpdate;;;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;execute;;;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;update;;;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;query;;;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;queryForList;;;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;queryForMap;;;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;queryForObject;;;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;queryForRowSet;;;Argument[0];sql",
        "org.springframework.jdbc.core;JdbcTemplate;false;queryForStream;;;Argument[0];sql",
        "org.springframework.jdbc.object;BatchSqlUpdate;false;BatchSqlUpdate;;;Argument[1];sql",
        "org.springframework.jdbc.object;MappingSqlQuery;false;BatchSqlUpdate;;;Argument[1];sql",
        "org.springframework.jdbc.object;MappingSqlQueryWithParameters;false;BatchSqlUpdate;;;Argument[1];sql",
        "org.springframework.jdbc.object;RdbmsOperation;true;setSql;;;Argument[0];sql",
        "org.springframework.jdbc.object;SqlCall;false;SqlCall;;;Argument[1];sql",
        "org.springframework.jdbc.object;SqlFunction;false;SqlFunction;;;Argument[1];sql",
        "org.springframework.jdbc.object;SqlQuery;false;SqlQuery;;;Argument[1];sql",
        "org.springframework.jdbc.object;SqlUpdate;false;SqlUpdate;;;Argument[1];sql",
        "org.springframework.jdbc.object;UpdatableSqlQuery;false;UpdatableSqlQuery;;;Argument[1];sql"
      ]
  }
}

private class SsrfSinkCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;spec;kind"
        "org.springframework.boot.jdbc;DataSourceBuilder;false;url;(String);;Argument[0];jdbc-url",
        "org.springframework.jdbc.datasource;AbstractDriverBasedDataSource;false;setUrl;(String);;Argument[0];jdbc-url",
        "org.springframework.jdbc.datasource;DriverManagerDataSource;false;DriverManagerDataSource;(String);;Argument[0];jdbc-url",
        "org.springframework.jdbc.datasource;DriverManagerDataSource;false;DriverManagerDataSource;(String,String,String);;Argument[0];jdbc-url",
        "org.springframework.jdbc.datasource;DriverManagerDataSource;false;DriverManagerDataSource;(String,Properties);;Argument[0];jdbc-url"
      ]
  }
}
