import java
import semmle.code.java.dataflow.FlowSources

class XQueryInjectionConfig extends TaintTracking::Configuration {
  XQueryInjectionConfig() { this = "XQueryInjectionConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof XQueryInjectionSink }
}

/*Find if the executeQuery method is finally called.*/
predicate executeQuery(MethodAccess ma) {
  exists(LocalVariableDeclExpr lvd, MethodAccess ma1, Method m | lvd.getAChildExpr() = ma |
    m = ma1.getMethod() and
    m.hasName("executeQuery") and
    m.getDeclaringType()
        .getASourceSupertype*()
        .hasQualifiedName("javax.xml.xquery", "XQPreparedExpression") and
    ma1.getQualifier() = lvd.getAnAccess()
  )
}

class XQueryInjectionSink extends DataFlow::ExprNode {
  XQueryInjectionSink() {
    exists(MethodAccess ma, Method m | m = ma.getMethod() |
      m.hasName("prepareExpression") and
      m.getDeclaringType()
          .getASourceSupertype*()
          .hasQualifiedName("javax.xml.xquery", "XQConnection") and
      executeQuery(ma) and
      asExpr() = ma.getArgument(0)
    )
  }
}
