/**
 * Provides modeling for the `Object` class.
 */

private import codeql.ruby.AST
private import codeql.ruby.dataflow.FlowSummary

/**
 * Provides modeling for the `Object` class.
 */
module Object {
  /**
   * An instance method on `Object`, which is available to all classes except `BasicObject`.
   */
  class ObjectInstanceMethodCall extends UnknownMethodCall {
    ObjectInstanceMethodCall() { this.getMethodName() = objectInstanceMethodName() }
  }

  /**
   * Gets the name of an `Object` instance method.
   */
  string objectInstanceMethodName() {
    result in [
        "!~", "<=>", "===", "=~", "callable_methods", "define_singleton_method", "display",
        "do_until", "do_while", "dup", "enum_for", "eql?", "extend", "f", "freeze", "h", "hash",
        "inspect", "instance_of?", "instance_variable_defined?", "instance_variable_get",
        "instance_variable_set", "instance_variables", "is_a?", "itself", "kind_of?",
        "matching_methods", "method", "method_missing", "methods", "nil?", "object_id",
        "private_methods", "protected_methods", "public_method", "public_methods", "public_send",
        "remove_instance_variable", "respond_to?", "respond_to_missing?", "send",
        "shortest_abbreviation", "singleton_class", "singleton_method", "singleton_methods",
        "taint", "tainted?", "to_enum", "to_s", "trust", "untaint", "untrust", "untrusted?"
      ]
  }

  private class DupSummary extends SimpleSummarizedCallable {
    DupSummary() { this = "dup" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }
}
