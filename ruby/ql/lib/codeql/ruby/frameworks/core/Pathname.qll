/** Modeling of the `Pathname` class from the Ruby standard library. */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.dataflow.internal.DataFlowDispatch
private import codeql.ruby.controlflow.CfgNodes

/**
 * Modeling of the `Pathname` class from the Ruby standard library.
 *
 * https://docs.ruby-lang.org/en/3.1/Pathname.html
 */
module Pathname {
  /// Flow summary for `Pathname.new`.
  private class NewSummary extends SummarizedCallable {
    NewSummary() { this = "Pathname.new" }

    override MethodCall getACall() {
      result = API::getTopLevelMember("Pathname").getAnInstantiation().getExprNode().getExpr()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /// Flow summary for `Pathname#dirname`.
  private class DirnameSummary extends SimpleSummarizedCallable {
    DirnameSummary() { this = "dirname" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /// Flow summary for `Pathname#each_filename`.
  private class EachFilenameSummary extends SimpleSummarizedCallable {
    EachFilenameSummary() { this = "each_filename" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = false
    }
  }

  /// Flow summary for `Pathname#expand_path`.
  private class ExpandPathSummary extends SimpleSummarizedCallable {
    ExpandPathSummary() { this = "expand_path" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /// Flow summary for `Pathname#join`.
  private class JoinSummary extends SimpleSummarizedCallable {
    JoinSummary() { this = "join" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = ["Argument[self]", "Argument[any]"] and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /// Flow summary for `Pathname#parent`.
  private class ParentSummary extends SimpleSummarizedCallable {
    ParentSummary() { this = "parent" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /// Flow summary for `Pathname#realpath`.
  private class RealpathSummary extends SimpleSummarizedCallable {
    RealpathSummary() { this = "realpath" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /// Flow summary for `Pathname#relative_path_from`.
  private class RelativePathFromSummary extends SimpleSummarizedCallable {
    RelativePathFromSummary() { this = "relative_path_from" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /// Flow summary for `Pathname#to_path`.
  private class ToPathSummary extends SimpleSummarizedCallable {
    ToPathSummary() { this = "to_path" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }
}
