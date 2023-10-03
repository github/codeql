/**
 * Contains flow summaries and steps modelling flow through string methods.
 */

private import javascript
private import semmle.javascript.dataflow.FlowSummary

/** Holds if the given call takes a regexp containing a wildcard. */
pragma[noinline]
private predicate hasWildcardReplaceRegExp(StringReplaceCall call) {
  RegExp::isWildcardLike(call.getRegExp().getRoot().getAChild*())
}

/**
 * Summary for calls to `.replace` or `.replaceAll` (without a regexp pattern containing a wildcard).
 */
private class StringReplaceNoWildcard extends SummarizedCallable {
  StringReplaceNoWildcard() {
    this = "String#replace / String#replaceAll (without wildcard pattern)"
  }

  override StringReplaceCall getACall() { not hasWildcardReplaceRegExp(result) }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    preservesValue = false and
    (
      input = "Argument[this]" and
      output = "ReturnValue"
      or
      input = "Argument[1].ReturnValue" and
      output = "ReturnValue"
    )
  }
}

/**
 * Summary for calls to `.replace` or `.replaceAll` (with a regexp pattern containing a wildcard).
 *
 * In this case, the receiver is considered to flow into the callback.
 */
private class StringReplaceWithWildcard extends SummarizedCallable {
  StringReplaceWithWildcard() {
    this = "String#replace / String#replaceAll (with wildcard pattern)"
  }

  override StringReplaceCall getACall() { hasWildcardReplaceRegExp(result) }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    preservesValue = false and
    (
      input = "Argument[this]" and
      output = ["ReturnValue", "Argument[1].Parameter[0]"]
      or
      input = "Argument[1].ReturnValue" and
      output = "ReturnValue"
    )
  }
}

class StringSplit extends SummarizedCallable {
  StringSplit() { this = "String#split" }

  override DataFlow::MethodCallNode getACallSimple() {
    result.getMethodName() = "split" and result.getNumArgument() = 1
  }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    preservesValue = false and
    input = "Argument[this]" and
    output = "ReturnValue.ArrayElement"
  }
}
