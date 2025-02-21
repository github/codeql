/**
 * Contains flow summaries and steps modelling flow through string methods.
 */

private import javascript
private import semmle.javascript.dataflow.FlowSummary

/**
 * Summary for calls to `.replace` or `.replaceAll` (without a regexp pattern containing a wildcard).
 */
private class StringReplaceNoWildcard extends SummarizedCallable {
  StringReplaceNoWildcard() {
    this = "String#replace / String#replaceAll (without wildcard pattern)"
  }

  override StringReplaceCall getACall() { not result.hasRegExpContainingWildcard() }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
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

  override StringReplaceCall getACall() { result.hasRegExpContainingWildcard() }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
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
    result.getMethodName() = "split" and
    result.getNumArgument() = [1, 2] and
    not result.getArgument(0).getStringValue() = ["#", "?"]
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = false and
    input = "Argument[this]" and
    output = "ReturnValue.ArrayElement"
  }
}

/**
 * A call of form `x.split("#")` or `x.split("?")`.
 *
 * These are of special significance when tracking a tainted URL suffix, such as `window.location.href`,
 * because the first element of the resulting array should not be considered tainted.
 *
 * This summary defaults to the same behaviour as the general `.split()` case, but it contains optional steps
 * and barriers named `tainted-url-suffix` that should be activated when tracking a tainted URL suffix.
 */
class StringSplitHashOrQuestionMark extends SummarizedCallable {
  StringSplitHashOrQuestionMark() { this = "String#split with '#' or '?'" }

  override DataFlow::MethodCallNode getACallSimple() {
    result.getMethodName() = "split" and
    result.getNumArgument() = [1, 2] and
    result.getArgument(0).getStringValue() = ["#", "?"]
  }

  override predicate propagatesFlow(string input, string output, boolean preservesValue) {
    preservesValue = false and
    (
      input = "Argument[this].OptionalBarrier[split-url-suffix]" and
      output = "ReturnValue.ArrayElement"
      or
      input = "Argument[this].OptionalStep[split-url-suffix-pre]" and
      output = "ReturnValue.ArrayElement[0]"
      or
      input = "Argument[this].OptionalStep[split-url-suffix-post]" and
      output = "ReturnValue.ArrayElement[1]" // TODO: support ArrayElement[1..]
    )
  }
}
