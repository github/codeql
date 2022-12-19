/** Provides models of commonly used functions in the `github.com/sirupsen/logrus` package. */

import go

/** Provides models of commonly used functions in the `github.com/sirupsen/logrus` package. */
module Logrus {
  /** Gets the package name `github.com/sirupsen/logrus`. */
  string packagePath() {
    result = package(["github.com/sirupsen/logrus", "github.com/Sirupsen/logrus"], "")
  }

  bindingset[result]
  private string getALogResultName() {
    result
        .matches([
            "Debug%", "Error%", "Fatal%", "Info%", "Log%", "Panic%", "Print%", "Trace%", "Warn%"
          ])
  }

  bindingset[result]
  private string getAnEntryUpdatingMethodName() {
    result.regexpMatch("With(Context|Error|Fields?|Time)")
  }

  private class LogFunction extends Function {
    LogFunction() {
      exists(string name | name = getALogResultName() or name = getAnEntryUpdatingMethodName() |
        this.hasQualifiedName(packagePath(), name) or
        this.(Method).hasQualifiedName(packagePath(), ["Entry", "Logger"], name)
      )
    }
  }

  private class LogCall extends LoggerCall::Range, DataFlow::CallNode {
    LogCall() {
      // find calls to logrus logging functions
      this = any(LogFunction f).getACall() and
      // unless all formatters that get assigned are sanitizing formatters
      not allFormattersSanitizing()
    }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }

  private class StringFormatters extends StringOps::Formatting::Range instanceof LogFunction {
    int argOffset;

    StringFormatters() {
      this.getName().matches("%f") and
      if this.getName() = "Logf" then argOffset = 1 else argOffset = 0
    }

    override int getFormatStringIndex() { result = argOffset }

    override int getFirstFormattedParameterIndex() { result = argOffset + 1 }
  }

  private class SetFormatterFunction extends Function {
    SetFormatterFunction() {
      this.hasQualifiedName(packagePath(), "SetFormatter") or
      this.(Method).hasQualifiedName(packagePath(), "Logger", "SetFormatter")
    }
  }

  private class LoggerFormatter extends Field {
    LoggerFormatter() { this.hasQualifiedName(packagePath(), "Logger", "Formatter") }
  }

  private class JsonFormatter extends Type {
    JsonFormatter() { this.hasQualifiedName(packagePath(), "JSONFormatter") }
  }

  /**
   * Gets the types corresponding to sanitizing formatters.
   */
  private Type sanitizingFormatter() { result instanceof JsonFormatter }

  /**
   * An assignment statement that assigns a value to the `Formatter` property of a `Logger` object.
   */
  private class SetFormatterAssignment extends AssignStmt {
    SetFormatterAssignment() {
      exists(LoggerFormatter field | this.getAnLhs().(SelectorExpr).getSelector().refersTo(field))
    }
  }

  /**
   * Holds if there is local data flow to `node` that, at some point, has a sanitizing formatter
   * type.
   */
  private predicate isSanitizingFormatter(DataFlow::Node node) {
    // is there data flow from something of a sanitizing formatter type to the node?
    exists(DataFlow::Node source |
      // this is a slight approximation since a variable could be set to a
      // sanitizing formatter and then replaced with another one that isn't
      DataFlow::localFlow(source, node) and
      source.getType() = sanitizingFormatter().getPointerType()
    )
  }

  /**
   * Holds if `node` is the first argument to a call to the `SetFormatter` function or if `node`
   * is the value being assigned to the `Formatter` property of a `Logger` object.
   */
  private predicate isSanitizerNode(DataFlow::Node node) {
    node = any(SetFormatterFunction f).getACall().getArgument(0)
    or
    node.asExpr() = any(SetFormatterAssignment stmt).getRhs()
  }

  /**
   * Holds if all calls to `SetFormatter` have a sanitizing formatter as argument and all
   * assignments to the `Formatter` property of `Logger` values are also sanitizing formatters.
   * Also holds if there are not any calls to `SetFormatter` or assignments to the `Formatter`
   * property in the codebase.
   */
  private predicate allFormattersSanitizing() {
    forex(DataFlow::Node node | isSanitizerNode(node) | isSanitizingFormatter(node))
  }
}
