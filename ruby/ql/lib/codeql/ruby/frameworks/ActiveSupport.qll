/**
 * Modeling for `ActiveSupport`, which is a utility gem that ships with Rails.
 * https://rubygems.org/gems/activesupport
 */

private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.FlowSummary

/**
 * Modeling for `ActiveSupport`.
 */
module ActiveSupport {
  /**
   * Extensions to core classes
   */
  module CoreExtensions {
    /**
     * Extensions to the `String` class
     */
    module String {
      /**
       * A call to `String#constantize`, which tries to find a declared constant with the given name.
       * Passing user input to this method may result in instantiation of arbitrary Ruby classes.
       */
      class Constantize extends CodeExecution::Range, DataFlow::CallNode {
        // We treat this an `UnknownMethodCall` in order to match every call to `constantize` that isn't overridden.
        // We can't (yet) rely on API Graphs or dataflow to tell us that the receiver is a String.
        Constantize() {
          this.asExpr().getExpr().(UnknownMethodCall).getMethodName() = "constantize"
        }

        override DataFlow::Node getCode() { result = this.getReceiver() }
      }

      /**
       * Flow summary for methods which transform the receiver in some way, possibly preserving taint.
       */
      private class StringTransformSummary extends SummarizedCallable {
        // We're modelling a lot of different methods, so we make up a name for this summary.
        StringTransformSummary() { this = "ActiveSupportStringTransform" }

        override MethodCall getACall() {
          result.getMethodName() =
            [
              "camelize", "camelcase", "classify", "dasherize", "deconstantize", "demodulize",
              "foreign_key", "humanize", "indent", "parameterize", "pluralize", "singularize",
              "squish", "strip_heredoc", "tableize", "titlecase", "titleize", "underscore",
              "upcase_first"
            ]
        }

        override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
          input = "Argument[self]" and output = "ReturnValue" and preservesValue = false
        }
      }
    }
  }
}
