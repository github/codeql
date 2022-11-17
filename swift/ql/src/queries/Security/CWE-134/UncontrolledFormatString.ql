/**
 * @name Uncontrolled format string
 * @description TODO
 * @kind path-problem
 * @problem.severity TODO
 * @security-severity TODO
 * @precision TODO
 * @id swift/uncontrolled-format-string
 * @tags security
 *       external/cwe/cwe-134
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
import DataFlow::PathGraph
import swift

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

from TaintedFormatConfiguration config, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode
where config.hasFlowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "This format string is derived from a $@.",
  sourceNode.getNode(), "user-provided value"
