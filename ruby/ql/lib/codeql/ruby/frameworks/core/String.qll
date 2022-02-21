/** Provides flow summaries for the `String` class. */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.dataflow.internal.DataFlowDispatch

// TODO: the way we interpret `preservesValue` in this module may not be
// correct: we assume that if the input string appears intact in the output,
// then value is preserves. This means that we consider appending or prepending
// characters to the string to be value-preserving.
// We may want to be stricter here, and define value-preserving as when the
// output string exactly matches the input string.
/**
 * Provides flow summaries for the `String` class.
 *
 * The summaries are ordered (and implemented) based on
 * https://docs.ruby-lang.org/en/3.1/String.html.
 */
module String {
  /**
   * Value-preserving flow from the receiver to the return value.
   */
  private predicate valueIdentityFlow(string input, string output, boolean preservesValue) {
    input = "Receiver" and
    output = "ReturnValue" and
    preservesValue = true
  }

  /**
   * Taint-preserving (but not value-preserving) flow from the receiver to the return value.
   */
  private predicate taintIdentityFlow(string input, string output, boolean preservesValue) {
    input = "Receiver" and
    output = "ReturnValue" and
    preservesValue = false
  }

  private class NewSummary extends SummarizedCallable {
    NewSummary() { this = "String.new" }

