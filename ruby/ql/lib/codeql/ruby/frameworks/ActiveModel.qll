/**
 * Provides modeling for the `ActiveModel` library.
 * https://rubygems.org/gems/activemodel
 * Version: 7.0
 */

private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.Concepts
private import codeql.ruby.frameworks.ActiveRecord

/**
 * Provides modeling for the `ActiveModel` library.
 * https://rubygems.org/gems/activemodel
 * Version: 7.0
 */
module ActiveModel {
  /**
   * Flow summary for `ActiveModel#serializable_hash`. This method returns the
   * attributes of the receiver as a hash.
   */
  private class SerializableHashSummary extends SimpleSummarizedCallable {
    SerializableHashSummary() { this = "serializable_hash" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      // This results in an input/output pair for every field in the database, which is probably too costly.
      // Consider restricting to fields which are written to on this model instance.
      // Or introduce a Field[any] component.
      exists(DataFlow::Content::FieldContent field, string name |
        name = field.getName().regexpCapture("^@(.+)$", 1)
      |
        input = "Argument[self].Field[" + field + "]" and
        output = "ReturnValue.Element[\"" + name + "\"]" and
        preservesValue = true
      )
    }
  }
}
