/**
 * Provides default sources and sanitizers for reasoning about data flow from
 * sources of sensitive information, as well as extension points for adding
 * your own sources and sanitizers.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.TaintTracking::TaintTracking
private import codeql.ruby.dataflow.RemoteFlowSources
private import SensitiveDataHeuristics::HeuristicNames
private import SensitiveDataHeuristics
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
    re.getConstantValue().getStringlikeValue() = [".*", ".+"]
  }

  /** Holds if `c` is a sensitive data classification that is relevant to consider for Cleartext Storage queries. */
  private predicate isRelevantClassification(SensitiveDataClassification c) {
    c =
      [
        SensitiveDataClassification::password(), SensitiveDataClassification::certificate(),
        SensitiveDataClassification::secret(), SensitiveDataClassification::private()
      ]
  }

  pragma[noinline]
  private string getCombinedRelevantSensitiveRegexp() {
    // Combine all the maybe-sensitive regexps into one using non-capturing groups and |.
    result =
      "(?:" +
        strictconcat(string r, SensitiveDataClassification c |
          r = maybeSensitiveRegexp(c) and isRelevantClassification(c)
        |
          r, ")|(?:"
        ) + ")"
  }

  /** Holds if the given name indicates the presence of sensitive data that is relevant to consider for Cleartext Storage queries. */
  bindingset[name]
  private predicate nameIndicatesRelevantSensitiveData(string name) {
    name.regexpMatch(getCombinedRelevantSensitiveRegexp()) and
    not name.regexpMatch(notSensitiveRegexp())
  }

  /**
   * Holds if `re` may be a regular expression that can be used to sanitize
   * sensitive data with a call to `gsub`.
   */
  private predicate effectiveGsubRegExp(CfgNodes::ExprNodes::RegExpLiteralCfgNode re) {
    re.getConstantValue().getStringlikeValue() = "."
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
   * A call that might obfuscate sensitive data, for example through hashing.
   */
  private class ObfuscatorCall extends Sanitizer, DataFlow::CallNode {
    ObfuscatorCall() { nameIsNotSensitive(this.getMethodName()) }
  }

  /**
   * A data flow node that does not contain clear-text sensitive data, according to its syntactic name.
   */
  private class NameGuidedNonCleartextSensitive extends NonCleartextSensitive {
    NameGuidedNonCleartextSensitive() {
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
   * A data flow node that receives flow that is not clear-text sensitive data.
   */
  class NonCleartextSensitiveFlow extends NonCleartextSensitive {
    NonCleartextSensitiveFlow() {
      any(NonCleartextSensitive other).(DataFlow::LocalSourceNode).flowsTo(this)
    }
  }

  /**
   * DEPRECATED: Use NonCleartextSensitiveFlow instead.
   */
  deprecated class NonCleartextPasswordFlow = NonCleartextSensitiveFlow;

  /**
   * A data flow node that does not contain clear-text sensitive data.
   */
  abstract private class NonCleartextSensitive extends DataFlow::Node { }

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
   * A value written to a hash entry with a key that may contain sensitive information.
   */
  private class HashKeyWriteSensitiveSource extends Source {
    private string name;
    private DataFlow::ExprNode recv;

    HashKeyWriteSensitiveSource() {
      exists(DataFlow::CallNode writeNode |
        nameIndicatesRelevantSensitiveData(name) and
        not nameIsNotSensitive(name) and
        // avoid safe values assigned to presumably unsafe names
        not this instanceof NonCleartextSensitive and
        // hash[name] = val
        hashKeyWrite(writeNode, name, this) and
        recv = writeNode.getReceiver()
      )
    }

    override string describe() { result = "a write to " + name }

    /** Gets the name of the key */
    string getName() { result = name }

    /**
     * Gets the name of the hash variable that this sensitive source is assigned
     * to, if applicable.
     */
    LocalVariable getVariable() {
      result = recv.getExprNode().getExpr().(VariableReadAccess).getVariable()
    }
  }

  /**
   * An entry into a hash literal that may contain sensitive data
   */
  private class HashLiteralSensitiveSource extends Source {
    private string name;

    HashLiteralSensitiveSource() {
      exists(CfgNodes::ExprNodes::HashLiteralCfgNode lit |
        nameIndicatesRelevantSensitiveData(name) and
        not nameIsNotSensitive(name) and
        // avoid safe values assigned to presumably unsafe names
        not this instanceof NonCleartextSensitive and
        // hash = { name: val }
        exists(CfgNodes::ExprNodes::PairCfgNode p | p = lit.getAKeyValuePair() |
          p.getKey().getConstantValue().getStringlikeValue() = name and
          p.getValue() = this.asExpr()
        )
      )
    }

    override string describe() { result = "a write to " + name }
  }

  /** An assignment that may assign sensitive data to a variable */
  private class AssignSensitiveVariableSource extends Source {
    string name;

    AssignSensitiveVariableSource() {
      // avoid safe values assigned to presumably unsafe names
      not this instanceof NonCleartextSensitive and
      nameIndicatesRelevantSensitiveData(name) and
      not nameIsNotSensitive(name) and
      exists(Assignment a |
        this.asExpr().getExpr() = a.getRightOperand() and
        a.getLeftOperand().getAVariable().getName() = name
      )
    }

    override string describe() { result = "an assignment to " + name }
  }

  /** A parameter that may contain sensitive data. */
  private class ParameterSensitiveSource extends Source {
    private string name;

    ParameterSensitiveSource() {
      nameIndicatesRelevantSensitiveData(name) and
      not nameIsNotSensitive(name) and
      not this instanceof NonCleartextSensitive and
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
  deprecated predicate isAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(string name, ElementReference ref, LocalVariable hashVar |
      // from `hsh[password] = "changeme"` to a `hsh[password]` read
      nodeFrom.(HashKeyWriteSensitiveSource).getName() = name and
      nodeTo.asExpr().getExpr() = ref and
      ref.getArgument(0).getConstantValue().getStringlikeValue() = name and
      nodeFrom.(HashKeyWriteSensitiveSource).getVariable() = hashVar and
      ref.getReceiver().(VariableReadAccess).getVariable() = hashVar and
      nodeFrom.asExpr().getASuccessor*() = nodeTo.asExpr()
    )
  }
}
