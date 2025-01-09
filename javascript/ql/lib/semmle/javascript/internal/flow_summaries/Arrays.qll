/**
 * Contains a summary for relevant methods on arrays.
 *
 * Note that some of Array methods are modelled in `AmbiguousCoreMethods.qll`, and `toString` is special-cased elsewhere.
 */

private import javascript
private import semmle.javascript.dataflow.FlowSummary
private import semmle.javascript.dataflow.InferredTypes
private import semmle.javascript.dataflow.internal.DataFlowPrivate as Private
private import FlowSummaryUtil

pragma[nomagic]
DataFlow::SourceNode arrayConstructorRef() { result = DataFlow::globalVarRef("Array") }

pragma[nomagic]
private int firstSpreadIndex(ArrayExpr expr) {
  result = min(int i | expr.getElement(i) instanceof SpreadElement)
}

/**
 * Store and read steps for an array literal. Since literals are not seen as calls, this is not a flow summary.
 *
 * In case of spread elements `[x, ...y]`, we generate a read from `y -> ...y` and then a store from `...y` into
 * the array literal (to ensure constant-indices get broken up).
 */
class ArrayLiteralStep extends DataFlow::AdditionalFlowStep {
  override predicate storeStep(
    DataFlow::Node pred, DataFlow::ContentSet contents, DataFlow::Node succ
  ) {
    exists(ArrayExpr array, int i |
      pred = array.getElement(i).flow() and
      succ = array.flow()
    |
      if i >= firstSpreadIndex(array)
      then contents = DataFlow::ContentSet::arrayElement() // after a spread operator, store into unknown indices
      else contents = DataFlow::ContentSet::arrayElementFromInt(i)
    )
  }

  override predicate readStep(
    DataFlow::Node pred, DataFlow::ContentSet contents, DataFlow::Node succ
  ) {
    exists(SpreadElement spread |
      spread = any(ArrayExpr array).getAnElement() and
      pred = spread.getOperand().flow() and
      succ = spread.flow() and
      contents = DataFlow::ContentSet::arrayElement()
    )
  }
}

pragma[nomagic]
private predicate isForLoopVariable(Variable v) {
  v.getADeclarationStatement() = any(ForStmt stmt).getInit()
  or
  // Handle the somewhat rare case: `for (v; ...; ++v) { ... }`
  v.getADeclaration() = any(ForStmt stmt).getInit()
}

private predicate isLikelyArrayIndex(Expr e) {
  // Require that 'e' is of type number and refers to a for-loop variable.
  // TODO: This is here to mirror the old behaviour. Experiment with turning the 'and' into an 'or'.
  TTNumber() = unique(InferredType type | type = e.flow().analyze().getAType()) and
  isForLoopVariable(e.(VarAccess).getVariable())
  or
  e.(PropAccess).getPropertyName() = "length"
}

/**
 * A dynamic property store `obj[e] = rhs` seen as a potential array access.
 *
 * We need to restrict to cases where `e` is likely to be an array index, as
 * propagating data between arbitrary unknown property accesses is too imprecise.
 */
class DynamicArrayStoreStep extends DataFlow::AdditionalFlowStep {
  override predicate storeStep(
    DataFlow::Node pred, DataFlow::ContentSet contents, DataFlow::Node succ
  ) {
    exists(Assignment assignment, IndexExpr lvalue |
      lvalue = assignment.getLhs() and
      not exists(lvalue.getPropertyName()) and
      isLikelyArrayIndex(lvalue.getPropertyNameExpr()) and
      contents = DataFlow::ContentSet::arrayElement() and
      succ.(DataFlow::ExprPostUpdateNode).getPreUpdateNode() = lvalue.getBase().flow()
    |
      pred = assignment.(Assignment).getRhs().flow()
      or
      // for compound assignments, use the result of the operator
      pred = assignment.(CompoundAssignExpr).flow()
    )
  }
}

class ArrayConstructorSummary extends SummarizedCallable {
  ArrayConstructorSummary() { this = "Array constructor" }

  override DataFlow::InvokeNode getACallSimple() {
    result = arrayConstructorRef().getAnInvocation()
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[0..]" and
    output = "ReturnValue.ArrayElement"
    or
    preservesValue = false and
    input = "Argument[0..]" and
    output = "ReturnValue"
  }
}

