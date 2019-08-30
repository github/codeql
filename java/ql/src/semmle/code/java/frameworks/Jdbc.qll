/**
 * Provides classes and predicates for working with the Java JDBC API.
 */

import semmle.code.java.Type

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
/** A method with the name `prepareStatement` declared in `java.sql.Connection`. */
class ConnectionPrepareStatement extends Method {
  ConnectionPrepareStatement() {
    getDeclaringType() instanceof TypeConnection and
    hasName("prepareStatement")
  }
}

/** A method with the name `prepareCall` declared in `java.sql.Connection`. */
class ConnectionPrepareCall extends Method {
  ConnectionPrepareCall() {
    getDeclaringType() instanceof TypeConnection and
    hasName("prepareCall")
  }
}

/** A method with the name `executeQuery` declared in `java.sql.Statement`. */
class StatementExecuteQuery extends Method {
  StatementExecuteQuery() {
    getDeclaringType() instanceof TypeStatement and
    hasName("executeQuery")
  }
}

/** A method with the name `execute` declared in `java.sql.Statement`. */
class MethodStatementExecute extends Method {
  MethodStatementExecute() {
    getDeclaringType() instanceof TypeStatement and
    hasName("execute")
  }
}

/** A method with the name `executeUpdate` declared in `java.sql.Statement`. */
class MethodStatementExecuteUpdate extends Method {
  MethodStatementExecuteUpdate() {
    getDeclaringType() instanceof TypeStatement and
    hasName("executeUpdate")
  }
}

/** A method with the name `executeLargeUpdate` declared in `java.sql.Statement`. */
class MethodStatementExecuteLargeUpdate extends Method {
  MethodStatementExecuteLargeUpdate() {
    getDeclaringType() instanceof TypeStatement and
    hasName("executeLargeUpdate")
  }
}

/** A method with the name `addBatch` declared in `java.sql.Statement`. */
class MethodStatementAddBatch extends Method {
  MethodStatementAddBatch() {
    getDeclaringType() instanceof TypeStatement and
    hasName("addBatch")
  }
}

/** A method with the name `getString` declared in `java.sql.ResultSet`. */
class ResultSetGetStringMethod extends Method {
  ResultSetGetStringMethod() {
    getDeclaringType() instanceof TypeResultSet and
    hasName("getString") and
    getReturnType() instanceof TypeString
  }
}

/*--- Other definitions ---*/
/**
 * An expression representing SQL code that occurs as an argument of
 * a method in `java.sql.Connection` or `java.sql.Statement`.
 */
class SqlExpr extends Expr {
  SqlExpr() {
    exists(MethodAccess call, Method method |
      call.getArgument(0) = this and
      method = call.getMethod() and
      (
        method instanceof ConnectionPrepareStatement or
        method instanceof ConnectionPrepareCall or
        method instanceof StatementExecuteQuery or
        method instanceof MethodStatementExecute or
        method instanceof MethodStatementExecuteUpdate or
        method instanceof MethodStatementExecuteLargeUpdate or
        method instanceof MethodStatementAddBatch
      )
    )
  }
}
