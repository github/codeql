/**
 * Provides classes and predicates for tracking exceptions and information
 * associated with exceptions.
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Basic

deprecated private Value traceback_function(string name) {
  result = Module::named("traceback").attr(name)
}

/**
 * This represents information relating to an exception, for instance the
 * message, arguments or parts of the exception traceback.
 */
deprecated class ExceptionInfo extends StringKind {
  ExceptionInfo() { this = "exception.info" }

  override string repr() { result = "exception info" }
}

/**
 * A class representing sources of information about
 * execution state exposed in tracebacks and the like.
 */
abstract deprecated class ErrorInfoSource extends TaintSource { }

/**
 * This kind represents exceptions themselves.
 */
deprecated class ExceptionKind extends TaintKind {
  ExceptionKind() { this = "exception.kind" }

  override string repr() { result = "exception" }

  override TaintKind getTaintOfAttribute(string name) {
    name = "args" and result instanceof ExceptionInfoSequence
    or
    name = "message" and result instanceof ExceptionInfo
  }
}

/**
 * A source of exception objects, either explicitly created, or captured by an
 * `except` statement.
 */
deprecated class ExceptionSource extends ErrorInfoSource {
  ExceptionSource() {
    exists(ClassValue cls |
      cls.getASuperType() = ClassValue::baseException() and
      this.(ControlFlowNode).pointsTo().getClass() = cls
    )
    or
    this = any(ExceptStmt s).getName().getAFlowNode()
  }

  override string toString() { result = "exception.source" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof ExceptionKind }
}

/**
 * Represents a sequence of pieces of information relating to an exception,
 * for instance the contents of the `args` attribute, or the stack trace.
 */
deprecated class ExceptionInfoSequence extends SequenceKind {
  ExceptionInfoSequence() { this.getItem() instanceof ExceptionInfo }
}

/**
 * Represents calls to functions in the `traceback` module that return
 * sequences of exception information.
 */
deprecated class CallToTracebackFunction extends ErrorInfoSource {
  CallToTracebackFunction() {
    exists(string name |
      name in [
          "extract_tb", "extract_stack", "format_list", "format_exception_only", "format_exception",
          "format_tb", "format_stack"
        ]
    |
      this = traceback_function(name).getACall()
    )
  }

  override string toString() { result = "exception.info.sequence.source" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof ExceptionInfoSequence }
}

/**
 * Represents calls to functions in the `traceback` module that return a single
 * string of information about an exception.
 */
deprecated class FormattedTracebackSource extends ErrorInfoSource {
  FormattedTracebackSource() { this = traceback_function("format_exc").getACall() }

  override string toString() { result = "exception.info.source" }

  override predicate isSourceOf(TaintKind kind) { kind instanceof ExceptionInfo }
}
