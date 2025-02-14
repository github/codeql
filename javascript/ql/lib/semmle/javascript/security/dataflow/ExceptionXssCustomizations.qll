/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * cross-site scripting vulnerabilities where the taint-flow passes through a thrown
 * exception.
 */

import javascript

/**
 * Provides sources, sinks, and sanitizers for reasoning about
 * cross-site scripting vulnerabilities where the taint-flow passes through a thrown
 * exception.
 */
module ExceptionXss {
  private import Xss::Shared as Shared

  private newtype TFlowState =
    TThrown() or
    TNotYetThrown()

  /** A flow state to associate with a tracked value. */
  class FlowState extends TFlowState {
    /** Gets a string representation fo this flow state */
    string toString() {
      this = TThrown() and result = "thrown"
      or
      this = TNotYetThrown() and result = "not-yet-thrown"
    }

    /** Gets the corresponding flow label. */
    deprecated DataFlow::FlowLabel toFlowLabel() {
      this = TThrown() and result.isTaint()
      or
      this = TNotYetThrown() and result instanceof NotYetThrown
    }
  }

  /** Predicates for working with flow states. */
  module FlowState {
    /** Gets the flow state corresponding to `label`. */
    deprecated FlowState fromFlowLabel(DataFlow::FlowLabel label) { result.toFlowLabel() = label }

    /** A tainted value originating from a thrown and caught exception. */
    FlowState thrown() { result = TThrown() }

    /** A value that has not yet been thrown. */
    FlowState notYetThrown() { result = TNotYetThrown() }
  }

  /** A data flow source for XSS caused by interpreting exception or error text as HTML. */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets a flow state to associate with this source.
     *
     * For sources that should pass through a `throw/catch` before reaching the sink, use the
     * `FlowState::notYetThrown()` state. Otherwise use `FlowState::thrown()` (the default).
     */
    FlowState getAFlowState() { result = FlowState::thrown() }

    /** DEPRECATED. Use `getAFlowState()` instead. */
    deprecated DataFlow::FlowLabel getAFlowLabel() { result = this.getAFlowState().toFlowLabel() }

    /**
     * Gets a human-readable description of what type of error this refers to.
     *
     * The result should be capitalized and usable in the context of a noun.
     */
    string getDescription() { result = "Error text" }
  }

  /**
   * DEPRECATED. Use `FlowState` instead.
   *
   * A FlowLabel representing tainted data that has not been thrown in an exception.
   * In the js/xss-through-exception query data-flow can only reach a sink after
   * the data has been thrown as an exception, and data that has not been thrown
   * as an exception therefore has this flow label, and only this flow label, associated with it.
   */
  abstract deprecated class NotYetThrown extends DataFlow::FlowLabel {
    NotYetThrown() { this = "NotYetThrown" }
  }

  private class XssSourceAsSource extends Source instanceof Shared::Source {
    override FlowState getAFlowState() { result instanceof TNotYetThrown }

    override string getDescription() { result = "Exception text" }
  }

  /**
   * An error produced by validating using `ajv`.
   *
   * Such an error can contain property names from the input if the
   * underlying schema uses `additionalProperties` or `propertyPatterns`.
   *
   * For example, an input of form `{"<img src=x onerror=alert(1)>": 45}` might produce the error
   * `data/<img src=x onerror=alert(1)> should be string`.
   */
  private class JsonSchemaValidationError extends Source {
    JsonSchemaValidationError() {
      this = any(JsonSchema::Ajv::Instance i).getAValidationError().asSource()
      or
      this = any(JsonSchema::Joi::JoiValidationErrorRead r).getAValidationResultAccess(_)
    }

    override string getDescription() { result = "JSON schema validation error" }
  }
}
