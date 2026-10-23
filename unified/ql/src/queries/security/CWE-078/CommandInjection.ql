/**
 * @name System command built from user-controlled sources
 * @description Building a system command from user-controlled sources may allow a malicious
 *              user to change the meaning of the command.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id swift/command-line-injection
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.FlowSources
import codeql.swift.dataflow.ExternalFlow
import CommandInjectionFlow::PathGraph

// Copied from codeql/swift/security/CommandInjectionExtensions.qll.
/**
 * Provides classes and predicates for reasoning about system
 * commands built from user-controlled sources (that is, command injection
 * vulnerabilities).
 */

/**
 * A dataflow sink for command injection vulnerabilities.
 */
abstract class CommandInjectionSink extends DataFlow::Node { }

/**
 * A barrier for command injection vulnerabilities.
 */
abstract class CommandInjectionBarrier extends DataFlow::Node { }

/**
 * A unit class for adding additional flow steps.
 */
class CommandInjectionAdditionalFlowStep extends Unit {
  /**
   * Holds if the step from `node1` to `node2` should be considered a flow
   * step for paths related to command injection vulnerabilities.
   */
  abstract predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo);
}

/**
 * A sink defined in a CSV model.
 */
private class DefaultCommandInjectionSink extends CommandInjectionSink {
  DefaultCommandInjectionSink() { sinkNode(this, "command-injection") }
}

private class CommandInjectionSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        ";Process;true;run(_:arguments:terminationHandler:);;;Argument[0..1];command-injection",
        ";Process;true;launchedProcess(launchPath:arguments:);;;Argument[0..1];command-injection",
        ";Process;true;arguments;;;PostUpdate;command-injection",
        ";Process;true;currentDirectory;;;PostUpdate;command-injection",
        ";Process;true;environment;;;PostUpdate;command-injection",
        ";Process;true;executableURL;;;PostUpdate;command-injection",
        ";Process;true;standardError;;;PostUpdate;command-injection",
        ";Process;true;standardInput;;;PostUpdate;command-injection",
        ";Process;true;standardOutput;;;PostUpdate;command-injection",
        ";Process;true;currentDirectoryPath;;;PostUpdate;command-injection",
        ";Process;true;launchPath;;;PostUpdate;command-injection",
        ";NSUserScriptTask;true;init(url:);;;Argument[0];command-injection",
        ";NSUserUnixTask;true;execute(withArguments:completionHandler:);;;Argument[0];command-injection",
      ]
  }
}

/**
 * A barrier for command injection vulnerabilities.
 */
private class CommandInjectionDefaultBarrier extends CommandInjectionBarrier {
  CommandInjectionDefaultBarrier() {
    // any numeric type
    this.asExpr().getType().getUnderlyingType().getABaseType*().getName() =
      ["Numeric", "SignedInteger", "UnsignedInteger"]
  }
}

// Copied from codeql/swift/security/CommandInjectionQuery.qll.
/**
 * Provides a taint-tracking configuration for reasoning about system
 * commands built from user-controlled sources (that is, command injection
 * vulnerabilities).
 */

/**
 * A taint configuration for tainted data that reaches a command injection sink.
 */
module CommandInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  predicate isSink(DataFlow::Node node) { node instanceof CommandInjectionSink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof CommandInjectionBarrier }

  predicate isAdditionalFlowStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    any(CommandInjectionAdditionalFlowStep s).step(nodeFrom, nodeTo)
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Detect taint flow of tainted data that reaches a command injection sink.
 */
module CommandInjectionFlow = TaintTracking::Global<CommandInjectionConfig>;

from CommandInjectionFlow::PathNode sourceNode, CommandInjectionFlow::PathNode sinkNode
where CommandInjectionFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode, "This command depends on a $@.",
  sourceNode.getNode(), "user-provided value"
