/**
 * Provides default sources and sanitizers for reasoning about data flow from
 * sources of sensitive information, as well as extension points for adding
 * your own sources and sanitizers.
 */

private import ruby
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking::TaintTracking
private import codeql.ruby.dataflow.RemoteFlowSources
private import SensitiveDataHeuristics::HeuristicNames
private import codeql.ruby.CFG
private import codeql.ruby.dataflow.SSA

/**
 * Provides default sources and sanitizers for reasoning about data flow from
 * sources of sensitive information, as well as extension points for adding
 * your own sources and sanitizers.
 */
module CleartextSources {
  /**
   * A data flow source of cleartext sensitive information.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the type of this data flow source. */
    abstract string describe();
  }

  /**
   * A sanitizer for cleartext sensitive information.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * Holds if `re` may be a regular expression that can be used to sanitize
   * sensitive data with a call to `sub`.
   */
  private predicate effectiveSubRegExp(CfgNodes::ExprNodes::RegExpLiteralCfgNode re) {
    re.getConstantValue().getStringlikeValue().matches([".*", ".+"])
  }

  /**
   * Holds if `re` may be a regular expression that can be used to sanitize
   * sensitive data with a call to `gsub`.
   */
  private predicate effectiveGsubRegExp(CfgNodes::ExprNodes::RegExpLiteralCfgNode re) {
    re.getConstantValue().getStringlikeValue().matches(".")
  }

  /**
   * A call to `sub`/`sub!` or `gsub`/`gsub!` that seems to mask sensitive information.
   */
  private class MaskingReplacerSanitizer extends Sanitizer, DataFlow::CallNode {
    MaskingReplacerSanitizer() {
      exists(CfgNodes::ExprNodes::RegExpLiteralCfgNode re |
        re = this.getArgument(0).asExpr() and
        (
          this.getMethodName() = ["sub", "sub!"] and effectiveSubRegExp(re)
          or
          this.getMethodName() = ["gsub", "gsub!"] and effectiveGsubRegExp(re)
        )
      )
    }
  }

  /**
   * Like `MaskingReplacerSanitizer` but updates the receiver for methods that
   * sanitize the receiver.
   * Taint is thereby cleared for any subsequent read.
   */
  private class InPlaceMaskingReplacerSanitizer extends Sanitizer {
    InPlaceMaskingReplacerSanitizer() {
      exists(MaskingReplacerSanitizer m | m.getMethodName() = ["gsub!", "sub!"] |
        m.getReceiver() = this
      )
    }
  }

  /**
   * Holds if `name` is for a method or variable that appears, syntactically, to
   * not be sensitive.
   */
  bindingset[name]
  predicate nameIsNotSensitive(string name) {
    name.regexpMatch(notSensitiveRegexp()) and
    // By default `notSensitiveRegexp()` includes some false positives for
    // common ruby method names that are not necessarily non-sensitive.
    // We explicitly exclude element references, element assignments, and
    // mutation methods.
    not name = ["[]", "[]="] and
    not name.matches("%!")
  }

  /**
   * A call that might obfuscate a password, for example through hashing.
   */
  private class ObfuscatorCall extends Sanitizer, DataFlow::CallNode {
    ObfuscatorCall() { nameIsNotSensitive(this.getMethodName()) }
  }

  /**
   * A data flow node that does not contain a clear-text password, according to its syntactic name.
   */
  private class NameGuidedNonCleartextPassword extends NonCleartextPassword {
    NameGuidedNonCleartextPassword() {
      exists(string name | nameIsNotSensitive(name) |
        // accessing a non-sensitive variable
        this.asExpr().getExpr().(VariableReadAccess).getVariable().getName() = name
        or
        // dereferencing a non-sensitive field
        this.asExpr()
            .(CfgNodes::ExprNodes::ElementReferenceCfgNode)
            .getArgument(0)
            .getConstantValue()
            .getStringlikeValue() = name
        or
        // calling a non-sensitive method
        this.(DataFlow::CallNode).getMethodName() = name
      )
      or
      // avoid i18n strings
      this.asExpr()
          .(CfgNodes::ExprNodes::ElementReferenceCfgNode)
          .getReceiver()
          .getConstantValue()
          .getStringlikeValue()
          .regexpMatch("(?is).*(messages|strings).*")
    }
  }

  /**
   * A data flow node that receives flow that is not a clear-text password.
   */
  class NonCleartextPasswordFlow extends NonCleartextPassword {
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
    writeNode.asExpr().getExpr() instanceof SetterMethodCall and
    // hash[name]
    writeNode.getArgument(0).asExpr().getConstantValue().getStringlikeValue() = name and
    // val
    writeNode.getArgument(1).asExpr().(CfgNodes::ExprNodes::AssignExprCfgNode).getRhs() =
      val.asExpr()
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
        not nameIsNotSensitive(name) and
        // avoid safe values assigned to presumably unsafe names
        not val instanceof NonCleartextPassword and
        (
          // hash[name] = val
          hashKeyWrite(this, name, val) and
          recv = this.(DataFlow::CallNode).getReceiver()
        )
      )
    }

    override string describe() { result = "a write to " + name }

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
      exists(DataFlow::Node val, CfgNodes::ExprNodes::HashLiteralCfgNode lit |
        name.regexpMatch(maybePassword()) and
        not nameIsNotSensitive(name) and
        // avoid safe values assigned to presumably unsafe names
        not val instanceof NonCleartextPassword and
        // hash = { name: val }
        exists(CfgNodes::ExprNodes::PairCfgNode p |
          this.asExpr() = lit and p = lit.getAKeyValuePair()
        |
          p.getKey().getConstantValue().getStringlikeValue() = name and
          p.getValue() = val.asExpr()
        )
      )
    }

    override string describe() { result = "a write to " + name }
  }

  /** An assignment that may assign a password to a variable */
  private class AssignPasswordVariableSource extends Source {
    string name;

    AssignPasswordVariableSource() {
      // avoid safe values assigned to presumably unsafe names
      not this instanceof NonCleartextPassword and
      name.regexpMatch(maybePassword()) and
      not nameIsNotSensitive(name) and
      exists(Assignment a |
        this.asExpr().getExpr() = a.getRightOperand() and
        a.getLeftOperand().getAVariable().getName() = name
      )
    }

    override string describe() { result = "an assignment to " + name }
  }

  /** A parameter that may contain a password. */
  private class ParameterPasswordSource extends Source {
    private string name;

    ParameterPasswordSource() {
      name.regexpMatch(maybePassword()) and
      not nameIsNotSensitive(name) and
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

  /** Holds if `nodeFrom` taints `nodeTo`. */
  predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(string name, ElementReference ref, LocalVariable hashVar |
      // from `hsh[password] = "changeme"` to a `hsh[password]` read
      nodeFrom.(HashKeyWritePasswordSource).getName() = name and
      nodeTo.asExpr().getExpr() = ref and
      ref.getArgument(0).getConstantValue().getStringlikeValue() = name and
      nodeFrom.(HashKeyWritePasswordSource).getVariable() = hashVar and
      ref.getReceiver().(VariableReadAccess).getVariable() = hashVar and
      nodeFrom.asExpr().getASuccessor*() = nodeTo.asExpr()
    )
  }
}
