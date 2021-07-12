import csharp
import semmle.code.csharp.dataflow.DataFlow::DataFlow::PathGraph

class MySink extends DataFlow::ExprNode {
  MySink() {
    exists(Method m, MethodCall mc |
      mc.getTarget() = m and
      m.getName() = "Sink" and
      this.getExpr() = mc.getArgumentForName("s")
    )
  }
}

class MySource extends DataFlow::ParameterNode {
  MySource() {
    exists(Parameter p | p = this.getParameter() |
      p = any(Class c | c.hasQualifiedName("Test")).getAMethod().getAParameter()
    )
  }
}

class MyConfig extends TaintTracking::Configuration {
  MyConfig() { this = "MyConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof MySource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof MySink }
}

from MyConfig c, DataFlow::PathNode source, DataFlow::PathNode sink
where c.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is used.", source.getNode(),
  "User-provided value"
