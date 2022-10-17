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
        // We're modeling a lot of different methods, so we make up a name for this summary.
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

    /**
     * Extensions to the `Enumerable` module.
     */
    module Enumerable {
      private class ArrayIndex extends int {
        ArrayIndex() { this = any(DataFlow::Content::KnownElementContent c).getIndex().getInt() }
      }

      private class CompactBlankSummary extends SimpleSummarizedCallable {
        CompactBlankSummary() { this = "compact_blank" }

        override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
          input = "Argument[self].Element[any]" and
          output = "ReturnValue.Element[?]" and
          preservesValue = true
        }
      }

      private class ExcludingSummary extends SimpleSummarizedCallable {
        ExcludingSummary() { this = ["excluding", "without"] }

        override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
          input = "Argument[self].Element[any]" and
          output = "ReturnValue.Element[?]" and
          preservesValue = true
        }
      }

      private class InOrderOfSummary extends SimpleSummarizedCallable {
        InOrderOfSummary() { this = "in_order_of" }

        override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
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

        override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
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
      // TODO: index_by, index_with, pick, pluck (they require Hash dataflow)
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
   * Type summaries for extensions to the `Pathname` module.
   */
  private class PathnameTypeSummary extends ModelInput::TypeModelCsv {
    override predicate row(string row) {
      // package1;type1;package2;type2;path
      // Pathname#existence : Pathname
      row = ";Pathname;;Pathname;Method[existence].ReturnValue"
    }
  }

  /** Taint flow summaries for extensions to the `Pathname` module. */
  private class PathnameTaintSummary extends ModelInput::SummaryModelCsv {
    override predicate row(string row) {
      // Pathname#existence
      row = ";Pathname;Method[existence];Argument[self];ReturnValue;taint"
    }
  }

  /**
   * `ActiveSupport::SafeBuffer` wraps a string, providing HTML-safe methods
   * for concatenation.
   * It is possible to insert tainted data into `SafeBuffer` that won't get
   * sanitized, and this taint is then propagated via most of the methods.
   */
  private class SafeBufferSummary extends ModelInput::SummaryModelCsv {
    // TODO: SafeBuffer also reponds to all String methods.
    // Can we model this without repeating all the existing summaries we have
    // for String?
    override predicate row(string row) {
      row =
        [
          // SafeBuffer.new(x) does not sanitize x
          "activesupport;;Member[ActionView].Member[SafeBuffer].Method[new];Argument[0];ReturnValue;taint",
          // SafeBuffer#safe_concat(x) does not sanitize x
          "activesupport;;Member[ActionView].Member[SafeBuffer].Instance.Method[safe_concat];Argument[0];ReturnValue;taint",
          "activesupport;;Member[ActionView].Member[SafeBuffer].Instance.Method[safe_concat];Argument[0];Argument[self];taint",
          // These methods preserve taint in self
          "activesupport;;Member[ActionView].Member[SafeBuffer].Instance.Method[concat,insert,prepend,to_s,to_param];Argument[self];ReturnValue;taint",
        ]
    }
  }
}
