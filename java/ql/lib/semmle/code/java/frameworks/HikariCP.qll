/**
 * Definitions of sinks in the Hikari Connection Pool library.
 */

import java
private import semmle.code.java.dataflow.ExternalFlow

private class SsrfSinkCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;spec;kind"
        "com.zaxxer.hikari;HikariConfig;false;HikariConfig;(Properties);;Argument[0];jdbc-url;manual",
        "com.zaxxer.hikari;HikariConfig;false;setJdbcUrl;(String);;Argument[0];jdbc-url;manual"
      ]
  }
}
