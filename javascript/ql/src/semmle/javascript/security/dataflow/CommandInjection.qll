/**
 * Provides a taint tracking configuration for reasoning about
 * command-injection vulnerabilities (CWE-078).
 *
 * Note, for performance reasons: only import this file if
 * `CommandInjection::Configuration` is needed, otherwise
 * `CommandInjectionCustomizations` should be imported instead.
 */

import javascript

module CommandInjection {
  import CommandInjectionCustomizations::CommandInjection
  import IndirectCommandArgument

  /**
   * A taint-tracking configuration for reasoning about command-injection vulnerabilities.
   */
  class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "CommandInjection" }

    override predicate isSource(DataFlow::Node source) { source instanceof Source }

    /**
     * Holds if `sink` is a data flow sink for command-injection vulnerabilities, and
     * the alert should be placed at the node `highlight`.
     */
    predicate isSinkWithHighlight(DataFlow::Node sink, DataFlow::Node highlight) {
      sink instanceof Sink and highlight = sink
      or
      isIndirectCommandArgument(sink, highlight)
    }

    override predicate isSink(DataFlow::Node sink) { isSinkWithHighlight(sink, _) }

    override predicate isSanitizer(DataFlow::Node node) { node instanceof Sanitizer }
  }

  /**
   * Auxiliary data flow configuration for tracking string literals that look like they
   * may refer to an operating system shell, and array literals that may end up being
   * interpreted as argument lists for system commands.
   */
  class ArgumentListTracking extends DataFlow::Configuration {
    ArgumentListTracking() { this = "ArgumentListTracking" }

    override predicate isSource(DataFlow::Node nd) {
      nd instanceof DataFlow::ArrayCreationNode
      or
      exists(ConstantString shell | shellCmd(shell, _) | nd = DataFlow::valueNode(shell))
    }

    override predicate isSink(DataFlow::Node nd) {
      exists(SystemCommandExecution sys |
        nd = sys.getACommandArgument() or
        nd = sys.getArgumentList()
      )
    }
  }

  /**
   * Holds if `shell arg <cmd>` runs `<cmd>` as a shell command.
   *
   * That is, either `shell` is a Unix shell (`sh` or similar) and
   * `arg` is `"-c"`, or `shell` is `cmd.exe` and `arg` is `"/c"`.
   */
  private predicate shellCmd(ConstantString shell, string arg) {
    exists(string s | s = shell.getStringValue() |
      (s = "sh" or s = "bash" or s = "/bin/sh" or s = "/bin/bash") and
      arg = "-c"
    )
    or
    exists(string s | s = shell.getStringValue().toLowerCase() |
      (s = "cmd" or s = "cmd.exe") and
      (arg = "/c" or arg = "/C")
    )
  }
}
