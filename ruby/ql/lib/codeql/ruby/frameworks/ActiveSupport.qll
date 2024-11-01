/**
 * Modeling for `ActiveSupport`, which is a utility gem that ships with Rails.
 * https://rubygems.org/gems/activesupport
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.stdlib.Logger::Logger as StdlibLogger
private import codeql.ruby.frameworks.data.ModelsAsData

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
       * A call to `String#constantize` or `String#safe_constantize`, which
       * tries to find a declared constant with the given name.
       * Passing user input to this method may result in instantiation of
       * arbitrary Ruby classes.
       */
      class Constantize extends CodeExecution::Range, DataFlow::CallNode {
        // We treat this an `UnknownMethodCall` in order to match every call to `constantize` that isn't overridden.
        // We can't (yet) rely on API Graphs or dataflow to tell us that the receiver is a String.
        Constantize() {
          this.asExpr().getExpr().(UnknownMethodCall).getMethodName() =
            ["constantize", "safe_constantize"]
        }

        override DataFlow::Node getCode() { result = this.getReceiver() }

        override predicate runsArbitraryCode() { none() }
      }

      /**
       * Flow summary for methods which transform the receiver in some way, possibly preserving taint.
       */
      private class StringTransformSummary extends SummarizedCallable {
        // We're modeling a lot of different methods, so we make up a name for this summary.
        StringTransformSummary() { this = "ActiveSupportStringTransform" }

        override MethodCall getACall() {
          result.getMethodName() =
            [
              "at", "camelize", "camelcase", "classify", "dasherize", "deconstantize", "demodulize",
              "first", "foreign_key", "from", "html_safe", "humanize", "indent", "indent!",
              "inquiry", "last", "mb_chars", "parameterize", "pluralize", "remove", "remove!",
              "singularize", "squish", "squish!", "strip_heredoc", "tableize", "titlecase",
              "titleize", "to", "truncate", "truncate_bytes", "truncate_words", "underscore",
              "upcase_first"
            ]
        }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          input = "Argument[self]" and output = "ReturnValue" and preservesValue = false
        }
      }
    }

    /**
     * Extensions to the `Object` class.
     */
    module Object {
      /** Flow summary for methods which can return the receiver. */
      private class IdentitySummary extends SimpleSummarizedCallable {
        IdentitySummary() { this = ["presence", "deep_dup"] }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          input = "Argument[self]" and
          output = "ReturnValue" and
          preservesValue = true
        }
      }

      /**
       * A call to `Object#try`, which may execute its first argument as a Ruby
       * method call.
       * ```rb
       * x = "abc"
       * x.try(:upcase) # => "ABC"
       * y = nil
       * y.try(:upcase) # => nil
       * ```
       * `Object#try!` behaves similarly but raises `NoMethodError` if the
       * receiver is not `nil` and does not respond to the method.
       */
      class TryCallCodeExecution extends CodeExecution::Range instanceof DataFlow::CallNode {
        TryCallCodeExecution() {
          this.asExpr().getExpr() instanceof UnknownMethodCall and
          this.getMethodName() = ["try", "try!"]
        }

        override DataFlow::Node getCode() { result = super.getArgument(0) }

        override predicate runsArbitraryCode() { none() }
      }

      /** Flow summary for `Object#to_json`, which serializes the receiver as a JSON string. */
      private class ToJsonSummary extends SimpleSummarizedCallable {
        ToJsonSummary() { this = "to_json" }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          input = ["Argument[self]", "Argument[self].Element[any]"] and
          output = "ReturnValue" and
          preservesValue = false
        }
      }
    }

    /**
     * Extensions to the `Hash` class.
     */
    module Hash {
      /**
       * Flow summary for `reverse_merge`, and its alias `with_defaults`.
       */
      private class ReverseMergeSummary extends SimpleSummarizedCallable {
        ReverseMergeSummary() { this = ["reverse_merge", "with_defaults"] }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          input = "Argument[self,0].WithElement[any]" and
          output = "ReturnValue" and
          preservesValue = true
        }
      }

      /**
       * Flow summary for `reverse_merge!`, and its aliases `with_defaults!` and `reverse_update`.
       */
      private class ReverseMergeBangSummary extends SimpleSummarizedCallable {
        ReverseMergeBangSummary() { this = ["reverse_merge!", "with_defaults!", "reverse_update"] }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          input = "Argument[self,0].WithElement[any]" and
          output = ["ReturnValue", "Argument[self]"] and
          preservesValue = true
        }
      }

      private class TransformSummary extends SimpleSummarizedCallable {
        TransformSummary() {
          this =
            [
              "stringify_keys", "to_options", "symbolize_keys", "deep_stringify_keys",
              "deep_symbolize_keys", "with_indifferent_access"
            ]
        }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          // keys are considered equal modulo string/symbol in our implementation
          input = "Argument[self].WithElement[any]" and
          output = "ReturnValue" and
          preservesValue = true
        }
      }

      private string getExtractComponent(MethodCall mc, int i) {
        mc.getMethodName() = "extract!" and
        result = DataFlow::Content::getKnownElementIndex(mc.getArgument(i)).serialize()
      }

      /**
       * A flow summary for `Hash#extract!`. This method removes the key/value pairs
       * matching the given keys from the receiver and returns them (as a Hash).
       *
       * Example:
       *
       * ```rb
       *  hash = { a: 1, b: 2, c: 3, d: 4 }
       *  hash.extract!(:a, :b) # => {:a=>1, :b=>2}
       *  hash                  # => {:c=>3, :d=>4}
       * ```
       *
       * There is value flow from elements corresponding to keys in the
       * arguments (`:a` and `:b` in the example) to elements in
       * the return value.
       * There is also value flow from any element corresponding to a key _not_
       * mentioned in the arguments to an element in `self`, including elements
       * at unknown keys.
       */
      private class ExtractSummary extends SummarizedCallable {
        MethodCall mc;

        ExtractSummary() {
          mc.getMethodName() = "extract!" and
          this =
            "extract!(" +
              concat(int i, string s | s = getExtractComponent(mc, i) | s, "," order by i) + ")"
        }

        final override MethodCall getACall() { result = mc }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          (
            exists(string s | s = getExtractComponent(mc, _) |
              input = "Argument[self].Element[" + s + "!]" and
              output = "ReturnValue.Element[" + s + "!]"
            )
            or
            // Argument[self].WithoutElement[:a!, :b!].WithElement[any] means
            // "an element of self whose key is not :a or :b, including elements
            // with unknown keys"
            input =
              "Argument[self]" +
                concat(int i, string s |
                  s = getExtractComponent(mc, i)
                |
                  ".WithoutElement[" + s + "!]" order by i
                ) + ".WithElement[any]" and
            output = "Argument[self]"
          ) and
          preservesValue = true
        }
      }
    }

    /**
     * Extensions to the `Enumerable` module.
     */
    module Enumerable {
      private class ArrayIndex extends int {
        ArrayIndex() { this = any(DataFlow::Content::KnownElementContent c).getIndex().getInt() }
      }

      private class CompactBlankSummary extends SimpleSummarizedCallable {
        CompactBlankSummary() { this = "compact_blank" }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          input = "Argument[self].Element[any]" and
          output = "ReturnValue.Element[?]" and
          preservesValue = true
        }
      }

      private class ExcludingSummary extends SimpleSummarizedCallable {
        ExcludingSummary() { this = ["excluding", "without"] }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          input = "Argument[self].Element[any]" and
          output = "ReturnValue.Element[?]" and
          preservesValue = true
        }
      }

      private class InOrderOfSummary extends SimpleSummarizedCallable {
        InOrderOfSummary() { this = "in_order_of" }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          input = "Argument[self].Element[any]" and
          output = "ReturnValue.Element[?]" and
          preservesValue = true
        }
      }

      /**
       * Like `Array#push` but doesn't update the receiver.
       */
      private class IncludingSummary extends SimpleSummarizedCallable {
        IncludingSummary() { this = "including" }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          (
            exists(ArrayIndex i |
              input = "Argument[self].Element[" + i + "]" and
              output = "ReturnValue.Element[" + i + "]"
            )
            or
            input = "Argument[self].Element[?]" and
            output = "ReturnValue.Element[?]"
            or
            exists(int i | i in [0 .. (mc.getNumberOfArguments() - 1)] |
              input = "Argument[" + i + "]" and
              output = "ReturnValue.Element[?]"
            )
          ) and
          preservesValue = true
        }
      }

      private class IndexBySummary extends SimpleSummarizedCallable {
        IndexBySummary() { this = "index_by" }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          input = "Argument[self].Element[any]" and
          output = ["Argument[block].Parameter[0]", "ReturnValue.Element[?]"] and
          preservesValue = true
        }
      }

      private class IndexWithSummary extends SimpleSummarizedCallable {
        IndexWithSummary() { this = "index_with" }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          input = "Argument[self].Element[any]" and
          output = "Argument[block].Parameter[0]" and
          preservesValue = true
          or
          input = ["Argument[0]", "Argument[block].ReturnValue"] and
          output = "ReturnValue.Element[?]" and
          preservesValue = true
        }
      }

      private string getKeyArgument(MethodCall mc, int i) {
        mc.getMethodName() = ["pick", "pluck"] and
        result = DataFlow::Content::getKnownElementIndex(mc.getArgument(i)).serialize()
      }

      private class PickSingleSummary extends SummarizedCallable {
        private MethodCall mc;
        private string key;

        PickSingleSummary() {
          key = getKeyArgument(mc, 0) and
          this = "Enumerable.pick(" + key + ")" and
          mc.getMethodName() = "pick" and
          mc.getNumberOfArguments() = 1
        }

        override MethodCall getACall() { result = mc }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          input = "Argument[self].Element[0].Element[" + key + "]" and
          output = "ReturnValue" and
          preservesValue = true
        }
      }

      private class PickMultipleSummary extends SummarizedCallable {
        private MethodCall mc;

        PickMultipleSummary() {
          mc.getMethodName() = "pick" and
          mc.getNumberOfArguments() > 1 and
          exists(int maxKey |
            maxKey = max(int j | exists(getKeyArgument(mc, j))) and
            this =
              "Enumerable.pick(" +
                concat(int i, string key |
                  key = getKeyArgument(mc, i)
                  or
                  key = "_" and
                  not exists(getKeyArgument(mc, i)) and
                  i in [0 .. maxKey]
                |
                  key, "," order by i
                ) + ")"
          )
        }

        override MethodCall getACall() { result = mc }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          exists(string s, int i |
            s = getKeyArgument(mc, i) and
            input = "Argument[self].Element[0].Element[" + s + "]" and
            output = "ReturnValue.Element[" + i + "]"
          ) and
          preservesValue = true
        }
      }

      private class PluckSingleSummary extends SummarizedCallable {
        private MethodCall mc;
        private string key;

        PluckSingleSummary() {
          key = getKeyArgument(mc, 0) and
          this = "Enumerable.pluck(" + key + ")" and
          mc.getMethodName() = "pluck" and
          mc.getNumberOfArguments() = 1
        }

        override MethodCall getACall() { result = mc }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          input = "Argument[self].Element[any].Element[" + key + "]" and
          output = "ReturnValue.Element[any]" and
          preservesValue = true
        }
      }

      private class PluckMultipleSummary extends SummarizedCallable {
        private MethodCall mc;

        PluckMultipleSummary() {
          mc.getMethodName() = "pluck" and
          mc.getNumberOfArguments() > 1 and
          exists(int maxKey |
            maxKey = max(int j | exists(getKeyArgument(mc, j))) and
            this =
              "Enumerable.pluck(" +
                concat(int i, string key |
                  key = getKeyArgument(mc, i)
                  or
                  key = "_" and
                  not exists(getKeyArgument(mc, i)) and
                  i in [0 .. maxKey]
                |
                  key, "," order by i
                ) + ")"
          )
        }

        override MethodCall getACall() { result = mc }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          exists(string s, int i |
            s = getKeyArgument(mc, i) and
            input = "Argument[self].Element[any].Element[" + s + "]" and
            output = "ReturnValue.Element[?].Element[" + i + "]"
          ) and
          preservesValue = true
        }
      }

      private class SoleSummary extends SimpleSummarizedCallable {
        SoleSummary() { this = "sole" }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          input = "Argument[self].Element[0]" and
          output = "ReturnValue" and
          preservesValue = true
        }
      }
    }
  }

  /**
   * `ActiveSupport::Logger`
   */
  module Logger {
    private class ActiveSupportLoggerInstantiation extends StdlibLogger::LoggerInstantiation {
      ActiveSupportLoggerInstantiation() {
        this =
          API::getTopLevelMember("ActiveSupport")
              .getMember(["Logger", "TaggedLogging"])
              .getAnInstantiation()
      }
    }
  }

  /**
   * `ActiveSupport::ERB`
   */
  module Erb {
    /**
     * `ActiveSupport::ERB::Util`
     */
    module Util {
      private class JsonEscapeSummary extends SimpleSummarizedCallable {
        JsonEscapeSummary() { this = "json_escape" }

        override predicate propagatesFlow(string input, string output, boolean preservesValue) {
          input = "Argument[0]" and
          output = "ReturnValue" and
          preservesValue = false
        }
      }
    }
  }
}
