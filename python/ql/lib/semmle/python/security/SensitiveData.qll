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
import semmle.python.security.internal.SensitiveDataHeuristics
private import HeuristicNames

abstract deprecated class SensitiveData extends TaintKind {
  bindingset[this]
  SensitiveData() { this = this }

  /** Gets the classification of this sensitive data taint kind. */
  abstract SensitiveDataClassification getClassification();
}

deprecated module SensitiveData {
  class Secret extends SensitiveData {
    Secret() { this = "sensitive.data.secret" }

    override string repr() { result = "a secret" }

    override SensitiveDataClassification getClassification() {
      result = SensitiveDataClassification::secret()
    }
  }

  class Id extends SensitiveData {
    Id() { this = "sensitive.data.id" }

    override string repr() { result = "an ID" }

    override SensitiveDataClassification getClassification() {
      result = SensitiveDataClassification::id()
    }
  }

  class Password extends SensitiveData {
    Password() { this = "sensitive.data.password" }

    override string repr() { result = "a password" }

    override SensitiveDataClassification getClassification() {
      result = SensitiveDataClassification::password()
    }
  }

  class Certificate extends SensitiveData {
    Certificate() { this = "sensitive.data.certificate" }

    override string repr() { result = "a certificate or key" }

    override SensitiveDataClassification getClassification() {
      result = SensitiveDataClassification::certificate()
    }
  }

  private SensitiveData fromFunction(Value func) {
    nameIndicatesSensitiveData(func.getName(), result.getClassification())
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
      nameIndicatesSensitiveData(this.(AttrNode).getName(), data.getClassification())
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
        nameIndicatesSensitiveData(sensitive.getText(), data.getClassification())
      )
    }

    override predicate isSourceOf(TaintKind kind) { kind = data }

    override string repr() { result = "a request parameter containing " + data.repr() }
  }
}

//Backwards compatibility
deprecated class SensitiveDataSource = SensitiveData::Source;
