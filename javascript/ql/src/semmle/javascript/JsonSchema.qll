/**
 * Provides classes and predicates for working with JSON schema libraries.
 */

import javascript

/**
 * Provides classes and predicates for working with JSON schema libraries.
 */
module JsonSchema {
  /** A call that validates an input against a JSON schema. */
  abstract class ValidationCall extends DataFlow::CallNode {
    /** Gets the data flow node whose value is being validated. */
    abstract DataFlow::Node getInput();

    /** Gets the return value that indicates successful validation. */
    boolean getPolarity() { result = true }
  }

  /** Provides a model of the `ajv` library. */
  module Ajv {
    /** A method on `Ajv` that returns `this`. */
    private string chainedMethod() {
      result =
        ["addSchema", "addMetaSchema", "removeSchema", "addFormat", "addKeyword", "removeKeyword"]
    }

    /** An instance of `ajv`. */
    class Instance extends API::InvokeNode {
      Instance() { this = API::moduleImport("ajv").getAnInstantiation() }

      /** Gets the data flow node holding the options passed to this `Ajv` instance. */
      DataFlow::Node getOptionsArg() { result = getArgument(0) }

      /** Gets an API node that refers to this object. */
      API::Node ref() {
        result = getReturn()
        or
        result = ref().getMember(chainedMethod()).getReturn()
      }
    }

    /** A call to the `validate` method of `ajv`. */
    class AjvValidationCall extends ValidationCall {
      Instance instance;
      int argIndex;

      AjvValidationCall() {
        this = instance.ref().getMember("validate").getACall() and argIndex = 1
        or
        this = instance.ref().getMember(["compile", "getSchema"]).getReturn().getACall() and
        argIndex = 0
        or
        this = instance.ref().getMember("compileAsync").getPromised().getACall() and argIndex = 0
      }

      override DataFlow::Node getInput() { result = getArgument(argIndex) }

      /** Gets the argument holding additional options to the call. */
      DataFlow::Node getOwnOptionsArg() { result = getArgument(argIndex + 1) }

      /** Gets a data flow passed as the extra options to this validation call or to the underlying `Ajv` instance. */
      DataFlow::Node getAnOptionsArg() {
        result = getOwnOptionsArg()
        or
        result = instance.getOptionsArg()
      }

      /** Gets the ajv instance doing the validation. */
      Instance getAjvInstance() { result = instance }
    }
  }
}
