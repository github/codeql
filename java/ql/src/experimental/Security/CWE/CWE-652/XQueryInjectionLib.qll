import java
private import semmle.code.java.dataflow.ExternalFlow

/** A call to `XQConnection.prepareExpression`. */
class XQueryParserCall extends MethodAccess {
  XQueryParserCall() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName("javax.xml.xquery", "XQConnection") and
      m.hasName("prepareExpression")
    )
  }

  /**
   * Returns the first parameter of the `prepareExpression` method, which provides
   * the string, stream or reader to be compiled into a prepared expression.
   */
  Expr getInput() { result = this.getArgument(0) }
}

/** A call to `XQPreparedExpression.executeQuery`. */
class XQueryPreparedExecuteCall extends MethodAccess {
  XQueryPreparedExecuteCall() {
    exists(Method m |
      this.getMethod() = m and
      m.hasName("executeQuery") and
      m.getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName("javax.xml.xquery", "XQPreparedExpression")
    )
  }

  /** Return this prepared expression. */
  Expr getPreparedExpression() { result = this.getQualifier() }
}

/** A call to `XQExpression.executeQuery`. */
class XQueryExecuteCall extends MethodAccess {
  XQueryExecuteCall() {
    exists(Method m |
      this.getMethod() = m and
      m.hasName("executeQuery") and
      m.getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName("javax.xml.xquery", "XQExpression")
    )
  }

  /** Return this execute query argument. */
  Expr getExecuteQueryArgument() { result = this.getArgument(0) }
}

/** A call to `XQExpression.executeCommand`. */
class XQueryExecuteCommandCall extends MethodAccess {
  XQueryExecuteCommandCall() {
    exists(Method m |
      this.getMethod() = m and
      m.hasName("executeCommand") and
      m.getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName("javax.xml.xquery", "XQExpression")
    )
  }

  /** Return this execute command argument. */
  Expr getExecuteCommandArgument() { result = this.getArgument(0) }
}

private class XQuerySinkModel extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        "javax.xml.xquery;XQPreparedExpression;true;executeQuery;;;Argument[-1];xquery",
        "javax.xml.xquery;XQExpression;true;executeQuery;;;Argument[0];xquery",
        "javax.xml.xquery;XQExpression;true;executeCommand;;;Argument[0];xquery"
      ]
  }
}
