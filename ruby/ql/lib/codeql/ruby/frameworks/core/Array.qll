/** Provides flow summaries for the `Array` and `Enumerable` classes. */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.dataflow.internal.DataFlowDispatch

private class ArrayIndex extends int {
  ArrayIndex() { this = any(DataFlow::Content::KnownArrayElementContent c).getIndex() }
}

/**
 * Provides flow summaries for the `Array` class.
 *
 * The summaries are ordered (and implemented) based on
 * https://docs.ruby-lang.org/en/3.1/Array.html, however for methods that have the
 * more general `Enumerable` scope, they are implemented in the `Enumerable`
 * module instead.
 */
module Array {
  bindingset[arg]
  private DataFlow::Content::KnownArrayElementContent getKnownArrayElementContent(Expr arg) {
    result.getIndex() = arg.getConstantValue().getInt()
  }

  bindingset[arg]
  private predicate isUnknownArrayElementContent(Expr arg) {
    not exists(getKnownArrayElementContent(arg)) and
    not arg instanceof RangeLiteral
  }

  private class ArrayLiteralSummary extends SummarizedCallable {
    ArrayLiteralSummary() { this = "Array.[]" }

    override MethodCall getACall() {
      result = API::getTopLevelMember("Array").getAMethodCall("[]").getExprNode().getExpr()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      exists(ArrayIndex i |
        input = "Argument[" + i + "]" and
        output = "ReturnValue.ArrayElement[" + i + "]" and
        preservesValue = true
      )
    }
  }

  private class NewSummary extends SummarizedCallable {
    NewSummary() { this = "Array.new" }

