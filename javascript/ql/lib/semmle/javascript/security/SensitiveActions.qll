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
import semmle.javascript.security.internal.SensitiveDataHeuristics
private import HeuristicNames

/** An expression that might contain sensitive data. */
cached
abstract class SensitiveExpr extends Expr {
  /** Gets a human-readable description of this expression for use in alert messages. */
  cached
  abstract string describe();

  /** Gets a classification of the kind of sensitive data this expression might contain. */
  cached
  abstract SensitiveDataClassification getClassification();
}

/** DEPRECATED: Use `SensitiveDataClassification` and helpers instead. */
deprecated module SensitiveExpr {
  /** DEPRECATED: Use `SensitiveDataClassification` instead. */
  deprecated class Classification = SensitiveDataClassification;

  /** DEPRECATED: Use `SensitiveDataClassification::secret` instead. */
  deprecated predicate secret = SensitiveDataClassification::secret/0;

  /** DEPRECATED: Use `SensitiveDataClassification::id` instead. */
  deprecated predicate id = SensitiveDataClassification::id/0;

  /** DEPRECATED: Use `SensitiveDataClassification::password` instead. */
  deprecated predicate password = SensitiveDataClassification::password/0;

  /** DEPRECATED: Use `SensitiveDataClassification::certificate` instead. */
  deprecated predicate certificate = SensitiveDataClassification::certificate/0;
}

/** A function call that might produce sensitive data. */
class SensitiveCall extends SensitiveExpr, InvokeExpr {
  SensitiveDataClassification classification;

  SensitiveCall() {
    classification = this.getCalleeName().(SensitiveDataFunctionName).getClassification()
    or
    // This is particularly to pick up methods with an argument like "password", which
    // may indicate a lookup.
    exists(string s | this.getAnArgument().mayHaveStringValue(s) |
      nameIndicatesSensitiveData(s, classification)
    )
  }

  override string describe() { result = "a call to " + this.getCalleeName() }

  override SensitiveDataClassification getClassification() { result = classification }
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

/**
 * Holds if `node` is a write to a variable or property named `name`.
 *
 * Helper predicate factored out for performance,
 * to filter `name` as much as possible before using it in
 * regex matching.
 */
pragma[nomagic]
private predicate writesProperty(DataFlow::Node node, string name) {
  exists(DataFlow::PropWrite pwn |
    pwn.getPropertyName() = name and
    pwn.getRhs() = node
  )
  or
  exists(VarDef v | v.getAVariable().getName() = name |
    if exists(v.getSource())
    then v.getSource() = node.asExpr()
    else node = DataFlow::ssaDefinitionNode(SSA::definition(v))
  )
}

/** A write to a variable or property that might contain sensitive data. */
private class BasicSensitiveWrite extends SensitiveWrite {
  SensitiveDataClassification classification;

  BasicSensitiveWrite() {
    exists(string name |
      /*
       * PERFORMANCE OPTIMISATION:
       * `nameIndicatesSensitiveData` performs a `regexpMatch` on `name`.
       * To carry out a regex match, we must first compute the Cartesian product
       * of all possible `name`s and regexes, then match.
       * To keep this product as small as possible,
       * we want to filter `name` as much as possible before the product.
       *
       * Do this by factoring out a helper predicate containing the filtering
       * logic that restricts `name`. This helper predicate will get picked first
       * in the join order, since it is the only call here that binds `name`.
       */

      writesProperty(this, name) and
      nameIndicatesSensitiveData(name, classification)
    )
  }

  /** Gets a classification of the kind of sensitive data the write might handle. */
  SensitiveDataClassification getClassification() { result = classification }
}

/** An access to a variable or property that might contain sensitive data. */
private class BasicSensitiveVariableAccess extends SensitiveVariableAccess {
  SensitiveDataClassification classification;

  BasicSensitiveVariableAccess() { nameIndicatesSensitiveData(name, classification) }

  override SensitiveDataClassification getClassification() { result = classification }
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
abstract class SensitiveDataFunctionName extends SensitiveFunctionName {
  /** Gets a classification of the kind of sensitive data this function may produce. */
  abstract SensitiveDataClassification getClassification();
}

/** A method that might return sensitive data, based on the name. */
class CredentialsFunctionName extends SensitiveDataFunctionName {
  SensitiveDataClassification classification;

  CredentialsFunctionName() { nameIndicatesSensitiveData(this, classification) }

  override SensitiveDataClassification getClassification() { result = classification }
}

/**
 * A sensitive action, such as transfer of sensitive data.
 */
abstract class SensitiveAction extends DataFlow::Node { }

/** A call that may perform authorization. */
class AuthorizationCall extends SensitiveAction, DataFlow::CallNode {
  AuthorizationCall() {
    exists(string s | s = this.getCalleeName() |
      // name contains `login` or `auth`, but not as part of `loginfo` or `unauth`;
      // also exclude `author` and words followed by `err` (as in `error`)
      s.regexpMatch("(?i).*(login(?!fo)|(?<!un)auth(?!or\\b)|verify)(?!err).*") and
      // but it does not start with `get` or `set`
      not s.regexpMatch("(?i)(get|set).*")
    )
  }
}

/** A call to a function whose name suggests that it encodes or encrypts its arguments. */
class ProtectCall extends DataFlow::CallNode {
  ProtectCall() {
    exists(string s | this.getCalleeName().regexpMatch("(?i).*" + s + ".*") |
      s = "protect" or s = "encode" or s = "encrypt"
    )
  }
}

/** An expression that might contain a clear-text password. */
class CleartextPasswordExpr extends SensitiveExpr {
  CleartextPasswordExpr() {
    this.(SensitiveExpr).getClassification() = SensitiveDataClassification::password()
  }

  override string describe() { none() }

  override SensitiveDataClassification getClassification() { none() }
}

/**
 * Provides heuristics for classifying passwords.
 */
module PasswordHeuristics {
  /**
   * Holds if `password` looks like a deliberately weak password that the user should change.
   */
  bindingset[password]
  predicate isDummyPassword(string password) {
    password.length() < 4
    or
    exists(string normalized | normalized = password.toLowerCase() |
      count(normalized.charAt(_)) = 1 or
      normalized
          .regexpMatch(".*(pass|test|sample|example|secret|root|admin|user|change|auth|fake|(my(token|password))|string|foo|bar|baz|qux|1234|3141|abcd).*")
    )
  }

  /**
   * Holds if `header` looks like a deliberately weak authentication header.
   */
  bindingset[header]
  predicate isDummyAuthHeader(string header) {
    isDummyPassword(header)
    or
    exists(string prefix, string suffix | prefix = getAnHttpAuthenticationScheme() |
      header.toLowerCase() = prefix + " " + suffix and
      isDummyPassword(suffix)
    )
    or
    header.trim().toLowerCase() = getAnHttpAuthenticationScheme()
  }

  /**
   * Gets a HTTP authentication scheme normalized to lowercase.
   * From this list: https://www.iana.org/assignments/http-authschemes/http-authschemes.xhtml
   */
  private string getAnHttpAuthenticationScheme() {
    result =
      [
        "Basic", "Bearer", "Digest", "HOBA", "Mutual", "Negotiate", "OAuth", "SCRAM-SHA-1",
        "SCRAM-SHA-256", "vapid"
      ].toLowerCase()
  }
}
