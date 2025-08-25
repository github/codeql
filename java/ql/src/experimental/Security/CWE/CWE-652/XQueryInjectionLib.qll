deprecated module;

import java

/** A call to `XQConnection.prepareExpression`. */
class XQueryParserCall extends MethodCall {
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
class XQueryPreparedExecuteCall extends MethodCall {
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
class XQueryExecuteCall extends MethodCall {
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
class XQueryExecuteCommandCall extends MethodCall {
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
