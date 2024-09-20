/** Provides flow summaries for the `String` class. */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.FlowSummary as FlowSummary
private import codeql.ruby.dataflow.internal.DataFlowDispatch
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.Regexp as RE

/**
 * A call to a string substitution method, i.e. `String#sub`, `String#sub!`,
 * `String#gsub`, or `String#gsub!`.
 *
 * We heuristically include any call to a method matching the above names,
 * provided it has exactly two arguments and a receiver.
 */
class StringSubstitutionCall extends DataFlow::CallNode {
  StringSubstitutionCall() {
    this.getMethodName() = ["sub", "sub!", "gsub", "gsub!"] and
    exists(this.getReceiver()) and
    (
      this.getNumberOfArguments() = 2
      or
      this.getNumberOfArguments() = 1 and exists(this.getBlock())
    )
  }

  /**
   * Holds if this is a global substitution, i.e. this is a call to `gsub` or
   * `gsub!`.
   */
  predicate isGlobal() { this.getMethodName() = ["gsub", "gsub!"] }

  /**
   * Holds if this is a destructive substitution, i.e. this is a call to `sub!`
   * or `gsub!`.
   */
  predicate isDestructive() { this.getMethodName() = ["sub!", "gsub!"] }

  /** Gets the first argument to this call. */
  DataFlow::Node getPatternArgument() { result = this.getArgument(0) }

  /** Gets the second argument to this call. */
  DataFlow::Node getReplacementArgument() { result = this.getArgument(1) }

  /**
   * Gets the regular expression passed as the first (pattern) argument in this
   * call, if any.
   */
  RE::RegExpPatternSource getPatternRegExp() {
    result.(DataFlow::LocalSourceNode).flowsTo(this.getPatternArgument())
    or
    result.asExpr().getExpr() =
      this.getPatternArgument().asExpr().getExpr().(ConstantReadAccess).getValue()
  }

  /**
   * Gets the string value passed as the first (pattern) argument in this call,
   * if any.
   */
  string getPatternString() {
    result = this.getPatternArgument().asExpr().getConstantValue().getString()
  }

  /**
   * Gets the string value used to replace instances of the pattern, if any.
   * This includes values passed explicitly as the second argument and values
   * returned from the block, if one is given.
   */
  string getReplacementString() {
    result = this.getReplacementArgument().asExpr().getConstantValue().getString()
    or
    exists(DataFlow::Node blockReturnNode, DataFlow::LocalSourceNode stringNode |
      exprNodeReturnedFrom(blockReturnNode, this.getBlock().asExpr().getExpr())
    |
      stringNode.flowsTo(blockReturnNode) and
      result = stringNode.asExpr().getConstantValue().getString()
    )
  }

  /** Gets a string that is being replaced by this call. */
  string getAReplacedString() {
    result = this.getPatternRegExp().getRegExpTerm().getAMatchedString()
    or
    result = this.getPatternString()
  }

  /** Holds if this call to `replace` replaces `old` with `new`. */
  predicate replaces(string old, string new) {
    old = this.getAReplacedString() and
    new = this.getReplacementString()
  }
}

/**
 * Provides flow summaries for the `String` class.
 *
 * The summaries are ordered (and implemented) based on
 * https://docs.ruby-lang.org/en/3.1/String.html.
 */
module String {
  /**
   * Taint-preserving (but not value-preserving) flow from the receiver to the return value.
   */
  private predicate taintIdentityFlow(string input, string output, boolean preservesValue) {
    input = "Argument[self]" and
    output = "ReturnValue" and
    preservesValue = false
  }

  /** A `String` callable with a flow summary. */
  abstract class SummarizedCallable extends FlowSummary::SummarizedCallable {
    bindingset[this]
    SummarizedCallable() { any() }
  }

  abstract private class SimpleSummarizedCallable extends SummarizedCallable,
    FlowSummary::SimpleSummarizedCallable
  {
    bindingset[this]
    SimpleSummarizedCallable() { any() }
  }

  private class NewSummary extends SummarizedCallable {
    NewSummary() { this = "String.new" }

