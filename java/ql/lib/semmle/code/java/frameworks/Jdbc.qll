/**
 * Provides classes and predicates for working with the Java JDBC API.
 */

import semmle.code.java.Type
import semmle.code.java.dataflow.ExternalFlow

/*--- Types ---*/
/** The interface `java.sql.Connection`. */
class TypeConnection extends Interface {
  TypeConnection() { hasQualifiedName("java.sql", "Connection") }
}

/** The interface `java.sql.PreparedStatement`. */
class TypePreparedStatement extends Interface {
  TypePreparedStatement() { hasQualifiedName("java.sql", "PreparedStatement") }
}

/** The interface `java.sql.ResultSet`. */
class TypeResultSet extends Interface {
  TypeResultSet() { hasQualifiedName("java.sql", "ResultSet") }
}

/** The interface `java.sql.Statement`. */
class TypeStatement extends Interface {
  TypeStatement() { hasQualifiedName("java.sql", "Statement") }
}

/*--- Methods ---*/
/** A method with the name `getString` declared in `java.sql.ResultSet`. */
class ResultSetGetStringMethod extends Method {
  ResultSetGetStringMethod() {
    getDeclaringType() instanceof TypeResultSet and
    hasName("getString") and
    getReturnType() instanceof TypeString
  }
}

/*--- Other definitions ---*/
private class SqlSinkCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;spec;kind"
        "java.sql;Connection;true;prepareStatement;;;Argument[0];sql",
        "java.sql;Connection;true;prepareCall;;;Argument[0];sql",
        "java.sql;Statement;true;execute;;;Argument[0];sql",
        "java.sql;Statement;true;executeQuery;;;Argument[0];sql",
        "java.sql;Statement;true;executeUpdate;;;Argument[0];sql",
        "java.sql;Statement;true;executeLargeUpdate;;;Argument[0];sql",
        "java.sql;Statement;true;addBatch;;;Argument[0];sql"
      ]
  }
}

private class SsrfSinkCsv extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;spec;kind"
        "java.sql;DriverManager;false;getConnection;(String);;Argument[0];jdbc-url",
        "java.sql;DriverManager;false;getConnection;(String,Properties);;Argument[0];jdbc-url",
        "java.sql;DriverManager;false;getConnection;(String,String,String);;Argument[0];jdbc-url",
        "java.sql;Driver;false;connect;(String,Properties);;Argument[0];jdbc-url"
      ]
  }
}
