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

  private class LogCall extends LoggerCall::Range, DataFlow::CallNode {
    LogCall() {
      exists(string name | name = getALogResultName() or name = getAnEntryUpdatingMethodName() |
        this.getTarget().hasQualifiedName(packagePath(), name) or
        this.getTarget().(Method).hasQualifiedName(packagePath(), ["Entry", "Logger"], name)
      )
    }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }
}
