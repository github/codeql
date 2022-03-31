/**
 * Definitions of sinks in the JDBI library.
 */

import java
import semmle.code.java.dataflow.ExternalFlow

private class SsrfSinkCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;spec;kind"
        "org.jdbi.v3.core;Jdbi;false;create;(String);;Argument[0];jdbc-url",
        "org.jdbi.v3.core;Jdbi;false;create;(String,Properties);;Argument[0];jdbc-url",
        "org.jdbi.v3.core;Jdbi;false;create;(String,String,String);;Argument[0];jdbc-url",
        "org.jdbi.v3.core;Jdbi;false;open;(String);;Argument[0];jdbc-url",
        "org.jdbi.v3.core;Jdbi;false;open;(String,Properties);;Argument[0];jdbc-url",
        "org.jdbi.v3.core;Jdbi;false;open;(String,String,String);;Argument[0];jdbc-url"
      ]
  }
}
