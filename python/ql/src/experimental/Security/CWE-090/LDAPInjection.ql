/**
 * @name Python LDAP Injection
 * @description Python LDAP Injection through search filter
 * @kind path-problem
 * @problem.severity error
 * @id python/ldap-injection
 * @tags experimental	
 *       security	
 *       external/cwe/cwe-090
 */

// Determine precision above
import python
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.internal.TaintTrackingPublic
import DataFlow::PathGraph

class InitializeSink extends DataFlow::Node {
  InitializeSink() {
    exists(SsaVariable initVar, CallNode searchCall |
      // get variable whose value equals a call to ldap.initialize
      initVar.getDefinition().getImmediateDominator() = Value::named("ldap.initialize").getACall() and
      // get the Call in which the previous variable is used
      initVar.getAUse().getNode() = searchCall.getNode().getFunc().(Attribute).getObject() and
      // restrict that call's attribute (something.this) to match %search%
      searchCall.getNode().getFunc().(Attribute).getName().matches("%search%") and
      // set the third argument (search_filter) as sink
      this.asExpr() = searchCall.getArg(2).getNode()
      // set the first argument (DN) as sink
      // or this.asExpr() = searchCall.getArg(0) // Should this be set?
    )
  }
}

class ConnectionSink extends DataFlow::Node {
  ConnectionSink() {
    exists(SsaVariable connVar, CallNode searchCall |
      // get variable whose value equals a call to ldap.initialize
      connVar.getDefinition().getImmediateDominator() = Value::named("ldap3.Connection").getACall() and
      // get the Call in which the previous variable is used
      connVar.getAUse().getNode() = searchCall.getNode().getFunc().(Attribute).getObject() and
      // restrict that call's attribute (something.this) to match %search%
      searchCall.getNode().getFunc().(Attribute).getName().matches("%search%") and
      // set the second argument (search_filter) as sink
      this.asExpr() = searchCall.getArg(1).getNode()
      // set the first argument (DN) as sink
      // or this.asExpr() = searchCall.getArg(0) // Should this be set?
    )
  }
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

class LDAPInjectionSink extends DataFlow::Node {
  LDAPInjectionSink() {
    this instanceof InitializeSink or
    this instanceof ConnectionSink
  }
}

class LDAPInjectionFlowConfig extends TaintTracking::Configuration {
  LDAPInjectionFlowConfig() { this = "LDAPInjectionFlowConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof LDAPInjectionSink }

  override predicate isSanitizer(DataFlow::Node sanitizer) { sanitizer instanceof EscapeSanitizer }
}

from LDAPInjectionFlowConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ LDAP query executes $@.", sink.getNode(), "This",
  source.getNode(), "a user-provided value"
