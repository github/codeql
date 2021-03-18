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
  ReMethods() { this in ["match", "fullmatch", "search", "split", "findall", "finditer"] }```
}

class DirectRegex extends DataFlow::Node {
  DirectRegex() {
    exists(ReMethods reMethod, DataFlow::CallCfgNode reCall |
      reCall = API::moduleImport("re").getMember(reMethod).getACall() and
      this = reCall.getArg(0)
    )
  }
}

class CompiledRegex extends DataFlow::Node {
  CompiledRegex() {
    exists(DataFlow::CallCfgNode patternCall, AttrRead reMethod |
      patternCall = API::moduleImport("re").getMember("compile").getACall() and
      patternCall = reMethod.getObject().getALocalSource() and
      reMethod.getAttributeName() instanceof ReMethods and
      this = patternCall.getArg(0)
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
