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

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.web.HttpRequest

/**
 * Provides heuristics for identifying names related to sensitive information.
 *
 * INTERNAL: Do not use directly.
 * This is copied from the javascript library, but should be language independent.
 */
private module HeuristicNames {
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
  string maybeSensitive(SensitiveData data) {
    result = maybeSecret() and data instanceof SensitiveData::Secret
    or
    result = maybeAccountInfo() and data instanceof SensitiveData::Id
    or
    result = maybePassword() and data instanceof SensitiveData::Password
    or
    result = maybeCertificate() and data instanceof SensitiveData::Certificate
  }

  /**
   * Gets a regular expression that identifies strings that may indicate the presence of data
   * that is hashed or encrypted, and hence rendered non-sensitive.
   */
  string notSensitive() {
    result = "(?is).*(redact|censor|obfuscate|hash|md5|sha|((?<!un)(en))?(crypt|code)).*"
  }

  bindingset[name]
  SensitiveData getSensitiveDataForName(string name) {
    name.regexpMatch(HeuristicNames::maybeSensitive(result)) and
    not name.regexpMatch(HeuristicNames::notSensitive())
  }
}

abstract class SensitiveData extends TaintKind {
  bindingset[this]
  SensitiveData() { this = this }
}

module SensitiveData {
  class Secret extends SensitiveData {
    Secret() { this = "sensitive.data.secret" }

    override string repr() { result = "a secret" }
  }

  class Id extends SensitiveData {
    Id() { this = "sensitive.data.id" }

    override string repr() { result = "an ID" }
  }

  class Password extends SensitiveData {
    Password() { this = "sensitive.data.password" }

    override string repr() { result = "a password" }
  }

  class Certificate extends SensitiveData {
    Certificate() { this = "sensitive.data.certificate" }

    override string repr() { result = "a certificate or key" }
  }

  private SensitiveData fromFunction(Value func) {
    result = HeuristicNames::getSensitiveDataForName(func.getName())
  }

  abstract class Source extends TaintSource {
    abstract string repr();
  }

  private class SensitiveCallSource extends Source {
    SensitiveData data;

    SensitiveCallSource() {
      exists(Value callee | callee.getACall() = this | data = fromFunction(callee))
    }

    override predicate isSourceOf(TaintKind kind) { kind = data }

    override string repr() { result = "a call returning " + data.repr() }
  }

  /** An access to a variable or property that might contain sensitive data. */
  private class SensitiveVariableAccess extends SensitiveData::Source {
    SensitiveData data;

    SensitiveVariableAccess() {
      data = HeuristicNames::getSensitiveDataForName(this.(AttrNode).getName())
    }

    override predicate isSourceOf(TaintKind kind) { kind = data }

    override string repr() { result = "an attribute or property containing " + data.repr() }
  }

  private class SensitiveRequestParameter extends SensitiveData::Source {
    SensitiveData data;

    SensitiveRequestParameter() {
      this.(CallNode).getFunction().(AttrNode).getName() = "get" and
      exists(StringValue sensitive |
        this.(CallNode).getAnArg().pointsTo(sensitive) and
        data = HeuristicNames::getSensitiveDataForName(sensitive.getText())
      )
    }

    override predicate isSourceOf(TaintKind kind) { kind = data }

    override string repr() { result = "a request parameter containing " + data.repr() }
  }
}

//Backwards compatibility
class SensitiveDataSource = SensitiveData::Source;
