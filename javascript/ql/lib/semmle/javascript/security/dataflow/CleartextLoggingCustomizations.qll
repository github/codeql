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

    /**
     * DEPRECATED. Overriding this predicate no longer has any effect.
     */
    deprecated DataFlow::FlowLabel getLabel() { result.isTaint() }
  }

  /**
   * A data flow sink for clear-text logging of sensitive information.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * DEPRECATED. Overriding this predicate no longer has any effect.
     */
    deprecated DataFlow::FlowLabel getLabel() { result.isTaint() }
  }

  /**
   * A barrier for clear-text logging of sensitive information.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * A call to `.replace()` that seems to mask sensitive information.
   */
  class MaskingReplacer extends Barrier, StringReplaceCall {
    MaskingReplacer() {
      this.maybeGlobal() and
      exists(this.getRawReplacement().getStringValue()) and
      exists(DataFlow::RegExpCreationNode regexpObj |
        this.(StringReplaceCall).getRegExp() = regexpObj and
        regexpObj.getRoot() = any(RegExpDot term).getRootTerm()
      )
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
      exists(string name | name.regexpMatch(notSensitiveRegexp()) |
        this.asExpr().(VarAccess).getName() = name
        or
        this.(DataFlow::PropRead).getPropertyName() = name
        or
        this.(DataFlow::InvokeNode).getCalleeName() = name
      )
      or
      // avoid i18n strings
      this.(DataFlow::PropRead)
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
      forall(AbstractValue v | v = this.analyze().getAValue() | not v.getType() = TTObject())
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
    ObfuscatorCall() { this.getCalleeName().regexpMatch(notSensitiveRegexp()) }
  }

  /**
   * A data flow node that does not contain a clear-text password.
   */
  abstract private class NonCleartextPassword extends DataFlow::Node { }

  /**
   * A value stored in a property that may contain password information
   */
  private class ObjectPasswordPropertySource extends DataFlow::ValueNode, Source {
    string name;

    ObjectPasswordPropertySource() {
      exists(DataFlow::PropWrite write |
        write.getPropertyName() = name and
        name.regexpMatch(maybePassword()) and
        not name.regexpMatch(notSensitiveRegexp()) and
        this = write.getRhs() and
        // avoid safe values assigned to presumably unsafe names
        not this instanceof NonCleartextPassword
      )
    }

    override string describe() { result = "an access to " + name }
  }

  /**
   * An access to a variable or property that might contain a password.
   */
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
      name = this.getCalleeName() and
      name.regexpMatch("(?is)getPassword")
    }

    override string describe() { result = "a call to " + name }
  }

  /** An access to the sensitive object `process.env`. */
  class ProcessEnvSource extends Source {
    ProcessEnvSource() { this = NodeJSLib::process().getAPropertyRead("env") }

    override string describe() { result = "process environment" }
  }

  /** Gets a data flow node referring to `process.env`. */
  private DataFlow::SourceNode processEnv(DataFlow::TypeTracker t) {
    t.start() and
    result instanceof ProcessEnvSource
    or
    exists(DataFlow::TypeTracker t2 | result = processEnv(t2).track(t2, t))
  }

  /** Gets a data flow node referring to `process.env`. */
  DataFlow::SourceNode processEnv() { result = processEnv(DataFlow::TypeTracker::end()) }

  /**
   * A property access on `process.env`, seen as a barrier.
   */
  private class SafeEnvironmentVariableBarrier extends Barrier instanceof DataFlow::PropRead {
    SafeEnvironmentVariableBarrier() {
      this = processEnv().getAPropertyRead() and
      // If the name is known, it should not be sensitive
      not nameIndicatesSensitiveData(this.getPropertyName(), _)
    }
  }

  /**
   * DEPRECATED. Use `Barrier` instead, sanitized have been replaced by sanitized nodes.
   *
   * Holds if the edge `pred` -> `succ` should be sanitized for clear-text logging of sensitive information.
   */
  deprecated predicate isSanitizerEdge(DataFlow::Node pred, DataFlow::Node succ) {
    succ.(DataFlow::PropRead).getBase() = pred
  }

  /**
   * Holds if the edge `src` -> `trg` is an additional taint-step for clear-text logging of sensitive information.
   */
  predicate isAdditionalTaintStep(DataFlow::Node src, DataFlow::Node trg) {
    // A property-copy step,
    // dst[x] = src[x]
    // dst[x] = JSON.stringify(src[x])
    exists(DataFlow::PropWrite write, DataFlow::PropRead read |
      read = write.getRhs()
      or
      exists(JsonStringifyCall stringify |
        stringify.getOutput() = write.getRhs() and
        stringify.getInput() = read
      )
    |
      not exists(write.getPropertyName()) and
      not exists(read.getPropertyName()) and
      not isFilteredPropertyName(read.getPropertyNameExpr().flow().getALocalSource()) and
      src = read.getBase() and
      trg = write.getBase().getPostUpdateNode()
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

  /**
   * Holds if `name` is filtered by e.g. a regular-expression test or a filter call.
   */
  private predicate isFilteredPropertyName(DataFlow::SourceNode name) {
    exists(DataFlow::MethodCallNode reduceCall |
      reduceCall.getMethodName() = "reduce" and
      reduceCall.getABoundCallbackParameter(0, 1) = name
    |
      reduceCall.getReceiver+().(DataFlow::MethodCallNode).getMethodName() = "filter"
    )
    or
    exists(StringOps::RegExpTest test | test.getStringOperand().getALocalSource() = name)
    or
    exists(MembershipCandidate test | test.getAMemberNode().getALocalSource() = name)
  }
}
