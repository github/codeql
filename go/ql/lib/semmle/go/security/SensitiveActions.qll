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

import go

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
  string maybeAccountInfo() { result = "(?is).*(puid|username|userid).*" }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence of
   * a password or an authorization key.
   */
  string maybePassword() {
    result = "(?is).*pass(wd|word|code|phrase)(?!.*question).*" or
    result = "(?is).*(auth(entication|ori[sz]ation)?)key.*"
  }

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
  }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence of data
   * that is hashed, encrypted, or a test value, and hence non-sensitive.
   */
  string notSensitive() {
    result =
      "(?is).*(test|redact|censor|obfuscate|hash|md5|(?<!un)mask|sha|((?<!un)(en))?(crypt|code)).*"
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

/** Provides classes and predicates for classifying different kinds of sensitive data. */
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
    Classification() { this = ["secret", "id", "password", "certificate"] }
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
class SensitiveCall extends SensitiveExpr, CallExpr {
  SensitiveExpr::Classification classification;

  SensitiveCall() {
    classification = this.getCalleeName().(SensitiveDataFunctionName).getClassification()
    or
    // This is particularly to pick up methods with an argument like "password", which
    // may indicate a lookup.
    exists(string s | this.getAnArgument().getStringValue() = s |
      s.regexpMatch(maybeSensitive(classification)) and
      not s.regexpMatch(notSensitive())
    )
  }

  override string describe() { result = "a call to " + this.getCalleeName() }

  override SensitiveExpr::Classification getClassification() { result = classification }
}

/** An access to a variable or property that might contain sensitive data. */
abstract class SensitiveVariableAccess extends SensitiveExpr {
  string name;

  SensitiveVariableAccess() {
    exists(Entity e |
      this.(Ident).uses(e) or
      this.(SelectorExpr).uses(e)
    |
      e.getName() = name
    )
  }

  override string describe() { result = "an access to " + name }
}

/** A write to a location that might contain sensitive data. */
abstract class SensitiveWrite extends ControlFlow::Node { }

/** A write to a variable or property that might contain sensitive data. */
private class BasicSensitiveWrite extends SensitiveWrite, Write {
  SensitiveExpr::Classification classification;

  BasicSensitiveWrite() {
    exists(ValueEntity v | this.writes(v, _) |
      v.getName().regexpMatch(maybeSensitive(classification)) and
      not v.getName().regexpMatch(notSensitive())
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
  SensitiveFunctionName() { this = any(Function f).getName() }
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
    exists(string s | s = this.getCalleeName() |
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
    exists(string s | this.getCalleeName().regexpMatch("(?i).*" + s + ".*") |
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
    count(password.charAt(_)) <= 2 // aaaaaaaa or bBbBbB or ghghghghghgh or the like
    or
    password
        .regexpMatch("(?i).*(pass|test|sample|example|secret|root|admin|user|change|auth|redacted|0123456789).*")
  }
}
