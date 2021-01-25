import java

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
class XQueryExecuteCall extends MethodAccess {
  XQueryExecuteCall() {
    exists(Method m | this.getMethod() = m and
    m.hasName("executeQuery") and
    m.getDeclaringType()
        .getASourceSupertype*()
        .hasQualifiedName("javax.xml.xquery", "XQPreparedExpression")
    )
  }

  /** Return this prepared expression. */
  Expr getPreparedExpression() { result = this.getQualifier() }
}
