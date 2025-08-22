/**
 * Provides modeling for the `Kernel` module.
 */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.CFG
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.dataflow.internal.DataFlowDispatch

/** Provides modeling for the `Kernel` class. */
module Kernel {
  /**
   * The `Kernel` module is included by the `Object` class, so its methods are available
   * in every Ruby object. In addition, its module methods can be called by
   * providing a specific receiver as in `Kernel.exit`.
   */
  class KernelMethodCall extends DataFlow::CallNode {
    KernelMethodCall() {
      // Match Kernel calls using local flow, to avoid finding singleton calls on subclasses
      this = DataFlow::getConstant("Kernel").getAMethodCall(_)
      or
      this.asExpr().getExpr() instanceof UnknownMethodCall and
      (
        this.getReceiver().asExpr().getExpr() instanceof SelfVariableAccess and
        isPrivateKernelMethod(super.getMethodName())
        or
        this.asExpr().getExpr() instanceof SuperCall and
        isPrivateKernelMethod(super.getMethodName())
        or
        isPublicKernelMethod(super.getMethodName())
      )
    }
  }

  /**
   * Public methods in the `Kernel` module. These can be invoked on any object via the usual dot syntax.
   * ```ruby
   * arr = []
   * arr.send("push", 5) # => [5]
   * ```
   */
  private predicate isPublicKernelMethod(string method) {
    method in [
        "class", "clone", "frozen?", "tap", "then", "yield_self", "send", "public_send", "__send__",
        "method", "public_method", "singleton_method"
      ]
  }

  /**
   * Private methods in the `Kernel` module.
   * These can be be invoked on `self`, on `Kernel`, or using a low-level primitive like `send` or `instance_eval`.
   * ```ruby
   * puts "hello world"
   * Kernel.puts "hello world"
   * 5.instance_eval { puts "hello world" }
   * 5.send("puts", "hello world")
   * ```
   */
  private predicate isPrivateKernelMethod(string method) {
    method in [
        "Array", "Complex", "Float", "Hash", "Integer", "Rational", "String", "__callee__",
        "__dir__", "__method__", "`", "abort", "at_exit", "autoload", "autoload?", "binding",
        "block_given?", "callcc", "caller", "caller_locations", "catch", "chomp", "chop", "eval",
        "exec", "exit", "exit!", "fail", "fork", "format", "gets", "global_variables", "gsub",
        "iterator?", "lambda", "load", "local_variables", "loop", "open", "p", "pp", "print",
        "printf", "proc", "putc", "puts", "raise", "rand", "readline", "readlines", "require",
        "require_relative", "select", "set_trace_func", "sleep", "spawn", "sprintf", "srand", "sub",
        "syscall", "system", "test", "throw", "trace_var", "trap", "untrace_var", "warn"
      ]
  }

  /**
   * A system command executed via the `Kernel.system` method.
   * `Kernel.system` accepts three argument forms:
   * - A single string. If it contains no shell meta characters, keywords or
   *   builtins, it is executed directly in a subprocess.
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
   * In addition, `Kernel.system` accepts an optional environment hash as the
   * first argument and an optional options hash as the last argument.
   * We don't yet distinguish between these arguments and the command arguments.
   * ```ruby
   * system({"FOO" => "BAR"}, "cat foo.txt | tail", {unsetenv_others: true})
   * ```
   * Ruby documentation: https://docs.ruby-lang.org/en/3.0.0/Kernel.html#method-i-system
   */
  class KernelSystemCall extends SystemCommandExecution::Range instanceof KernelMethodCall {
    KernelSystemCall() { this.getMethodName() = "system" }

    override DataFlow::Node getAnArgument() { result = super.getArgument(_) }

    override predicate isShellInterpreted(DataFlow::Node arg) {
      // Kernel.system invokes a subshell if you provide a single string as argument
      super.getNumberOfArguments() = 1 and arg = this.getAnArgument()
    }
  }

  /**
   * A system command executed via the `Kernel.exec` method.
   * `Kernel.exec` takes the same argument forms as `Kernel.system`. See `KernelSystemCall` for details.
   * Ruby documentation: https://docs.ruby-lang.org/en/3.0.0/Kernel.html#method-i-exec
   */
  class KernelExecCall extends SystemCommandExecution::Range instanceof KernelMethodCall {
    KernelExecCall() { this.getMethodName() = "exec" }

    override DataFlow::Node getAnArgument() { result = super.getArgument(_) }