/**
 * A call to `join` with a separator argument.
 *
 * Calls without separators are modelled in `StringConcatenation.qll`.
 */
class Join extends SummarizedCallable {
  Join() { this = "Array#join" }

  override InstanceCall getACallSimple() {
    result.getMethodName() = "join" and
    result.getNumArgument() = [0, 1]
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = false and
    input = "Argument[this].ArrayElement" and
    output = "ReturnValue"
  }
}

class CopyWithin extends SummarizedCallable {
  CopyWithin() { this = "Array#copyWithin" }

  override InstanceCall getACallSimple() { result.getMethodName() = "copyWithin" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[this].WithArrayElement" and
    output = "ReturnValue"
    or
    // Explicitly add a taint step since WithArrayElement is not implicitly converted to a taint step
    preservesValue = false and
    input = "Argument[this]" and
    output = "ReturnValue"
  }
}

class FlowIntoCallback extends SummarizedCallable {
  FlowIntoCallback() { this = "Array method with flow into callback" }

  override InstanceCall getACallSimple() {
    result.getMethodName() = ["every", "findIndex", "findLastIndex", "some"]
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      input = "Argument[this].ArrayElement" and
      output = "Argument[0].Parameter[0]"
      or
      input = "Argument[1]" and
      output = "Argument[0].Parameter[this]"
    )
  }
}

class Filter extends SummarizedCallable {
  Filter() { this = "Array#filter" }

  override InstanceCall getACallSimple() { result.getMethodName() = "filter" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      input = "Argument[this].ArrayElement" and
      output = "Argument[0].Parameter[0]"
      or
      input = "Argument[1]" and
      output = "Argument[0].Parameter[this]"
      or
      // Note: in case the filter condition acts as a barrier/sanitizer,
      // it is up to the query to mark the 'filter' call as a barrier/sanitizer
      input = "Argument[this].WithArrayElement" and
      output = "ReturnValue"
    )
    or
    // Explicitly add a taint step since WithArrayElement is not implicitly converted to a taint step
    preservesValue = false and
    input = "Argument[this]" and
    output = "ReturnValue"
  }
}

class Fill extends SummarizedCallable {
  Fill() { this = "Array#fill" } // TODO: clear contents if no interval is given

  override InstanceCall getACallSimple() { result.getMethodName() = "fill" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[0..]" and
    output = ["ReturnValue.ArrayElement", "Argument[this].ArrayElement"]
  }
}

class FindLike extends SummarizedCallable {
  FindLike() { this = "Array#find / Array#findLast" }

  override InstanceCall getACallSimple() { result.getMethodName() = ["find", "findLast"] }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      input = "Argument[this].ArrayElement" and
      output = ["Argument[0].Parameter[0]", "ReturnValue"]
      or
      input = "Argument[1]" and
      output = "Argument[0].Parameter[this]"
    )
  }
}

class FindLibrary extends SummarizedCallable {
  FindLibrary() { this = "'array.prototype.find' / 'array-find'" }

  override DataFlow::CallNode getACallSimple() {
    result = DataFlow::moduleImport(["array.prototype.find", "array-find"]).getACall()
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      input = "Argument[0].ArrayElement" and
      output = ["Argument[1].Parameter[0]", "ReturnValue"]
      or
      input = "Argument[2]" and
      output = "Argument[1].Parameter[this]"
    )
  }
}

class Flat extends SummarizedCallable {
  private int depth;

  Flat() { this = "Array#flat(" + depth + ")" and depth in [1 .. 3] }

  override InstanceCall getACallSimple() {
    result.getMethodName() = "flat" and
    (
      result.getNumArgument() = 1 and
      result.getArgument(0).getIntValue() = depth
      or
      depth = 1 and
      result.getNumArgument() = 0
    )
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      input = "Argument[this]" + concat(int n | n in [0 .. depth] | ".ArrayElement")
      or
      exists(int partialDepth | partialDepth in [1 .. depth - 1] |
        input =
          "Argument[this]" + concat(int n | n in [0 .. partialDepth] | ".ArrayElement") +
            ".WithoutArrayElement"
      )
    ) and
    output = "ReturnValue.ArrayElement"
  }
}

class FlatMap extends SummarizedCallable {
  FlatMap() { this = "Array#flatMap" }

