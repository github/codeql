/** Provides classes and predicates for defining flow summaries. */

private import javascript
private import semmle.javascript.dataflow.internal.sharedlib.FlowSummaryImpl as Impl
private import semmle.javascript.dataflow.internal.FlowSummaryPrivate
private import semmle.javascript.dataflow.internal.sharedlib.DataFlowImplCommon as DataFlowImplCommon
private import semmle.javascript.dataflow.internal.DataFlowPrivate

/**
 * A model for a function that can propagate data flow.
 *
 * This class makes it possible to model flow through functions, using the same mechanism as
 * `summaryModel` as described in the [library customization docs](https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-javascript).
 *
 * Extend this class to define summary models directly in CodeQL.
 * Data extensions and `summaryModel` are usually preferred; but there are a few cases where direct use of this class may be needed:
 *
 * - The relevant call sites cannot be matched by the access path syntax, and require the full power of CodeQL.
 *   For example, complex overloading patterns might require more local reasoning at the call site.
 * - The input/output behaviour cannot be described statically in the access path syntax, but the relevant access paths
 *   can be generated dynamically in CodeQL, based on the usages found in the codebase.
 *
 * Subclasses should bind `this` to a unique identifier for the function being modelled. There is no special
 * interpreation of the `this` value, it should just not clash with the `this`-value used by other classes.
 *
 * For example, this models flow through calls such as `require("my-library").myFunction()`:
 * ```codeql
 * class MyFunction extends SummarizedCallable {
 *   MyFunction() { this = "MyFunction" }
 *
 *   override predicate propagatesFlow(string input, string output, boolean preservesValues) {
 *     input = "Argument[0]" and
 *     output = "ReturnValue" and
 *     preservesValue = false
 *   }
 *
 *   override DataFlow::InvokeNode getACall() {
 *     result = API::moduleImport("my-library").getMember("myFunction").getACall()
 *   }
 * }
 * ```
 * This would be equivalent to the following model written as a data extension:
 * ```yaml
 * extensions:
 *  - addsTo:
 *      pack: codeql/javascript-all
 *      extensible: summaryModel
 *    data:
 *      - ["my-library", "Member[myFunction]", "Argument[0]", "ReturnValue", "taint"]
 * ```
 */
abstract class SummarizedCallable extends LibraryCallable, Impl::Public::SummarizedCallable {
  bindingset[this]
  SummarizedCallable() { any() }

  /**
   * Holds if data may flow from `input` to `output` through this callable.
   *
   * `preservesValue` indicates whether this is a value-preserving step or a taint-step.
   *
   * See the [library customization docs](https://codeql.github.com/docs/codeql-language-guides/customizing-library-models-for-javascript) for
   * the syntax of the `input` and `output` parameters.
   */
  pragma[nomagic]
  predicate propagatesFlow(string input, string output, boolean preservesValue) { none() }

  override predicate propagatesFlow(
    string input, string output, boolean preservesValue, string model
  ) {
    this.propagatesFlow(input, output, preservesValue) and model = this
  }

  /**
   * Gets the synthesized parameter that results from an input specification
   * that starts with `Argument[s]` for this library callable.
   */
  DataFlow::ParameterNode getParameter(string s) {
    exists(ParameterPosition pos |
      DataFlowImplCommon::parameterNode(result, MkLibraryCallable(this), pos) and
      s = encodeParameterPosition(pos)
    )
  }
}
