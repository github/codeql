import csharp
import utils.test.ProvenancePathGraph::ShowProvenance<Taint::PathNode, Taint::PathGraph>

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
      p = any(Class c | c.hasFullyQualifiedName("", "Test")).getAMethod().getAParameter()
    )
  }
}

module TaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof MySource }

  predicate isSink(DataFlow::Node sink) { sink instanceof MySink }
}

module Taint = TaintTracking::Global<TaintConfig>;

from Taint::PathNode source, Taint::PathNode sink
where Taint::flowPath(source, sink)
select sink.getNode(), source, sink, "$@ flows to here and is used.", source.getNode(),
  "User-provided value"
