import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTracking2
import DataFlow::PathGraph

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
  // return the first parameter of the `bindString` method and use it as a sink
  Expr getSink() { result = this.getArgument(0) }
}

/** A call to `XQDynamicContext.bindString`. */
class XQueryBindStringCall extends MethodAccess {
  XQueryBindStringCall() {
    exists(Method m |
      this.getMethod() = m and
      m.getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName("javax.xml.xquery", "XQDynamicContext") and
      m.hasName("bindString")
    )
  }
  // return the second parameter of the `bindString` method and use it as a sink
  Expr getSink() { result = this.getArgument(1) }
}

/** Used to determine whether to call the `prepareExpression` method, and the first parameter value can be remotely controlled. */
class ParserParameterRemoteFlowConf extends TaintTracking2::Configuration {
  ParserParameterRemoteFlowConf() { this = "ParserParameterRemoteFlowConf" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(XQueryParserCall xqpc | xqpc.getSink() = sink.asExpr())
  }
}

/** Used to determine whether to call the `bindString` method, and the second parameter value can be controlled remotely. */
class BindParameterRemoteFlowConf extends TaintTracking2::Configuration {
  BindParameterRemoteFlowConf() { this = "BindParameterRemoteFlowConf" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(XQueryBindStringCall xqbsc | xqbsc.getSink() = sink.asExpr())
  }
}

/**
 * A data flow source for XQuery injection vulnerability.
 *  1. `prepareExpression` call as sink.
 *  2. Determine whether the `var1` parameter of `prepareExpression` method can be controlled remotely.
 */
class XQueryInjectionSource extends DataFlow::ExprNode {
  XQueryInjectionSource() {
    exists(MethodAccess ma, Method m, ParserParameterRemoteFlowConf conf, DataFlow::Node node |
      m = ma.getMethod()
    |
      m.hasName("prepareExpression") and
      m.getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName("javax.xml.xquery", "XQConnection") and
      asExpr() = ma and
      node.asExpr() = ma.getArgument(0) and
      conf.hasFlowTo(node)
    )
  }
}

/** A data flow sink for XQuery injection vulnerability. */
class XQueryInjectionSink extends DataFlow::Node {
  XQueryInjectionSink() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m.hasName("executeQuery") and
      m.getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName("javax.xml.xquery", "XQPreparedExpression") and
      asExpr() = ma.getQualifier()
    )
  }
}
