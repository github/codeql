/** Provides flow summaries for the `Hash` class. */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.dataflow.internal.DataFlowDispatch
private import codeql.ruby.ast.internal.Module

/**
 * Provides flow summaries for the `Hash` class.
 *
 * The summaries are ordered (and implemented) based on
 * https://docs.ruby-lang.org/en/3.1/Hash.html.
 *
 * Some summaries are shared with the `Array` class, and those are defined
 * in `Array.qll`.
 */
module Hash {
  /**
   * Gets a call to the method `name` invoked on the `Hash` object
   * (not on a hash instance).
   */
  private MethodCall getAStaticHashCall(string name) {
    result.getMethodName() = name and
    resolveConstantReadAccess(result.getReceiver()) = TResolved("Hash")
  }

  private class HashLiteralSummary extends SummarizedCallable {
    HashLiteralSummary() { this = "Hash.[]" }

    final override MethodCall getACallSimple() { result = getAStaticHashCall("[]") }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      // we make use of the special `hash-splat` argument kind, which contains all keyword
      // arguments wrapped in an implicit hash, as well as explicit hash splat arguments
      input = "Argument[hash-splat]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  /**
   * `Hash[]` called on an existing hash, e.g.
   *
   * ```rb
   * h = {foo: 0, bar: 1, baz: 2}
   * Hash[h] # => {:foo=>0, :bar=>1, :baz=>2}
   * ```
   *
   * or on a 2-element array, e.g.
   *
   * ```rb
   * Hash[ [ [:foo, 0], [:bar, 1] ] ] # => {:foo=>0, :bar=>1}
   * ```
   */
  private class HashNewSummary extends SummarizedCallable {
    HashNewSummary() { this = "Hash[]" }

    final override MethodCall getACallSimple() {
      result = getAStaticHashCall("[]") and
      result.getNumberOfArguments() = 1
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        // Hash[{symbol: x}]
        input = "Argument[0].WithElement[any]" and
        output = "ReturnValue"
        or
        // Hash[[:symbol, x]]
        input = "Argument[0].Element[any].Element[1]" and
        output = "ReturnValue.Element[?]"
      ) and
      preservesValue = true
    }
  }

  /**
   * `Hash[]` called on an even number of arguments, e.g.
   *
   * ```rb
   * Hash[:foo, 0, :bar, 1] # => {:foo=>0, :bar=>1}
   * ```
   */
  private class HashNewSuccessivePairsSummary extends SummarizedCallable {
    private int i;
    private ConstantValue key;

    HashNewSuccessivePairsSummary() {
      this = "Hash[" + i + ", " + key.serialize() + "]" and
      i % 2 = 1 and
      exists(ElementReference er |
        key = er.getArgument(i - 1).getConstantValue() and
        exists(er.getArgument(i))
      )
    }

    final override MethodCall getACallSimple() {
      result = getAStaticHashCall("[]") and
      key = result.getArgument(i - 1).getConstantValue() and
      exists(result.getArgument(i))
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      // Hash[:symbol, x]
      input = "Argument[" + i + "]" and
      output = "ReturnValue.Element[" + key.serialize() + "]" and
      preservesValue = true
    }
  }

  private class TryConvertSummary extends SummarizedCallable {
    TryConvertSummary() { this = "Hash.try_convert" }

    override MethodCall getACallSimple() { result = getAStaticHashCall("try_convert") }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[0].WithElement[any]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  abstract private class StoreSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    StoreSummary() { mc.getMethodName() = "store" and mc.getNumberOfArguments() = 2 }

    final override MethodCall getACallSimple() { result = mc }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[1]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class StoreKnownSummary extends StoreSummary {
    private ConstantValue key;

    StoreKnownSummary() {
      key = DataFlow::Content::getKnownElementIndex(mc.getArgument(0)) and
      this = "store(" + key.serialize() + ")"
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      super.propagatesFlow(input, output, preservesValue)
      or
      input = "Argument[1]" and
      output = "Argument[self].Element[" + key.serialize() + "]" and
      preservesValue = true
      or
      input = "Argument[self].WithoutElement[" + key.serialize() + "!]" and
      output = "Argument[self]" and
      preservesValue = true
    }
  }

  private class StoreUnknownSummary extends StoreSummary {
    StoreUnknownSummary() {
      not exists(DataFlow::Content::getKnownElementIndex(mc.getArgument(0))) and
      this = "store"
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      super.propagatesFlow(input, output, preservesValue)
      or
      input = "Argument[1]" and
      output = "Argument[self].Element[?]" and
      preservesValue = true
    }
  }

