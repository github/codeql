private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.internal.DataFlowDispatch
private import codeql.ruby.dataflow.internal.DataFlowImplCommon

/**
 * A system command executed via subshell literal syntax.
 * E.g.
 * ```ruby
 * `cat foo.txt`
 * %x(cat foo.txt)
 * %x[cat foo.txt]
 * %x{cat foo.txt}
 * %x/cat foo.txt/
 * ```
 */
class SubshellLiteralExecution extends SystemCommandExecution::Range {
  SubshellLiteral literal;

  SubshellLiteralExecution() { this.asExpr().getExpr() = literal }

  override DataFlow::Node getAnArgument() { result.asExpr().getExpr() = literal.getComponent(_) }

  override predicate isShellInterpreted(DataFlow::Node arg) { arg = getAnArgument() }
}

/**
 * A system command executed via shell heredoc syntax.
 * E.g.
 * ```ruby
 * <<`EOF`
 * cat foo.text
 * EOF
 * ```
 */
class SubshellHeredocExecution extends SystemCommandExecution::Range {
  HereDoc heredoc;

  SubshellHeredocExecution() { this.asExpr().getExpr() = heredoc and heredoc.isSubShell() }

  override DataFlow::Node getAnArgument() { result.asExpr().getExpr() = heredoc.getComponent(_) }

  override predicate isShellInterpreted(DataFlow::Node arg) { arg = getAnArgument() }
}

/**
 * A system command executed via the `Kernel.system` method.
 * `Kernel.system` accepts three argument forms:
 * - A single string. If it contains no shell meta characters, keywords or builtins, it is executed directly in a subprocess.
 *   Otherwise, it is executed in a subshell.
 *   ```ruby
 *   system("cat foo.txt | tail")
 *   ```
 * - A command and one or more arguments.
 *   The command is executed in a subprocess.
 *   ```ruby
 *   system("cat", "foo.txt")
 *   ```
 * - An array containing the command name and argv[0], followed by zero or more arguments.
 *   The command is executed in a subprocess.
 *   ```ruby
 *   system(["cat", "cat"], "foo.txt")
 *   ```
 * In addition, `Kernel.system` accepts an optional environment hash as the first argument and and optional options hash as the last argument.
 * We don't yet distinguish between these arguments and the command arguments.
 * ```ruby
 * system({"FOO" => "BAR"}, "cat foo.txt | tail", {unsetenv_others: true})
 * ```
 * Ruby documentation: https://docs.ruby-lang.org/en/3.0.0/Kernel.html#method-i-system
 */
class KernelSystemCall extends SystemCommandExecution::Range {
  MethodCall methodCall;

  KernelSystemCall() {
    methodCall.getMethodName() = "system" and
    this.asExpr().getExpr() = methodCall and
    // `Kernel.system` can be reached via `Kernel.system` or just `system`
    // (if there's no other method by the same name in scope).
    (
      this = API::getTopLevelMember("Kernel").getAMethodCall("system")
      or
      // we assume that if there's no obvious target for this method call, then it must refer to Kernel.system.
      not exists(DataFlowCallable method, DataFlowCall call |
        viableCallable(call) = method and call.getExpr() = methodCall
      )
    )
  }

  override DataFlow::Node getAnArgument() { result.asExpr().getExpr() = methodCall.getAnArgument() }

  override predicate isShellInterpreted(DataFlow::Node arg) {
    // Kernel.system invokes a subshell if you provide a single string as argument
    methodCall.getNumberOfArguments() = 1 and arg.asExpr().getExpr() = methodCall.getAnArgument()
  }
}

/**
 * A system command executed via the `Kernel.exec` method.
 * `Kernel.exec` takes the same argument forms as `Kernel.system`. See `KernelSystemCall` for details.
 * Ruby documentation: https://docs.ruby-lang.org/en/3.0.0/Kernel.html#method-i-exec
 */
class KernelExecCall extends SystemCommandExecution::Range {
  MethodCall methodCall;

  KernelExecCall() {
    methodCall.getMethodName() = "exec" and
    this.asExpr().getExpr() = methodCall and
    // `Kernel.exec` can be reached via `Kernel.exec`, `Process.exec` or just `exec`
    // (if there's no other method by the same name in scope).
    (
      this = API::getTopLevelMember("Kernel").getAMethodCall("exec")
      or
      this = API::getTopLevelMember("Process").getAMethodCall("exec")
      or
      // we assume that if there's no obvious target for this method call, then it must refer to Kernel.exec.
      not exists(DataFlowCallable method, DataFlowCall call |
        viableCallable(call) = method and call.getExpr() = methodCall
      )
    )
  }

  override DataFlow::Node getAnArgument() { result.asExpr().getExpr() = methodCall.getAnArgument() }

  override predicate isShellInterpreted(DataFlow::Node arg) {
    // Kernel.exec invokes a subshell if you provide a single string as argument
    methodCall.getNumberOfArguments() = 1 and arg.asExpr().getExpr() = methodCall.getAnArgument()
  }
}

/**
 * A system command executed via the `Kernel.spawn` method.
 * `Kernel.spawn` takes the same argument forms as `Kernel.system`. See `KernelSystemCall` for details.
 * Ruby documentation: https://docs.ruby-lang.org/en/3.0.0/Kernel.html#method-i-spawn
 * TODO: document and handle the env and option arguments.
 * ```
 * spawn([env,] command... [,options]) → pid
 * ```
 */
class KernelSpawnCall extends SystemCommandExecution::Range {
  MethodCall methodCall;

  KernelSpawnCall() {
    methodCall.getMethodName() = "spawn" and
    this.asExpr().getExpr() = methodCall and
    // `Kernel.spawn` can be reached via `Kernel.spawn`, `Process.spawn` or just `spawn`
    // (if there's no other method by the same name in scope).
    (
      this = API::getTopLevelMember("Kernel").getAMethodCall("spawn")
      or
      this = API::getTopLevelMember("Process").getAMethodCall("spawn")
      or
      not exists(DataFlowCallable method, DataFlowCall call |
        viableCallable(call) = method and call.getExpr() = methodCall
      )
    )
  }

  override DataFlow::Node getAnArgument() { result.asExpr().getExpr() = methodCall.getAnArgument() }

  override predicate isShellInterpreted(DataFlow::Node arg) {
    // Kernel.spawn invokes a subshell if you provide a single string as argument
    methodCall.getNumberOfArguments() = 1 and arg.asExpr().getExpr() = methodCall.getAnArgument()
  }
}

class Open3Call extends SystemCommandExecution::Range {
  MethodCall methodCall;

  Open3Call() {
    this.asExpr().getExpr() = methodCall and
    exists(string methodName |
      methodName in [
          "popen3", "popen2", "popen2e", "capture3", "capture2", "capture2e", "pipeline_rw",
          "pipeline_r", "pipeline_w", "pipeline_start", "pipeline"
        ] and
      this = API::getTopLevelMember("Open3").getAMethodCall(methodName)
    )
  }

  override DataFlow::Node getAnArgument() { result.asExpr().getExpr() = methodCall.getAnArgument() }

  override predicate isShellInterpreted(DataFlow::Node arg) {
    // These Open3 methods invoke a subshell if you provide a single string as argument
    methodCall.getNumberOfArguments() = 1 and arg.asExpr().getExpr() = methodCall.getAnArgument()
  }
}
