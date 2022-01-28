/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * cleartext logging of sensitive information, as well as extension points for
 * adding your own.
 */

private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking::TaintTracking
private import codeql.ruby.Concepts
private import codeql.ruby.dataflow.RemoteFlowSources
private import internal.SensitiveDataHeuristics::HeuristicNames
private import codeql.ruby.CFG
private import codeql.ruby.dataflow.SSA

module CleartextLogging {
  /**
   * A data flow source for cleartext logging of sensitive information.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the type of this data flow source. */
    abstract string describe();
  }

  /**
   * A data flow sink for cleartext logging of sensitive information.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for cleartext logging of sensitive information.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * A node that receives sanitized sensitive information.
   */
  abstract class SanitizerIn extends DataFlow::Node { }

  /**
   * Holds if `re` may be a regular expression that can be used to sanitize
   * sensitive data with a call to `sub`.
   */
  private predicate effectiveSubRegExp(RegExpLiteral re) {
    re.getConstantValue().getStringOrSymbol().matches([".*", ".+"])
  }

  /**
   * Holds if `re` may be a regular expression that can be used to sanitize
   * sensitive data with a call to `gsub`.
   */
  private predicate effectiveGsubRegExp(RegExpLiteral re) {
    re.getConstantValue().getStringOrSymbol().matches(".")
  }

  /**
   * A call to `sub`/`sub!` or `gsub`/`gsub!` that seems to mask sensitive information.
   */
  private class MaskingReplacerSanitizer extends Sanitizer, DataFlow::CallNode {
    MaskingReplacerSanitizer() {
      exists(RegExpLiteral re |
        re = this.getArgument(0).asExpr().getExpr() and
        (
          this.getMethodName() = ["sub", "sub!"] and effectiveSubRegExp(re)
          or
          this.getMethodName() = ["gsub", "gsub!"] and effectiveGsubRegExp(re)
        )
      )
    }
  }

  /**
   * A node sanitized by a prior call to `sub!` or `gsub!`,
   * e.g. the `password` argument to `info` in:
   * ```
   * password = "changeme"
   * password.sub!(/.+/, "")
   * Logger.new(STDOUT).info password
   * ```
   */
  private class MaskingReplacerSanitizedNode extends SanitizerIn {
    MaskingReplacerSanitizedNode() {
      exists(MaskingReplacerSanitizer maskCall, Variable v |
        maskCall.getMethodName() = ["sub!", "gsub!"] and
        v = maskCall.getReceiver().asExpr().getExpr().(VariableReadAccess).getVariable() and
        v = this.asExpr().getExpr().(VariableReadAccess).getVariable() and
        maskCall.asExpr().getASuccessor*() = this.asExpr()
      )
    }
  }

  /**
   * Gets the name of a  method that would be falsely marked as non-sensitive
   * by `notSensitiveRegexp`.
   */
  private predicate nonSensitiveMethodNameExclusion(string name) {
    name = ["[]", "[]="]
  }

  /**
   * A call that might obfuscate a password, for example through hashing.
   */
  private class ObfuscatorCall extends Sanitizer, DataFlow::CallNode {
    ObfuscatorCall() {
      this.getMethodName().regexpMatch(notSensitiveRegexp()) and
      not nonSensitiveMethodNameExclusion(this.getMethodName())
    }
  }

  /**
   * A data flow node that does not contain a clear-text password, according to its syntactic name.
   */
  private class NameGuidedNonCleartextPassword extends NonCleartextPassword {
    NameGuidedNonCleartextPassword() {
      exists(string name | name.regexpMatch(notSensitiveRegexp()) |
        // accessing a non-sensitive variable
        this.asExpr().getExpr().(VariableReadAccess).getVariable().getName() = name
        or
        // dereferencing a non-sensitive field
        this.asExpr()
            .getExpr()
            .(ElementReference)
            .getArgument(0)
            .getConstantValue()
            .getStringOrSymbol() = name
        or
        // calling a non-sensitive method
        (
          this.(DataFlow::CallNode).getMethodName() = name and
          not nonSensitiveMethodNameExclusion(name)
        )
      )
      or
      // avoid i18n strings
      this.asExpr()
          .getExpr()
          .(ElementReference)
          .getReceiver()
          .getConstantValue()
          .getStringOrSymbol()
          .regexpMatch("(?is).*(messages|strings).*")
    }
  }

  /**
   * A data flow node that receives flow that is not a clear-text password.
   */
  private class NonCleartextPasswordFlow extends NonCleartextPassword {
    NonCleartextPasswordFlow() {
      any(NonCleartextPassword other).(DataFlow::LocalSourceNode).flowsTo(this)
    }
  }

  /**
   * A data flow node that does not contain a clear-text password.
   */
  abstract private class NonCleartextPassword extends DataFlow::Node { }

  // `writeNode` assigns pair with key `name` to `val`
  private predicate hashKeyWrite(DataFlow::CallNode writeNode, string name, DataFlow::Node val) {
    exists(SetterMethodCall setter |
      setter = writeNode.asExpr().getExpr() and
      // hash[name]
      setter.getArgument(0).getConstantValue().getStringOrSymbol() = name and
      // val
      setter.getArgument(1).(Assignment).getRightOperand() = val.asExpr().getExpr()
    )
  }

  /**
   * A write to a hash entry with a value that may contain password information.
   */
  private class HashKeyWritePasswordSource extends Source {
    private string name;
    private DataFlow::ExprNode recv;

    HashKeyWritePasswordSource() {
      exists(DataFlow::Node val |
        name.regexpMatch(maybePassword()) and
        not name.regexpMatch(notSensitiveRegexp()) and
        // avoid safe values assigned to presumably unsafe names
        not val instanceof NonCleartextPassword and
        (
          // hash[name] = val
          hashKeyWrite(this, name, val) and
          recv = this.(DataFlow::CallNode).getReceiver()
        )
      )
    }

    override string describe() { result = "an write to " + name }

    /** Gets the name of the key */
    string getName() { result = name }

    /**
     * Gets the name of the hash variable that this password source is assigned
     * to, if applicable.
     */
    LocalVariable getVariable() {
      result = recv.getExprNode().getExpr().(VariableReadAccess).getVariable()
    }
  }

  /**
   * A hash literal with an entry that may contain a password
   */
  private class HashLiteralPasswordSource extends Source {
    private string name;

    HashLiteralPasswordSource() {
      exists(DataFlow::Node val, HashLiteral lit |
        name.regexpMatch(maybePassword()) and
        not name.regexpMatch(notSensitiveRegexp()) and
        // avoid safe values assigned to presumably unsafe names
        not val instanceof NonCleartextPassword and
        // hash = { name: val }
        exists(Pair p |
          this.asExpr().getExpr() = lit and p = lit.getAKeyValuePair() |
          p.getKey().getConstantValue().getStringOrSymbol() = name and
          p.getValue() = val.asExpr().getExpr()
        )
      )
    }

    override string describe() { result = "an write to " + name }
  }

  /** An assignment that may assign a password to a variable */
  private class AssignPasswordVariableSource extends Source {
    string name;

    AssignPasswordVariableSource() {
      // avoid safe values assigned to presumably unsafe names
      not this instanceof NonCleartextPassword and
      name.regexpMatch(maybePassword()) and
      (
        exists(Assignment a |
          this.asExpr().getExpr() = a.getRightOperand() and
          a.getLeftOperand().getAVariable().getName() = name)
      )
    }

    override string describe() { result = "an assignment to " + name }
  }

  /** A parameter that may contain a password. */
  private class ParameterPasswordSource extends Source {
    private string name;

    ParameterPasswordSource() {
      name.regexpMatch(maybePassword()) and
      not this instanceof NonCleartextPassword and
      exists(Parameter p, LocalVariable v |
        v = p.getAVariable() and
        v.getName() = name and
        this.asExpr().getExpr() = v.getAnAccess()
      )
    }

    override string describe() { result = "a parameter " + name }
  }

  /** A call that might return a password. */
  private class CallPasswordSource extends DataFlow::CallNode, Source {
    private string name;

    CallPasswordSource() {
      name = this.getMethodName() and
      name.regexpMatch("(?is)getPassword")
    }

    override string describe() { result = "a call to " + name }
  }

  private string commonLogMethodName() {
    result = ["info", "debug", "warn", "warning", "error", "log"]
  }

  /** Holds if `nodeFrom` taints `nodeTo`. */
  predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(string name, ElementReference ref, LocalVariable hashVar |
      // from `hsh[password] = "changeme"` to a `hsh[password]` read
      nodeFrom.(HashKeyWritePasswordSource).getName() = name and
      nodeTo.asExpr().getExpr() = ref and
      ref.getArgument(0).getConstantValue().getStringOrSymbol() = name and
      nodeFrom.(HashKeyWritePasswordSource).getVariable() = hashVar and
      ref.getReceiver().(VariableReadAccess).getVariable() = hashVar and
      nodeFrom.asExpr().getASuccessor*() = nodeTo.asExpr()
    )
  }

  /**
   * A node representing an expression whose value is logged.
   */
  private class LoggingInputAsSink extends Sink {
    LoggingInputAsSink() {
      // precise match based on inferred type of receiver
      exists(Logging logging | this = logging.getAnInput())
      or
      // imprecise name based match
      exists(DataFlow::CallNode call, string recvName |
        recvName =
          call.getReceiver().asExpr().getExpr().(VariableReadAccess).getVariable().getName() and
        recvName.regexpMatch(".*log(ger)?") and
        call.getMethodName() = commonLogMethodName()
      |
        this = call.getArgument(_)
      )
    }
  }
}
