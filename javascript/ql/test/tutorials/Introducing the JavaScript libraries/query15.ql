import javascript

class TrackedStringLiteral extends DataFlow::TrackedNode {
  TrackedStringLiteral() { this.asExpr() instanceof ConstantString }
}

from TrackedStringLiteral source, DataFlow::Node sink, SsaExplicitDefinition def
where
  source.flowsTo(sink) and
  sink = DataFlow::ssaDefinitionNode(def) and
  def.getSourceVariable().getName().toLowerCase() = "password"
select sink