    override MethodCall getACall() {
      result = API::getTopLevelMember("String").getAnInstantiation().getExprNode().getExpr()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class TryConvertSummary extends SummarizedCallable {
    TryConvertSummary() { this = "String.try_convert" }

    override MethodCall getACall() {
      result =
        API::getTopLevelMember("String").getAMethodCall("try_convert").getExprNode().getExpr()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  /**
   * A flow summary for the `String#%` method.
   */
  private class FormatSummary extends SummarizedCallable {
    private MethodCall mc;

    FormatSummary() { this = "%" and mc.getMethodName() = this }

    override MethodCall getACall() { result = mc }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = ["Receiver", "Argument[0]", "ArrayElement of Argument[0]"] and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  // TODO: * + << <=>
  /**
   * A flow summary for the `String#b` method.
   */
  private class BSummary extends SummarizedCallable {
    private MethodCall mc;

    BSummary() { this = "b" and mc.getMethodName() = this }

    override MethodCall getACall() { result = mc }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      valueIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for the `String#byteslice` method.
   */
  private class BytesliceSummary extends SummarizedCallable {
    private MethodCall mc;

    BytesliceSummary() { this = "byteslice" and mc.getMethodName() = this }

    override MethodCall getACall() { result = mc }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      valueIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#capitalize(!)`.
   */
  private class CapitalizeSummary extends SummarizedCallable {
    private MethodCall mc;

    CapitalizeSummary() { this = ["capitalize", "capitalize!"] and mc.getMethodName() = this }

    override MethodCall getACall() { result = mc }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Receiver" and
      preservesValue = false and
      output = "ReturnValue"
    }
  }

  /**
   * A flow summary for `String#center`, `String#ljust` and `String#rjust`.
   */
  private class CenterSummary extends SimpleSummarizedCallable {
    CenterSummary() { this = ["center", "ljust", "rjust"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Receiver" and
        output = "ReturnValue"
        or
        input = "Argument[1]" and
        output = "ReturnValue"
      ) and
      preservesValue = false
    }
  }

  /**
   * A flow summary for the `String#chomp`, `String#chomp!`, `String#chop` and `String#chop!` methods.
   */
  private class ChompSummary extends SummarizedCallable {
    private MethodCall mc;

    ChompSummary() { this = ["chomp", "chomp!", "chop", "chop!"] and mc.getMethodName() = this }

    override MethodCall getACall() { result = mc }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Receiver" and
      preservesValue = false and
      (
        output = "ReturnValue"
        or
        this = ["chomp!", "chop!"] and output = "Receiver"
      )
    }
  }

  // TODO: we already have a summary for Array#clear. Check that it applies correctly to String#clear.
  /**
   * A flow summary for `String#concat` and `String#prepend`.
   */
  private class ConcatSummary extends SimpleSummarizedCallable {
    ConcatSummary() {
      // `concat` and `prepend` omitted because they clash with the summaries for
      // `Array#concat` and `Array#prepend`.
      // this = ["concat", "prepend"]
      none()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = ["Receiver", "Argument[_]"] and
      output = ["ReturnValue", "Receiver"] and
      preservesValue = true
    }
  }

  /**
   * A flow summary for `String#delete(!)`, `String#delete_prefix(!)` and `String#delete_suffix(!)`.
   */
  private class DeleteSummary extends SimpleSummarizedCallable {
    DeleteSummary() { this = ["delete", "delete_prefix", "delete_suffix"] + ["", "!"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#downcase(!)`, `String#upcase` and `String#swapcase(!)`.
   */
  private class DowncaseSummary extends SimpleSummarizedCallable {
    DowncaseSummary() { this = ["downcase", "upcase", "swapcase"] + ["", "!"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#dump` and `String#undump`.
   */
  private class DumpSummary extends SimpleSummarizedCallable {
    DumpSummary() { this = ["dump", "undump"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#each_line` and `String#lines`.
   */
  private class EachLineSummary extends SummarizedCallable {
    MethodCall mc;

    EachLineSummary() { this = ["each_line", "lines"] and mc.getMethodName() = this }

    override MethodCall getACall() { result = mc }

    predicate hasBlock() { exists(Block b | b = mc.getBlock()) }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      preservesValue = false and
      input = "Receiver" and
      (
        output = "Parameter[0] of BlockArgument"
        or
        not this.hasBlock() and output = "ArrayElement[?] of ReturnValue"
        or
        this.hasBlock() and output = "ReturnValue"
      )
    }
  }

  /**
   * A flow summary for `String#encode(!)` and `String#unicode_normalize(!)`.
   */
  private class EncodeSummary extends SimpleSummarizedCallable {
    EncodeSummary() { this = ["encode", "unicode_normalize"] + ["", "!"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#force_encoding`.
   */
  private class ForceEncodingSummary extends SimpleSummarizedCallable {
    ForceEncodingSummary() { this = "force_encoding" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Receiver" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /**
   * A flow summary for `String#freeze`.
   */
  private class FreezeSummary extends SimpleSummarizedCallable {
    FreezeSummary() { this = "freeze" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      valueIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#gsub(!)` and `String#sub(!)`.
   */
  private class GsubSummary extends SimpleSummarizedCallable {
    GsubSummary() { this = ["sub", "gsub"] + ["", "!"] }

    // str.gsub(pattern, replacement) -> new_str
    // str.gsub(pattern) {|match| block } -> new_str
    // str.gsub(pattern) -> enumerator of matches
    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      // receiver -> return value
      // replacement -> return value
      // block return -> return value
      (
        input = ["Receiver", "Argument[1]"] and
        preservesValue = false
        or
        input = "ReturnValue of BlockArgument" and preservesValue = true
      ) and
      output = "ReturnValue"
    }
  }

  /**
   * A flow summary for `String#insert`.
   */
  private class InsertSummary extends SimpleSummarizedCallable {
    InsertSummary() {
      this = "insert" and
      // Disabled because it clashes with the summary for Array#insert.
      none()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Receiver" and preservesValue = false
        or
        input = "Argument[1]" and preservesValue = true
      ) and
      output = "ReturnValue"
    }
  }

  /**
   * A flow summary for `String#inspect`.
   */
  private class InspectSummary extends SimpleSummarizedCallable {
    InspectSummary() { this = "inspect" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#strip(!)`, `String#lstrip(!)` and `String#rstrip(!)`.
   */
  private class StripSummary extends SimpleSummarizedCallable {
    StripSummary() { this = ["strip", "lstrip", "rstrip"] + ["", "!"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      valueIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#next(!)` and `String#succ(!)`.
   */
  private class NextSummary extends SimpleSummarizedCallable {
    NextSummary() { this = ["next", "succ"] + ["", "!"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#partition` and `String#rpartition`.
   */
  private class PartitionSummary extends SimpleSummarizedCallable {
    PartitionSummary() { this = ["partition", "rpartition"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Receiver" and
      output = "ArrayElement[" + [0, 1, 2] + "] of ReturnValue" and
      preservesValue = false
    }
  }

  /**
   * A flow summary for `String#replace`.
   */
  private class ReplaceSummary extends SimpleSummarizedCallable {
    ReplaceSummary() { this = "replace" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and
      output = ["ReturnValue", "Receiver"] and
      preservesValue = true
    }
    // TODO: we should also clear any existing content in Receiver
  }

  /**
   * A flow summary for `String#reverse(!)`.
   */
  private class ReverseSummary extends SimpleSummarizedCallable {
    ReverseSummary() { this = ["reverse", "reverse!"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#scan`.
   */
  private class ScanSummary extends SummarizedCallable {
    private MethodCall mc;

    ScanSummary() { this = "scan" and mc.getMethodName() = this }

    override MethodCall getACall() { result = mc }

    private predicate hasBlock() { exists(Block b | b = mc.getBlock()) }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Receiver" and
      (
        // scan(pattern) {|match, ...| block } -> str
        not this.hasBlock() and
        output = "ArrayElement[?] of ReturnValue" and
        preservesValue = false
        or
        // Parameter[_] doesn't seem to work
        output = "Parameter[" + [0 .. 10] + "] of BlockArgument" and preservesValue = false
        or
        // scan(pattern) -> array
        this.hasBlock() and
        output = "ReturnValue" and
        preservesValue = true
      )
    }
  }

  /**
   * A flow summary for `String#scrub(!)`.
   */
  private class ScrubSummary extends SummarizedCallable {
    private MethodCall mc;

    ScrubSummary() { this = ["scrub", "scrub!"] and mc.getMethodName() = this }

    override MethodCall getACall() { result = mc }

    private predicate hasBlock() { exists(Block b | b = mc.getBlock()) }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Receiver" and
      output = "Parameter[0] of BlockArgument" and
      preservesValue = true
      or
      input = "Argument[0]" and output = "ReturnValue" and preservesValue = true
      or
      this.hasBlock() and
      input = "ReturnValue of BlockArgument" and
      output = "ReturnValue" and
      preservesValue = true
      or
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  // TODO: what do we do about `String#shellescape`?
  /**
   * A flow summary for `String#shellsplit`.
   */
  private class ShellSplitSummary extends SimpleSummarizedCallable {
    ShellSplitSummary() { this = "shellsplit" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Receiver" and
      output = "ArrayElement[?] of ReturnValue" and
      preservesValue = false
    }
  }

  /**
   * A flow summary for `String#slice(!)`, `String#split` and `String#[]`.
   */
  private class SliceSummary extends SimpleSummarizedCallable {
    SliceSummary() { this = ["slice", "slice!", "split", "[]"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#squeeze(!)`.
   */
  private class SqueezeSummary extends SimpleSummarizedCallable {
    SqueezeSummary() { this = ["squeeze", "squeeze!"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#to_s` and `String.to_str`.
   */
  private class ToStrSummary extends SimpleSummarizedCallable {
    ToStrSummary() { this = ["to_str", "to_s"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      valueIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#tr`.
   */
  private class TrSummary extends SimpleSummarizedCallable {
    TrSummary() { this = ["tr", "tr_s"] + ["", "!"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = ["Receiver", "Argument[1]"] and output = "ReturnValue" and preservesValue = false
    }
  }

  /**
   * A flow summary for `String#upto`.
   */
  private class UptoSummary extends SummarizedCallable {
    private MethodCall mc;

    UptoSummary() { this = "upto" and mc.getMethodName() = this }

    override MethodCall getACall() { result = mc }

    private predicate hasBlock() { exists(Block b | b = mc.getBlock()) }

    // TODO: if second arg ('exclusive') is true, the first arg is excluded
    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      valueIdentityFlow(input, output, preservesValue)
      or
      input = ["Receiver", "Argument[0]"] and
      output = "Parameter[0] of BlockArgument" and
      preservesValue = true
      or
      not this.hasBlock() and
      input = "ReturnValue of BlockArgument" and
      output = "ArrayElement[?] of ReturnValue" and
      preservesValue = true
    }
  }
}
