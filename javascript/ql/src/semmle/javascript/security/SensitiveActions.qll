/**
 * Provides classes and predicates for identifying sensitive data and methods for security.
 *
 * 'Sensitive' data in general is anything that should not be sent around in unencrypted form. This
 * library tries to guess where sensitive data may either be stored in a variable or produced by a
 * method.
 *
 * In addition, there are methods that ought not to be executed or not in a fashion that the user
 * can control. This includes authorization methods such as logins, and sending of data, etc.
 */

import javascript

/**
 * Provides heuristics for identifying names related to sensitive information.
 *
 * INTERNAL: Do not use directly.
 */
module HeuristicNames {
  /** Gets a regular expression that identifies strings that look like they represent secret data that are not passwords. */
  string suspiciousNonPassword() { result = "(?is).*(secret|account|accnt|(?<!un)trusted).*" }

  /** Gets a regular expression that identifies strings that look like they represent secret data that are passwords. */
  string suspiciousPassword() { result = "(?is).*(password|passwd).*" }

  /** Gets a regular expression that identifies strings that look like they represent secret data. */
  string suspicious() { result = suspiciousPassword() or result = suspiciousNonPassword() }

  /**
   * Gets a regular expression that identifies strings that look like they represent data that is
   * hashed or encrypted.
   */
  string nonSuspicious() {
    result = "(?is).*(redact|censor|obfuscate|hash|md5|sha|((?<!un)(en))?(crypt|code)).*"
  }

  /**
   * Gets a regular expression that identifies names that look like they represent credential information.
   */
  string suspiciousCredentials() {
    result = "(?i).*pass(wd|word|code|phrase)(?!.*question).*" or
    result = "(?i).*(puid|username|userid).*" or
    result = "(?i).*(cert)(?!.*(format|name)).*" or
    result = "(?i).*(auth(entication|ori[sz]ation)?)key.*"
  }
}
private import HeuristicNames

/** An expression that might contain sensitive data. */
abstract class SensitiveExpr extends Expr {
  /** Gets a human-readable description of this expression for use in alert messages. */
  abstract string describe();
}

/** A function call that might produce sensitive data. */
class SensitiveCall extends SensitiveExpr, InvokeExpr {
  SensitiveCall() {
    this.getCalleeName() instanceof SensitiveDataFunctionName
    or
    // This is particularly to pick up methods with an argument like "password", which
    // may indicate a lookup.
    exists(string s | this.getAnArgument().mayHaveStringValue(s) |
      s.regexpMatch(suspicious()) and
      not s.regexpMatch(nonSuspicious())
    )
  }

  override string describe() { result = "a call to " + getCalleeName() }
}

/** An access to a variable or property that might contain sensitive data. */
abstract class SensitiveVariableAccess extends SensitiveExpr {
  string name;

  SensitiveVariableAccess() {
    this.(VarAccess).getName() = name
    or
    exists(DataFlow::PropRead pr |
      this = pr.asExpr() and
      pr.getPropertyName() = name
    )
  }

  override string describe() { result = "an access to " + name }
}

/** A write to a location that might contain sensitive data. */
abstract class SensitiveWrite extends DataFlow::Node { }

/** A write to a variable or property that might contain sensitive data. */
private class BasicSensitiveWrite extends SensitiveWrite {
  BasicSensitiveWrite() {
    exists(string name |
      name.regexpMatch(suspicious()) and
      not name.regexpMatch(nonSuspicious())
    |
      exists(DataFlow::PropWrite pwn |
        pwn.getPropertyName() = name and
        pwn.getRhs() = this
      )
      or
      exists(VarDef v | v.getAVariable().getName() = name |
        if exists(v.getSource())
        then v.getSource() = this.asExpr()
        else
          exists(SsaExplicitDefinition ssa |
            DataFlow::ssaDefinitionNode(ssa) = this and
            ssa.getDef() = v
          )
      )
    )
  }
}

/** An access to a variable or property that might contain sensitive data. */
private class BasicSensitiveVariableAccess extends SensitiveVariableAccess {
  BasicSensitiveVariableAccess() {
    name.regexpMatch(suspicious()) and not name.regexpMatch(nonSuspicious())
  }
}

/** A function name that suggests it may be sensitive. */
abstract class SensitiveFunctionName extends string {
  SensitiveFunctionName() {
    this = any(Function f).getName() or
    this = any(Property p).getName() or
    this = any(PropAccess pacc).getPropertyName()
  }
}

/** A function name that suggests it may produce sensitive data. */
abstract class SensitiveDataFunctionName extends SensitiveFunctionName { }

/** A method that might return sensitive data, based on the name. */
class CredentialsFunctionName extends SensitiveDataFunctionName {
  CredentialsFunctionName() { this.regexpMatch(suspicious()) }
}

/**
 * A sensitive action, such as transfer of sensitive data.
 */
abstract class SensitiveAction extends DataFlow::Node { }

/** A call that may perform authorization. */
class AuthorizationCall extends SensitiveAction, DataFlow::CallNode {
  AuthorizationCall() {
    exists(string s | s = getCalleeName() |
      // name contains `login` or `auth`, but not as part of `loginfo` or `unauth`;
      // also exclude `author`
      s.regexpMatch("(?i).*(login(?!fo)|(?<!un)auth(?!or\\b)|verify).*") and
      // but it does not start with `get` or `set`
      not s.regexpMatch("(?i)(get|set).*")
    )
  }
}

/** A call to a function whose name suggests that it encodes or encrypts its arguments. */
class ProtectCall extends DataFlow::CallNode {
  ProtectCall() {
    exists(string s | getCalleeName().regexpMatch("(?i).*" + s + ".*") |
      s = "protect" or s = "encode" or s = "encrypt"
    )
  }
}

/**
 * Classes for expressions containing cleartext passwords.
 */
private module CleartextPasswords {
  bindingset[name]
  private predicate isCleartextPasswordIndicator(string name) {
    name.regexpMatch(suspiciousPassword()) and
    not name.regexpMatch(nonSuspicious())
  }

  /** An expression that might contain a cleartext password. */
  abstract class CleartextPasswordExpr extends SensitiveExpr { }

  /** A function name that suggests it may produce a cleartext password. */
  private class CleartextPasswordDataFunctionName extends SensitiveDataFunctionName {
    CleartextPasswordDataFunctionName() { isCleartextPasswordIndicator(this) }
  }

  /** A call that might return a cleartext password. */
  private class CleartextPasswordCallExpr extends CleartextPasswordExpr, SensitiveCall {
    CleartextPasswordCallExpr() {
      this.getCalleeName() instanceof CleartextPasswordDataFunctionName
      or
      // This is particularly to pick up methods with an argument like "password", which
      // may indicate a lookup.
      exists(string s |
        this.getAnArgument().mayHaveStringValue(s) and
        isCleartextPasswordIndicator(s)
      )
    }
  }

  /** An access to a variable or property that might contain a cleartext password. */
  private class CleartextPasswordLookupExpr extends CleartextPasswordExpr, SensitiveVariableAccess {
    CleartextPasswordLookupExpr() { isCleartextPasswordIndicator(name) }
  }
}
import CleartextPasswords
