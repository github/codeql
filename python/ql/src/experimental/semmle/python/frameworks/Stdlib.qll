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
   * A class to find `re` methods immediately executing an expression from a
   * compiled expression by `re.compile`.
   *
   * See `RegexExecutionMethods`
   *
   * See https://docs.python.org/3/library/re.html#regular-expression-objects
   */
  private class CompiledRegex extends DataFlow::CallCfgNode, RegexExecution::Range {
    DataFlow::Node regexNode;
    DataFlow::CallCfgNode regexMethod;

    CompiledRegex() {
      exists(DataFlow::CallCfgNode patternCall, DataFlow::AttrRead reMethod |
        this.getFunction() = reMethod and
        patternCall = API::moduleImport("re").getMember("compile").getACall() and
        patternCall = reMethod.getObject().getALocalSource() and
        reMethod.getAttributeName() instanceof RegexExecutionMethods and
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
    DataFlow::CallCfgNode escapeMethod;

    ReEscape() {
      this = API::moduleImport("re").getMember("escape").getACall() and
      regexNode = this.getArg(0)
    }

    override DataFlow::Node getRegexNode() { result = regexNode }
  }
}
