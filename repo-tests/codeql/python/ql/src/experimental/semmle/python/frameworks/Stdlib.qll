/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 * Note: some modeling is done internally in the dataflow/taint tracking implementation.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import experimental.semmle.python.Concepts
private import semmle.python.ApiGraphs

/**
 * Provides models for Python's `re` library.
 *
 * See https://docs.python.org/3/library/re.html
 */
private module Re {
  /**
   * List of `re` methods immediately executing an expression.
   *
   * See https://docs.python.org/3/library/re.html#module-contents
   */
  private class RegexExecutionMethods extends string {
    RegexExecutionMethods() {
      this in ["match", "fullmatch", "search", "split", "findall", "finditer", "sub", "subn"]
    }
  }

  /**
   * A class to find `re` methods immediately executing an expression.
   *
   * See `RegexExecutionMethods`
   */
  private class DirectRegex extends DataFlow::CallCfgNode, RegexExecution::Range {
    DataFlow::Node regexNode;

    DirectRegex() {
      this = API::moduleImport("re").getMember(any(RegexExecutionMethods m)).getACall() and
      regexNode = this.getArg(0)
    }

    override DataFlow::Node getRegexNode() { result = regexNode }

    override string getRegexModule() { result = "re" }
  }

  /**
   * A class to find `re` methods immediately executing a compiled expression by `re.compile`.
   *
   * Given the following example:
   *
   * ```py
   * pattern = re.compile(input)
   * pattern.match(s)
   * ```
   *
   * This class will identify that `re.compile` compiles `input` and afterwards
   * executes `re`'s `match`. As a result, `this` will refer to `pattern.match(s)`
   * and `this.getRegexNode()` will return the node for `input` (`re.compile`'s first argument)
   *
   *
   * See `RegexExecutionMethods`
   *
   * See https://docs.python.org/3/library/re.html#regular-expression-objects
   */
  private class CompiledRegex extends DataFlow::MethodCallNode, RegexExecution::Range {
    DataFlow::Node regexNode;

    CompiledRegex() {
      exists(DataFlow::MethodCallNode patternCall |
        patternCall = API::moduleImport("re").getMember("compile").getACall() and
        patternCall.flowsTo(this.getObject()) and
        this.getMethodName() instanceof RegexExecutionMethods and
        regexNode = patternCall.getArg(0)
      )
    }

    override DataFlow::Node getRegexNode() { result = regexNode }

    override string getRegexModule() { result = "re" }
  }

  /**
   * A class to find `re` methods escaping an expression.
   *
   * See https://docs.python.org/3/library/re.html#re.escape
   */
  class ReEscape extends DataFlow::CallCfgNode, RegexEscape::Range {
    DataFlow::Node regexNode;

    ReEscape() {
      this = API::moduleImport("re").getMember("escape").getACall() and
      regexNode = this.getArg(0)
    }

    override DataFlow::Node getRegexNode() { result = regexNode }
  }
}
