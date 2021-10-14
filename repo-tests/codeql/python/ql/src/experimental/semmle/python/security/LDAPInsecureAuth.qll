/**
 * Provides a taint-tracking configuration for detecting LDAP injection vulnerabilities
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import experimental.semmle.python.Concepts

string getFullHostRegex() { result = "(?i)ldap://.+" }

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
      // check what comes after the `ldap://` prefix
      not s.substring(7, s.length()).regexpMatch(getPrivateHostRegex())
    )
  }
}

class LDAPSchema extends StrConst {
  LDAPSchema() { this.getText().regexpMatch(getSchemaRegex()) }
}

class LDAPPrivateHost extends StrConst {
  LDAPPrivateHost() { this.getText().regexpMatch(getPrivateHostRegex()) }
}

predicate concatAndCompareAgainstFullHostRegex(LDAPSchema schema, StrConst host) {
  not host instanceof LDAPPrivateHost and
  (schema.getText() + host.getText()).regexpMatch(getFullHostRegex())
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

/**
 * A taint-tracking configuration for detecting LDAP insecure authentications.
 */
class LDAPInsecureAuthConfig extends TaintTracking::Configuration {
  LDAPInsecureAuthConfig() { this = "LDAPInsecureAuthConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource or
    source.asExpr() instanceof LDAPFullHost or
    source.asExpr() instanceof LDAPBothStrings or
    source.asExpr() instanceof LDAPBothVar or
    source.asExpr() instanceof LDAPVarString or
    source.asExpr() instanceof LDAPStringVar
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(LDAPBind ldapBind | not ldapBind.useSSL() and sink = ldapBind.getHost())
  }
}
