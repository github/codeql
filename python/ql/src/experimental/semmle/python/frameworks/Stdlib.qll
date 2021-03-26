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

/** Provides models for the Python standard library. */
private module Re {
  /** List of re methods. */
  private class ReMethods extends string {
    ReMethods() {
      this in ["match", "fullmatch", "search", "split", "findall", "finditer", "sub", "subn"]
    }
  }

  private class DirectRegex extends DataFlow::CallCfgNode, RegexExecution::Range {
    DataFlow::Node regexNode;
    Attribute regexMethod;

    DirectRegex() {
      this = API::moduleImport("re").getMember(any(ReMethods m)).getACall() and
      regexNode = this.getArg(0) and
      regexMethod = this.asExpr().(Attribute)
    }

    override DataFlow::Node getRegexNode() { result = regexNode }

    override Attribute getRegexMethod() { result = regexMethod }
  }

  private class CompiledRegex extends DataFlow::CallCfgNode, RegexExecution::Range {
    DataFlow::Node regexNode;
    Attribute regexMethod;

    CompiledRegex() {
      exists(DataFlow::CallCfgNode patternCall, DirectRegex reMethod |
        this = reMethod and
        patternCall = API::moduleImport("re").getMember("compile").getACall() and
        patternCall = reMethod.(DataFlow::AttrRead).getObject().getALocalSource() and
        regexNode = patternCall.getArg(0) and
        // regexMethod is *not* worked out outside class instanciation because `CompiledRegex` focuses on re.compile(pattern).ReMethod
        regexMethod = reMethod.getRegexMethod()
      )
    }

    override DataFlow::Node getRegexNode() { result = regexNode }

    override Attribute getRegexMethod() { result = regexMethod }
  }
}
