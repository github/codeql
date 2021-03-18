/**
 * @name Python LDAP Improper Authentication
 * @description Check if a user-controlled query carry no authentication
 * @kind path-problem
 * @problem.severity warning
 * @id python/ldap-improper-auth
 * @tags experimental
 *       security
 *       external/cwe/cwe-287
 */

// Determine precision above
import python
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.internal.TaintTrackingPublic
import DataFlow::PathGraph

// LDAP2
class BindSink extends DataFlow::Node {
  BindSink() {
    exists(SsaVariable bindVar, CallNode bindCall, CallNode searchCall |
      // get variable initializing the connection
      bindVar.getDefinition().getImmediateDominator() = Value::named("ldap.initialize").getACall() and
      // get a call using that variable
      bindVar.getAUse().getImmediateDominator() = bindCall and
      // restrict call to any bind method
      bindCall.getNode().getFunc().(Attribute).getName().matches("%bind%") and
      (
        // check second argument (password)
        bindCall.getArg(1).getNode() instanceof None or
        count(bindCall.getAnArg()) = 1
      ) and
      // get another call using that variable
      bindVar.getAUse().getNode() = searchCall.getNode().getFunc().(Attribute).getObject() and
      // restrict call to any search method
      searchCall.getNode().getFunc().(Attribute).getName().matches("%search%") and
      // set the third argument as sink
      this.asExpr() = searchCall.getArg(2).getNode()
    )
  }
}

// LDAP3
class ConnectionSink extends DataFlow::Node {
  ConnectionSink() {
    exists(SsaVariable connectionVar, CallNode connectionCall, CallNode searchCall |
      // get call initializing the connection
      connectionCall = Value::named("ldap3.Connection").getACall() and
      (
        // check password argument
        not exists(connectionCall.getArgByName("password")) or
        connectionCall.getArgByName("password").pointsTo(Value::named("None"))
      ) and
      // get the variable initializing the connection
      connectionVar.getDefinition().getImmediateDominator() = connectionCall and
      // get a call using that variable
      connectionVar.getAUse().getNode() = searchCall.getNode().getFunc().(Attribute).getObject() and
      // restrict call to any search method
      searchCall.getNode().getFunc().(Attribute).getName().matches("%search%") and
      // set the second argument as sink
      this.asExpr() = searchCall.getArg(1).getNode()
    )
  }
}

class LDAPImproperAuthSink extends DataFlow::Node {
  LDAPImproperAuthSink() {
    this instanceof BindSink or
    this instanceof ConnectionSink
  }
}

class LDAPImproperAuthConfig extends TaintTracking::Configuration {
  LDAPImproperAuthConfig() { this = "LDAPImproperAuthConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof LDAPImproperAuthSink }
}

from LDAPImproperAuthConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ LDAP query executes $@.", sink.getNode(), "This",
  source.getNode(), "a user-provided value without authentication."
