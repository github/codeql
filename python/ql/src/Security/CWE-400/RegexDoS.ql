/**
 * @name Python Regex DoS
 * @description Python Regular Expression Denial of Service
 * @kind path-problem
 * @problem.severity error
 * @id python/regex-dos
 * @tags experimental	
 *       security	
 *       external/cwe/cwe-400
 */

import python
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.internal.TaintTrackingPublic
import DataFlow::PathGraph

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

class RegexDoSSink extends DataFlow::Node {
  RegexDoSSink() { this instanceof DirectRegex or this instanceof CompiledRegex }
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

class RegexDoSFlowConfig extends TaintTracking::Configuration {
  RegexDoSFlowConfig() { this = "RegexDoSFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof RegexDoSSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) { sanitizer instanceof EscapeSanitizer }
}

from RegexDoSFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ regex operation includes $@.", sink.getNode(), "This",
  source.getNode(), "a user-provided value"
