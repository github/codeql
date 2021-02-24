/**
 * Provides sources, sinks and sanitizers for reasoning about
 * DoS attacks due to inefficient handling of user-controlled objects.
 */

import javascript

/**
 * Provides sources, sinks and sanitizers for reasoning about
 * DoS attacks due to inefficient handling of user-controlled objects.
 */
module DeepObjectResourceExhaustion {
  /**
   * A data flow source for slow input validation.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for slow input validation.
   */
  abstract class Sink extends DataFlow::Node {
    /**
     * Holds if `link` and `text` should be included in the message to explain
     * why the input validation is slow.
     */
    abstract predicate hasReason(DataFlow::Node link, string text);
  }

  /**
   * A sanitizer for slow input validation.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** Gets a node that may refer to an object with `allErrors` set to `true`. */
  private DataFlow::SourceNode allErrorsObject(
    DataFlow::TypeTracker t, DataFlow::PropWrite allErrors
  ) {
    t.start() and
    exists(JsonSchema::Ajv::AjvValidationCall call) and // only compute if `ajv` is used
    allErrors.getPropertyName() = "allErrors" and
    allErrors.getRhs().mayHaveBooleanValue(true) and
    result = allErrors.getBase().getALocalSource()
    or
    exists(ExtendCall call |
      allErrorsObject(t.continue(), allErrors).flowsTo(call.getAnOperand()) and
      (result = call or result = call.getDestinationOperand().getALocalSource())
    )
    or
    exists(DataFlow::ObjectLiteralNode obj |
      allErrorsObject(t.continue(), allErrors).flowsTo(obj.getASpreadProperty()) and
      result = obj
    )
    or
    exists(DataFlow::TypeTracker t2 | result = allErrorsObject(t2, allErrors).track(t2, t))
  }

  /** Gets a node that may refer to an object with `allErrors` set to `true`. */
  private DataFlow::SourceNode allErrorsObject(DataFlow::PropWrite allErrors) {
    result = allErrorsObject(DataFlow::TypeTracker::end(), allErrors)
  }

  /** Argument to an `ajv` validation call configured with `allErrors: true`. */
  private class AjvValidationSink extends Sink {
    DataFlow::PropWrite allErrors;

    AjvValidationSink() {
      exists(JsonSchema::Ajv::AjvValidationCall call |
        this = call.getInput() and
        allErrorsObject(allErrors).flowsTo(call.getAnOptionsArg())
      )
    }

    override predicate hasReason(DataFlow::Node link, string text) {
      link = allErrors and
      text = "allErrors: true"
    }
  }
}
