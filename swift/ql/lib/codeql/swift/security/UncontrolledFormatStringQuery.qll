/**
 * Provides a taint-tracking configuration for reasoning about uncontrolled format string
 * vulnerabilities.
 */
 
import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources

/**
 * A function that takes a `printf` style format argument.
 */
abstract class FormattingFunction extends AbstractFunctionDecl {
  /**
   * Gets the position of the format argument.
   */
  abstract int getFormatParameterIndex();
}

/**
 * An initializer for `String`, `NSString` or `NSMutableString` that takes a
 * `printf` style format argument.
 */
class StringInitWithFormat extends FormattingFunction, MethodDecl {
  StringInitWithFormat() {
    exists(string fName |
      this.hasQualifiedName(["String", "NSString", "NSMutableString"], fName) and
      fName.matches("init(format:%")
    )
  }

  override int getFormatParameterIndex() { result = 0 }
}

/**
 * The `localizedStringWithFormat` method of `String`, `NSString` and `NSMutableString`.
 */
class LocalizedStringWithFormat extends FormattingFunction, MethodDecl {
  LocalizedStringWithFormat() {
    this.hasQualifiedName(["String", "NSString", "NSMutableString"],
      "localizedStringWithFormat(_:_:)")
  }

  override int getFormatParameterIndex() { result = 0 }
}

/**
 * The functions `NSLog` and `NSLogv`.
 */
class NsLog extends FormattingFunction, FreeFunctionDecl {
  NsLog() { this.getName() = ["NSLog(_:_:)", "NSLogv(_:_:)"] }

  override int getFormatParameterIndex() { result = 0 }
}

/**
 * The `NSException.raise` method.
 */
class NsExceptionRaise extends FormattingFunction, MethodDecl {
  NsExceptionRaise() { this.hasQualifiedName("NSException", "raise(_:format:arguments:)") }

  override int getFormatParameterIndex() { result = 1 }
}

/**
 * A call to a function that takes a `printf` style format argument.
 */
class FormattingFunctionCall extends CallExpr {
  FormattingFunction target;

  FormattingFunctionCall() { target = this.getStaticTarget() }

  /**
   * Gets the format expression used in this call.
   */
  Expr getFormat() { result = this.getArgument(target.getFormatParameterIndex()).getExpr() }
}

/**
 * A taint configuration for tainted data that reaches a format string.
 */
class TaintedFormatConfiguration extends TaintTracking::Configuration {
  TaintedFormatConfiguration() { this = "TaintedFormatConfiguration" }

  override predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  override predicate isSink(DataFlow::Node node) {
    node.asExpr() = any(FormattingFunctionCall fc).getFormat()
  }
}