  override InstanceCall getACallSimple() { result.getMethodName() = "flatMap" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      input = "Argument[this].ArrayElement" and
      output = "Argument[0].Parameter[0]"
      or
      input = "Argument[this]" and
      output = "Argument[0].Parameter[2]"
      or
      input = "Argument[1]" and
      output = "Argument[0].Parameter[1]"
      or
      input = "Argument[0].ReturnValue." + ["ArrayElement", "WithoutArrayElement"] and
      output = "ReturnValue.ArrayElement"
    )
  }
}

private DataFlow::CallNode arrayFromCall() {
  // TODO: update fromAsync model when async iterators are supported
  result = arrayConstructorRef().getAMemberCall(["from", "fromAsync"])
  or
  result = DataFlow::moduleImport("array-from").getACall()
}

class From1Arg extends SummarizedCallable {
  From1Arg() { this = "Array.from(arg)" }

  override DataFlow::CallNode getACallSimple() {
    result = arrayFromCall() and result.getNumArgument() = 1
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      input = "Argument[0].WithArrayElement" and
      output = "ReturnValue"
      or
      input = "Argument[0]." + ["SetElement", "IteratorElement"] and
      output = "ReturnValue.ArrayElement"
      or
      input = "Argument[0].MapKey" and
      output = "ReturnValue.ArrayElement.Member[0]"
      or
      input = "Argument[0].MapValue" and
      output = "ReturnValue.ArrayElement.Member[1]"
      or
      input = "Argument[0].IteratorError" and
      output = "ReturnValue[exception]"
    )
    or
    // Explicitly add a taint step since WithArrayElement is not implicitly converted to a taint step
    preservesValue = false and
    input = "Argument[0]" and
    output = "ReturnValue"
  }
}

class FromManyArg extends SummarizedCallable {
  FromManyArg() { this = "Array.from(arg, callback, [thisArg])" }

  override DataFlow::CallNode getACallSimple() {
    result = arrayFromCall() and
    result.getNumArgument() > 1
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      input = "Argument[0]." + ["ArrayElement", "SetElement", "IteratorElement"] and
      output = "Argument[1].Parameter[0]"
      or
      input = "Argument[0].MapKey" and
      output = "Argument[1].Parameter[0].Member[0]"
      or
      input = "Argument[0].MapValue" and
      output = "Argument[1].Parameter[0].Member[1]"
      or
      input = "Argument[1].ReturnValue" and
      output = "ReturnValue.ArrayElement"
      or
      input = "Argument[2]" and
      output = "Argument[1].Parameter[this]"
      or
      input = "Argument[0].IteratorError" and
      output = "ReturnValue[exception]"
    )
  }
}

class Map extends SummarizedCallable {
  Map() { this = "Array#map" }

  override InstanceCall getACallSimple() {
    // Note that this summary may spuriously apply to library methods named `map` such as from lodash/underscore.
    // However, this will not cause spurious flow, because for such functions, the first argument will be an array, not a callback,
    // and every part of the summary below uses Argument[0] in a way that requires it to be a callback.
    result.getMethodName() = "map"
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      input = "Argument[this].ArrayElement" and
      output = "Argument[0].Parameter[0]"
      or
      input = "Argument[this]" and
      output = "Argument[0].Parameter[2]"
      or
      input = "Argument[1]" and
      output = "Argument[0].Parameter[this]"
      or
      input = "Argument[0].ReturnValue" and
      output = "ReturnValue.ArrayElement"
    )
  }
}

class Of extends SummarizedCallable {
  Of() { this = "Array.of" }

  override DataFlow::CallNode getACallSimple() {
    result = arrayConstructorRef().getAMemberCall("of")
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[0..]" and
    output = "ReturnValue.ArrayElement"
  }
}

class Pop extends SummarizedCallable {
  Pop() { this = "Array#pop" }

  override InstanceCall getACallSimple() { result.getMethodName() = "pop" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[this].ArrayElement" and
    output = "ReturnValue"
  }
}

class PushLike extends SummarizedCallable {
  PushLike() { this = "Array#push / Array#unshift" }

  override InstanceCall getACallSimple() { result.getMethodName() = ["push", "unshift"] }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[0..]" and
    output = "Argument[this].ArrayElement"
  }
}