    override MethodCall getACall() {
      result = API::getTopLevelMember("Array").getAnInstantiation().getExprNode().getExpr()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[1]" and
        output = "ReturnValue.ArrayElement[?]"
        or
        exists(ArrayIndex i |
          input = "Argument[0].ArrayElement[" + i + "]" and
          output = "ReturnValue.ArrayElement[" + i + "]"
        )
        or
        input = "Argument[0].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?]"
        or
        input = "Argument[block].ReturnValue" and
        output = "ReturnValue.ArrayElement[?]"
      ) and
      preservesValue = true
    }
  }

  private class TryConvertSummary extends SummarizedCallable {
    TryConvertSummary() { this = "Array.try_convert" }

    override MethodCall getACall() {
      result = API::getTopLevelMember("Array").getAMethodCall("try_convert").getExprNode().getExpr()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        exists(ArrayIndex i |
          input = "Argument[0].ArrayElement[" + i + "]" and
          output = "ReturnValue.ArrayElement[" + i + "]"
        )
        or
        input = "Argument[0].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?]"
      ) and
      preservesValue = true
    }
  }

  private class SetIntersectionSummary extends SummarizedCallable {
    SetIntersectionSummary() { this = "&" }

    override BitwiseAndExpr getACall() { any() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = ["Argument[self].ArrayElement", "Argument[0].ArrayElement"] and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class SetUnionSummary extends SummarizedCallable {
    SetUnionSummary() { this = "|" }

    override BitwiseOrExpr getACall() { any() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = ["Argument[self].ArrayElement", "Argument[0].ArrayElement"] and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class RepetitionSummary extends SummarizedCallable {
    RepetitionSummary() { this = "*" }

    override MulExpr getACall() { any() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class ConcatenationSummary extends SummarizedCallable {
    ConcatenationSummary() { this = "+" }

    override AddExpr getACall() { any() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        exists(ArrayIndex i |
          input = "Argument[self].ArrayElement[" + i + "]" and
          output = "ReturnValue.ArrayElement[" + i + "]"
        )
        or
        input = ["Argument[self].ArrayElement[?]", "Argument[0].ArrayElement"] and
        output = "ReturnValue.ArrayElement[?]"
      ) and
      preservesValue = true
    }
  }

  private class SetDifferenceSummary extends SummarizedCallable {
    SetDifferenceSummary() { this = "-" }

    override SubExpr getACall() { any() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  /** Flow summary for `Array#<<`. For `Array#append`, see `PushSummary`. */
  private class AppendOperatorSummary extends SummarizedCallable {
    AppendOperatorSummary() { this = "<<" }

    override LShiftExpr getACall() { any() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        exists(ArrayIndex i |
          input = "Argument[self].ArrayElement[" + i + "]" and
          output = "ReturnValue.ArrayElement[" + i + "]"
        )
        or
        input = "Argument[self].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?]"
        or
        input = "Argument[0]" and
        output = ["ReturnValue.ArrayElement[?]", "Argument[self].ArrayElement[?]"]
      ) and
      preservesValue = true
    }
  }

  /** A call to `[]`, or its alias, `slice`. */
  abstract private class ElementReferenceReadSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    ElementReferenceReadSummary() { mc.getMethodName() = ["[]", "slice"] }

    override MethodCall getACall() { result = mc }
  }

  /** A call to `[]` with a known index. */
  private class ElementReferenceReadKnownSummary extends ElementReferenceReadSummary {
    private int i;

    ElementReferenceReadKnownSummary() {
      this = mc.getMethodName() + "(" + i + ")" and
      mc.getNumberOfArguments() = 1 and
      i = getKnownArrayElementContent(mc.getArgument(0)).getIndex()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement[" + [i.toString(), "?"] + "]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  /**
   * A call to `[]` with an unknown argument, which could be either an index or
   * a range.
   */
  private class ElementReferenceReadUnknownSummary extends ElementReferenceReadSummary {
    ElementReferenceReadUnknownSummary() {
      this = mc.getMethodName() + "(index)" and
      mc.getNumberOfArguments() = 1 and
      isUnknownArrayElementContent(mc.getArgument(0))
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["ReturnValue", "ReturnValue.ArrayElement[?]"] and
      preservesValue = true
    }
  }

  /** A call to `[]` with two known arguments or a known range argument. */
  private class ElementReferenceRangeReadKnownSummary extends ElementReferenceReadSummary {
    int start;
    int end;

    ElementReferenceRangeReadKnownSummary() {
      mc.getNumberOfArguments() = 2 and
      start = getKnownArrayElementContent(mc.getArgument(0)).getIndex() and
      exists(int length | mc.getArgument(1).getConstantValue().isInt(length) |
        end = (start + length - 1) and
        this = "[](" + start + ", " + length + ")"
      )
      or
      mc.getNumberOfArguments() = 1 and
      exists(RangeLiteral rl |
        rl = mc.getArgument(0) and
        (
          // Either an explicit, positive beginning index...
          start = rl.getBegin().getConstantValue().getInt() and start >= 0
          or
          // Or a begin-less one, since `..n` is equivalent to `0..n`
          not exists(rl.getBegin()) and start = 0
        ) and
        // There must be an explicit end. An end-less range like `2..` is not
        // treated as a known range, since we don't track the length of the array.
        exists(int e | e = rl.getEnd().getConstantValue().getInt() and e >= 0 |
          rl.isInclusive() and end = e
          or
          rl.isExclusive() and end = e - 1
        ) and
        this = "[](" + start + ".." + end + ")"
      )
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      preservesValue = true and
      (
        input = "Argument[self].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?]"
        or
        exists(ArrayIndex i | i >= start and i <= end |
          input = "Argument[self].ArrayElement[" + i + "]" and
          output = "ReturnValue.ArrayElement[" + (i - start) + "]"
        )
      )
    }
  }

  /**
   * A call to `[]` with two arguments or a range argument, where at least one
   * of the start and end/length is unknown.
   */
  private class ElementReferenceRangeReadUnknownSummary extends ElementReferenceReadSummary {
    ElementReferenceRangeReadUnknownSummary() {
      this = "[](range_unknown)" and
      (
        mc.getNumberOfArguments() = 2 and
        (
          not mc.getArgument(0).getConstantValue().isInt(_) or
          not mc.getArgument(1).getConstantValue().isInt(_)
        )
        or
        mc.getNumberOfArguments() = 1 and
        exists(RangeLiteral rl | rl = mc.getArgument(0) |
          exists(rl.getBegin()) and
          not exists(int b | b = rl.getBegin().getConstantValue().getInt() and b >= 0)
          or
          not exists(int e | e = rl.getEnd().getConstantValue().getInt() and e >= 0)
        )
      )
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  /** A call to `[]=`. */
  abstract private class ElementReferenceStoreSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    ElementReferenceStoreSummary() { mc.getMethodName() = "[]=" }

    final override MethodCall getACall() { result = mc }
  }

  /** A call to `[]=` with a known index. */
  private class ElementReferenceStoreKnownSummary extends ElementReferenceStoreSummary {
    private DataFlow::Content::KnownArrayElementContent c;

    ElementReferenceStoreKnownSummary() {
      mc.getNumberOfArguments() = 2 and
      c = getKnownArrayElementContent(mc.getArgument(0)) and
      this = "[" + c.getIndex() + "]="
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[1]" and
      output = "Argument[self].ArrayElement[" + c.getIndex() + "]" and
      preservesValue = true
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isSingleton(c)
    }
  }

  /** A call to `[]=` with an unknown index. */
  private class ElementReferenceStoreUnknownSummary extends ElementReferenceStoreSummary {
    ElementReferenceStoreUnknownSummary() {
      mc.getNumberOfArguments() = 2 and
      isUnknownArrayElementContent(mc.getArgument(0)) and
      this = "[]="
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[1]" and
      output = "Argument[self].ArrayElement[?]" and
      preservesValue = true
    }
  }

  /** A call to `[]=` with two arguments or a range argument. */
  private class ElementReferenceSliceStoreUnknownSummary extends ElementReferenceStoreSummary {
    ElementReferenceSliceStoreUnknownSummary() {
      this = "[]=(slice)" and
      (
        mc.getNumberOfArguments() > 2
        or
        mc.getNumberOfArguments() = 2 and
        mc.getArgument(0) instanceof RangeLiteral
      )
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      // We model this imprecisely, saying that there's flow from any element of
      // the argument or the receiver to any element of the receiver. This could
      // be made more precise when the range is known, similar to the way it's
      // done in `ElementReferenceRangeReadKnownSummary`.
      exists(string arg |
        arg = "Argument[" + (mc.getNumberOfArguments() - 1) + "]" and
        input = [arg + ".ArrayElement", arg, "Argument[self].ArrayElement"] and
        output = "Argument[self].ArrayElement[?]" and
        preservesValue = true
      )
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  private class AssocSummary extends SimpleSummarizedCallable {
    AssocSummary() { this = ["assoc", "rassoc"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement.ArrayElement" and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  abstract private class AtSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    AtSummary() { mc.getMethodName() = "at" }

    override MethodCall getACall() { result = mc }
  }

  private class AtKnownSummary extends AtSummary {
    private int i;

    AtKnownSummary() {
      this = "at(" + i + "]" and
      mc.getNumberOfArguments() = 1 and
      i = getKnownArrayElementContent(mc.getArgument(0)).getIndex()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement[" + [i.toString(), "?"] + "]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class AtUnknownSummary extends AtSummary {
    AtUnknownSummary() {
      this = "at" and
      mc.getNumberOfArguments() = 1 and
      isUnknownArrayElementContent(mc.getArgument(0))
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class BSearchSummary extends SimpleSummarizedCallable {
    BSearchSummary() { this = "bsearch" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["Argument[block].Parameter[0]", "ReturnValue"] and
      preservesValue = true
    }
  }

  private class BSearchIndexSummary extends SimpleSummarizedCallable {
    BSearchIndexSummary() { this = "bsearch_index" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  private class ClearSummary extends SimpleSummarizedCallable {
    ClearSummary() { this = "clear" }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  private class CollectBangSummary extends SimpleSummarizedCallable {
    // `map!` is an alias of `collect!`.
    CollectBangSummary() { this = ["collect!", "map!"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
      or
      input = "Argument[block].ReturnValue" and
      output = ["ReturnValue.ArrayElement[?]", "Argument[self].ArrayElement[?]"] and
      preservesValue = true
    }
  }

  private class CombinationSummary extends SimpleSummarizedCallable {
    CombinationSummary() { this = "combination" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement" and
        output = "Argument[block].Parameter[0].ArrayElement[?]"
        or
        input = "Argument[self]" and output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class CompactBangSummary extends SimpleSummarizedCallable {
    CompactBangSummary() { this = "compact!" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["ReturnValue.ArrayElement[?]", "Argument[self].ArrayElement[?]"] and
      preservesValue = true
    }
  }

  private class ConcatSummary extends SimpleSummarizedCallable {
    ConcatSummary() { this = "concat" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[0..].ArrayElement" and
      output = "Argument[self].ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class DeconstructSummary extends SimpleSummarizedCallable {
    DeconstructSummary() { this = "deconstruct" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      // The documentation of `deconstruct` is blank, but the implementation
      // shows that it just returns the receiver, unchanged:
      // https://github.com/ruby/ruby/blob/71bc99900914ef3bc3800a22d9221f5acf528082/array.c#L7810-L7814.
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class DeleteSummary extends SimpleSummarizedCallable {
    DeleteSummary() { this = "delete" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement" and
        output = ["Argument[self].ArrayElement[?]", "ReturnValue"]
        or
        input = "Argument[block].ReturnValue" and
        output = "ReturnValue"
      ) and
      preservesValue = true
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  abstract private class DeleteAtSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    DeleteAtSummary() { mc.getMethodName() = "delete_at" }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }

    override MethodCall getACall() { result = mc }
  }

  private class DeleteAtKnownSummary extends DeleteAtSummary {
    int i;

    DeleteAtKnownSummary() {
      this = "delete_at(" + i + ")" and
      mc.getArgument(0).getConstantValue().isInt(i) and
      i >= 0
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement[?]" and
        output = ["ReturnValue", "Argument[self].ArrayElement[?]"]
        or
        exists(ArrayIndex j | input = "Argument[self].ArrayElement[" + j + "]" |
          j < i and output = "Argument[self].ArrayElement[" + j + "]"
          or
          j = i and output = "ReturnValue"
          or
          j > i and output = "Argument[self].ArrayElement[" + (j - 1) + "]"
        )
      ) and
      preservesValue = true
    }
  }

  private class DeleteAtUnknownSummary extends DeleteAtSummary {
    DeleteAtUnknownSummary() {
      this = "delete_at(index)" and
      not exists(int i | mc.getArgument(0).getConstantValue().isInt(i) and i >= 0)
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["ReturnValue", "Argument[self].ArrayElement[?]"] and
      preservesValue = true
    }
  }

  private class DeleteIfSummary extends SimpleSummarizedCallable {
    DeleteIfSummary() { this = "delete_if" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output =
        [
          "Argument[block].Parameter[0]", "ReturnValue.ArrayElement[?]",
          "Argument[self].ArrayElement[?]"
        ] and
      preservesValue = true
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  private class DifferenceSummary extends SimpleSummarizedCallable {
    DifferenceSummary() { this = "difference" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      // `Array#difference` and `Array#-` do not behave exactly the same way,
      // but we model their flow the same way.
      any(SetDifferenceSummary s).propagatesFlowExt(input, output, preservesValue)
    }
  }

  private string getDigArg(MethodCall dig, int i) {
    dig.getMethodName() = "dig" and
    exists(Expr arg | arg = dig.getArgument(i) |
      result = arg.getConstantValue().getInt().toString()
      or
      not exists(arg.getConstantValue()) and
      result = "?"
    )
  }

  private class RelevantDigMethodCall extends MethodCall {
    RelevantDigMethodCall() {
      forall(int i | i in [0 .. this.getNumberOfArguments() - 1] | exists(getDigArg(this, i)))
    }
  }

  private string buildDigInputSpecComponent(RelevantDigMethodCall dig, int i) {
    exists(string s |
      s = getDigArg(dig, i) and
      if s = "?" then result = "" else result = "[" + [s, "?"] + "]"
    )
  }

  language[monotonicAggregates]
  private string buildDigInputSpec(RelevantDigMethodCall dig) {
    result =
      strictconcat(int i |
        i in [0 .. dig.getNumberOfArguments() - 1]
      |
        ".ArrayElement" + buildDigInputSpecComponent(dig, i) order by i
      )
  }

  private class DigSummary extends SummarizedCallable {
    private RelevantDigMethodCall dig;

    DigSummary() {
      this =
        "dig(" +
          strictconcat(int i |
            i in [0 .. dig.getNumberOfArguments() - 1]
          |
            getDigArg(dig, i), "," order by i
          ) + ")"
    }

    override MethodCall getACall() { result = dig }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self]" + buildDigInputSpec(dig) and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class EachSummary extends SimpleSummarizedCallable {
    // `each` and `reverse_each` are the same in terms of flow inputs/outputs.
    EachSummary() { this = ["each", "reverse_each"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement" and
        output = "Argument[block].Parameter[0]"
        or
        input = "Argument[self].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?]"
        or
        exists(ArrayIndex i |
          input = "Argument[self].ArrayElement[" + i + "]" and
          output = "ReturnValue.ArrayElement[" + i + "]"
        )
      ) and
      preservesValue = true
    }
  }

  private class EachIndexSummary extends SimpleSummarizedCallable {
    EachIndexSummary() { this = "each_index" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?]"
        or
        exists(ArrayIndex i |
          input = "Argument[self].ArrayElement[" + i + "]" and
          output = "ReturnValue.ArrayElement[" + i + "]"
        )
      ) and
      preservesValue = true
    }
  }

  abstract private class FetchSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    FetchSummary() { mc.getMethodName() = "fetch" }

    override MethodCall getACall() { result = mc }
  }

  private class FetchKnownSummary extends FetchSummary {
    int i;

    FetchKnownSummary() {
      this = "fetch(" + i + ")" and
      mc.getArgument(0).getConstantValue().isInt(i) and
      i >= 0
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement[?]" and
        output = ["ReturnValue", "Argument[self].ArrayElement[?]"]
        or
        exists(ArrayIndex j | input = "Argument[self].ArrayElement[" + j + "]" |
          j = i and output = "ReturnValue"
          or
          j != i and output = "Argument[self].ArrayElement[" + j + "]"
        )
        or
        input = "Argument[0]" and
        output = "Argument[block].Parameter[0]"
        or
        input = "Argument[1]" and output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class FetchUnknownSummary extends FetchSummary {
    FetchUnknownSummary() {
      this = "fetch(index)" and
      not exists(int i | mc.getArgument(0).getConstantValue().isInt(i) and i >= 0)
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = ["Argument[self].ArrayElement", "Argument[1]"] and
        output = "ReturnValue"
        or
        input = "Argument[0]" and
        output = "Argument[block].Parameter[0]"
      ) and
      preservesValue = true
    }
  }

  abstract private class FillSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    FillSummary() { mc.getMethodName() = "fill" }

    override MethodCall getACall() { result = mc }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = ["Argument[0]", "Argument[block].ReturnValue"] and
      output = "Argument[self].ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class FillAllSummary extends FillSummary {
    FillAllSummary() {
      this = "fill(all)" and
      if exists(mc.getBlock()) then mc.getNumberOfArguments() = 0 else mc.getNumberOfArguments() = 1
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  private class FillSomeSummary extends FillSummary {
    FillSomeSummary() {
      this = "fill(some)" and
      if exists(mc.getBlock()) then mc.getNumberOfArguments() > 0 else mc.getNumberOfArguments() > 1
    }
  }

  /**
   * A call to `flatten`.
   *
   * Note that we model flow from elements up to 3 levels of nesting
   * (`[[[1],[2]]]`), but not beyond that.
   */
  private class FlattenSummary extends SimpleSummarizedCallable {
    FlattenSummary() { this = "flatten" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input =
          [
            "Argument[self].ArrayElement", "Argument[self].ArrayElement.ArrayElement",
            "Argument[self].ArrayElement.ArrayElement.ArrayElement"
          ] and
        output = "ReturnValue.ArrayElement[?]"
      ) and
      preservesValue = true
    }
  }

  private class FlattenBangSummary extends SimpleSummarizedCallable {
    FlattenBangSummary() { this = "flatten!" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input =
          [
            "Argument[self].ArrayElement", "Argument[self].ArrayElement.ArrayElement",
            "Argument[self].ArrayElement.ArrayElement.ArrayElement"
          ] and
        output = ["Argument[self].ArrayElement[?]", "ReturnValue.ArrayElement[?]"]
      ) and
      preservesValue = true
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  private class IndexSummary extends SimpleSummarizedCallable {
    IndexSummary() { this = ["index", "rindex"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  abstract private class InsertSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    InsertSummary() { mc.getMethodName() = "insert" }

    override MethodCall getACall() { result = mc }
  }

  private class InsertKnownSummary extends InsertSummary {
    private int i;

    InsertKnownSummary() {
      this = "insert(" + i + ")" and
      mc.getArgument(0).getConstantValue().isInt(i)
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      exists(int numValues, string r |
        numValues = mc.getNumberOfArguments() - 1 and
        r = ["ReturnValue", "Argument[self]"] and
        preservesValue = true
      |
        input = "Argument[self].ArrayElement[?]" and
        output = r + ".ArrayElement[?]"
        or
        exists(ArrayIndex j |
          // Existing elements before the insertion point are unaffected.
          j < i and
          input = "Argument[self].ArrayElement[" + j + "]" and
          output = r + ".ArrayElement[" + j + "]"
          or
          // Existing elements after the insertion point are shifted by however
          // many values we're inserting.
          j >= i and
          input = "Argument[self].ArrayElement[" + j + "]" and
          output = r + ".ArrayElement[" + (j + numValues) + "]"
        )
        or
        exists(int j | j in [1 .. numValues] |
          input = "Argument[" + j + "]" and
          output = r + ".ArrayElement[" + (i + j - 1) + "]"
        )
      )
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  private class InsertUnknownSummary extends InsertSummary {
    InsertUnknownSummary() {
      this = "insert(index)" and
      not mc.getArgument(0).getConstantValue().isInt(_)
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement"
        or
        exists(int j | j in [1 .. mc.getNumberOfArguments() - 1] | input = "Argument[" + j + "]")
      ) and
      output = ["ReturnValue", "Argument[self]"] + ".ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class IntersectionSummary extends SummarizedCallable {
    MethodCall mc;

    IntersectionSummary() { this = "intersection" and mc.getMethodName() = this }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement"
        or
        exists(int i | i in [0 .. mc.getNumberOfArguments() - 1] |
          input = "Argument[" + i + "].ArrayElement"
        )
      ) and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }

    override MethodCall getACall() { result = mc }
  }

  private class KeepIfSummary extends SimpleSummarizedCallable {
    KeepIfSummary() { this = "keep_if" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output =
        [
          "ReturnValue.ArrayElement[?]", "Argument[self].ArrayElement[?]",
          "Argument[block].Parameter[0]"
        ] and
      preservesValue = true
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  abstract private class LastSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    LastSummary() { mc.getMethodName() = "last" }

    override MethodCall getACall() { result = mc }
  }

  private class LastNoArgSummary extends LastSummary {
    LastNoArgSummary() { this = "last(no_arg)" and mc.getNumberOfArguments() = 0 }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class LastArgSummary extends LastSummary {
    LastArgSummary() { this = "last(arg)" and mc.getNumberOfArguments() > 0 }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class PackSummary extends SimpleSummarizedCallable {
    PackSummary() { this = "pack" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  private class PermutationSummary extends SimpleSummarizedCallable {
    PermutationSummary() { this = ["permutation", "repeated_combination", "repeated_permutation"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement" and
        output = "Argument[block].Parameter[0].ArrayElement[?]"
        or
        input = "Argument[self]" and
        output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  abstract private class PopSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    PopSummary() { mc.getMethodName() = "pop" }

    override MethodCall getACall() { result = mc }
  }

  private class PopNoArgSummary extends PopSummary {
    PopNoArgSummary() { this = "pop(no_arg)" and mc.getNumberOfArguments() = 0 }

    // We don't track the length of the array, so we can't model that this
    // clears the last element of the receiver, and we can't be precise about
    // which particular element flows to the return value.
    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class PopArgSummary extends PopSummary {
    PopArgSummary() { this = "pop(arg)" and mc.getNumberOfArguments() > 0 }

    // We don't track the length of the array, so we can't model that this
    // clears elements from the end of the receiver, and we can't be precise
    // about which particular elements flow to the return value.
    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class PrependSummary extends SummarizedCallable {
    private MethodCall mc;

    // `unshift` is an alias for `prepend`
    PrependSummary() {
      mc.getMethodName() = ["prepend", "unshift"] and
      this = mc.getMethodName() + "(" + mc.getNumberOfArguments() + ")"
    }

    override MethodCall getACall() { result = mc }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      exists(int num | num = mc.getNumberOfArguments() and preservesValue = true |
        exists(ArrayIndex i |
          input = "Argument[self].ArrayElement[" + i + "]" and
          output = "Argument[self].ArrayElement[" + (i + num) + "]"
        )
        or
        input = "Argument[self].ArrayElement[?]" and
        output = "Argument[self].ArrayElement[?]"
        or
        exists(int i | i in [0 .. (num - 1)] |
          input = "Argument[" + i + "]" and
          output = "Argument[self].ArrayElement[" + i + "]"
        )
      )
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  private class ProductSummary extends SimpleSummarizedCallable {
    ProductSummary() { this = "product" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement"
        or
        exists(int i | i in [0 .. (mc.getNumberOfArguments() - 1)] |
          input = "Argument[" + i + "].ArrayElement"
        )
      ) and
      output = "ReturnValue.ArrayElement[?].ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class PushSummary extends SimpleSummarizedCallable {
    // `append` is an alias for `push`
    PushSummary() { this = ["push", "append"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        exists(ArrayIndex i |
          input = "Argument[self].ArrayElement[" + i + "]" and
          output = "ReturnValue.ArrayElement[" + i + "]"
        )
        or
        input = "Argument[self].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?]"
        or
        exists(int i | i in [0 .. (mc.getNumberOfArguments() - 1)] |
          input = "Argument[" + i + "]" and
          output = ["ReturnValue.ArrayElement[?]", "Argument[self].ArrayElement[?]"]
        )
      ) and
      preservesValue = true
    }
  }

  private class RejectBangSummary extends SimpleSummarizedCallable {
    RejectBangSummary() { this = "reject!" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output =
        [
          "ReturnValue.ArrayElement[?]", "Argument[self].ArrayElement[?]",
          "Argument[block].Parameter[0]"
        ] and
      preservesValue = true
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  private class ReplaceSummary extends SimpleSummarizedCallable {
    ReplaceSummary() { this = "replace" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      exists(string r | r = ["ReturnValue", "Argument[self]"] and preservesValue = true |
        input = "Argument[0].ArrayElement[?]" and
        output = r + ".ArrayElement[?]"
        or
        exists(ArrayIndex i |
          input = "Argument[0].ArrayElement[" + i + "]" and
          output = r + ".ArrayElement[" + i + "]"
        )
      )
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  private class ReverseSummary extends SimpleSummarizedCallable {
    ReverseSummary() { this = "reverse" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class ReverseBangSummary extends SimpleSummarizedCallable {
    ReverseBangSummary() { this = "reverse!" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["Argument[self]", "ReturnValue"] + ".ArrayElement[?]" and
      preservesValue = true
    }
  }

  abstract private class RotateSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    RotateSummary() { mc.getMethodName() = "rotate" }

    override MethodCall getACall() { result = mc }
  }

  private class RotateKnownSummary extends RotateSummary {
    private int c;

    RotateKnownSummary() {
      mc.getArgument(0).getConstantValue().isInt(c) and
      this = "rotate(" + c + ")"
      or
      not exists(mc.getArgument(0)) and c = 1 and this = "rotate"
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      preservesValue = true and
      (
        input = "Argument[self].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?]"
        or
        exists(ArrayIndex i |
          input = "Argument[self].ArrayElement[" + i + "]" and
          (
            i < c and output = "ReturnValue.ArrayElement[?]"
            or
            i >= c and output = "ReturnValue.ArrayElement[" + (i - c) + "]"
          )
        )
      )
    }
  }

  private class RotateUnknownSummary extends RotateSummary {
    RotateUnknownSummary() {
      this = "rotate(index)" and
      exists(mc.getArgument(0)) and
      not mc.getArgument(0).getConstantValue().isInt(_)
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  abstract private class RotateBangSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    RotateBangSummary() { mc.getMethodName() = "rotate!" }

    override MethodCall getACall() { result = mc }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  private class RotateBangKnownSummary extends RotateBangSummary {
    private int c;

    RotateBangKnownSummary() {
      mc.getArgument(0).getConstantValue().isInt(c) and
      this = "rotate!(" + c + ")"
      or
      not exists(mc.getArgument(0)) and c = 1 and this = "rotate!"
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      exists(string r | r = ["Argument[self]", "ReturnValue"] and preservesValue = true |
        input = "Argument[self].ArrayElement[?]" and
        output = r + ".ArrayElement[?]"
        or
        exists(ArrayIndex i |
          input = "Argument[self].ArrayElement[" + i + "]" and
          (
            i < c and output = r + ".ArrayElement[?]"
            or
            i >= c and output = r + ".ArrayElement[" + (i - c) + "]"
          )
        )
      )
    }
  }

  private class RotateBangUnknownSummary extends RotateBangSummary {
    RotateBangUnknownSummary() {
      this = "rotate!(index)" and
      exists(mc.getArgument(0)) and
      not mc.getArgument(0).getConstantValue().isInt(_)
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["Argument[self].ArrayElement[?]", "ReturnValue.ArrayElement[?]"] and
      preservesValue = true
    }
  }

  private class SelectBangSummary extends SimpleSummarizedCallable {
    // `filter!` is an alias for `select!`
    SelectBangSummary() { this = ["select!", "filter!"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output =
        [
          "Argument[block].Parameter[0]", "Argument[self].ArrayElement[?]",
          "ReturnValue.ArrayElement[?]"
        ] and
      preservesValue = true
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  abstract private class ShiftSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    ShiftSummary() { mc.getMethodName() = "shift" }

    override MethodCall getACall() { result = mc }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  private class ShiftNoArgSummary extends ShiftSummary {
    ShiftNoArgSummary() { this = "shift" and not exists(mc.getArgument(0)) }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      preservesValue = true and
      (
        input = "Argument[self].ArrayElement[?]" and
        output = ["ReturnValue", "Argument[self].ArrayElement[?]"]
        or
        exists(ArrayIndex i | input = "Argument[self].ArrayElement[" + i + "]" |
          i = 0 and output = "ReturnValue"
          or
          i > 0 and output = "Argument[self].ArrayElement[" + (i - 1) + "]"
        )
      )
    }
  }

  private class ShiftArgKnownSummary extends ShiftSummary {
    private int n;

    ShiftArgKnownSummary() {
      mc.getArgument(0).getConstantValue().isInt(n) and
      this = "shift(" + n + ")"
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      preservesValue = true and
      (
        input = "Argument[self].ArrayElement[?]" and
        output = ["ReturnValue.ArrayElement[?]", "Argument[self].ArrayElement[?]"]
        or
        exists(ArrayIndex i | input = "Argument[self].ArrayElement[" + i + "]" |
          i < n and output = "ReturnValue.ArrayElement[" + i + "]"
          or
          i >= n and output = "Argument[self].ArrayElement[" + (i - n) + "]"
        )
      )
    }
  }

  private class ShiftArgUnknownSummary extends ShiftSummary {
    ShiftArgUnknownSummary() {
      this = "shift(index)" and
      exists(mc.getArgument(0)) and
      not mc.getArgument(0).getConstantValue().isInt(_)
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["Argument[self].ArrayElement[?]", "ReturnValue.ArrayElement[?]"] and
      preservesValue = true
    }
  }

  private class ShuffleSummary extends SimpleSummarizedCallable {
    ShuffleSummary() { this = "shuffle" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class ShuffleBangSummary extends SimpleSummarizedCallable {
    ShuffleBangSummary() { this = "shuffle!" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["ReturnValue.ArrayElement[?]", "Argument[self].ArrayElement[?]"] and
      preservesValue = true
    }
  }

  abstract private class SliceBangSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    SliceBangSummary() { mc.getMethodName() = "slice!" }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }

    override Call getACall() { result = mc }
  }

  /** A call to `slice!` with a known integer index. */
  private class SliceBangKnownIndexSummary extends SliceBangSummary {
    int n;

    SliceBangKnownIndexSummary() {
      this = "slice!(" + n + ")" and
      mc.getNumberOfArguments() = 1 and
      n = getKnownArrayElementContent(mc.getArgument(0)).getIndex()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      preservesValue = true and
      (
        input = "Argument[self].ArrayElement[?]" and
        output = ["ReturnValue", "Argument[self].ArrayElement[?]"]
        or
        exists(ArrayIndex i | input = "Argument[self].ArrayElement[" + i + "]" |
          i < n and output = "Argument[self].ArrayElement[" + i + "]"
          or
          i = n and output = "ReturnValue"
          or
          i > n and output = "Argument[self].ArrayElement[" + (i - 1) + "]"
        )
      )
    }
  }

  /**
   * A call to `slice!` with a single, unknown argument, which could be either
   * an integer index or a range.
   */
  private class SliceBangUnknownSummary extends SliceBangSummary {
    SliceBangUnknownSummary() {
      this = "slice!(index)" and
      mc.getNumberOfArguments() = 1 and
      isUnknownArrayElementContent(mc.getArgument(0))
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output =
        [
          "Argument[self].ArrayElement[?]",
          "ReturnValue.ArrayElement[?]", // Return value is an array if the argument is a range
          "ReturnValue" // Return value is an element if the argument is an integer
        ] and
      preservesValue = true
    }
  }

  /** A call to `slice!` with two known arguments or a known range argument. */
  private class SliceBangRangeKnownSummary extends SliceBangSummary {
    int start;
    int end;

    SliceBangRangeKnownSummary() {
      mc.getNumberOfArguments() = 2 and
      start = getKnownArrayElementContent(mc.getArgument(0)).getIndex() and
      exists(int length | mc.getArgument(1).getConstantValue().isInt(length) |
        end = (start + length - 1) and
        this = "slice!(" + start + ", " + length + ")"
      )
      or
      mc.getNumberOfArguments() = 1 and
      exists(RangeLiteral rl |
        rl = mc.getArgument(0) and
        (
          start = rl.getBegin().getConstantValue().getInt() and start >= 0
          or
          not exists(rl.getBegin()) and start = 0
        ) and
        exists(int e | e = rl.getEnd().getConstantValue().getInt() and e >= 0 |
          rl.isInclusive() and end = e
          or
          rl.isExclusive() and end = e - 1
        ) and
        this = "slice!(" + start + ".." + end + ")"
      )
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      preservesValue = true and
      (
        input = "Argument[self].ArrayElement[?]" and
        output = ["ReturnValue.ArrayElement[?]", "Argument[self].ArrayElement[?]"]
        or
        exists(ArrayIndex i | input = "Argument[self].ArrayElement[" + i + "]" |
          i < start and output = "Argument[self].ArrayElement[" + i + "]"
          or
          i >= start and i <= end and output = "ReturnValue.ArrayElement[" + (i - start) + "]"
          or
          i > end and output = "Argument[self].ArrayElement[" + (i - (end - start + 1)) + "]"
        )
      )
    }
  }

  /**
   * A call to `slice!` with two arguments or a range argument, where at least one
   * of the start and end/length is unknown.
   */
  private class SliceBangRangeUnknownSummary extends SliceBangSummary {
    SliceBangRangeUnknownSummary() {
      this = "slice!(range_unknown)" and
      (
        mc.getNumberOfArguments() = 2 and
        (
          not mc.getArgument(0).getConstantValue().isInt(_) or
          not mc.getArgument(1).getConstantValue().isInt(_)
        )
        or
        mc.getNumberOfArguments() = 1 and
        exists(RangeLiteral rl | rl = mc.getArgument(0) |
          exists(rl.getBegin()) and
          not exists(int b | b = rl.getBegin().getConstantValue().getInt() and b >= 0)
          or
          not exists(int e | e = rl.getEnd().getConstantValue().getInt() and e >= 0)
        )
      )
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["Argument[self].ArrayElement[?]", "ReturnValue.ArrayElement[?]"] and
      preservesValue = true
    }
  }

  private class SortBangSummary extends SimpleSummarizedCallable {
    SortBangSummary() { this = "sort!" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output =
        [
          "Argument[block].Parameter[0]", "Argument[block].Parameter[1]",
          "Argument[self].ArrayElement[?]", "ReturnValue.ArrayElement[?]"
        ] and
      preservesValue = true
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  private class SortByBangSummary extends SimpleSummarizedCallable {
    SortByBangSummary() { this = "sort_by!" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output =
        [
          "Argument[block].Parameter[0]", "Argument[self].ArrayElement[?]",
          "ReturnValue.ArrayElement[?]"
        ] and
      preservesValue = true
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  private class TransposeSummary extends SimpleSummarizedCallable {
    TransposeSummary() { this = "transpose" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      preservesValue = true and
      (
        input = "Argument[self].ArrayElement[?].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?].ArrayElement[?]"
        or
        exists(ArrayIndex i, ArrayIndex j |
          input = "Argument[self].ArrayElement[" + j + "].ArrayElement[" + i + "]" and
          output = "ReturnValue.ArrayElement[" + i + "].ArrayElement[" + j + "]"
        )
      )
    }
  }

  private class UniqBangSummary extends SimpleSummarizedCallable {
    UniqBangSummary() { this = "uniq!" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output =
        [
          "Argument[self].ArrayElement[?]", "ReturnValue.ArrayElement[?]",
          "Argument[block].Parameter[0]"
        ] and
      preservesValue = true
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::ContentSet content) {
      pos.isSelf() and
      content.isAnyArrayElement()
    }
  }

  private class UnionSummary extends SimpleSummarizedCallable {
    UnionSummary() { this = "union" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement"
        or
        exists(int i | i in [0 .. mc.getNumberOfArguments() - 1] |
          input = "Argument[" + i + "].ArrayElement"
        )
      ) and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  abstract private class ValuesAtSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    ValuesAtSummary() { mc.getMethodName() = "values_at" }

    override Call getACall() { result = mc }
  }

  /**
   * A call to `values_at` where all the arguments are known, positive integers.
   */
  private class ValuesAtKnownSummary extends ValuesAtSummary {
    ValuesAtKnownSummary() {
      this = "values_at(known)" and
      forall(int i | i in [0 .. mc.getNumberOfArguments() - 1] |
        mc.getArgument(i).getConstantValue().getInt() >= 0
      )
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      preservesValue = true and
      (
        input = "Argument[self].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?]"
        or
        exists(ArrayIndex elementIndex, int argIndex |
          argIndex in [0 .. mc.getNumberOfArguments() - 1] and
          mc.getArgument(argIndex).getConstantValue().isInt(elementIndex)
        |
          input = "Argument[self].ArrayElement[" + elementIndex + "]" and
          output = "ReturnValue.ArrayElement[" + argIndex + "]"
        )
      )
    }
  }

  /**
   * A call to `values_at` where at least one of the arguments is not a known,
   * positive integer.
   */
  private class ValuesAtUnknownSummary extends ValuesAtSummary {
    ValuesAtUnknownSummary() {
      this = "values_at(unknown)" and
      exists(int i | i in [0 .. mc.getNumberOfArguments() - 1] |
        not exists(int val | mc.getArgument(i).getConstantValue().isInt(val) and val >= 0)
      )
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }
}

/**
 * Provides flow summaries for the `Enumerable` class.
 *
 * The summaries are ordered (and implemented) based on
 * https://docs.ruby-lang.org/en/3.1/Enumerable.html
 */
module Enumerable {
  private class ChunkSummary extends SimpleSummarizedCallable {
    ChunkSummary() { this = "chunk" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  private class ChunkWhileSummary extends SimpleSummarizedCallable {
    ChunkWhileSummary() { this = "chunk_while" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["Argument[block].Parameter[0]", "Argument[block].Parameter[1]"] and
      preservesValue = true
    }
  }

  private class CollectSummary extends SimpleSummarizedCallable {
    // `map` is an alias of `collect`.
    CollectSummary() { this = ["collect", "map"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
      or
      input = "Argument[block].ReturnValue" and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class CollectConcatSummary extends SimpleSummarizedCallable {
    // `flat_map` is an alias of `collect_concat`.
    CollectConcatSummary() { this = ["collect_concat", "flat_map"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
      or
      input = ["Argument[block].ReturnValue.ArrayElement", "Argument[block].ReturnValue"] and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class CompactSummary extends SimpleSummarizedCallable {
    CompactSummary() { this = "compact" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class CountSummary extends SimpleSummarizedCallable {
    CountSummary() { this = "count" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  private class CycleSummary extends SimpleSummarizedCallable {
    CycleSummary() { this = "cycle" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  private class DetectSummary extends SimpleSummarizedCallable {
    // `find` is an alias of `detect`.
    DetectSummary() { this = ["detect", "find"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement" and
        output = ["Argument[block].Parameter[0]", "ReturnValue"]
        or
        input = "Argument[0].ReturnValue" and
        output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  abstract private class DropSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    DropSummary() { mc.getMethodName() = "drop" }

    override MethodCall getACall() { result = mc }
  }

  private class DropKnownSummary extends DropSummary {
    private int i;

    DropKnownSummary() {
      this = "drop(" + i + ")" and
      mc.getArgument(0).getConstantValue().isInt(i)
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?]"
        or
        exists(ArrayIndex j |
          input = "Argument[self].ArrayElement[" + j + "]" and
          output = "ReturnValue.ArrayElement[" + (j - i) + "]"
        )
      ) and
      preservesValue = true
    }
  }

  private class DropUnknownSummary extends DropSummary {
    DropUnknownSummary() {
      this = "drop(index)" and
      not mc.getArgument(0).getConstantValue().isInt(_)
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class DropWhileSummary extends SimpleSummarizedCallable {
    DropWhileSummary() { this = "drop_while" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["ReturnValue.ArrayElement[?]", "Argument[block].Parameter[0]"] and
      preservesValue = true
    }
  }

  private class EachConsSummary extends SimpleSummarizedCallable {
    EachConsSummary() { this = "each_cons" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "Argument[block].Parameter[0].ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class EachEntrySummary extends SimpleSummarizedCallable {
    EachEntrySummary() { this = "each_entry" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement" and
        output = "Argument[block].Parameter[0]"
        or
        input = "Argument[self].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?]"
        or
        exists(ArrayIndex i |
          input = "Argument[self].ArrayElement[" + i + "]" and
          output = "ReturnValue.ArrayElement[" + i + "]"
        )
      ) and
      preservesValue = true
    }
  }

  private class EachSliceSummary extends SimpleSummarizedCallable {
    EachSliceSummary() { this = "each_slice" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement" and
        output = "Argument[block].Parameter[0].ArrayElement[?]"
        or
        input = "Argument[self].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?]"
        or
        exists(ArrayIndex i |
          input = "Argument[self].ArrayElement[" + i + "]" and
          output = "ReturnValue.ArrayElement[" + i + "]"
        )
      ) and
      preservesValue = true
    }
  }

  private class EachWithIndexSummary extends SimpleSummarizedCallable {
    EachWithIndexSummary() { this = "each_with_index" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement" and
        output = "Argument[block].Parameter[0]"
        or
        input = "Argument[self].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?]"
        or
        exists(ArrayIndex i |
          input = "Argument[self].ArrayElement[" + i + "]" and
          output = "ReturnValue.ArrayElement[" + i + "]"
        )
      ) and
      preservesValue = true
    }
  }

  private class EachWithObjectSummary extends SimpleSummarizedCallable {
    EachWithObjectSummary() { this = "each_with_object" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement" and
        output = "Argument[block].Parameter[0]"
        or
        input = "Argument[0]" and
        output = ["Argument[block].Parameter[1]", "ReturnValue"]
      ) and
      preservesValue = true
    }
  }

  private class FilterMapSummary extends SimpleSummarizedCallable {
    FilterMapSummary() { this = "filter_map" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["Argument[block].Parameter[0]", "ReturnValue.ArrayElement[?]"] and
      preservesValue = true
    }
  }

  private class FindIndexSummary extends SimpleSummarizedCallable {
    FindIndexSummary() { this = "find_index" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  abstract private class FirstSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    FirstSummary() { mc.getMethodName() = "first" }

    override MethodCall getACall() { result = mc }
  }

  private class FirstNoArgSummary extends FirstSummary {
    FirstNoArgSummary() { this = "first(no_arg)" and mc.getNumberOfArguments() = 0 }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = ["Argument[self].ArrayElement[0]", "Argument[self].ArrayElement[?]"] and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class FirstArgKnownSummary extends FirstSummary {
    private int n;

    FirstArgKnownSummary() {
      this = "first(" + n + ")" and mc.getArgument(0).getConstantValue().isInt(n)
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        exists(ArrayIndex i |
          i < n and
          input = "Argument[self].ArrayElement[" + i + "]" and
          output = "ReturnValue.ArrayElement[" + i + "]"
        )
        or
        input = "Argument[self].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?]"
      ) and
      preservesValue = true
    }
  }

  private class FirstArgUnknownSummary extends FirstSummary {
    FirstArgUnknownSummary() {
      this = "first(?)" and
      mc.getNumberOfArguments() > 0 and
      not mc.getArgument(0).getConstantValue().isInt(_)
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        exists(ArrayIndex i |
          input = "Argument[self].ArrayElement[" + i + "]" and
          output = "ReturnValue.ArrayElement[" + i + "]"
        )
        or
        input = "Argument[self].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?]"
      ) and
      preservesValue = true
    }
  }

  abstract private class GrepSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    GrepSummary() { mc.getMethodName() = ["grep", "grep_v"] }

    override MethodCall getACall() { result = mc }
  }

  private class GrepBlockSummary extends GrepSummary {
    GrepBlockSummary() { this = mc.getMethodName() + "(block)" and exists(mc.getBlock()) }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement" and
        output = "Argument[block].Parameter[0]"
        or
        input = "Argument[block].ReturnValue" and
        output = "ReturnValue.ArrayElement[?]"
      ) and
      preservesValue = true
    }
  }

  private class GrepNoBlockSummary extends GrepSummary {
    GrepNoBlockSummary() { this = mc.getMethodName() + "(no_block)" and not exists(mc.getBlock()) }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class GroupBySummary extends SimpleSummarizedCallable {
    GroupBySummary() { this = "group_by" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      // TODO: Add flow to return value once we have flow through hashes
      input = "Argument[self].ArrayElement" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  abstract private class InjectSummary extends SummarizedCallable {
    MethodCall mc;

    // `reduce` is an alias for `inject`.
    bindingset[this]
    InjectSummary() { mc.getMethodName() = ["inject", "reduce"] }

    override MethodCall getACall() { result = mc }
  }

  private class InjectNoArgSummary extends InjectSummary {
    InjectNoArgSummary() { this = mc.getMethodName() + "_no_arg" and mc.getNumberOfArguments() = 0 }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      // The no-argument variant of inject passes element 0 to the first block
      // parameter (first iteration only). All other elements are passed to the
      // second block parameter.
      (
        input = "Argument[self].ArrayElement[0]" and
        output = "Argument[block].Parameter[0]"
        or
        exists(ArrayIndex i | i > 0 | input = "Argument[self].ArrayElement[" + i + "]") and
        output = "Argument[block].Parameter[1]"
        or
        input = "Argument[block].ReturnValue" and output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class InjectArgSummary extends InjectSummary {
    InjectArgSummary() { this = mc.getMethodName() + "_arg" and mc.getNumberOfArguments() > 0 }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        // The first argument of the call is passed to the first block parameter.
        input = "Argument[0]" and
        output = "Argument[block].Parameter[0]"
        or
        // Each element in the receiver is passed to the second block parameter.
        exists(ArrayIndex i | input = "Argument[self].ArrayElement[" + i + "]") and
        output = "Argument[block].Parameter[1]"
        or
        input = "Argument[block].ReturnValue" and output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  abstract private class MinOrMaxBySummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    MinOrMaxBySummary() { mc.getMethodName() = ["min_by", "max_by"] }

    override MethodCall getACall() { result = mc }
  }

  private class MinOrMaxByNoArgSummary extends MinOrMaxBySummary {
    MinOrMaxByNoArgSummary() {
      this = mc.getMethodName() + "_no_arg" and
      mc.getNumberOfArguments() = 0
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["Argument[block].Parameter[0]", "ReturnValue"] and
      preservesValue = true
    }
  }

  private class MinOrMaxByArgSummary extends MinOrMaxBySummary {
    MinOrMaxByArgSummary() {
      this = mc.getMethodName() + "_arg" and
      mc.getNumberOfArguments() > 0
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["Argument[block].Parameter[0]", "ReturnValue.ArrayElement[?]"] and
      preservesValue = true
    }
  }

  abstract private class MinOrMaxSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    MinOrMaxSummary() { mc.getMethodName() = ["min", "max"] }

    override MethodCall getACall() { result = mc }
  }

  private class MinOrMaxNoArgNoBlockSummary extends MinOrMaxSummary {
    MinOrMaxNoArgNoBlockSummary() {
      this = mc.getMethodName() + "_no_arg_no_block" and
      mc.getNumberOfArguments() = 0 and
      not exists(mc.getBlock())
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class MinOrMaxArgNoBlockSummary extends MinOrMaxSummary {
    MinOrMaxArgNoBlockSummary() {
      this = mc.getMethodName() + "_arg_no_block" and
      mc.getNumberOfArguments() > 0 and
      not exists(mc.getBlock())
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class MinOrMaxNoArgBlockSummary extends MinOrMaxSummary {
    MinOrMaxNoArgBlockSummary() {
      this = mc.getMethodName() + "_no_arg_block" and
      mc.getNumberOfArguments() = 0 and
      exists(mc.getBlock())
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["Argument[block].Parameter[0]", "Argument[block].Parameter[1]", "ReturnValue"] and
      preservesValue = true
    }
  }

  private class MinOrMaxArgBlockSummary extends MinOrMaxSummary {
    MinOrMaxArgBlockSummary() {
      this = mc.getMethodName() + "_arg_block" and
      mc.getNumberOfArguments() > 0 and
      exists(mc.getBlock())
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output =
        [
          "Argument[block].Parameter[0]", "Argument[block].Parameter[1]",
          "ReturnValue.ArrayElement[?]"
        ] and
      preservesValue = true
    }
  }

  abstract private class MinmaxSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    MinmaxSummary() { mc.getMethodName() = "minmax" }

    override MethodCall getACall() { result = mc }
  }

  private class MinmaxNoArgNoBlockSummary extends MinmaxSummary {
    MinmaxNoArgNoBlockSummary() {
      this = "minmax_no_block" and
      not exists(mc.getBlock())
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "ReturnValue.ArrayElement[?]" and
      preservesValue = true
    }
  }

  private class MinmaxBlockSummary extends MinmaxSummary {
    MinmaxBlockSummary() {
      this = "minmax_block" and
      exists(mc.getBlock())
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output =
        [
          "Argument[block].Parameter[0]", "Argument[block].Parameter[1]",
          "ReturnValue.ArrayElement[?]"
        ] and
      preservesValue = true
    }
  }

  private class MinmaxBySummary extends SimpleSummarizedCallable {
    MinmaxBySummary() { this = "minmax_by" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["Argument[block].Parameter[0]", "ReturnValue.ArrayElement[?]"] and
      preservesValue = true
    }
  }

  private class PartitionSummary extends SimpleSummarizedCallable {
    PartitionSummary() { this = "partition" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["Argument[block].Parameter[0]", "ReturnValue.ArrayElement[?].ArrayElement[?]"] and
      preservesValue = true
    }
  }

  private class QuerySummary extends SimpleSummarizedCallable {
    QuerySummary() { this = ["all?", "any?", "none?", "one?"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  private class RejectSummary extends SimpleSummarizedCallable {
    RejectSummary() { this = "reject" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["Argument[block].Parameter[0]", "ReturnValue.ArrayElement[?]"] and
      preservesValue = true
    }
  }

  private class SelectSummary extends SimpleSummarizedCallable {
    // `find_all` and `filter` are aliases of `select`.
    SelectSummary() { this = ["select", "find_all", "filter"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["Argument[block].Parameter[0]", "ReturnValue.ArrayElement[?]"] and
      preservesValue = true
    }
  }

  private class SliceBeforeAfterSummary extends SimpleSummarizedCallable {
    SliceBeforeAfterSummary() { this = ["slice_before", "slice_after"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  private class SliceWhenSummary extends SimpleSummarizedCallable {
    SliceWhenSummary() { this = "slice_when" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["Argument[block].Parameter[0]", "Argument[block].Parameter[1]"] and
      preservesValue = true
    }
  }

  private class SortSummary extends SimpleSummarizedCallable {
    SortSummary() { this = "sort" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output =
        [
          "Argument[block].Parameter[0]", "Argument[block].Parameter[1]",
          "ReturnValue.ArrayElement[?]"
        ] and
      preservesValue = true
    }
  }

  private class SortBySummary extends SimpleSummarizedCallable {
    SortBySummary() { this = "sort_by" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["Argument[block].Parameter[0]", "ReturnValue.ArrayElement[?]"] and
      preservesValue = true
    }
  }

  private class SumSummary extends SimpleSummarizedCallable {
    SumSummary() { this = "sum" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  abstract private class TakeSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    TakeSummary() { mc.getMethodName() = "take" }

    override MethodCall getACall() { result = mc }
  }

  private class TakeKnownSummary extends TakeSummary {
    private int i;

    TakeKnownSummary() {
      this = "take(" + i + ")" and
      mc.getArgument(0).getConstantValue().isInt(i)
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?]"
        or
        exists(ArrayIndex j | j < i |
          input = "Argument[self].ArrayElement[" + j + "]" and
          output = "ReturnValue.ArrayElement[" + j + "]"
        )
      ) and
      preservesValue = true
    }
  }

  private class TakeUnknownSummary extends TakeSummary {
    TakeUnknownSummary() {
      this = "take(index)" and
      not mc.getArgument(0).getConstantValue().isInt(_)
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      // When the index is unknown, we can't know the size of the result, but we
      // know that indices are preserved, so, as an approximation, we just treat
      // it like the array is copied.
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class TakeWhileSummary extends SimpleSummarizedCallable {
    TakeWhileSummary() { this = "take_while" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
      or
      // We can't know the size of the return value, but we know that indices
      // are preserved, so, as an approximation, we just treat it like the array
      // is copied.
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class ToASummary extends SimpleSummarizedCallable {
    // `entries` is an alias of `to_a`.
    // `to_ary` works a bit like `to_a` (close enough for our purposes).
    ToASummary() { this = ["to_a", "entries", "to_ary"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class UniqSummary extends SimpleSummarizedCallable {
    UniqSummary() { this = "uniq" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[self].ArrayElement" and
      output = ["ReturnValue.ArrayElement[?]", "Argument[block].Parameter[0]"] and
      preservesValue = true
    }
  }

  abstract private class ZipSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    ZipSummary() { mc.getMethodName() = "zip" }

    override MethodCall getACall() { result = mc }
  }

  private class ZipBlockSummary extends ZipSummary {
    ZipBlockSummary() { this = "zip(block)" and exists(mc.getBlock()) }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].ArrayElement" and
        output = "Argument[block].Parameter[0].ArrayElement[0]"
        or
        exists(int i | i in [0 .. (mc.getNumberOfArguments() - 1)] |
          input = "Argument[" + i + "].ArrayElement" and
          output = "Argument[block].Parameter[0].ArrayElement[" + (i + 1) + "]"
        )
      ) and
      preservesValue = true
    }
  }

  private class ZipNoBlockSummary extends ZipSummary {
    ZipNoBlockSummary() { this = "zip(no_block)" and not exists(mc.getBlock()) }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        // receiver[i] -> return_value[i][0]
        exists(ArrayIndex i |
          input = "Argument[self].ArrayElement[" + i + "]" and
          output = "ReturnValue.ArrayElement[" + i + "].ArrayElement[0]"
        )
        or
        // receiver[?] -> return_value[?][0]
        input = "Argument[self].ArrayElement[?]" and
        output = "ReturnValue.ArrayElement[?].ArrayElement[0]"
        or
        // arg_j[i] -> return_value[i][j+1]
        exists(ArrayIndex i, int j | j in [0 .. (mc.getNumberOfArguments() - 1)] |
          input = "Argument[" + j + "].ArrayElement[" + i + "]" and
          output = "ReturnValue.ArrayElement[" + i + "].ArrayElement[" + (j + 1) + "]"
        )
        or
        // arg_j[?] -> return_value[?][j+1]
        exists(int j | j in [0 .. (mc.getNumberOfArguments() - 1)] |
          input = "Argument[" + j + "].ArrayElement[?]" and
          output = "ReturnValue.ArrayElement[?].ArrayElement[" + (j + 1) + "]"
        )
      ) and
      preservesValue = true
    }
  }
}
