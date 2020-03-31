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
  /**
   * Gets a regular expression that identifies strings that may indicate the presence of secret
   * or trusted data.
   */
  string maybeSecret() { result = "(?is).*((?<!is)secret|(?<!un|is)trusted).*" }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence of
   * user names or other account information.
   */
  string maybeAccountInfo() {
    result = "(?is).*acc(ou)?nt.*" or
    result = "(?is).*(puid|username|userid).*"
  }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence of
   * a password or an authorization key.
   */
  string maybePassword() {
    result = "(?is).*pass(wd|word|code|phrase)(?!.*question).*" or
    result = "(?is).*(auth(entication|ori[sz]ation)?)key.*"
  }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence of
   * a certificate.
   */
  string maybeCertificate() { result = "(?is).*(cert)(?!.*(format|name)).*" }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence
   * of sensitive data, with `classification` describing the kind of sensitive data involved.
   */
  string maybeSensitive(SensitiveExpr::Classification classification) {
    result = maybeSecret() and classification = SensitiveExpr::secret()
    or
    result = maybeAccountInfo() and classification = SensitiveExpr::id()
    or
    result = maybePassword() and classification = SensitiveExpr::password()
    or
    result = maybeCertificate() and classification = SensitiveExpr::certificate()
  }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence of data
   * that is hashed or encrypted, and hence rendered non-sensitive, or contains special characters
   * suggesting nouns within the string do not represent the meaning of the whole string (e.g. a URL or a SQL query).
   */
  string notSensitive() {
    result = "(?is).*([^\\w$.-]|redact|censor|obfuscate|hash|md5|sha|((?<!un)(en))?(crypt|code)).*"
  }
}

private import HeuristicNames

/** An expression that might contain sensitive data. */
abstract class SensitiveExpr extends Expr {
  /** Gets a human-readable description of this expression for use in alert messages. */
  abstract string describe();

  /** Gets a classification of the kind of sensitive data this expression might contain. */
  abstract SensitiveExpr::Classification getClassification();
}

module SensitiveExpr {
  /**
   * A classification of different kinds of sensitive data:
   *
   *   - secret: generic secret or trusted data;
   *   - id: a user name or other account information;
   *   - password: a password or authorization key;
   *   - certificate: a certificate.
   *
   * While classifications are represented as strings, this should not be relied upon.
   * Instead, use the predicates below to work with classifications.
   */
  class Classification extends string {
    Classification() { this = "secret" or this = "id" or this = "password" or this = "certificate" }
  }

  /** Gets the classification for secret or trusted data. */
  Classification secret() { result = "secret" }

  /** Gets the classification for user names or other account information. */
  Classification id() { result = "id" }

  /** Gets the classification for passwords or authorization keys. */
  Classification password() { result = "password" }

  /** Gets the classification for certificates. */
  Classification certificate() { result = "certificate" }
}

/** A function call that might produce sensitive data. */
class SensitiveCall extends SensitiveExpr, InvokeExpr {
  SensitiveExpr::Classification classification;

  SensitiveCall() {
    classification = this.getCalleeName().(SensitiveDataFunctionName).getClassification()
    or
    // This is particularly to pick up methods with an argument like "password", which
    // may indicate a lookup.
    exists(string s | this.getAnArgument().mayHaveStringValue(s) |
      s.regexpMatch(maybeSensitive(classification)) and
      not s.regexpMatch(notSensitive())
    )
  }

  override string describe() { result = "a call to " + getCalleeName() }

  override SensitiveExpr::Classification getClassification() { result = classification }
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
  SensitiveExpr::Classification classification;

  BasicSensitiveWrite() {
    exists(string name |
      name.regexpMatch(maybeSensitive(classification)) and
      not name.regexpMatch(notSensitive())
    |
      exists(DataFlow::PropWrite pwn |
        pwn.getPropertyName() = name and
        pwn.getRhs() = this
      )
      or
      exists(VarDef v | v.getAVariable().getName() = name |
        if exists(v.getSource())
        then v.getSource() = this.asExpr()
        else this = DataFlow::ssaDefinitionNode(SSA::definition(v))
      )
    )
  }

  /** Gets a classification of the kind of sensitive data the write might handle. */
  SensitiveExpr::Classification getClassification() { result = classification }
}

/** An access to a variable or property that might contain sensitive data. */
private class BasicSensitiveVariableAccess extends SensitiveVariableAccess {
  SensitiveExpr::Classification classification;

  BasicSensitiveVariableAccess() {
    name.regexpMatch(maybeSensitive(classification)) and not name.regexpMatch(notSensitive())
  }

  override SensitiveExpr::Classification getClassification() { result = classification }
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
  abstract SensitiveExpr::Classification getClassification();
}

/** A method that might return sensitive data, based on the name. */
class CredentialsFunctionName extends SensitiveDataFunctionName {
  SensitiveExpr::Classification classification;

  CredentialsFunctionName() { this.regexpMatch(maybeSensitive(classification)) }

  override SensitiveExpr::Classification getClassification() { result = classification }
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

/** An expression that might contain a clear-text password. */
class CleartextPasswordExpr extends SensitiveExpr {
  CleartextPasswordExpr() { this.(SensitiveExpr).getClassification() = SensitiveExpr::password() }

  override string describe() { none() }

  override SensitiveExpr::Classification getClassification() { none() }
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
      normalized.regexpMatch(".*(pass|test|sample|example|secret|root|admin|user|change|auth).*")
    )
  }
}
