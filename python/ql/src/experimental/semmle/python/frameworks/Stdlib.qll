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

    DirectRegex() {
      this = API::moduleImport("re").getMember(any(ReMethods m)).getACall() and
      regexNode = this.getArg(0)
    }

    override DataFlow::Node getRegexNode() { result = regexNode }

    override string getRegexModule() { result = "re" }
  }

  private class CompiledRegex extends DataFlow::CallCfgNode, RegexExecution::Range {
    DataFlow::Node regexNode;
    DataFlow::CallCfgNode regexMethod;

    CompiledRegex() {
      exists(DataFlow::CallCfgNode patternCall, DataFlow::AttrRead reMethod |
        this.getFunction() = reMethod and
        patternCall = API::moduleImport("re").getMember("compile").getACall() and
        patternCall = reMethod.getObject().getALocalSource() and
        reMethod.getAttributeName() instanceof ReMethods and
        regexNode = patternCall.getArg(0)
      )
    }

    override DataFlow::Node getRegexNode() { result = regexNode }

    override string getRegexModule() { result = "re" }
  }

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