    override MethodCall getACall() {
      result = API::getTopLevelMember("String").getAnInstantiation().getExprNode().getExpr()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /**
   * A flow summary for the `String#%` method.
   */
  private class FormatSummary extends SimpleSummarizedCallable {
    FormatSummary() { this = "%" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = ["Argument[self]", "Argument[0]", "Argument[0].Element[any]"] and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  // TODO: * + << <=>
  /**
   * A flow summary for the `String#b` method.
   */
  private class BSummary extends SimpleSummarizedCallable {
    BSummary() { this = "b" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for the `String#byteslice` method.
   */
  private class BytesliceSummary extends SimpleSummarizedCallable {
    BytesliceSummary() { this = "byteslice" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#capitalize(!)`.
   */
  private class CapitalizeSummary extends SimpleSummarizedCallable {
    CapitalizeSummary() { this = ["capitalize", "capitalize!"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      preservesValue = false and
      output = "ReturnValue"
    }
  }

  /**
   * A flow summary for `String#center`, `String#ljust` and `String#rjust`.
   */
  private class CenterSummary extends SimpleSummarizedCallable {
    CenterSummary() { this = ["center", "ljust", "rjust"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
      or
      input = "Argument[1]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /**
   * A flow summary for the `String#chomp`, `String#chomp!`, `String#chop` and `String#chop!` methods.
   */
  private class ChompSummary extends SimpleSummarizedCallable {
    ChompSummary() { this = ["chomp", "chomp!", "chop", "chop!"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
      or
      this = ["chomp!", "chop!"] and
      input = "Argument[self]" and
      preservesValue = false and
      output = "Argument[self]"
    }
  }

  /**
   * This is a placeholder for `String#clear`.
   * We can't currently write this summary because there is no `DataFlow::Content` node to refer to (unlike with `Array#clear`).
   * We need a `DataFlow::Content` node in order to override `clearsContent`.
   */
  private class ClearSummary extends SimpleSummarizedCallable {
    ClearSummary() { none() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      none()
    }
  }

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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self,0..]" and
      output = ["ReturnValue", "Argument[self]"] and
      preservesValue = false
    }
  }

  /**
   * A flow summary for `String#delete(!)`, `String#delete_prefix(!)` and `String#delete_suffix(!)`.
   */
  private class DeleteSummary extends SimpleSummarizedCallable {
    DeleteSummary() { this = ["delete", "delete_prefix", "delete_suffix"] + ["", "!"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#downcase(!)`, `String#upcase` and `String#swapcase(!)`.
   */
  private class DowncaseSummary extends SimpleSummarizedCallable {
    DowncaseSummary() { this = ["downcase", "upcase", "swapcase"] + ["", "!"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#dump` and `String#undump`.
   */
  private class DumpSummary extends SimpleSummarizedCallable {
    DumpSummary() { this = ["dump", "undump"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#each_line` and `String#lines`.
   * This is split into two summaries below - one for when a block is passed and one for when no block is passed.
   */
  abstract private class EachLineSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    EachLineSummary() { mc.getMethodName() = ["each_line", "lines"] }

    final override MethodCall getACall() { result = mc }
  }

  /**
   * A flow summary for `String#each_line` and `String#lines` when a block is passed.
   */
  private class EachLineBlockSummary extends EachLineSummary {
    EachLineBlockSummary() { this = "each_line_with_block" and exists(mc.getBlock()) }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      preservesValue = false and
      input = "Argument[self]" and
      output = ["Argument[block].Parameter[0]", "ReturnValue"]
    }
  }

  /**
   * A flow summary for `String#each_line` and `String#lines` when no block is passed.
   */
  private class EachLineNoBlockSummary extends EachLineSummary {
    EachLineNoBlockSummary() { this = "each_line_without_block" and not exists(mc.getBlock()) }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      preservesValue = false and
      input = "Argument[self]" and
      output = "ReturnValue.Element[?]"
    }
  }

  /**
   * A flow summary for `String#encode(!)` and `String#unicode_normalize(!)`.
   */
  private class EncodeSummary extends SimpleSummarizedCallable {
    EncodeSummary() { this = ["encode", "unicode_normalize"] + ["", "!"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#force_encoding`.
   */
  private class ForceEncodingSummary extends SimpleSummarizedCallable {
    ForceEncodingSummary() { this = "force_encoding" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#freeze`.
   */
  private class FreezeSummary extends SimpleSummarizedCallable {
    FreezeSummary() { this = "freeze" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
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
    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      // receiver -> return value
      // replacement -> return value
      // block return -> return value
      preservesValue = false and
      output = "ReturnValue" and
      input = ["Argument[self]", "Argument[1]", "Argument[block].ReturnValue"]
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
      or
      input = "Argument[1]" and output = "ReturnValue" and preservesValue = false
    }
  }

  /**
   * A flow summary for `String#inspect`.
   */
  private class InspectSummary extends SimpleSummarizedCallable {
    InspectSummary() { this = "inspect" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#strip(!)`, `String#lstrip(!)` and `String#rstrip(!)`.
   */
  private class StripSummary extends SimpleSummarizedCallable {
    StripSummary() { this = ["strip", "lstrip", "rstrip"] + ["", "!"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#next(!)` and `String#succ(!)`.
   */
  private class NextSummary extends SimpleSummarizedCallable {
    NextSummary() { this = ["next", "succ"] + ["", "!"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#partition` and `String#rpartition`.
   */
  private class PartitionSummary extends SimpleSummarizedCallable {
    PartitionSummary() { this = ["partition", "rpartition"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue.Element[0,1,2]" and
      preservesValue = false
    }
  }

  /**
   * A flow summary for `String#replace`.
   */
  private class ReplaceSummary extends SimpleSummarizedCallable {
    ReplaceSummary() { this = "replace" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[0]" and
      output = ["ReturnValue", "Argument[self]"] and
      preservesValue = false
    }
    // TODO: we should also clear any existing content in Argument[self]
  }

  /**
   * A flow summary for `String#reverse(!)`.
   */
  private class ReverseSummary extends SimpleSummarizedCallable {
    ReverseSummary() { this = ["reverse", "reverse!"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#scan`.
   */
  abstract private class ScanSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    ScanSummary() { mc.getMethodName() = "scan" }

    final override MethodCall getACall() { result = mc }
  }

  private class ScanBlockSummary extends ScanSummary {
    ScanBlockSummary() { this = "scan_with_block" and exists(mc.getBlock()) }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      preservesValue = false and
      output =
        [
          // scan(pattern) -> array
          "ReturnValue",
          // scan(pattern) {|match, ...| block } -> str
          // Parameter[_] doesn't seem to work
          "Argument[block].Parameter[" + [0 .. 10] + "]"
        ]
    }
  }

  private class ScanNoBlockSummary extends ScanSummary {
    ScanNoBlockSummary() { this = "scan_no_block" and not exists(mc.getBlock()) }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      // scan(pattern) -> array
      input = "Argument[self]" and
      output = "ReturnValue.Element[?]" and
      preservesValue = false
    }
  }

  /**
   * A flow summary for `String#scrub(!)`.
   */
  abstract private class ScrubSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    ScrubSummary() { mc.getMethodName() = ["scrub", "scrub!"] }

    override MethodCall getACall() { result = mc }
  }

  private class ScrubBlockSummary extends ScrubSummary {
    ScrubBlockSummary() { this = "scrub_block" and exists(mc.getBlock()) }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
      or
      preservesValue = false and
      (
        input = "Argument[self]" and
        output = "Argument[block].Parameter[0]"
        or
        input = "Argument[0]" and output = "ReturnValue"
        or
        input = "Argument[block].ReturnValue" and
        output = "ReturnValue"
      )
    }
  }

  private class ScrubNoBlockSummary extends ScrubSummary {
    ScrubNoBlockSummary() { this = "scrub_no_block" and not exists(mc.getBlock()) }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
      or
      preservesValue = false and
      input = "Argument[0]" and
      output = "ReturnValue"
    }
  }

  /**
   * A flow summary for `String#shellescape`.
   */
  private class ShellescapeSummary extends SimpleSummarizedCallable {
    ShellescapeSummary() { this = "shellescape" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#shellsplit`.
   */
  private class ShellSplitSummary extends SimpleSummarizedCallable {
    ShellSplitSummary() { this = "shellsplit" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue.Element[?]" and
      preservesValue = false
    }
  }

  /**
   * A flow summary for `String#slice(!)`, `String#split` and `String#[]`.
   */
  private class SliceSummary extends SimpleSummarizedCallable {
    SliceSummary() { this = ["slice", "slice!", "split", "[]"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#squeeze(!)`.
   */
  private class SqueezeSummary extends SimpleSummarizedCallable {
    SqueezeSummary() { this = ["squeeze", "squeeze!"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#to_s` and `String.to_str`.
   */
  private class ToStrSummary extends SimpleSummarizedCallable {
    ToStrSummary() { this = ["to_str", "to_s"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
    }
  }

  /**
   * A flow summary for `String#tr`.
   */
  private class TrSummary extends SimpleSummarizedCallable {
    TrSummary() { this = ["tr", "tr_s"] + ["", "!"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
      or
      input = "Argument[1]" and output = "ReturnValue" and preservesValue = false
    }
  }

  /**
   * A flow summary for `String#upto`.
   * ```
   * String#upto(stop, exclusive=false, &block)
   * ```
   */
  abstract private class UptoSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    UptoSummary() { mc.getMethodName() = "upto" }

    override MethodCall getACall() { result = mc }
  }

  /**
   * A flow summary for `String#upto`, when `exclusive = false`.
   */
  private class UptoInclusiveSummary extends UptoSummary {
    UptoInclusiveSummary() {
      this = "upto_inclusive" and
      (not exists(mc.getArgument(1)) or mc.getArgument(1).getConstantValue().isBoolean(false))
    }

    // TODO: if second arg ('exclusive') is true, the first arg is excluded
    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      taintIdentityFlow(input, output, preservesValue)
      or
      input = ["Argument[self]", "Argument[0]"] and
      output = "Argument[block].Parameter[0]" and
      preservesValue = false
      or
      input = "Argument[block].ReturnValue" and
      output = "ReturnValue.Element[?]" and
      preservesValue = false
    }
  }

  /**
   * A flow summary for `String#upto`, when `exclusive = true`.
   */
  private class UptoExclusiveSummary extends UptoSummary {
    UptoExclusiveSummary() {
      this = "upto_exclusive" and
      mc.getArgument(1).getConstantValue().isBoolean(true)
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = false
      or
      input = "Argument[block].ReturnValue" and
      output = "ReturnValue.Element[?]" and
      preservesValue = false
    }
  }
}
