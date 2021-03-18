/**
 * @name Python Insecure LDAP Authentication
 * @description Python LDAP Insecure LDAP Authentication
 * @kind path-problem
 * @problem.severity error
 * @id python/insecure-ldap-auth
 * @tags experimental
 *       security
 *       external/cwe/cwe-090
 */

import python
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.internal.TaintTrackingPublic
import DataFlow::PathGraph

class FalseArg extends ControlFlowNode {
  FalseArg() { this.getNode().(Expr).(BooleanLiteral) instanceof False }
}

// From luchua-bc's Insecure LDAP authentication in Java (to reduce false positives)
string getFullHostRegex() { result = "(?i)ldap://[\\[a-zA-Z0-9].*" }

string getSchemaRegex() { result = "(?i)ldap(://)?" }

string getPrivateHostRegex() {
  result =
    "(?i)localhost(?:[:/?#].*)?|127\\.0\\.0\\.1(?:[:/?#].*)?|10(?:\\.[0-9]+){3}(?:[:/?#].*)?|172\\.16(?:\\.[0-9]+){2}(?:[:/?#].*)?|192.168(?:\\.[0-9]+){2}(?:[:/?#].*)?|\\[?0:0:0:0:0:0:0:1\\]?(?:[:/?#].*)?|\\[?::1\\]?(?:[:/?#].*)?"
}

// "ldap://somethingon.theinternet.com"
class LDAPFullHost extends StrConst {
  LDAPFullHost() {
    exists(string s |
      s = this.getText() and
      s.regexpMatch(getFullHostRegex()) and
      not s.substring(7, s.length()).regexpMatch(getPrivateHostRegex()) // No need to check for ldaps, would be SSL by default.
    )
  }
}

class LDAPSchema extends StrConst {
  LDAPSchema() { this.getText().regexpMatch(getSchemaRegex()) }
}

class LDAPPrivateHost extends StrConst {
  LDAPPrivateHost() { this.getText().regexpMatch(getPrivateHostRegex()) }
}

predicate concatAndCompareAgainstFullHostRegex(Expr schema, Expr host) {
  schema instanceof LDAPSchema and
  not host instanceof LDAPPrivateHost and
  exists(string full_host |
    full_host = schema.(StrConst).getText() + host.(StrConst).getText() and
    full_host.regexpMatch(getFullHostRegex())
  )
}

// "ldap://" + "somethingon.theinternet.com"
class LDAPBothStrings extends BinaryExpr {
  LDAPBothStrings() { concatAndCompareAgainstFullHostRegex(this.getLeft(), this.getRight()) }
}

// schema + host
class LDAPBothVar extends BinaryExpr {
  LDAPBothVar() {
    exists(SsaVariable schemaVar, SsaVariable hostVar |
      this.getLeft() = schemaVar.getVariable().getALoad() and // getAUse is incompatible with Expr
      this.getRight() = hostVar.getVariable().getALoad() and
      concatAndCompareAgainstFullHostRegex(schemaVar
            .getDefinition()
            .getImmediateDominator()
            .getNode(), hostVar.getDefinition().getImmediateDominator().getNode())
    )
  }
}

// schema + "somethingon.theinternet.com"
class LDAPVarString extends BinaryExpr {
  LDAPVarString() {
    exists(SsaVariable schemaVar |
      this.getLeft() = schemaVar.getVariable().getALoad() and
      concatAndCompareAgainstFullHostRegex(schemaVar
            .getDefinition()
            .getImmediateDominator()
            .getNode(), this.getRight())
    )
  }
}

// "ldap://" + host
class LDAPStringVar extends BinaryExpr {
  LDAPStringVar() {
    exists(SsaVariable hostVar |
      this.getRight() = hostVar.getVariable().getALoad() and
      concatAndCompareAgainstFullHostRegex(this.getLeft(),
        hostVar.getDefinition().getImmediateDominator().getNode())
    )
  }
}

class LDAPInsecureAuthSource extends DataFlow::Node {
  LDAPInsecureAuthSource() {
    this instanceof RemoteFlowSource or
    this.asExpr() instanceof LDAPBothStrings or
    this.asExpr() instanceof LDAPBothVar or
    this.asExpr() instanceof LDAPVarString or
    this.asExpr() instanceof LDAPStringVar
  }
}

class SafeLDAPOptions extends ControlFlowNode {
  SafeLDAPOptions() {
    this = Value::named("ldap.OPT_X_TLS_ALLOW").getAReference() or
    this = Value::named("ldap.OPT_X_TLS_TRY").getAReference() or
    this = Value::named("ldap.OPT_X_TLS_DEMAND").getAReference() or
    this = Value::named("ldap.OPT_X_TLS_HARD").getAReference()
  }
}

// LDAP3
class LDAPInsecureAuthSink extends DataFlow::Node {
  LDAPInsecureAuthSink() {
    exists(SsaVariable connVar, CallNode connCall, SsaVariable srvVar, CallNode srvCall |
      // set connCall as a Call to ldap3.Connection
      connCall = Value::named("ldap3.Connection").getACall() and
      // get variable whose definition is a call to ldap3.Connection to correlate ldap3.Server and Connection.start_tls()
      connVar.getDefinition().getImmediateDominator() = connCall and
      // get connCall's first argument variable definition
      srvVar.getAUse() = connCall.getArg(0) and
      /*
       *    // restrict srvVar definition to a ldap3.Server Call
       *    srvCall = Value::named("ldap3.Server").getACall() and
       *    srvVar.getDefinition().getImmediateDominator() = srvCall
       *    // redundant? ldap3.Connection's first argument *must* be ldap3.Server
       */

      // set srvCall as srvVar definition's call
      srvVar.getDefinition().getImmediateDominator() = srvCall and
      // set ldap3.Server's 1st argument as sink
      this.asExpr() = srvCall.getArg(0).getNode() and
      (
        // check ldap3.Server call's 3rd argument (positional) is null and there's no use_ssl
        count(srvCall.getAnArg()) < 3 and
        count(srvCall.getArgByName("use_ssl")) = 0
        or
        // check ldap3.Server call's 3rd argument is False
        srvCall.getAnArg() instanceof FalseArg
        or
        // check ldap3.Server argByName "use_ssl" is False
        srvCall.getArgByName("use_ssl") instanceof FalseArg
      ) and
      /*
       * Avoid flow through any function (Server()) whose variable declaring it (srv) is the first
       * argument in any function (Connection()) whose variable declaring it also calls .start_tls
       */

      /*
       *  host = schema + "somethingon.theinternet.com"
       *  srv = Server(host, port = 1337)
       *  conn = Connection(srv, "dn", "password")
       *  conn.start_tls() !
       */

      not connVar
          .getAUse()
          .getImmediateDominator()
          .(CallNode)
          .getNode()
          .getFunc()
          .(Attribute)
          .getName()
          .matches("start_tls")
    )
  }
}

class LDAPInsecureAuthConfig extends TaintTracking::Configuration {
  LDAPInsecureAuthConfig() { this = "LDAPInsecureAuthConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof LDAPInsecureAuthSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof LDAPInsecureAuthSink }
}

from LDAPInsecureAuthConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "$@ from $@ is authenticated insecurely.", source.getNode(),
  "The host", sink.getNode(), "this LDAP query"
