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
    result.regexpMatch("(Debug|Error|Fatal|Info|Log|Panic|Print|Trace|Warn).*")
  }

  bindingset[result]
  private string getAnEntryUpdatingMethodName() {
    result = ["WithError", "WithField", "WithFields", "WithTime"]
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
    LogCall() { this = any(LogFunction f).getACall() }

    override DataFlow::Node getAMessageComponent() { result = this.getASyntacticArgument() }
  }

  private class StringFormatters extends StringOps::Formatting::Range instanceof LogFunction {
    int argOffset;

    StringFormatters() {
      this.getName().matches("%f") and
      if this.getName() = "Logf" then argOffset = 1 else argOffset = 0
    }

    override int getFormatStringIndex() { result = argOffset }
  }
}
