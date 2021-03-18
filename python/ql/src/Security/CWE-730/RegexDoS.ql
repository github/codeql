/**
 * @name Regular expression injection
 * @description User input should not be used in regular expressions without first being escaped,
 *              otherwise a malicious user may be able to inject an expression that could require
 *              exponential time on certain inputs.
 * @kind path-problem
 * @problem.severity error
 * @id python/regex-injection
 * @tags security
 *       external/cwe/cwe-730
 *       external/cwe/cwe-400
 */

// determine precision above
import python
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.internal.TaintTrackingPublic
import DataFlow::PathGraph

// Should this be moved to a different structure? (For other queries to be able to use it)
class ReMethods extends string {
  ReMethods() {
    this = "match" or
    this = "fullmatch" or
    this = "search" or
    this = "split" or
    this = "findall" or
    this = "finditer"
  }
}

class DirectRegex extends DataFlow::Node {
  DirectRegex() {
    exists(string reMethod, CallNode reCall |
      reMethod instanceof ReMethods and
      reCall = Value::named("re." + reMethod).getACall() and
      this.asExpr() = reCall.getArg(0).getNode()
    )
  }
}

class CompiledRegex extends DataFlow::Node {
  CompiledRegex() {
    exists(CallNode patternCall, SsaVariable patternVar, CallNode reMethodCall |
      patternCall = Value::named("re.compile").getACall() and
      patternVar.getDefinition().getImmediateDominator() = patternCall and
      patternVar.getAUse().getNode() = reMethodCall.getNode().getFunc().(Attribute).getObject() and
      reMethodCall.getNode().getFunc().(Attribute).getName() instanceof ReMethods and
      this.asExpr() = patternCall.getArg(0).getNode()
    )
  }
}

class RegexInjectionSink extends DataFlow::Node {
  RegexInjectionSink() { this instanceof DirectRegex or this instanceof CompiledRegex }
}

class EscapeSanitizer extends DataFlow::Node {
  EscapeSanitizer() {
    exists(Call c |
      (
        // avoid flow through any %escape% function
        c.getFunc().(Attribute).getName().matches("%escape%") or // something.%escape%()
        c.getFunc().(Name).getId().matches("%escape%") // %escape%()
      ) and
      this.asExpr() = c
    )
  }
}

class RegexInjectionFlowConfig extends TaintTracking::Configuration {
  RegexInjectionFlowConfig() { this = "RegexInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RegexInjectionSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) { sanitizer instanceof EscapeSanitizer }
}

from RegexInjectionFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ regular expression is constructed from a $@.",
  sink.getNode(), "This", source.getNode(), "user-provided value"