    override predicate isShellInterpreted(DataFlow::Node arg) {
      // Kernel.exec invokes a subshell if you provide a single string as argument
      super.getNumberOfArguments() = 1 and arg = this.getAnArgument()
    }
  }

  /**
   * A system command executed via the `Kernel.spawn` method.
   * `Kernel.spawn` takes the same argument forms as `Kernel.system`.
   * See `KernelSystemCall` for details.
   * Ruby documentation: https://docs.ruby-lang.org/en/3.0.0/Kernel.html#method-i-spawn
   * TODO: document and handle the env and option arguments.
   * ```
   * spawn([env,] command... [,options]) -> pid
   * ```
   */
  class KernelSpawnCall extends SystemCommandExecution::Range instanceof KernelMethodCall {
    KernelSpawnCall() { this.getMethodName() = "spawn" }

    override DataFlow::Node getAnArgument() { result = super.getArgument(_) }

    override predicate isShellInterpreted(DataFlow::Node arg) {
      // Kernel.spawn invokes a subshell if you provide a single string as argument
      super.getNumberOfArguments() = 1 and arg = this.getAnArgument()
    }
  }

  /**
   * A call to `Kernel.eval`, which executes its first argument as Ruby code.
   * ```ruby
   * a = 1
   * Kernel.eval("a = 2")
   * a # => 2
   * ```
   */
  class EvalCallCodeExecution extends CodeExecution::Range, KernelMethodCall {
    EvalCallCodeExecution() { this.getMethodName() = "eval" }

    override DataFlow::Node getCode() { result = this.getArgument(0) }
  }

  /**
   * A call to `Kernel#send`, which executes its first argument as a Ruby method call.
   * ```ruby
   * arr = []
   * arr.send("push", 1)
   * arr # => [1]
   * ```
   */
  class SendCallCodeExecution extends CodeExecution::Range, KernelMethodCall {
    SendCallCodeExecution() { this.getMethodName() = ["send", "public_send", "__send__"] }

    override DataFlow::Node getCode() { result = this.getArgument(0) }

    override predicate runsArbitraryCode() { none() }
  }

  /**
   * A call to `method`, `public_method` or `singleton_method` which returns a method object.
   * To actually execute the method, the `call` method needs to be called on the object.
   * ```ruby
   * m = method("exit")
   * m.call()
   * ```
   */
  class MethodCallCodeExecution extends CodeExecution::Range, KernelMethodCall {
    MethodCallCodeExecution() {
      this.getMethodName() = ["method", "public_method", "singleton_method"]
    }

    override DataFlow::Node getCode() { result = this.getArgument(0) }

    override predicate runsArbitraryCode() { none() }
  }

  private class TapSummary extends SimpleSummarizedCallable {
    TapSummary() { this = "tap" }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self]" and
      output = ["ReturnValue", "Argument[block].Parameter[0]"] and
      preservesValue = true
    }
  }

  /** A call to e.g. `Kernel.load` that accesses a file. */
  private class KernelFileAccess extends FileSystemAccess::Range instanceof KernelMethodCall {
    KernelFileAccess() {
      super.getMethodName() = ["load", "require", "require_relative", "autoload", "autoload?"]
    }

    override DataFlow::Node getAPathArgument() {
      result = super.getArgument(0) and
      super.getMethodName() = ["load", "require", "require_relative"]
      or
      result = super.getArgument(1) and
      super.getMethodName() = ["autoload", "autoload?"]
    }
  }

  private import codeql.ruby.ast.internal.Module as Module

  /**
   * A call to `Array()`, that converts it's singular argument to an array.
   * This summary is based on https://ruby-doc.org/3.2.1/Kernel.html#method-i-Array
   */
  private class KernelArraySummary extends SummarizedCallable {
    KernelArraySummary() { this = "Array()" }

    override MethodCall getACallSimple() {
      result.getMethodName() = "Array" and
      // I have to have a simplified "KernelMethodCall" implementation inlined here, because relying on `UnknownMethodCall` results in non-monotonic recursion (even if using `getACall`).
      (
        // similar to `getAStaticArrayCall` from Array.qll
        Module::resolveConstantReadAccess(result.getReceiver()) = Module::TResolved("Kernel")
        or
        result.getReceiver() instanceof SelfVariableAccess
      )
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        // already an array
        input = "Argument[0].WithElement[0..]" and
        output = "ReturnValue"
        or
        // not already an array
        input = "Argument[0].WithoutElement[0..]" and
        output = "ReturnValue.Element[0]"
      ) and
      preservesValue = true
    }
  }
}
