/** Provides models of commonly used functions in the `github.com/sirupsen/logrus` package. */

import go

module Logrus {
  private string getAPkgName() {
    result = "github.com/sirupsen/logrus"
    or
    result = "github.com/Sirupsen/logrus"
  }

  bindingset[result]
  private string getALogResultName() {
    result.matches("Debug%")
    or
    result.matches("Error%")
    or
    result.matches("Fatal%")
    or
    result.matches("Info%")
    or
    result.matches("Panic%")
    or
    result.matches("Print%")
    or
    result.matches("Trace%")
    or
    result.matches("Warn%")
  }

  private class LogCall extends LoggerCall::Range, DataFlow::CallNode {
    LogCall() { this.getTarget().hasQualifiedName(getAPkgName(), getALogResultName()) }

    override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
  }

  private class LogEntryCall extends LoggerCall::Range, DataFlow::MethodCallNode {
    LogEntryCall() {
      this.getTarget().(Method).hasQualifiedName(getAPkgName(), "Entry", getALogResultName())
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
