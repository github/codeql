import javascript
private import semmle.javascript.security.dataflow.Xss

query Angular2::PipeRefExpr pipeRef() { any() }

query CallExpr pipeCall() { result.getCallee() instanceof Angular2::PipeRefExpr }

query CallExpr pipeCallArg(int i, Expr arg) {
  result.getCallee() instanceof Angular2::PipeRefExpr and
  result.getArgument(i) = arg
}

query Angular2::PipeClass pipeClass() { any() }

query DataFlow::Node pipeClassRef(Angular2::PipeClass cls) { result = cls.getAPipeRef() }

class TaintConfig extends TaintTracking::Configuration {
  TaintConfig() { this = "TaintConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getCalleeName() = "source"
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof DomBasedXss::Sink }
}

query predicate taintFlow(DataFlow::Node source, DataFlow::Node sink) {
  any(TaintConfig c).hasFlow(source, sink)
}

query predicate testAttrSourceLocation(HTML::Attribute attrib, Angular2::TemplateTopLevel top) {
  attrib.getName() = "[testAttr]" and
  top = attrib.getCodeInAttribute()
}
