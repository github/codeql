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

    /**
     * Gets the return value that indicates successful validation, if any.
     *
     * Has no result if the return value from this call does not directly
     * indicate success.
     */
    boolean getPolarity() { result = true }

    /**
     * Gets a value that indicates whether the validation was successful.
     */
    DataFlow::Node getAValidationResultAccess(boolean polarity) {
      result = this and polarity = this.getPolarity()
    }
  }

  /** A data flow node that is used a JSON schema. */
  abstract class SchemaRoot extends DataFlow::Node { }

  /** An object literal with a `$schema` property indicating it is the root of a JSON schema. */
  private class SchemaNodeByTag extends SchemaRoot, DataFlow::ObjectLiteralNode {
    SchemaNodeByTag() {
      this.getAPropertyWrite("$schema").getRhs().getStringValue().matches("%//json-schema.org%")
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
    /** Gets a method on `Ajv` that returns `this`. */
    private string chainedMethod() {
      result =
        ["addSchema", "addMetaSchema", "removeSchema", "addFormat", "addKeyword", "removeKeyword"]
    }

    /** An instance of `ajv`. */
    class Instance extends API::InvokeNode {
      Instance() { this = API::moduleImport("ajv").getAnInstantiation() }

      /** Gets the data flow node holding the options passed to this `Ajv` instance. */
      DataFlow::Node getOptionsArg() { result = this.getArgument(0) }

      /** Gets an API node that refers to this object. */
      API::Node ref() {
        result = this.getReturn()
        or
        result = this.ref().getMember(chainedMethod()).getReturn()
      }

      /**
       * Gets an API node for a function produced by `new Ajv().compile()` or similar.
       *
       * Note that this does not include the instance method `new Ajv().validate` as its
       * signature is different.
       */
      API::Node getAValidationFunction() {
        result = this.ref().getMember(["compile", "getSchema"]).getReturn()
        or
        result = this.ref().getMember("compileAsync").getPromised()
      }

      /**
       * Gets an API node that refers to an error produced by this Ajv instance.
       */
      API::Node getAValidationError() {
        exists(API::Node base | base = [this.ref(), this.getAValidationFunction()] |
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

      override DataFlow::Node getInput() { result = this.getArgument(argIndex) }

      /** Gets the argument holding additional options to the call. */
      DataFlow::Node getOwnOptionsArg() { result = this.getArgument(argIndex + 1) }

      /** Gets a data flow passed as the extra options to this validation call or to the underlying `Ajv` instance. */
      DataFlow::Node getAnOptionsArg() {
        result = this.getOwnOptionsArg()
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

  /** Provides a model for working with the [`joi`](https://npmjs.org/package/joi) library. */
  module Joi {
    /** Gets a schema created using `joi.object()` or other schemas that might refer an object schema. */
    private API::Node objectSchema() {
      // A call that creates a schema that might be an object schema.
      result =
        API::moduleImport("joi")
            .getMember([
                "object", "alternatives", "all", "link", "compile", "allow", "valid", "when",
                "build", "options"
              ])
            .getReturn()
      or
      // A call to a schema that returns another schema.
      // Read from the [index.d.ts](https://github.com/sideway/joi/blob/master/lib/index.d.ts) file.
      result =
        objectSchema()
            .getMember([
                // AnySchema
                "allow", "alter", "bind", "cache", "cast", "concat", "default", "description",
                "disallow", "empty", "equal", "error", "example", "exist", "external", "failover",
                "forbidden", "fork", "id", "invalid", "keep", "label", "message", "messages",
                "meta", "not", "note", "only", "optional", "options", "prefs", "preferences",
                "presence", "raw", "required", "rule", "shared", "strict", "strip", "tag", "tailor",
                "unit", "valid", "warn", "warning", "when",
                // ObjectSchema
                "and", "append", "assert", "instance", "keys", "length", "max", "min", "nand", "or",
                "oxor", "pattern", "ref", "regex", "rename", "schema", "unknown", "with", "without",
                "xor"
              ])
            .getReturn()
    }

    /**
     * A call to the `validate` method from the [`joi`](https://npmjs.org/package/joi) library.
     * The `error` property in the result indicates whether the validation was successful.
     */
    class JoiValidationErrorRead extends ValidationCall, API::CallNode {
      JoiValidationErrorRead() { this = objectSchema().getMember("validate").getACall() }

      override DataFlow::Node getInput() { result = this.getArgument(0) }

      override boolean getPolarity() { none() }

      override DataFlow::Node getAValidationResultAccess(boolean polarity) {
        result = this.getReturn().getMember("error").getAnImmediateUse() and
        polarity = false
      }
    }
  }
}
