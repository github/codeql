/**
 * @name Uncontrolled command line
 * @description Using externally controlled strings in a command line may allow
 *              a malicious user to change the meaning of the command.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision medium
 * @id php/command-line-injection
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import codeql.php.AST
import codeql.php.DataFlow
import codeql.php.TaintTracking

/**
 * A source of user input from PHP superglobals.
 */
class UserInputSource extends DataFlow::ExprNode {
  UserInputSource() {
    exists(VariableName v | v = this.asExpr() |
      v.getValue() = "$_GET" or
      v.getValue() = "$_POST" or
      v.getValue() = "$_REQUEST" or
      v.getValue() = "$_COOKIE"
    )
    or
    exists(SubscriptExpr sub, VariableName v |
      sub = this.asExpr() and
      v = sub.getObject() and
      (
        v.getValue() = "$_GET" or
        v.getValue() = "$_POST" or
        v.getValue() = "$_REQUEST" or
        v.getValue() = "$_COOKIE"
      )
    )
  }
}

/**
 * A sink for command execution.
 */
class CommandSink extends DataFlow::ExprNode {
  CommandSink() {
    exists(FunctionCallExpr call |
      call.getFunctionName() =
        [
          "exec", "system", "passthru", "shell_exec", "popen", "proc_open", "pcntl_exec",
          "eval"
        ] and
      this.asExpr() = call.getArgument(0)
    )
    or
    // Backtick operator / shell_exec
    exists(ShellCommandExpr shell | this.asExpr() = shell)
  }
}

module CommandInjectionConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof UserInputSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof CommandSink }

  predicate isBarrier(DataFlow::Node node) {
    exists(FunctionCallExpr call |
      call.getFunctionName() = ["escapeshellarg", "escapeshellcmd"] and
      node.asExpr() = call
    )
  }
}

module CommandInjectionFlow = TaintTracking::Global<CommandInjectionConfig>;

import CommandInjectionFlow::PathGraph

from CommandInjectionFlow::PathNode source, CommandInjectionFlow::PathNode sink
where CommandInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This command depends on a $@.", source.getNode(),
  "user-provided value"