class ReduceLike extends SummarizedCallable {
  ReduceLike() { this = "Array#reduce / Array#reduceRight" }

  override InstanceCall getACallSimple() { result.getMethodName() = ["reduce", "reduceRight"] }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    /*
     * Signatures:
     *   reduce(callbackFn, [initialValue])
     *   callbackfn(accumulator, currentValue, index, array)
     */

    (
      input = ["Argument[1]", "Argument[0].ReturnValue"] and
      output = "Argument[0].Parameter[0]" // accumulator
      or
      input = "Argument[this].ArrayElement" and
      output = "Argument[0].Parameter[1]" // currentValue
      or
      input = "Argument[this]" and
      output = "Argument[0].Parameter[3]" // array
      or
      input = "Argument[0].ReturnValue" and
      output = "ReturnValue"
    )
  }
}

class Reverse extends SummarizedCallable {
  Reverse() { this = "Array#reverse / Array#toReversed" }

  override InstanceCall getACallSimple() { result.getMethodName() = ["reverse", "toReversed"] }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[this].ArrayElement" and
    output = "ReturnValue.ArrayElement"
  }
}

class Shift extends SummarizedCallable {
  Shift() { this = "Array#shift" }

  override InstanceCall getACallSimple() { result.getMethodName() = "shift" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[this].ArrayElement[0]" and
    output = "ReturnValue"
    or
    // ArrayElement[0] in the above summary is not automatically converted to a taint step, so manully add
    // one from the array to the return value.
    preservesValue = false and
    input = "Argument[this]" and
    output = "ReturnValue"
  }
}

class Sort extends SummarizedCallable {
  Sort() { this = "Array#sort / Array#toSorted" }

  override InstanceCall getACallSimple() { result.getMethodName() = ["sort", "toSorted"] }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      input = "Argument[this].ArrayElement" and
      output = "ReturnValue.ArrayElement"
      or
      input = "Argument[this].ArrayElement" and
      output = "Argument[0].Parameter[0,1]"
    )
  }
}

class Splice extends SummarizedCallable {
  Splice() { this = "Array#splice" }

  override InstanceCall getACallSimple() { result.getMethodName() = "splice" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      input = "Argument[this].ArrayElement" and
      output = "ReturnValue.ArrayElement"
      or
      input = "Argument[2..]" and
      output = ["Argument[this].ArrayElement", "ReturnValue.ArrayElement"]
    )
  }
}

class ToSpliced extends SummarizedCallable {
  ToSpliced() { this = "Array#toSpliced" }

  override InstanceCall getACallSimple() { result.getMethodName() = "toSpliced" }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      input = "Argument[this].ArrayElement" and
      output = "ReturnValue.ArrayElement"
      or
      input = "Argument[2..]" and
      output = "ReturnValue.ArrayElement"
    )
  }
}

class ArrayCoercionPackage extends FunctionalPackageSummary {
  ArrayCoercionPackage() { this = "ArrayCoercionPackage" }

  override string getAPackageName() { result = ["arrify", "array-ify"] }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    (
      input = "Argument[0].WithArrayElement" and
      output = "ReturnValue"
      or
      input = "Argument[0].WithoutArrayElement" and
      output = "ReturnValue.ArrayElement"
    )
    or
    // Explicitly add a taint step since WithArrayElement is not implicitly converted to a taint step
    preservesValue = false and
    input = "Argument[0]" and
    output = "ReturnValue"
  }
}

class ArrayCopyingPackage extends FunctionalPackageSummary {
  ArrayCopyingPackage() { this = "ArrayCopyingPackage" }

  override string getAPackageName() { result = ["array-union", "array-uniq", "uniq"] }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = true and
    input = "Argument[0..].ArrayElement" and
    output = "ReturnValue.ArrayElement"
  }
}

class ArrayFlatteningPackage extends FunctionalPackageSummary {
  ArrayFlatteningPackage() { this = "ArrayFlatteningPackage" }

  override string getAPackageName() {
    result = ["array-flatten", "arr-flatten", "flatten", "array.prototype.flat"]
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    // TODO: properly support these. For the moment we're just adding parity with the old model
    preservesValue = false and
    input = "Argument[0..]" and
    output = "ReturnValue"
  }
}
