/**
 * Provides classes and predicates for working with the Java JDBC API.
 */
overlay[local?]
module;

import java

/*--- Types ---*/
/** The interface `java.sql.Connection`. */
class TypeConnection extends Interface {
  TypeConnection() { this.hasQualifiedName("java.sql", "Connection") }
}

/** The interface `java.sql.PreparedStatement`. */
class TypePreparedStatement extends Interface {
  TypePreparedStatement() { this.hasQualifiedName("java.sql", "PreparedStatement") }
}

/** The interface `java.sql.ResultSet`. */
class TypeResultSet extends Interface {
  TypeResultSet() { this.hasQualifiedName("java.sql", "ResultSet") }
}

/** The interface `java.sql.Statement`. */
class TypeStatement extends Interface {
  TypeStatement() { this.hasQualifiedName("java.sql", "Statement") }
}

/*--- Methods ---*/
/** A method with the name `getString` declared in `java.sql.ResultSet`. */
class ResultSetGetStringMethod extends Method {
  ResultSetGetStringMethod() {
    this.getDeclaringType() instanceof TypeResultSet and
    this.hasName("getString") and
    this.getReturnType() instanceof TypeString
  }
}

/** A method with the name `executeUpdate` declared in `java.sql.PreparedStatement`. */
class PreparedStatementExecuteUpdateMethod extends Method {
  PreparedStatementExecuteUpdateMethod() {
    this.getDeclaringType() instanceof TypePreparedStatement and
    this.hasName("executeUpdate")
  }
}

/** A method with the name `executeLargeUpdate` declared in `java.sql.PreparedStatement`. */
class PreparedStatementExecuteLargeUpdateMethod extends Method {
  PreparedStatementExecuteLargeUpdateMethod() {
    this.getDeclaringType() instanceof TypePreparedStatement and
    this.hasName("executeLargeUpdate")
  }
}
