import python
import experimental.semmle.python.Concepts
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources

class LDAPImproperAuthSink extends DataFlow::Node {
  LDAPImproperAuthSink() {
    exists(LDAPBind ldapBind |
      (
        (
          DataFlow::localFlow(DataFlow::exprNode(any(None noneName)), ldapBind.getPasswordNode()) or
          not exists(ldapBind.getPasswordNode())
        )
        or
        exists(StrConst emptyString |
          emptyString.getText() = "" and
          DataFlow::localFlow(DataFlow::exprNode(emptyString), ldapBind.getPasswordNode())
        )
      ) and
      this = ldapBind.getQueryNode()
    )
  }
}

class LDAPImproperAuthenticationConfig extends TaintTracking::Configuration {
  LDAPImproperAuthenticationConfig() { this = "LDAPImproperAuthenticationConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof LDAPImproperAuthSink }
}
