/**
 * Provides default sources, sinks and sanitizers for reasoning about
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

    abstract DataFlow::FlowLabel getLabel();
  }

  /**
   * A data flow sink for clear-text logging of sensitive information.
   */
  abstract class Sink extends DataFlow::Node {
    DataFlow::FlowLabel getLabel() { result.isTaint() }
  }

  /**
   * A barrier for clear-text logging of sensitive information.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A call to `.replace()` that seems to mask sensitive information.
   */
  class MaskingReplacer extends Barrier, DataFlow::MethodCallNode {
    MaskingReplacer() {
      this.getCalleeName() = "replace" and
      exists(RegExpLiteral reg |
        reg = this.getArgument(0).getALocalSource().asExpr() and
        reg.isGlobal() and
        any(RegExpDot term).getLiteral() = reg
      ) and
      exists(this.getArgument(1).getStringValue())
    }
  }

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

    override DataFlow::FlowLabel getLabel() { result.isTaint() }
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

    override DataFlow::FlowLabel getLabel() { result.isTaint() }
  }

  /** A call that might return a password. */
  private class CallPasswordSource extends DataFlow::ValueNode, DataFlow::InvokeNode, Source {
    string name;

    CallPasswordSource() {
      name = getCalleeName() and
      name.regexpMatch("(?is)getPassword")
    }

    override string describe() { result = "a call to " + name }

    override DataFlow::FlowLabel getLabel() { result.isTaint() }
  }

  /** An access to the sensitive object `process.env`. */
  class ProcessEnvSource extends Source {
    ProcessEnvSource() { this = NodeJSLib::process().getAPropertyRead("env") }

    override string describe() { result = "process environment" }

    override DataFlow::FlowLabel getLabel() {
      result.isTaint() or
      result instanceof PartiallySensitiveMap
    }
  }

  /**
   * A flow label describing a map that might contain sensitive information in some properties.
   * Property reads on such maps where the property name is fixed is unlikely to leak sensitive information.
   */
  class PartiallySensitiveMap extends DataFlow::FlowLabel {
    PartiallySensitiveMap() { this = "PartiallySensitiveMap" }
  }

  /**
   * Holds if the edge `pred` -> `succ` should be sanitized for clear-text logging of sensitive information.
   */
  predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
    succ.(DataFlow::PropRead).getBase() = pred
  }

  /**
   * Holds if the edge `src` -> `trg` is an additional taint-step for clear-text logging of sensitive information.
   */
  predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node trg) {
    // A taint propagating data flow edge through objects: a tainted write taints the entire object.
    exists(DataFlow::PropWrite write |
      write.getRhs() = src and
      trg.(DataFlow::SourceNode).flowsTo(write.getBase())
    )
    or
    // Taint through the arguments object.
    exists(DataFlow::CallNode call, Function f |
      src = call.getAnArgument() and
      f = call.getACallee() and
      not call.isImprecise() and
      trg.asExpr() = f.getArgumentsVariable().getAnAccess()
    )
  }
}