  abstract private class AssocSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    AssocSummary() { mc.getMethodName() = "assoc" }

    override MethodCall getACallSimple() { result = mc }
  }

  private class AssocKnownSummary extends AssocSummary {
    private ConstantValue key;

    AssocKnownSummary() {
      this = "assoc(" + key.serialize() + "]" and
      not key.isInt(_) and // exclude arrays
      mc.getNumberOfArguments() = 1 and
      key = DataFlow::Content::getKnownElementIndex(mc.getArgument(0))
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[" + key.serialize() + "]" and
      output = "ReturnValue.Element[1]" and
      preservesValue = true
    }
  }

  private class AssocUnknownSummary extends SummarizedCallable {
    AssocUnknownSummary() { this = "assoc-unknown-arg" }

    override MethodCall getACallSimple() {
      result.getMethodName() = "assoc" and
      result.getNumberOfArguments() = 1 and
      not exists(DataFlow::Content::getKnownElementIndex(result.getArgument(0)))
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].Element[any].WithoutElement[any]" and
      output = "ReturnValue.Element[1]" and
      preservesValue = true
    }
  }

  private class EachPairSummary extends SimpleSummarizedCallable {
    EachPairSummary() { this = "each_pair" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[self].Element[any]" and
        output = "Argument[block].Parameter[1]"
        or
        input = "Argument[self].WithElement[any]" and
        output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class EachValueSummary extends SimpleSummarizedCallable {
    EachValueSummary() { this = "each_value" }

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

  private string getExceptComponent(MethodCall mc, int i) {
    mc.getMethodName() = ["except", "except!"] and
    result = DataFlow::Content::getKnownElementIndex(mc.getArgument(i)).serialize()
  }

  private class ExceptSummary extends SummarizedCallable {
    MethodCall mc;

    ExceptSummary() {
      // except! is an ActiveSupport extension
      // https://api.rubyonrails.org/classes/Hash.html#method-i-except-21
      mc.getMethodName() = ["except", "except!"] and
      this =
        mc.getMethodName() + "(" +
          concat(int i, string s | s = getExceptComponent(mc, i) | s, "," order by i) + ")"
    }

    final override MethodCall getACallSimple() { result = mc }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input =
        "Argument[self]" +
          concat(int i, string s |
            s = getExceptComponent(mc, i)
          |
            ".WithoutElement[" + s + "!]" order by i
          ) + ".WithElement[any]" and
      (
        if mc.getMethodName() = "except!"
        then output = ["ReturnValue", "Argument[self]"]
        else output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }
}

abstract private class FetchValuesSummary extends SummarizedCallable {
  MethodCall mc;

  bindingset[this]
  FetchValuesSummary() { mc.getMethodName() = "fetch_values" }

  final override MethodCall getACallSimple() { result = mc }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    (
      input = "Argument[self].WithElement[?]" and
      output = "ReturnValue"
      or
      input = "Argument[0]" and
      output = "Argument[block].Parameter[0]"
      or
      input = "Argument[block].ReturnValue" and
      output = "ReturnValue.Element[?]"
    ) and
    preservesValue = true
  }
}

private class FetchValuesKnownSummary extends FetchValuesSummary {
  ConstantValue key;

  FetchValuesKnownSummary() {
    forex(Expr arg | arg = mc.getAnArgument() | exists(arg.getConstantValue())) and
    key = mc.getAnArgument().getConstantValue() and
    this = "fetch_values(" + key.serialize() + ")"
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    super.propagatesFlow(input, output, preservesValue)
    or
    input = "Argument[self].Element[" + key.serialize() + "]" and
    output = "ReturnValue.Element[?]" and
    preservesValue = true
  }
}

private class FetchValuesUnknownSummary extends FetchValuesSummary {
  FetchValuesUnknownSummary() {
    exists(Expr arg | arg = mc.getAnArgument() | not exists(arg.getConstantValue())) and
    this = "fetch_values(?)"
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    super.propagatesFlow(input, output, preservesValue)
    or
    input = "Argument[self].Element[any]" and
    output = "ReturnValue.Element[?]" and
    preservesValue = true
  }
}

private class MergeSummary extends SimpleSummarizedCallable {
  MergeSummary() {
    // deep_merge is an ActiveSupport extension
    // https://api.rubyonrails.org/classes/Hash.html#method-i-deep_merge
    this = ["merge", "deep_merge"]
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    (
      input = "Argument[self,any].WithElement[any]" and
      output = "ReturnValue"
      or
      input = "Argument[self,any].Element[any]" and
      output = "Argument[block].Parameter[1,2]"
    ) and
    preservesValue = true
  }
}

private class MergeBangSummary extends SimpleSummarizedCallable {
  MergeBangSummary() {
    // deep_merge! is an ActiveSupport extension
    // https://api.rubyonrails.org/classes/Hash.html#method-i-deep_merge-21
    this = ["merge!", "deep_merge!", "update"]
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    (
      input = "Argument[self,any].WithElement[any]" and
      output = ["ReturnValue", "Argument[self]"]
      or
      input = "Argument[self,any].Element[any]" and
      output = "Argument[block].Parameter[1,2]"
    ) and
    preservesValue = true
  }
}

private class RassocSummary extends SimpleSummarizedCallable {
  RassocSummary() { this = "rassoc" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[self].Element[any].WithoutElement[any]" and
    output = "ReturnValue.Element[1]" and
    preservesValue = true
  }
}

abstract private class SliceSummary extends SummarizedCallable {
  MethodCall mc;

  bindingset[this]
  SliceSummary() { mc.getMethodName() = "slice" }

  final override MethodCall getACallSimple() { result = mc }
}

private class SliceKnownSummary extends SliceSummary {
  ConstantValue key;

  SliceKnownSummary() {
    key = mc.getAnArgument().getConstantValue() and
    this = "slice(" + key.serialize() + ")" and
    not key.isInt(_) // covered in `Array.qll`
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[self].WithElement[" + key.serialize() + "]" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

private class SliceUnknownSummary extends SliceSummary {
  SliceUnknownSummary() {
    exists(Expr arg | arg = mc.getAnArgument() | not exists(arg.getConstantValue())) and
    this = "slice(?)"
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[self].WithoutElement[0..!].WithElement[any]" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

private class ToASummary extends SimpleSummarizedCallable {
  ToASummary() { this = "to_a" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[self].WithoutElement[0..!].Element[any]" and
    output = "ReturnValue.Element[?].Element[1]" and
    preservesValue = true
  }
}

private class ToHWithoutBlockSummary extends SimpleSummarizedCallable {
  ToHWithoutBlockSummary() { this = ["to_h", "to_hash"] and not exists(mc.getBlock()) }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[self].WithElement[any]" and
    output = "ReturnValue" and
    preservesValue = true
  }
}

private class ToHWithBlockSummary extends SimpleSummarizedCallable {
  ToHWithBlockSummary() { this = "to_h" and exists(mc.getBlock()) }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    (
      input = "Argument[self].Element[any]" and
      output = "Argument[block].Parameter[1]"
      or
      input = "Argument[block].ReturnValue.Element[1]" and
      output = "ReturnValue.Element[?]"
    ) and
    preservesValue = true
  }
}

private class TransformKeysSummary extends SimpleSummarizedCallable {
  TransformKeysSummary() { this = "transform_keys" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[self].Element[any]" and
    output = "ReturnValue.Element[?]" and
    preservesValue = true
  }
}

private class TransformKeysBangSummary extends SimpleSummarizedCallable {
  TransformKeysBangSummary() { this = "transform_keys!" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    (
      input = "Argument[self].Element[any]" and
      output = "Argument[self].Element[?]"
    ) and
    preservesValue = true
  }
}

private class TransformValuesSummary extends SimpleSummarizedCallable {
  TransformValuesSummary() { this = "transform_values" }

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

private class TransformValuesBangSummary extends SimpleSummarizedCallable {
  TransformValuesBangSummary() { this = "transform_values!" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    (
      input = "Argument[self].Element[any]" and
      output = "Argument[block].Parameter[0]"
      or
      input = "Argument[block].ReturnValue" and
      output = "Argument[self].Element[?]"
      or
      input = "Argument[self].WithoutElement[any]" and
      output = "Argument[self]"
    ) and
    preservesValue = true
  }
}

private class ValuesSummary extends SimpleSummarizedCallable {
  ValuesSummary() { this = "values" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[self].Element[any]" and
    output = "ReturnValue.Element[?]" and
    preservesValue = true
  }
}

// We don't (yet) track data flow through hash keys, but this is still useful in cases where a
// whole hash(like) object is tainted, such as `ActionController#params`.
private class KeysSummary extends SimpleSummarizedCallable {
  KeysSummary() { this = "keys" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    input = "Argument[self]" and
    output = "ReturnValue.Element[?]" and
    preservesValue = false
  }
}
