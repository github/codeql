/**
 * Provides classes and predicates for working with the Java JDBC API.
 */

import java

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
