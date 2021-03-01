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

  /** A data flow node that is used a JSON schema. */
  abstract class SchemaRoot extends DataFlow::Node { }

  /** An object literal with a `$schema` property indicating it is the root of a JSON schema. */
  private class SchemaNodeByTag extends SchemaRoot, DataFlow::ObjectLiteralNode {
    SchemaNodeByTag() {
      getAPropertyWrite("$schema").getRhs().getStringValue().matches("%//json-schema.org%")
    }
  }

  /** Gets a data flow node that is part of a JSON schema. */
  private DataFlow::SourceNode getAPartOfJsonSchema(DataFlow::TypeBackTracker t) {
    t.start() and
    result = any(SchemaRoot n).getALocalSource()
    or
    result = getAPartOfJsonSchema(t.continue()).getAPropertySource()
    or
    exists(DataFlow::TypeBackTracker t2 | result = getAPartOfJsonSchema(t2).backtrack(t2, t))
  }

  /** Gets a data flow node that is part of a JSON schema. */
  DataFlow::SourceNode getAPartOfJsonSchema() {
    result = getAPartOfJsonSchema(DataFlow::TypeBackTracker::end())
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

      /**
       * Gets an API node for a function produced by `new Ajv().compile()` or similar.
       *
       * Note that this does not include the instance method `new Ajv().validate` as its
       * signature is different.
       */
      API::Node getAValidationFunction() {
        result = ref().getMember(["compile", "getSchema"]).getReturn()
        or
        result = ref().getMember("compileAsync").getPromised()
      }

      /**
       * Gets an API node that refers to an error produced by this Ajv instance.
       */
      API::Node getAValidationError() {
        exists(API::Node base | base = [ref(), getAValidationFunction()] |
          result = base.getMember("errors")
          or
          result = base.getMember("errorsText").getReturn()
        )
      }
    }

    /** A call to the `validate` method of `ajv`. */
    class AjvValidationCall extends ValidationCall {
      Instance instance;
      int argIndex;

      AjvValidationCall() {
        this = instance.ref().getMember("validate").getACall() and argIndex = 1
        or
        this = instance.getAValidationFunction().getACall() and argIndex = 0
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

    private class AjvSchemaNode extends SchemaRoot {
      AjvSchemaNode() {
        this =
          any(Instance i)
              .ref()
              .getMember(["addSchema", "validate", "compile", "compileAsync"])
              .getParameter(0)
              .getARhs()
      }
    }
  }
}
