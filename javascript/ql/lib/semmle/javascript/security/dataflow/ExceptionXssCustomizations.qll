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

  /** A data flow source for XSS caused by interpreting exception or error text as HTML. */
  abstract class Source extends DataFlow::Node {
    /**
     * Gets a flow label to associate with this source.
     *
     * For sources that should pass through a `throw/catch` before reaching the sink, use the
     * `NotYetThrown` labe. Otherwise use `taint` (the default).
     */
    DataFlow::FlowLabel getAFlowLabel() { result.isTaint() }

    /**
     * Gets a human-readable description of what type of error this refers to.
     *
     * The result should be capitalized and usable in the context of a noun.
     */
    string getDescription() { result = "Error text" }
  }

  /**
   * A FlowLabel representing tainted data that has not been thrown in an exception.
   * In the js/xss-through-exception query data-flow can only reach a sink after
   * the data has been thrown as an exception, and data that has not been thrown
   * as an exception therefore has this flow label, and only this flow label, associated with it.
   */
  abstract class NotYetThrown extends DataFlow::FlowLabel {
    NotYetThrown() { this = "NotYetThrown" }
  }

  private class XssSourceAsSource extends Source instanceof Shared::Source {
    override DataFlow::FlowLabel getAFlowLabel() { result instanceof NotYetThrown }

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
