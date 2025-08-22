/** Provides flow summaries for the `Array` and `Enumerable` classes. */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.ast.internal.Module
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.dataflow.internal.DataFlowDispatch

/** An array index that may be tracked precisely in data flow. */
private class ArrayIndex extends int {
  ArrayIndex() { this = any(DataFlow::Content::KnownElementContent c).getIndex().getInt() }
}

private string lastBlockParam(MethodCall mc, string name, int lastBlockParam) {
  mc.getMethodName() = name and
  result = name + "(" + lastBlockParam + ")" and
  lastBlockParam = mc.getBlock().getNumberOfParameters() - 1
}

/**
 * Gets a call to the method `name` invoked on the `Array` object
 * (not on an array instance).
 */
private MethodCall getAStaticArrayCall(string name) {
  result.getMethodName() = name and
  resolveConstantReadAccess(result.getReceiver()) = TResolved("Array")
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
  private predicate isUnknownElementIndex(Expr e) {
    not exists(DataFlow::Content::getKnownElementIndex(e)) and
    not e instanceof RangeLiteral
  }

  private class ArrayLiteralSummary extends SummarizedCallable {
    ArrayLiteralSummary() { this = "Array.[]" }

    override MethodCall getACallSimple() { result = getAStaticArrayCall("[]") }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      // we make use of the special `splat` argument kind, which contains all positional
      // arguments wrapped in an implicit array, as well as explicit splat arguments
      input = "Argument[splat]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class NewSummary extends SummarizedCallable {
    NewSummary() { this = "Array.new" }

    override MethodCall getACallSimple() { result = getAStaticArrayCall("new") }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[1]" and
        output = "ReturnValue.Element[?]"
        or
        input = "Argument[0].WithElement[any]" and
        output = "ReturnValue"
        or
        input = "Argument[block].ReturnValue" and
        output = "ReturnValue.Element[?]"
      ) and
      preservesValue = true
    }
  }

  private class TryConvertSummary extends SummarizedCallable {
    TryConvertSummary() { this = "Array.try_convert" }

    override MethodCall getACallSimple() { result = getAStaticArrayCall("try_convert") }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[0].WithElement[any]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class SetIntersectionSummary extends SummarizedCallable {
    SetIntersectionSummary() { this = "&" }

    override BitwiseAndExpr getACallSimple() { any() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = ["Argument[self].Element[any]", "Argument[0].Element[any]"] and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  private class SetUnionSummary extends SummarizedCallable {
    SetUnionSummary() { this = "|" }

    override BitwiseOrExpr getACallSimple() { any() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = ["Argument[self].Element[any]", "Argument[0].Element[any]"] and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  private class RepetitionSummary extends SummarizedCallable {
    RepetitionSummary() { this = "*" }

    override MulExpr getACallSimple() { any() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  private class ConcatenationSummary extends SummarizedCallable {
    ConcatenationSummary() { this = "+" }

    override AddExpr getACallSimple() { any() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].WithElement[any]" and
        output = "ReturnValue"
        or
        input = "Argument[0].Element[any]" and
        output = "ReturnValue.Element[?]"
      ) and
      preservesValue = true
    }
  }

  abstract private class DifferenceSummaryShared extends SummarizedCallable {
    bindingset[this]
    DifferenceSummaryShared() { any() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  private class SetDifferenceSummary extends DifferenceSummaryShared {
    SetDifferenceSummary() { this = "-" }

    override SubExpr getACallSimple() { any() }
  }

  /** Flow summary for `Array#<<`. For `Array#append`, see `PushSummary`. */
  private class AppendOperatorSummary extends SummarizedCallable {
    AppendOperatorSummary() { this = "<<" }

    override LShiftExpr getACallSimple() { any() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].WithElement[any]" and
        output = "ReturnValue"
        or
        input = "Argument[0]" and
        output = ["ReturnValue.Element[?]", "Argument[self].Element[?]"]
      ) and
      preservesValue = true
    }
  }

  private class ElementReferenceReadMethodName extends string {
    ElementReferenceReadMethodName() { this = ["[]", "slice"] }
  }

  /** A call to `[]`, or its alias, `slice`. */
  abstract private class ElementReferenceReadSummary extends SummarizedCallable {
    MethodCall mc;
    ElementReferenceReadMethodName methodName; // adding this as a field helps give a better join order

    bindingset[this]
    ElementReferenceReadSummary() {
      mc.getMethodName() = methodName and not mc = getAStaticArrayCall(methodName)
    }

    override MethodCall getACallSimple() { result = mc }
  }

  /** A call to `[]` with a known index. */
  private class ElementReferenceReadKnownSummary extends ElementReferenceReadSummary {
    private ConstantValue index;

    ElementReferenceReadKnownSummary() {
      this = methodName + "(" + index.serialize() + ")" and
      mc.getNumberOfArguments() = 1 and
      index = DataFlow::Content::getKnownElementIndex(mc.getArgument(0)) and
      if methodName = "slice" then index.isInt(_) else any()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[" + index.serialize() + "]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private predicate isKnownRange(RangeLiteral rl, int start, int end) {
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
    )
  }

  /**
   * A call to `[]` with an unknown argument, which could be either an index or
   * a range. To avoid spurious flow, we are going to ignore the possibility
   * that the argument might be a range (unless it is an explicit range literal,
   * see `ElementReferenceRangeReadUnknownSummary`).
   */
  private class ElementReferenceReadUnknownSummary extends ElementReferenceReadSummary {
    ElementReferenceReadUnknownSummary() {
      this = methodName + "(index)" and
      mc.getNumberOfArguments() = 1 and
      isUnknownElementIndex(mc.getArgument(0))
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  /** A call to `[]` with two known arguments or a known range argument. */
  private class ElementReferenceRangeReadKnownSummary extends ElementReferenceReadSummary {
    int start;
    int end;

    ElementReferenceRangeReadKnownSummary() {
      mc.getNumberOfArguments() = 2 and
      start = DataFlow::Content::getKnownElementIndex(mc.getArgument(0)).getInt() and
      exists(int length | mc.getArgument(1).getConstantValue().isInt(length) |
        end = (start + length - 1) and
        this = "[](" + start + ", " + length + ")"
      )
      or
      mc.getNumberOfArguments() = 1 and
      isKnownRange(mc.getArgument(0), start, end) and
      this = methodName + "(" + start + ".." + end + ")"
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      preservesValue = true and
      (
        input = "Argument[self].WithElement[?]" and
        output = "ReturnValue"
        or
        exists(ArrayIndex i | i >= start and i <= end |
          input = "Argument[self].Element[" + i + "!]" and
          output = "ReturnValue.Element[" + (i - start) + "]"
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
      this = methodName + "(range_unknown)" and
      (
        mc.getNumberOfArguments() = 2 and
        (
          not exists(mc.getArgument(0).getConstantValue()) or
          not exists(mc.getArgument(1).getConstantValue())
        )
        or
        mc.getNumberOfArguments() = 1 and
        mc.getArgument(0) = any(RangeLiteral range | not isKnownRange(range, _, _))
      )
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[0..]" and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  /** A call to `[]=`. */
  abstract private class ElementReferenceStoreSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    ElementReferenceStoreSummary() { mc.getMethodName() = "[]=" }

    final override MethodCall getACallSimple() { result = mc }
  }

  /** A call to `[]=` with a known index. */
  private class ElementReferenceStoreKnownSummary extends ElementReferenceStoreSummary {
    private ConstantValue index;

    ElementReferenceStoreKnownSummary() {
      mc.getNumberOfArguments() = 2 and
      index = DataFlow::Content::getKnownElementIndex(mc.getArgument(0)) and
      this = "[" + index.serialize() + "]="
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[1]" and
      output = "Argument[self].Element[" + index.serialize() + "]" and
      preservesValue = true
      or
      input = "Argument[self].WithoutElement[" + index.serialize() + "!]" and
      output = "Argument[self]" and
      preservesValue = true
    }
  }

  /** A call to `[]=` with an unknown index. */
  private class ElementReferenceStoreUnknownSummary extends ElementReferenceStoreSummary {
    ElementReferenceStoreUnknownSummary() {
      mc.getNumberOfArguments() = 2 and
      isUnknownElementIndex(mc.getArgument(0)) and
      this = "[]="
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[1]" and
      output = "Argument[self].Element[?]" and
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      // We model this imprecisely, saying that there's flow from any element of
      // the argument or the receiver to any element of the receiver. This could
      // be made more precise when the range is known, similar to the way it's
      // done in `ElementReferenceRangeReadKnownSummary`.
      exists(string arg |
        arg = "Argument[" + (mc.getNumberOfArguments() - 1) + "]" and
        input = [arg + ".Element[any]", arg, "Argument[self].Element[any]"] and
        output = "Argument[self].Element[?]" and
        preservesValue = true
      )
      or
      input = "Argument[self].WithoutElement[any]" and
      output = "Argument[self]" and
      preservesValue = true
    }
  }

  private class AssocSummary extends SimpleSummarizedCallable {
    AssocSummary() { this = ["assoc", "rassoc"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any].WithElement[any]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  abstract private class AtSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    AtSummary() { mc.getMethodName() = "at" }

    override MethodCall getACallSimple() { result = mc }
  }

  private class AtKnownSummary extends AtSummary {
    private ConstantValue index;

    AtKnownSummary() {
      this = "at(" + index.serialize() + "]" and
      mc.getNumberOfArguments() = 1 and
      index = DataFlow::Content::getKnownElementIndex(mc.getArgument(0))
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[" + index.serialize() + "]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class AtUnknownSummary extends AtSummary {
    AtUnknownSummary() {
      this = "at" and
      mc.getNumberOfArguments() = 1 and
      isUnknownElementIndex(mc.getArgument(0))
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class BSearchSummary extends SimpleSummarizedCallable {
    BSearchSummary() { this = "bsearch" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = ["Argument[block].Parameter[0]", "ReturnValue"] and
      preservesValue = true
    }
  }

  private class BSearchIndexSummary extends SimpleSummarizedCallable {
    BSearchIndexSummary() { this = "bsearch_index" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  private class ClearSummary extends SimpleSummarizedCallable {
    ClearSummary() { this = "clear" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].WithoutElement[any]" and
      output = "Argument[self]" and
      preservesValue = true
    }
  }

  private class CollectBangSummary extends SimpleSummarizedCallable {
    // `map!` is an alias of `collect!`.
    CollectBangSummary() { this = ["collect!", "map!"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
      or
      input = "Argument[block].ReturnValue" and
      output = ["ReturnValue.Element[?]", "Argument[self].Element[?]"] and
      preservesValue = true
    }
  }

  private class CombinationSummary extends SimpleSummarizedCallable {
    CombinationSummary() { this = "combination" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]" and
        output = "Argument[block].Parameter[0].Element[?]"
        or
        input = "Argument[self]" and output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class CompactBangSummary extends SimpleSummarizedCallable {
    CompactBangSummary() { this = "compact!" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[0..]" and
      output = ["ReturnValue.Element[?]", "Argument[self].Element[?]"] and
      preservesValue = true
    }
  }

  private class ConcatSummary extends SimpleSummarizedCallable {
    ConcatSummary() { this = "concat" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[0..].Element[any]" and
      output = "Argument[self].Element[?]" and
      preservesValue = true
    }
  }

  private class DeconstructSummary extends SimpleSummarizedCallable {
    DeconstructSummary() { this = "deconstruct" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      // The documentation of `deconstruct` is blank, but the implementation
      // shows that it just returns the receiver, unchanged:
      // https://github.com/ruby/ruby/blob/71bc99900914ef3bc3800a22d9221f5acf528082/array.c#L7810-L7814.
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  abstract private class DeleteSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    DeleteSummary() { mc.getMethodName() = "delete" }

    final override MethodCall getACallSimple() { result = mc }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].WithoutElement[any]" and
        output = "Argument[self]"
        or
        input = "Argument[self].WithElement[?]" and
        output = "Argument[self]"
        or
        input = "Argument[block].ReturnValue" and
        output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class DeleteKnownSummary extends DeleteSummary {
    private ConstantValue index;

    DeleteKnownSummary() {
      this = "delete(" + index.serialize() + ")" and
      mc.getArgument(0).getConstantValue() = index
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      super.propagatesFlow(input, output, preservesValue)
      or
      (
        (
          if index.isInt(_)
          then
            // array indices may get shifted
            input = "Argument[self].WithoutElement[" + index.serialize() + "!].Element[0..!]" and
            output = "Argument[self].Element[?]"
            or
            input = "Argument[self].WithoutElement[0..!]" and
            output = "Argument[self]"
          else (
            input = "Argument[self].WithoutElement[" + index.serialize() + "!]" and
            output = "Argument[self]"
          )
        )
        or
        input = "Argument[self].Element[" + index.serialize() + "]" and
        output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class DeleteUnknownSummary extends DeleteSummary {
    DeleteUnknownSummary() {
      // Note: take care to avoid a name clash with the "delete" summary from String.qll
      this = "delete-unknown-key" and
      not exists(DataFlow::Content::getKnownElementIndex(mc.getArgument(0)))
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      super.propagatesFlow(input, output, preservesValue)
      or
      (
        // array indices may get shifted
        input = "Argument[self].Element[0..!]" and
        output = "Argument[self].Element[?]"
        or
        input = "Argument[self].WithoutElement[0..!].WithElement[any]" and
        output = "Argument[self]"
        or
        input = "Argument[self].Element[any]" and
        output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  abstract private class DeleteAtSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    DeleteAtSummary() { mc.getMethodName() = "delete_at" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].WithoutElement[any]" and
      output = "Argument[self]" and
      preservesValue = true
    }

    override MethodCall getACallSimple() { result = mc }
  }

  private class DeleteAtKnownSummary extends DeleteAtSummary {
    int i;

    DeleteAtKnownSummary() {
      this = "delete_at(" + i + ")" and
      mc.getArgument(0).getConstantValue().isInt(i) and
      i >= 0
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      super.propagatesFlow(input, output, preservesValue)
      or
      (
        input = "Argument[self].Element[?]" and
        output = ["ReturnValue", "Argument[self].Element[?]"]
        or
        input = "Argument[self].Element[" + i + "!]" and
        output = "ReturnValue"
        or
        exists(ArrayIndex j |
          j < i and
          input = "Argument[self].WithElement[" + j + "!]" and
          output = "Argument[self]"
          or
          j > i and
          input = "Argument[self].Element[" + j + "!]" and
          output = "Argument[self].Element[" + (j - 1) + "]"
        )
      ) and
      preservesValue = true
    }
  }

  private class DeleteAtUnknownSummary extends DeleteAtSummary {
    DeleteAtUnknownSummary() {
      this = "delete_at(index)" and
      not mc.getArgument(0).getConstantValue().isInt(_)
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      super.propagatesFlow(input, output, preservesValue)
      or
      input = "Argument[self].Element[any]" and
      output = ["ReturnValue", "Argument[self].Element[?]"] and
      preservesValue = true
    }
  }

  private class DeleteIfSummary extends SummarizedCallable {
    MethodCall mc;
    int lastBlockParam;

    DeleteIfSummary() { this = lastBlockParam(mc, "delete_if", lastBlockParam) }

    final override MethodCall getACallSimple() { result = mc }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]" and
        output = "Argument[block].Parameter[" + lastBlockParam + "]"
        or
        // array indices may get shifted
        input = "Argument[self].Element[0..!]" and
        output = ["ReturnValue.Element[?]", "Argument[self].Element[?]"]
        or
        input = "Argument[self].WithoutElement[0..!].WithElement[any]" and
        output = ["ReturnValue", "Argument[self]"]
      ) and
      preservesValue = true
    }
  }

  private class DifferenceSummary extends DifferenceSummaryShared, SimpleSummarizedCallable {
    DifferenceSummary() { this = "difference" }
  }

  private string getDigArg(MethodCall dig, int i) {
    dig.getMethodName() = "dig" and
    exists(Expr arg | arg = dig.getArgument(i) |
      result = DataFlow::Content::getKnownElementIndex(arg).serialize()
      or
      not exists(DataFlow::Content::getKnownElementIndex(arg)) and
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
      if s = "?" then result = "any" else result = s
    )
  }

  language[monotonicAggregates]
  private string buildDigInputSpec(RelevantDigMethodCall dig) {
    result =
      strictconcat(int i |
        i in [0 .. dig.getNumberOfArguments() - 1]
      |
        ".Element[" + buildDigInputSpecComponent(dig, i) + "]" order by i
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

    override MethodCall getACallSimple() { result = dig }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self]" + buildDigInputSpec(dig) and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class EachSummary extends SummarizedCallable {
    MethodCall mc;
    int lastBlockParam;

    EachSummary() {
      exists(string name |
        // `each` and `reverse_each` are the same in terms of flow inputs/outputs.
        name = ["each", "reverse_each"] and
        this = lastBlockParam(mc, name, lastBlockParam)
      )
    }

    final override MethodCall getACallSimple() { result = mc }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]" and
        output = "Argument[block].Parameter[" + lastBlockParam + "]"
        or
        input = "Argument[self].WithElement[any]" and
        output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class EachIndexSummary extends SimpleSummarizedCallable {
    EachIndexSummary() { this = ["each_index", "each_key"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].WithElement[any]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  abstract private class FetchSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    FetchSummary() { mc.getMethodName() = "fetch" }

    override MethodCall getACallSimple() { result = mc }
  }

  private class FetchKnownSummary extends FetchSummary {
    ConstantValue index;

    FetchKnownSummary() {
      this = "fetch(" + index.serialize() + ")" and
      index = mc.getArgument(0).getConstantValue() and
      not index.isInt(any(int i | i < 0))
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[" + index.serialize() + "]" and
        output = "ReturnValue"
        or
        input = "Argument[0]" and
        output = "Argument[block].Parameter[0]"
        or
        input = "Argument[1]" and
        output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class FetchUnknownSummary extends FetchSummary {
    FetchUnknownSummary() {
      this = "fetch(index)" and
      not exists(ConstantValue index |
        index = mc.getArgument(0).getConstantValue() and not index.isInt(any(int i | i < 0))
      )
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = ["Argument[self].Element[any]", "Argument[1]"] and
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

    override MethodCall getACallSimple() { result = mc }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = ["Argument[0]", "Argument[block].ReturnValue"] and
      output = "Argument[self].Element[?]" and
      preservesValue = true
    }
  }

  private class FillAllSummary extends FillSummary {
    FillAllSummary() {
      this = "fill(all)" and
      if exists(mc.getBlock()) then mc.getNumberOfArguments() = 0 else mc.getNumberOfArguments() = 1
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      super.propagatesFlow(input, output, preservesValue)
      or
      input = "Argument[self].WithoutElement[any]" and
      output = "Argument[self]" and
      preservesValue = true
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input =
          [
            "Argument[self].Element[any]", "Argument[self].Element[any].Element[any]",
            "Argument[self].Element[any].Element[any].Element[any]"
          ] and
        output = "ReturnValue.Element[?]"
      ) and
      preservesValue = true
    }
  }

  private class FlattenBangSummary extends SimpleSummarizedCallable {
    FlattenBangSummary() { this = "flatten!" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input =
          [
            "Argument[self].Element[any]", "Argument[self].Element[any].Element[any]",
            "Argument[self].Element[any].Element[any].Element[any]"
          ] and
        output = ["Argument[self].Element[?]", "ReturnValue.Element[?]"]
        or
        input = "Argument[self].WithoutElement[any]" and
        output = "Argument[self]"
      ) and
      preservesValue = true
    }
  }

  private class IndexSummary extends SimpleSummarizedCallable {
    IndexSummary() { this = ["index", "rindex"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  abstract private class InsertSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    InsertSummary() { mc.getMethodName() = "insert" }

    override MethodCall getACallSimple() { result = mc }
  }

  private class InsertKnownSummary extends InsertSummary {
    private int i;

    InsertKnownSummary() {
      this = "insert(" + i + ")" and
      mc.getArgument(0).getConstantValue().isInt(i)
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      exists(int numValues, string r |
        numValues = mc.getNumberOfArguments() - 1 and
        r = ["ReturnValue", "Argument[self]"] and
        preservesValue = true
      |
        input = "Argument[self].Element[?]" and
        output = r + ".Element[?]"
        or
        exists(ArrayIndex j |
          // Existing elements before the insertion point are unaffected.
          j < i and
          input = "Argument[self].WithElement[" + j + "!]" and
          output = r
          or
          // Existing elements after the insertion point are shifted by however
          // many values we're inserting.
          j >= i and
          input = "Argument[self].Element[" + j + "!]" and
          output = r + ".Element[" + (j + numValues) + "]"
        )
        or
        exists(int j | j in [1 .. numValues] |
          input = "Argument[" + j + "]" and
          output = r + ".Element[" + (i + j - 1) + "]"
        )
      )
      or
      input = "Argument[self].WithoutElement[any]" and
      output = "Argument[self]" and
      preservesValue = true
    }
  }

  private class InsertUnknownSummary extends InsertSummary {
    InsertUnknownSummary() {
      this = "insert(index)" and
      not mc.getArgument(0).getConstantValue().isInt(_)
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]"
        or
        exists(int j | j in [1 .. mc.getNumberOfArguments() - 1] | input = "Argument[" + j + "]")
      ) and
      output = ["ReturnValue", "Argument[self]"] + ".Element[?]" and
      preservesValue = true
    }
  }

  private class IntersectionSummary extends SummarizedCallable {
    MethodCall mc;

    IntersectionSummary() { this = "intersection" and mc.getMethodName() = this }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]"
        or
        exists(int i | i in [0 .. mc.getNumberOfArguments() - 1] |
          input = "Argument[" + i + "].Element[any]"
        )
      ) and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }

    override MethodCall getACallSimple() { result = mc }
  }

  private class KeepIfSummary extends SummarizedCallable {
    MethodCall mc;
    int lastBlockParam;

    KeepIfSummary() { this = lastBlockParam(mc, "keep_if", lastBlockParam) }

    final override MethodCall getACallSimple() { result = mc }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].WithoutElement[any]" and
        output = "Argument[self]"
        or
        // array indices may get shifted
        input = "Argument[self].Element[0..!]" and
        output = ["ReturnValue.Element[?]", "Argument[self].Element[?]"]
        or
        input = "Argument[self].WithoutElement[0..!].WithElement[any]" and
        output = ["ReturnValue", "Argument[self]"]
        or
        input = "Argument[self].Element[any]" and
        output = "Argument[block].Parameter[" + lastBlockParam + "]"
      ) and
      preservesValue = true
    }
  }

  abstract private class LastSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    LastSummary() { mc.getMethodName() = "last" }

    override MethodCall getACallSimple() { result = mc }
  }

  private class LastNoArgSummary extends LastSummary {
    LastNoArgSummary() { this = "last(no_arg)" and mc.getNumberOfArguments() = 0 }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class LastArgSummary extends LastSummary {
    LastArgSummary() { this = "last(arg)" and mc.getNumberOfArguments() > 0 }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  private class PackSummary extends SimpleSummarizedCallable {
    PackSummary() { this = "pack" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  private class PermutationSummary extends SimpleSummarizedCallable {
    PermutationSummary() { this = ["permutation", "repeated_combination", "repeated_permutation"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]" and
        output = "Argument[block].Parameter[0].Element[?]"
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

    override MethodCall getACallSimple() { result = mc }
  }

  private class PopNoArgSummary extends PopSummary {
    PopNoArgSummary() { this = "pop(no_arg)" and mc.getNumberOfArguments() = 0 }

    // We don't track the length of the array, so we can't model that this
    // clears the last element of the receiver, and we can't be precise about
    // which particular element flows to the return value.
    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class PopArgSummary extends PopSummary {
    PopArgSummary() { this = "pop(arg)" and mc.getNumberOfArguments() > 0 }

    // We don't track the length of the array, so we can't model that this
    // clears elements from the end of the receiver, and we can't be precise
    // about which particular elements flow to the return value.
    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue.Element[?]" and
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

    override MethodCall getACallSimple() {
      result = mc and
      // Filter out obvious 'prepend' calls in a module scope
      // Including such calls is mostly harmless but also easy to filter out
      not result.getReceiver().(SelfVariableAccess).getCfgScope() instanceof ModuleBase
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      exists(int num | num = mc.getNumberOfArguments() and preservesValue = true |
        exists(ArrayIndex i |
          input = "Argument[self].Element[" + i + "!]" and
          output = "Argument[self].Element[" + (i + num) + "]"
        )
        or
        input = "Argument[self].Element[?]" and
        output = "Argument[self].Element[?]"
        or
        exists(int i | i in [0 .. (num - 1)] |
          input = "Argument[" + i + "]" and
          output = "Argument[self].Element[" + i + "]"
        )
      )
      or
      input = "Argument[self].WithoutElement[any]" and
      output = "Argument[self]" and
      preservesValue = true
    }
  }

  private class ProductSummary extends SimpleSummarizedCallable {
    ProductSummary() { this = "product" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]"
        or
        exists(int i | i in [0 .. (mc.getNumberOfArguments() - 1)] |
          input = "Argument[" + i + "].Element[any]"
        )
      ) and
      output = "ReturnValue.Element[?].Element[?]" and
      preservesValue = true
    }
  }

  private class JoinSummary extends SimpleSummarizedCallable {
    JoinSummary() { this = ["join"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  private class PushSummary extends SimpleSummarizedCallable {
    // `append` is an alias for `push`
    PushSummary() { this = ["push", "append"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].WithElement[any]" and
        output = "ReturnValue"
        or
        exists(int i | i in [0 .. (mc.getNumberOfArguments() - 1)] |
          input = "Argument[" + i + "]" and
          output = ["ReturnValue.Element[?]", "Argument[self].Element[?]"]
        )
      ) and
      preservesValue = true
    }
  }

  private class RejectBangSummary extends SummarizedCallable {
    MethodCall mc;
    int lastBlockParam;

    RejectBangSummary() { this = lastBlockParam(mc, "reject!", lastBlockParam) }

    final override MethodCall getACallSimple() { result = mc }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        // array indices may get shifted
        input = "Argument[self].Element[0..!]" and
        output = ["ReturnValue.Element[?]", "Argument[self].Element[?]"]
        or
        input = "Argument[self].WithoutElement[0..!].WithElement[any]" and
        output = ["ReturnValue", "Argument[self]"]
        or
        input = "Argument[self].Element[any]" and
        output = "Argument[block].Parameter[" + lastBlockParam + "]"
      ) and
      preservesValue = true
    }
  }

  private class ReplaceSummary extends SimpleSummarizedCallable {
    ReplaceSummary() { this = "replace" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[0].WithElement[any]" and
      output = ["ReturnValue", "Argument[self]"] and
      preservesValue = true
      or
      input = "Argument[self].WithoutElement[any]" and
      output = "Argument[self]" and
      preservesValue = true
    }
  }

  private class ReverseSummary extends SimpleSummarizedCallable {
    ReverseSummary() { this = "reverse" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  private class ReverseBangSummary extends SimpleSummarizedCallable {
    ReverseBangSummary() { this = "reverse!" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = ["Argument[self]", "ReturnValue"] + ".Element[?]" and
      preservesValue = true
    }
  }

  abstract private class RotateSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    RotateSummary() { mc.getMethodName() = "rotate" }

    override MethodCall getACallSimple() { result = mc }
  }

  private class RotateKnownSummary extends RotateSummary {
    private int c;

    RotateKnownSummary() {
      DataFlow::Content::getKnownElementIndex(mc.getArgument(0)).isInt(c) and
      this = "rotate(" + c + ")"
      or
      not exists(mc.getArgument(0)) and c = 1 and this = "rotate"
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      preservesValue = true and
      (
        input = "Argument[self].Element[?]" and
        output = "ReturnValue.Element[?]"
        or
        exists(ArrayIndex i |
          input = "Argument[self].Element[" + i + "!]" and
          (
            i < c and output = "ReturnValue.Element[?]"
            or
            i >= c and output = "ReturnValue.Element[" + (i - c) + "]"
          )
        )
      )
    }
  }

  private class RotateUnknownSummary extends RotateSummary {
    RotateUnknownSummary() {
      this = "rotate(index)" and
      exists(mc.getArgument(0)) and
      not DataFlow::Content::getKnownElementIndex(mc.getArgument(0)).isInt(_)
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  abstract private class RotateBangSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    RotateBangSummary() { mc.getMethodName() = "rotate!" }

    override MethodCall getACallSimple() { result = mc }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].WithoutElement[any]" and
      output = "Argument[self]" and
      preservesValue = true
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      super.propagatesFlow(input, output, preservesValue)
      or
      exists(string r | r = ["Argument[self]", "ReturnValue"] and preservesValue = true |
        input = "Argument[self].Element[?]" and
        output = r + ".Element[?]"
        or
        exists(ArrayIndex i |
          input = "Argument[self].Element[" + i + "!]" and
          (
            i < c and output = r + ".Element[?]"
            or
            i >= c and output = r + ".Element[" + (i - c) + "]"
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      super.propagatesFlow(input, output, preservesValue)
      or
      input = "Argument[self].Element[any]" and
      output = ["Argument[self].Element[?]", "ReturnValue.Element[?]"] and
      preservesValue = true
    }
  }

  private class SelectBangSummary extends SummarizedCallable {
    MethodCall mc;
    int lastBlockParam;

    SelectBangSummary() {
      exists(string name |
        name = ["select!", "filter!"] and
        this = lastBlockParam(mc, name, lastBlockParam)
      )
    }

    final override MethodCall getACallSimple() { result = mc }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]" and
        output = "Argument[block].Parameter[" + lastBlockParam + "]"
        or
        // array indices may get shifted
        input = "Argument[self].Element[0..!]" and
        output = ["ReturnValue.Element[?]", "Argument[self].Element[?]"]
        or
        input = "Argument[self].WithoutElement[0..!].WithElement[any]" and
        output = ["ReturnValue", "Argument[self]"]
        or
        input = "Argument[self].WithoutElement[any]" and
        output = "Argument[self]"
      ) and
      preservesValue = true
    }
  }

  abstract private class ShiftSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    ShiftSummary() { mc.getMethodName() = "shift" }

    override MethodCall getACallSimple() { result = mc }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].WithoutElement[any]" and
      output = "Argument[self]" and
      preservesValue = true
    }
  }

  private class ShiftNoArgSummary extends ShiftSummary {
    ShiftNoArgSummary() { this = "shift" and not exists(mc.getArgument(0)) }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      super.propagatesFlow(input, output, preservesValue)
      or
      preservesValue = true and
      (
        input = "Argument[self].WithoutElement[0..!]" and
        output = "Argument[self]"
        or
        input = "Argument[self].Element[?]" and
        output =
          [
            "ReturnValue", // array
            "ReturnValue.Element[1]" // hash
          ]
        or
        input = "Argument[self].WithoutElement[0..!].WithoutElement[?].Element[any]" and
        output = "ReturnValue.Element[1]"
        or
        exists(ArrayIndex i | input = "Argument[self].Element[" + i + "!]" |
          i = 0 and output = "ReturnValue"
          or
          i > 0 and output = "Argument[self].Element[" + (i - 1) + "]"
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      super.propagatesFlow(input, output, preservesValue)
      or
      preservesValue = true and
      (
        input = "Argument[self].Element[?]" and
        output = ["ReturnValue.Element[?]", "Argument[self].Element[?]"]
        or
        exists(ArrayIndex i |
          i < n and
          input = "Argument[self].WithElement[" + i + "!]" and
          output = "ReturnValue"
          or
          i >= n and
          input = "Argument[self].Element[" + i + "!]" and
          output = "Argument[self].Element[" + (i - n) + "]"
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = ["Argument[self].Element[?]", "ReturnValue.Element[?]"] and
      preservesValue = true
    }
  }

  private class ShuffleSummary extends SimpleSummarizedCallable {
    ShuffleSummary() { this = "shuffle" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  private class ShuffleBangSummary extends SimpleSummarizedCallable {
    ShuffleBangSummary() { this = "shuffle!" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = ["ReturnValue.Element[?]", "Argument[self].Element[?]"] and
      preservesValue = true
    }
  }

  abstract private class SliceBangSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    SliceBangSummary() { mc.getMethodName() = "slice!" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].WithoutElement[any]" and
      output = "Argument[self]" and
      preservesValue = true
    }

    override Call getACallSimple() { result = mc }
  }

  /** A call to `slice!` with a known integer index. */
  private class SliceBangKnownIndexSummary extends SliceBangSummary {
    int n;

    SliceBangKnownIndexSummary() {
      this = "slice!(" + n + ")" and
      mc.getNumberOfArguments() = 1 and
      n = DataFlow::Content::getKnownElementIndex(mc.getArgument(0)).getInt()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      super.propagatesFlow(input, output, preservesValue)
      or
      preservesValue = true and
      (
        input = "Argument[self].Element[?]" and
        output = ["ReturnValue", "Argument[self].Element[?]"]
        or
        input = "Argument[self].Element[" + n + "!]" and output = "ReturnValue"
        or
        exists(ArrayIndex i |
          i < n and
          input = "Argument[self].WithElement[" + i + "!]" and
          output = "Argument[self]"
          or
          i > n and
          input = "Argument[self].Element[" + i + "!]" and
          output = "Argument[self].Element[" + (i - 1) + "]"
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
      isUnknownElementIndex(mc.getArgument(0))
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      super.propagatesFlow(input, output, preservesValue)
      or
      input = "Argument[self].Element[any]" and
      output =
        [
          "Argument[self].Element[?]",
          "ReturnValue.Element[?]", // Return value is an array if the argument is a range
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
      start = DataFlow::Content::getKnownElementIndex(mc.getArgument(0)).getInt() and
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      super.propagatesFlow(input, output, preservesValue)
      or
      preservesValue = true and
      (
        input = "Argument[self].Element[?]" and
        output = ["ReturnValue.Element[?]", "Argument[self].Element[?]"]
        or
        exists(ArrayIndex i |
          i < start and
          input = "Argument[self].WithElement[" + i + "!]" and
          output = "Argument[self]"
          or
          i >= start and
          i <= end and
          input = "Argument[self].Element[" + i + "!]" and
          output = "ReturnValue.Element[" + (i - start) + "]"
          or
          i > end and
          input = "Argument[self].Element[" + i + "!]" and
          output = "Argument[self].Element[" + (i - (end - start + 1)) + "]"
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      super.propagatesFlow(input, output, preservesValue)
      or
      input = "Argument[self].Element[any]" and
      output = ["Argument[self].Element[?]", "ReturnValue.Element[?]"] and
      preservesValue = true
    }
  }

  private class SortBangSummary extends SimpleSummarizedCallable {
    SortBangSummary() { this = "sort!" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output =
        [
          "Argument[block].Parameter[0]", "Argument[block].Parameter[1]",
          "Argument[self].Element[?]", "ReturnValue.Element[?]"
        ] and
      preservesValue = true
      or
      input = "Argument[self].WithoutElement[any]" and
      output = "Argument[self]" and
      preservesValue = true
    }
  }

  private class SortByBangSummary extends SimpleSummarizedCallable {
    SortByBangSummary() { this = "sort_by!" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output =
        ["Argument[block].Parameter[0]", "Argument[self].Element[?]", "ReturnValue.Element[?]"] and
      preservesValue = true
      or
      input = "Argument[self].WithoutElement[any]" and
      output = "Argument[self]" and
      preservesValue = true
    }
  }

  private class TransposeSummary extends SimpleSummarizedCallable {
    TransposeSummary() { this = "transpose" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      preservesValue = true and
      (
        input = "Argument[self].Element[?].Element[?]" and
        output = "ReturnValue.Element[?].Element[?]"
        or
        exists(ArrayIndex i, ArrayIndex j |
          input = "Argument[self].Element[" + j + "!].Element[" + i + "!]" and
          output = "ReturnValue.Element[" + i + "].Element[" + j + "]"
        )
        or
        exists(ArrayIndex i |
          input = "Argument[self].Element[" + i + "!].Element[?]" and
          output = "ReturnValue.Element[?].Element[" + i + "]"
          or
          input = "Argument[self].Element[?].Element[" + i + "!]" and
          output = "ReturnValue.Element[" + i + "].Element[?]"
        )
      )
    }
  }

  private class UniqBangSummary extends SimpleSummarizedCallable {
    UniqBangSummary() { this = "uniq!" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output =
        ["Argument[self].Element[?]", "ReturnValue.Element[?]", "Argument[block].Parameter[0]"] and
      preservesValue = true
      or
      input = "Argument[self].WithoutElement[any]" and
      output = "Argument[self]" and
      preservesValue = true
    }
  }

  private class UnionSummary extends SimpleSummarizedCallable {
    UnionSummary() { this = "union" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]"
        or
        exists(int i | i in [0 .. mc.getNumberOfArguments() - 1] |
          input = "Argument[" + i + "].Element[any]"
        )
      ) and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  abstract private class ValuesAtSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    ValuesAtSummary() { mc.getMethodName() = "values_at" }

    override Call getACallSimple() { result = mc }
  }

  private string getValuesAtComponent(MethodCall mc, int i) {
    mc.getMethodName() = "values_at" and
    result = DataFlow::Content::getKnownElementIndex(mc.getArgument(i)).serialize()
  }

  private class ValuesAtKnownSummary extends ValuesAtSummary {
    ValuesAtKnownSummary() {
      this =
        "values_at(" +
          strictconcat(int i |
            exists(mc.getArgument(i))
          |
            getValuesAtComponent(mc, i), "," order by i
          ) + ")"
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      exists(string s, int i |
        s = getValuesAtComponent(mc, i) and
        input = "Argument[self].Element[" + s + "]" and
        output = "ReturnValue.Element[" + i + "]"
      ) and
      preservesValue = true
    }
  }

  private class ValuesAtUnknownSummary extends ValuesAtSummary {
    ValuesAtUnknownSummary() {
      exists(int i | exists(mc.getArgument(i)) | not exists(getValuesAtComponent(mc, i))) and
      this = "values_at(?)"
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue.Element[?]" and
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  private class ChunkWhileSummary extends SimpleSummarizedCallable {
    ChunkWhileSummary() { this = "chunk_while" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = ["Argument[block].Parameter[0]", "Argument[block].Parameter[1]"] and
      preservesValue = true
    }
  }

  private class CollectSummary extends SimpleSummarizedCallable {
    // `map` is an alias of `collect`.
    CollectSummary() { this = ["collect", "map"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      // For `Hash#map`, the value flows to parameter 1
      output = "Argument[block].Parameter[0, 1]" and
      preservesValue = true
      or
      input = "Argument[block].ReturnValue" and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  private class CollectConcatSummary extends SimpleSummarizedCallable {
    // `flat_map` is an alias of `collect_concat`.
    CollectConcatSummary() { this = ["collect_concat", "flat_map"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
      or
      input = ["Argument[block].ReturnValue.Element[any]", "Argument[block].ReturnValue"] and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  private class CompactSummary extends SimpleSummarizedCallable {
    CompactSummary() { this = "compact" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[0..]" and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
      or
      exists(ConstantValue index |
        not index.isInt(_) and
        input = "Argument[self].WithElement[" + index.serialize() + "!]" and
        output = "ReturnValue" and
        preservesValue = true
      )
    }
  }

  private class CountSummary extends SimpleSummarizedCallable {
    CountSummary() { this = "count" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  private class CycleSummary extends SimpleSummarizedCallable {
    CycleSummary() { this = "cycle" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  private class DetectSummary extends SimpleSummarizedCallable {
    // `find` is an alias of `detect`.
    DetectSummary() { this = ["detect", "find"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]" and
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

    override MethodCall getACallSimple() { result = mc }
  }

  private class DropKnownSummary extends DropSummary {
    private int i;

    DropKnownSummary() {
      this = "drop(" + i + ")" and
      mc.getArgument(0).getConstantValue().isInt(i)
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[?]" and
        output = "ReturnValue.Element[?]"
        or
        exists(ArrayIndex j, ArrayIndex h |
          h = j - i and
          input = "Argument[self].Element[" + j + "!]" and
          output = "ReturnValue.Element[" + h + "]"
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  private class DropWhileSummary extends SimpleSummarizedCallable {
    DropWhileSummary() { this = "drop_while" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = ["ReturnValue.Element[?]", "Argument[block].Parameter[0]"] and
      preservesValue = true
    }
  }

  private class EachConsSummary extends SimpleSummarizedCallable {
    EachConsSummary() { this = "each_cons" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "Argument[block].Parameter[0].Element[?]" and
      preservesValue = true
    }
  }

  private class EachEntrySummary extends SimpleSummarizedCallable {
    EachEntrySummary() { this = "each_entry" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]" and
        output = "Argument[block].Parameter[0]"
        or
        input = "Argument[self].WithElement[any]" and
        output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class EachSliceSummary extends SimpleSummarizedCallable {
    EachSliceSummary() { this = "each_slice" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]" and
        output = "Argument[block].Parameter[0].Element[?]"
        or
        input = "Argument[self].WithElement[any]" and
        output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class EachWithIndexSummary extends SimpleSummarizedCallable {
    EachWithIndexSummary() { this = "each_with_index" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]" and
        output = "Argument[block].Parameter[0]"
        or
        input = "Argument[self].WithElement[any]" and
        output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class EachWithObjectSummary extends SimpleSummarizedCallable {
    EachWithObjectSummary() { this = "each_with_object" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]" and
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
      or
      input = "Argument[block].ReturnValue" and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  private class FindIndexSummary extends SimpleSummarizedCallable {
    FindIndexSummary() { this = "find_index" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  abstract private class FirstSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    FirstSummary() { mc.getMethodName() = "first" }

    override MethodCall getACallSimple() { result = mc }
  }

  private class FirstNoArgSummary extends FirstSummary {
    FirstNoArgSummary() { this = "first(no_arg)" and mc.getNumberOfArguments() = 0 }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[0]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class FirstArgKnownSummary extends FirstSummary {
    private int n;

    FirstArgKnownSummary() {
      this = "first(" + n + ")" and mc.getArgument(0).getConstantValue().isInt(n)
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        exists(ArrayIndex i |
          i < n and
          input = "Argument[self].WithElement[" + i + "!]" and
          output = "ReturnValue"
        )
        or
        input = "Argument[self].WithElement[?]" and
        output = "ReturnValue"
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].WithElement[any]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class GrepMethodName extends string {
    GrepMethodName() { this = ["grep", "grep_v"] }
  }

  abstract private class GrepSummary extends SummarizedCallable {
    MethodCall mc;
    GrepMethodName methodName; // adding this as a field helps give a better join order

    bindingset[this]
    GrepSummary() { mc.getMethodName() = methodName }

    override MethodCall getACallSimple() { result = mc }
  }

  private class GrepBlockSummary extends GrepSummary {
    GrepBlockSummary() { this = methodName + "(block)" and exists(mc.getBlock()) }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]" and
        output = "Argument[block].Parameter[0]"
        or
        input = "Argument[block].ReturnValue" and
        output = "ReturnValue.Element[?]"
      ) and
      preservesValue = true
    }
  }

  private class GrepNoBlockSummary extends GrepSummary {
    GrepNoBlockSummary() { this = methodName + "(no_block)" and not exists(mc.getBlock()) }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  private class GroupBySummary extends SimpleSummarizedCallable {
    GroupBySummary() { this = "group_by" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      // TODO: Add flow to return value once we have flow through hashes
      input = "Argument[self].Element[any]" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  private class InjectMethodName extends string {
    // `reduce` is an alias for `inject`.
    InjectMethodName() { this = ["inject", "reduce"] }
  }

  abstract private class InjectSummary extends SummarizedCallable {
    MethodCall mc;
    InjectMethodName methodName; // adding this as a field helps give a better join order

    bindingset[this]
    InjectSummary() { mc.getMethodName() = methodName }

    override MethodCall getACallSimple() { result = mc }
  }

  private class InjectNoArgSummary extends InjectSummary {
    InjectNoArgSummary() { this = methodName + "_no_arg" and mc.getNumberOfArguments() = 0 }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      // The no-argument variant of inject passes element 0 to the first block
      // parameter (first iteration only). All other elements are passed to the
      // second block parameter.
      (
        input = "Argument[self].Element[0]" and
        output = "Argument[block].Parameter[0]"
        or
        input = "Argument[self].Element[1..]" and
        output = "Argument[block].Parameter[1]"
        or
        input = "Argument[block].ReturnValue" and output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class InjectArgSummary extends InjectSummary {
    InjectArgSummary() { this = methodName + "_arg" and mc.getNumberOfArguments() > 0 }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        // The first argument of the call is passed to the first block parameter.
        input = "Argument[0]" and
        output = "Argument[block].Parameter[0]"
        or
        // Each element in the receiver is passed to the second block parameter.
        input = "Argument[self].Element[0..]" and
        output = "Argument[block].Parameter[1]"
        or
        input = "Argument[block].ReturnValue" and output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class MinOrMaxByMethodName extends string {
    MinOrMaxByMethodName() { this = ["min_by", "max_by"] }
  }

  abstract private class MinOrMaxBySummary extends SummarizedCallable {
    MethodCall mc;
    MinOrMaxByMethodName methodName; // adding this as a field helps give a better join order

    bindingset[this]
    MinOrMaxBySummary() { mc.getMethodName() = methodName }

    override MethodCall getACallSimple() { result = mc }
  }

  private class MinOrMaxByNoArgSummary extends MinOrMaxBySummary {
    MinOrMaxByNoArgSummary() {
      this = methodName + "_no_arg" and
      mc.getNumberOfArguments() = 0
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = ["Argument[block].Parameter[0]", "ReturnValue"] and
      preservesValue = true
    }
  }

  private class MinOrMaxByArgSummary extends MinOrMaxBySummary {
    MinOrMaxByArgSummary() {
      this = methodName + "_arg" and
      mc.getNumberOfArguments() > 0
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = ["Argument[block].Parameter[0]", "ReturnValue.Element[?]"] and
      preservesValue = true
    }
  }

  private class MinOrMaxMethodName extends string {
    MinOrMaxMethodName() { this = ["min", "max"] }
  }

  abstract private class MinOrMaxSummary extends SummarizedCallable {
    MethodCall mc;
    MinOrMaxMethodName methodName; // adding this as a field helps give a better join order

    bindingset[this]
    MinOrMaxSummary() { mc.getMethodName() = methodName }

    override MethodCall getACallSimple() { result = mc }
  }

  private class MinOrMaxNoArgNoBlockSummary extends MinOrMaxSummary {
    MinOrMaxNoArgNoBlockSummary() {
      this = methodName + "_no_arg_no_block" and
      mc.getNumberOfArguments() = 0 and
      not exists(mc.getBlock())
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class MinOrMaxArgNoBlockSummary extends MinOrMaxSummary {
    MinOrMaxArgNoBlockSummary() {
      this = methodName + "_arg_no_block" and
      mc.getNumberOfArguments() > 0 and
      not exists(mc.getBlock())
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  private class MinOrMaxNoArgBlockSummary extends MinOrMaxSummary {
    MinOrMaxNoArgBlockSummary() {
      this = methodName + "_no_arg_block" and
      mc.getNumberOfArguments() = 0 and
      exists(mc.getBlock())
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = ["Argument[block].Parameter[0]", "Argument[block].Parameter[1]", "ReturnValue"] and
      preservesValue = true
    }
  }

  private class MinOrMaxArgBlockSummary extends MinOrMaxSummary {
    MinOrMaxArgBlockSummary() {
      this = methodName + "_arg_block" and
      mc.getNumberOfArguments() > 0 and
      exists(mc.getBlock())
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output =
        ["Argument[block].Parameter[0]", "Argument[block].Parameter[1]", "ReturnValue.Element[?]"] and
      preservesValue = true
    }
  }

  abstract private class MinmaxSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    MinmaxSummary() { mc.getMethodName() = "minmax" }

    override MethodCall getACallSimple() { result = mc }
  }

  private class MinmaxNoArgNoBlockSummary extends MinmaxSummary {
    MinmaxNoArgNoBlockSummary() {
      this = "minmax_no_block" and
      not exists(mc.getBlock())
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "ReturnValue.Element[?]" and
      preservesValue = true
    }
  }

  private class MinmaxBlockSummary extends MinmaxSummary {
    MinmaxBlockSummary() {
      this = "minmax_block" and
      exists(mc.getBlock())
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output =
        ["Argument[block].Parameter[0]", "Argument[block].Parameter[1]", "ReturnValue.Element[?]"] and
      preservesValue = true
    }
  }

  private class MinmaxBySummary extends SimpleSummarizedCallable {
    MinmaxBySummary() { this = "minmax_by" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = ["Argument[block].Parameter[0]", "ReturnValue.Element[?]"] and
      preservesValue = true
    }
  }

  private class PartitionSummary extends SimpleSummarizedCallable {
    PartitionSummary() { this = "partition" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = ["Argument[block].Parameter[0]", "ReturnValue.Element[?].Element[?]"] and
      preservesValue = true
    }
  }

  private class QuerySummary extends SummarizedCallable {
    MethodCall mc;
    int lastBlockParam;

    QuerySummary() {
      exists(string name |
        name = ["all?", "any?", "none?", "one?"] and
        this = lastBlockParam(mc, name, lastBlockParam)
      )
    }

    final override MethodCall getACallSimple() { result = mc }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "Argument[block].Parameter[" + lastBlockParam + "]" and
      preservesValue = true
    }
  }

  private class RejectSummary extends SummarizedCallable {
    MethodCall mc;
    int lastBlockParam;

    RejectSummary() { this = lastBlockParam(mc, "reject", lastBlockParam) }

    final override MethodCall getACallSimple() { result = mc }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        // array indices may get shifted
        input = "Argument[self].Element[0..!]" and
        output = "ReturnValue.Element[?]"
        or
        input = "Argument[self].WithoutElement[0..!].WithElement[any]" and
        output = "ReturnValue"
        or
        input = "Argument[self].Element[any]" and
        output = "Argument[block].Parameter[" + lastBlockParam + "]"
      ) and
      preservesValue = true
    }
  }

  private class SelectSummary extends SummarizedCallable {
    MethodCall mc;
    int lastBlockParam;

    SelectSummary() {
      exists(string name |
        name = ["select", "find_all", "filter"] and
        this = lastBlockParam(mc, name, lastBlockParam)
      )
    }

    final override MethodCall getACallSimple() { result = mc }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        // array indices may get shifted
        input = "Argument[self].Element[0..!]" and
        output = "ReturnValue.Element[?]"
        or
        input = "Argument[self].WithoutElement[0..!].WithElement[any]" and
        output = "ReturnValue"
        or
        input = "Argument[self].Element[any]" and
        output = "Argument[block].Parameter[" + lastBlockParam + "]"
      ) and
      preservesValue = true
    }
  }

  private class SliceBeforeAfterSummary extends SimpleSummarizedCallable {
    SliceBeforeAfterSummary() { this = ["slice_before", "slice_after"] }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  private class SliceWhenSummary extends SimpleSummarizedCallable {
    SliceWhenSummary() { this = "slice_when" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = ["Argument[block].Parameter[0]", "Argument[block].Parameter[1]"] and
      preservesValue = true
    }
  }

  private class SortSummary extends SimpleSummarizedCallable {
    SortSummary() { this = "sort" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output =
        ["Argument[block].Parameter[0]", "Argument[block].Parameter[1]", "ReturnValue.Element[?]"] and
      preservesValue = true
    }
  }

  private class SortBySummary extends SimpleSummarizedCallable {
    SortBySummary() { this = "sort_by" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = ["Argument[block].Parameter[0]", "ReturnValue.Element[?]"] and
      preservesValue = true
    }
  }

  private class SumSummary extends SimpleSummarizedCallable {
    SumSummary() { this = "sum" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = "Argument[block].Parameter[0]" and
      preservesValue = true
    }
  }

  abstract private class TakeSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    TakeSummary() { mc.getMethodName() = "take" }

    override MethodCall getACallSimple() { result = mc }
  }

  private class TakeKnownSummary extends TakeSummary {
    private int i;

    TakeKnownSummary() {
      this = "take(" + i + ")" and
      mc.getArgument(0).getConstantValue().isInt(i)
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].WithElement[?]" and
        output = "ReturnValue"
        or
        exists(ArrayIndex j | j < i |
          input = "Argument[self].WithElement[" + j + "!]" and
          output = "ReturnValue"
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
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

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].WithElement[0..]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class UniqSummary extends SimpleSummarizedCallable {
    UniqSummary() { this = "uniq" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any]" and
      output = ["ReturnValue.Element[?]", "Argument[block].Parameter[0]"] and
      preservesValue = true
    }
  }

  abstract private class ZipSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    ZipSummary() { mc.getMethodName() = "zip" }

    override MethodCall getACallSimple() { result = mc }
  }

  private class ZipBlockSummary extends ZipSummary {
    ZipBlockSummary() { this = "zip(block)" and exists(mc.getBlock()) }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]" and
        output = "Argument[block].Parameter[0].Element[0]"
        or
        exists(int i | i in [0 .. (mc.getNumberOfArguments() - 1)] |
          input = "Argument[" + i + "].Element[any]" and
          output = "Argument[block].Parameter[0].Element[" + (i + 1) + "]"
        )
      ) and
      preservesValue = true
    }
  }

  private class ZipNoBlockSummary extends ZipSummary {
    ZipNoBlockSummary() { this = "zip(no_block)" and not exists(mc.getBlock()) }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        // receiver[i] -> return_value[i][0]
        exists(ArrayIndex i |
          input = "Argument[self].Element[" + i + "!]" and
          output = "ReturnValue.Element[" + i + "].Element[0]"
        )
        or
        // receiver[?] -> return_value[?][0]
        input = "Argument[self].Element[?]" and
        output = "ReturnValue.Element[?].Element[0]"
        or
        // arg_j[i] -> return_value[i][j+1]
        exists(ArrayIndex i, int j | j in [0 .. (mc.getNumberOfArguments() - 1)] |
          input = "Argument[" + j + "].Element[" + i + "!]" and
          output = "ReturnValue.Element[" + i + "].Element[" + (j + 1) + "]"
        )
        or
        // arg_j[?] -> return_value[?][j+1]
        exists(int j | j in [0 .. (mc.getNumberOfArguments() - 1)] |
          input = "Argument[" + j + "].Element[?]" and
          output = "ReturnValue.Element[?].Element[" + (j + 1) + "]"
        )
      ) and
      preservesValue = true
    }
  }
}
