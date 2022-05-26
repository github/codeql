/**
 * Modeling for `ActiveSupport`, which is a utility gem that ships with Rails.
 * https://rubygems.org/gems/activesupport
 */

private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow

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
    }
  }
}
