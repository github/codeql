/**
 * Provides default sources, sinks and sanitisers for reasoning about
 * clear-text logging of sensitive information, as well as extension
 * points for adding your own.
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.security.SensitiveActions::HeuristicNames

module CleartextLogging {
  /**
   * A data flow source for clear-text logging of sensitive information.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the type of this data flow source. */
    abstract string describe();
  }

  /**
   * A data flow sink for clear-text logging of sensitive information.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A barrier for clear-text logging of sensitive information.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * An argument to a logging mechanism.
   */
  class LoggerSink extends Sink {
    LoggerSink() { this = any(LoggerCall log).getAMessageComponent() }
  }

  /**
   * A data flow node that does not contain a clear-text password, according to its syntactic name.
   */
  private class NameGuidedNonCleartextPassword extends NonCleartextPassword {
    NameGuidedNonCleartextPassword() {
      exists(string name | name.regexpMatch(notSensitive()) |
        this.asExpr().(VarAccess).getName() = name
        or
        this.(DataFlow::PropRead).getPropertyName() = name
        or
        this.(DataFlow::InvokeNode).getCalleeName() = name
      )
      or
      // avoid i18n strings
      this
          .(DataFlow::PropRead)
          .getBase()
          .asExpr()
          .(VarRef)
          .getName()
          .regexpMatch("(?is).*(messages|strings).*")
    }
  }

  /**
   * A data flow node that is definitely not an object.
   */
  private class NonObject extends NonCleartextPassword {
    NonObject() {
      forall(AbstractValue v | v = analyze().getAValue() | not v.getType() = TTObject())
    }
  }

  /**
   * A data flow node that receives flow that is not a clear-text password.
   */
  private class NonCleartextPasswordFlow extends NonCleartextPassword {
    NonCleartextPasswordFlow() {
      any(NonCleartextPassword other).(DataFlow::SourceNode).flowsTo(this)
    }
  }

  /**
   * A call that might obfuscate a password, for example through hashing.
   */
  private class ObfuscatorCall extends Barrier, DataFlow::InvokeNode {
    ObfuscatorCall() { getCalleeName().regexpMatch(notSensitive()) }
  }

  /**
   * A data flow node that does not contain a clear-text password.
   */
  abstract private class NonCleartextPassword extends DataFlow::Node { }

  /**
   * An object with a property that may contain password information
   *
   * This is a source since `console.log(obj)` will show the properties of `obj`.
   */
  private class ObjectPasswordPropertySource extends DataFlow::ValueNode, Source {
    string name;

    ObjectPasswordPropertySource() {
      exists(DataFlow::PropWrite write |
        name.regexpMatch(maybePassword()) and
        not name.regexpMatch(notSensitive()) and
        write = this.(DataFlow::SourceNode).getAPropertyWrite(name) and
        // avoid safe values assigned to presumably unsafe names
        not write.getRhs() instanceof NonCleartextPassword
      )
    }

    override string describe() { result = "an access to " + name }
  }

  /** An access to a variable or property that might contain a password. */
  private class ReadPasswordSource extends DataFlow::ValueNode, Source {
    string name;

    ReadPasswordSource() {
      // avoid safe values assigned to presumably unsafe names
      not this instanceof NonCleartextPassword and
      name.regexpMatch(maybePassword()) and
      (
        this.asExpr().(VarAccess).getName() = name
        or
        exists(DataFlow::SourceNode base |
          this = base.getAPropertyRead(name) and
          // avoid safe values assigned to presumably unsafe names
          exists(DataFlow::SourceNode baseObj | baseObj.flowsTo(base) |
            not base.getAPropertyWrite(name).getRhs() instanceof NonCleartextPassword
          )
        )
      )
    }

    override string describe() { result = "an access to " + name }
  }

  /** A call that might return a password. */
  private class CallPasswordSource extends DataFlow::ValueNode, DataFlow::InvokeNode, Source {
    string name;

    CallPasswordSource() {
      name = getCalleeName() and
      name.regexpMatch("(?is)getPassword")
    }

    override string describe() { result = "a call to " + name }
  }
}
