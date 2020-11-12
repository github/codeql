/** Provides models of commonly used functions in the `github.com/sirupsen/logrus` package. */

import go

/** Provides models of commonly used functions in the `github.com/sirupsen/logrus` package. */
module Logrus {
  /** Gets the package name. */
  string packagePath() { result in ["github.com/sirupsen/logrus", "github.com/Sirupsen/logrus"] }

  bindingset[result]
  private string getALogResultName() {
    result.matches(["Debug%", "Error%", "Fatal%", "Info%", "Panic%", "Print%", "Trace%", "Warn%"])
  }

  private class LogCall extends LoggerCall::Range, DataFlow::CallNode {
    LogCall() { this.getTarget().hasQualifiedName(packagePath(), getALogResultName()) }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }

  private class LogEntryCall extends LoggerCall::Range, DataFlow::MethodCallNode {
    LogEntryCall() {
      this.getTarget().(Method).hasQualifiedName(packagePath(), "Entry", getALogResultName())
    }

    override DataFlow::Node getAMessageComponent() {
      result = this.getAnArgument()
      or
      exists(DataFlow::MethodCallNode addFieldCall, DataFlow::SsaNode entry |
        entry.getAUse() = this.getReceiver() and
        entry.getAUse() = addFieldCall.getReceiver()
      |
        addFieldCall.getCalleeName().regexpMatch("With(Context|Error|Fields?|Time)") and
        result = addFieldCall.getAnArgument()
      )
      or
      exists(DataFlow::CallNode entryBuild |
        entryBuild.getASuccessor*() = this.getReceiver() and
        entryBuild.getCalleeName().regexpMatch("With(Context|Error|Fields?|Time)") and
        result = entryBuild.getAnArgument()
      )
    }
  }
}
