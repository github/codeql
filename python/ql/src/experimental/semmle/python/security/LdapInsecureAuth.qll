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
class LdapFullHost extends StringLiteral {
  LdapFullHost() {
    exists(string s |
      s = this.getText() and
      s.regexpMatch(getFullHostRegex()) and
      // check what comes after the `ldap://` prefix
      not s.substring(7, s.length()).regexpMatch(getPrivateHostRegex())
    )
  }
}

class LdapSchema extends StringLiteral {
  LdapSchema() { this.getText().regexpMatch(getSchemaRegex()) }
}

class LdapPrivateHost extends StringLiteral {
  LdapPrivateHost() { this.getText().regexpMatch(getPrivateHostRegex()) }
}

predicate concatAndCompareAgainstFullHostRegex(LdapSchema schema, StringLiteral host) {
  not host instanceof LdapPrivateHost and
  (schema.getText() + host.getText()).regexpMatch(getFullHostRegex())
}

// "ldap://" + "somethingon.theinternet.com"
class LdapBothStrings extends BinaryExpr {
  LdapBothStrings() { concatAndCompareAgainstFullHostRegex(this.getLeft(), this.getRight()) }
}

// schema + host
class LdapBothVar extends BinaryExpr {
  LdapBothVar() {
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
class LdapVarString extends BinaryExpr {
  LdapVarString() {
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
class LdapStringVar extends BinaryExpr {
  LdapStringVar() {
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
private module LdapInsecureAuthConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource or
    source.asExpr() instanceof LdapFullHost or
    source.asExpr() instanceof LdapBothStrings or
    source.asExpr() instanceof LdapBothVar or
    source.asExpr() instanceof LdapVarString or
    source.asExpr() instanceof LdapStringVar
  }

  predicate isSink(DataFlow::Node sink) {
    exists(LdapBind ldapBind | not ldapBind.useSsl() and sink = ldapBind.getHost())
  }
}

/** Global taint-tracking for detecting "LDAP insecure authentications" vulnerabilities. */
module LdapInsecureAuthFlow = TaintTracking::Global<LdapInsecureAuthConfig>;
