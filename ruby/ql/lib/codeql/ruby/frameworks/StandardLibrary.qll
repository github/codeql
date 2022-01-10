private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.dataflow.internal.DataFlowDispatch
private import codeql.ruby.CFG

/**
 * The `Kernel` module is included by the `Object` class, so its methods are available
 * in every Ruby object. In addition, its module methods can be called by
 * providing a specific receiver as in `Kernel.exit`.
 */
class KernelMethodCall extends DataFlow::CallNode {
  private MethodCall methodCall;

  KernelMethodCall() {
    methodCall = this.asExpr().getExpr() and
    (
      this = API::getTopLevelMember("Kernel").getAMethodCall(_)
      or
      methodCall instanceof UnknownMethodCall and
      (
        this.getReceiver().asExpr().getExpr() instanceof Self and
        isPrivateKernelMethod(methodCall.getMethodName())
        or
        isPublicKernelMethod(methodCall.getMethodName())
      )
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
  method in ["class", "clone", "frozen?", "tap", "then", "yield_self", "send"]
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
      "Array", "Complex", "Float", "Hash", "Integer", "Rational", "String", "__callee__", "__dir__",
      "__method__", "`", "abort", "at_exit", "autoload", "autoload?", "binding", "block_given?",
      "callcc", "caller", "caller_locations", "catch", "chomp", "chop", "eval", "exec", "exit",
      "exit!", "fail", "fork", "format", "gets", "global_variables", "gsub", "iterator?", "lambda",
      "load", "local_variables", "loop", "open", "p", "pp", "print", "printf", "proc", "putc",
      "puts", "raise", "rand", "readline", "readlines", "require", "require_relative", "select",
      "set_trace_func", "sleep", "spawn", "sprintf", "srand", "sub", "syscall", "system", "test",
      "throw", "trace_var", "trap", "untrace_var", "warn"
    ]
}

string basicObjectInstanceMethodName() {
  result in [
      "equal?", "instance_eval", "instance_exec", "method_missing", "singleton_method_added",
      "singleton_method_removed", "singleton_method_undefined"
    ]
}

/**
 * An instance method on `BasicObject`, which is available to all classes.
 */
class BasicObjectInstanceMethodCall extends UnknownMethodCall {
  BasicObjectInstanceMethodCall() { this.getMethodName() = basicObjectInstanceMethodName() }
}

string objectInstanceMethodName() {
  result in [
      "!~", "<=>", "===", "=~", "callable_methods", "define_singleton_method", "display",
      "do_until", "do_while", "dup", "enum_for", "eql?", "extend", "f", "freeze", "h", "hash",
      "inspect", "instance_of?", "instance_variable_defined?", "instance_variable_get",
      "instance_variable_set", "instance_variables", "is_a?", "itself", "kind_of?",
      "matching_methods", "method", "method_missing", "methods", "nil?", "object_id",
      "private_methods", "protected_methods", "public_method", "public_methods", "public_send",
      "remove_instance_variable", "respond_to?", "respond_to_missing?", "send",
      "shortest_abbreviation", "singleton_class", "singleton_method", "singleton_methods", "taint",
      "tainted?", "to_enum", "to_s", "trust", "untaint", "untrust", "untrusted?"
    ]
}

/**
 * An instance method on `Object`, which is available to all classes except `BasicObject`.
 */
class ObjectInstanceMethodCall extends UnknownMethodCall {
  ObjectInstanceMethodCall() { this.getMethodName() = objectInstanceMethodName() }
}

/**
 * A `Method` call that has no known target.
 * These will typically be calls to methods inherited from a superclass.
 */
class UnknownMethodCall extends MethodCall {
  UnknownMethodCall() { not exists(this.(Call).getATarget()) }
}

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

  override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getAnArgument() }
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

  override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getAnArgument() }
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
class KernelSystemCall extends SystemCommandExecution::Range, KernelMethodCall {
  KernelSystemCall() { this.getMethodName() = "system" }

  override DataFlow::Node getAnArgument() { result = this.getArgument(_) }

  override predicate isShellInterpreted(DataFlow::Node arg) {
    // Kernel.system invokes a subshell if you provide a single string as argument
    this.getNumberOfArguments() = 1 and arg = this.getAnArgument()
  }
}

/**
 * A system command executed via the `Kernel.exec` method.
 * `Kernel.exec` takes the same argument forms as `Kernel.system`. See `KernelSystemCall` for details.
 * Ruby documentation: https://docs.ruby-lang.org/en/3.0.0/Kernel.html#method-i-exec
 */
class KernelExecCall extends SystemCommandExecution::Range, KernelMethodCall {
  KernelExecCall() { this.getMethodName() = "exec" }

  override DataFlow::Node getAnArgument() { result = this.getArgument(_) }

  override predicate isShellInterpreted(DataFlow::Node arg) {
    // Kernel.exec invokes a subshell if you provide a single string as argument
    this.getNumberOfArguments() = 1 and arg = this.getAnArgument()
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
class KernelSpawnCall extends SystemCommandExecution::Range, KernelMethodCall {
  KernelSpawnCall() { this.getMethodName() = "spawn" }

  override DataFlow::Node getAnArgument() { result = this.getArgument(_) }

  override predicate isShellInterpreted(DataFlow::Node arg) {
    // Kernel.spawn invokes a subshell if you provide a single string as argument
    this.getNumberOfArguments() = 1 and arg = this.getAnArgument()
  }
}

/**
 * A system command executed via one of the `Open3` methods.
 * These methods take the same argument forms as `Kernel.system`.
 * See `KernelSystemCall` for details.
 */
class Open3Call extends SystemCommandExecution::Range {
  MethodCall methodCall;

  Open3Call() {
    this.asExpr().getExpr() = methodCall and
    this =
      API::getTopLevelMember("Open3")
          .getAMethodCall(["popen3", "popen2", "popen2e", "capture3", "capture2", "capture2e"])
  }

  override DataFlow::Node getAnArgument() { result.asExpr().getExpr() = methodCall.getAnArgument() }

  override predicate isShellInterpreted(DataFlow::Node arg) {
    // These Open3 methods invoke a subshell if you provide a single string as argument
    methodCall.getNumberOfArguments() = 1 and arg.asExpr().getExpr() = methodCall.getAnArgument()
  }
}

/**
 * A pipeline of system commands constructed via one of the `Open3` methods.
 * These methods accept a variable argument list of commands.
 * Commands can be in any form supported by `Kernel.system`. See `KernelSystemCall` for details.
 * ```ruby
 * Open3.pipeline("cat foo.txt", "tail")
 * Open3.pipeline(["cat", "foo.txt"], "tail")
 * Open3.pipeline([{}, "cat", "foo.txt"], "tail")
 * Open3.pipeline([["cat", "cat"], "foo.txt"], "tail")
 */
class Open3PipelineCall extends SystemCommandExecution::Range {
  MethodCall methodCall;

  Open3PipelineCall() {
    this.asExpr().getExpr() = methodCall and
    this =
      API::getTopLevelMember("Open3")
          .getAMethodCall(["pipeline_rw", "pipeline_r", "pipeline_w", "pipeline_start", "pipeline"])
  }

  override DataFlow::Node getAnArgument() { result.asExpr().getExpr() = methodCall.getAnArgument() }

  override predicate isShellInterpreted(DataFlow::Node arg) {
    // A command in the pipeline is executed in a subshell if it is given as a single string argument.
    arg.asExpr().getExpr() instanceof StringlikeLiteral and
    arg.asExpr().getExpr() = methodCall.getAnArgument()
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
  SendCallCodeExecution() { this.getMethodName() = "send" }

  override DataFlow::Node getCode() { result = this.getArgument(0) }
}

/**
 * A call to `BasicObject#instance_eval`, which executes its first argument as Ruby code.
 */
class InstanceEvalCallCodeExecution extends CodeExecution::Range, DataFlow::CallNode {
  InstanceEvalCallCodeExecution() {
    this.asExpr().getExpr().(UnknownMethodCall).getMethodName() = "instance_eval"
  }

  override DataFlow::Node getCode() { result = this.getArgument(0) }
}

/**
 * A call to `Module#class_eval`, which executes its first argument as Ruby code.
 */
class ClassEvalCallCodeExecution extends CodeExecution::Range, DataFlow::CallNode {
  ClassEvalCallCodeExecution() {
    this.asExpr().getExpr().(UnknownMethodCall).getMethodName() = "class_eval"
  }

  override DataFlow::Node getCode() { result = this.getArgument(0) }
}

/**
 * A call to `Module#module_eval`, which executes its first argument as Ruby code.
 */
class ModuleEvalCallCodeExecution extends CodeExecution::Range, DataFlow::CallNode {
  ModuleEvalCallCodeExecution() {
    this.asExpr().getExpr().(UnknownMethodCall).getMethodName() = "module_eval"
  }

  override DataFlow::Node getCode() { result = this.getArgument(0) }
}

/** Flow summary for `Regexp.escape` and its alias, `Regexp.quote`. */
class RegexpEscapeSummary extends SummarizedCallable {
  RegexpEscapeSummary() { this = "Regexp.escape" }

  override MethodCall getACall() {
    result = API::getTopLevelMember("Regexp").getAMethodCall(["escape", "quote"]).asExpr().getExpr()
  }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    input = "Argument[0]" and
    output = "ReturnValue" and
    preservesValue = false
  }
}

/** A reference to a `Logger` instance */
private DataFlow::Node loggerInstance() {
  result = API::getTopLevelMember("Logger").getAnInstantiation()
  or
  exists(DataFlow::Node inst |
    inst = loggerInstance() and
    inst.(DataFlow::LocalSourceNode).flowsTo(result)
  )
  or
  // Assume that a variable assigned as a `Logger` instance is always a
  // `Logger` instance. This covers class and instance variables where we can't
  // necessarily trace a dataflow path from assignment to use.
  exists(Variable v, Assignment a |
    a.getLeftOperand().getAVariable() = v and
    a.getRightOperand() = loggerInstance().asExpr().getExpr() and
    result.asExpr().getExpr().(VariableReadAccess).getVariable() = v
  )
}

/**
 * A call to a `Logger` instance method that causes a message to be logged.
 */
abstract class LoggerLoggingCall extends Logging::Range, DataFlow::CallNode {
  LoggerLoggingCall() { this.getReceiver() = loggerInstance() }
}

/**
 * A call to `Logger#add` or its alias `Logger#log`.
 */
private class LoggerAddCall extends LoggerLoggingCall {
  LoggerAddCall() { this.getMethodName() = ["add", "log"] }

  override DataFlow::Node getAnInput() {
    // Both the message and the progname are form part of the log output:
    // Logger#add(severity, message) / Logger#add(severity, message, progname)
    result = this.getArgument(1)
    or
    result = this.getArgument(2)
    or
    // a return value from the block in Logger#add(severity) <block> or in
    // Logger#add(severity, nil, progname) <block>
    (
      this.getNumberOfArguments() = 1
      or
      // TODO: this could track the value of the `message` argument to make
      // this check more accurate
      this.getArgument(1).asExpr().getExpr() instanceof NilLiteral
    ) and
    exprNodeReturnedFrom(result, this.getBlock().asExpr().getExpr())
  }
}

/**
 * A call to `Logger#<<`.
 */
private class LoggerPushCall extends LoggerLoggingCall {
  LoggerPushCall() { this.getMethodName() = "<<" }

  override DataFlow::Node getAnInput() {
    // Logger#<<(msg)
    result = this.getArgument(0)
  }
}

/**
 * A call to a `Logger` method that logs at a preset severity level.
 *
 * Specifically, these methods are `debug`, `error`, `fatal`, `info`,
 * `unknown`, and `warn`.
 */
private class LoggerInfoStyleCall extends LoggerLoggingCall {
  LoggerInfoStyleCall() {
    this.getMethodName() = ["debug", "error", "fatal", "info", "unknown", "warn"]
  }

  override DataFlow::Node getAnInput() {
    // `msg` from `Logger#info(msg)`,
    // or `progname` from `Logger#info(progname) <block>`
    result = this.getArgument(0)
    or
    // a return value from the block in `Logger#info(progname) <block>`
    exprNodeReturnedFrom(result, this.getBlock().asExpr().getExpr())
  }
}

/**
 * A call to `Logger#progname=`. This sets a default progname.
 * This call does not log anything directly, but the assigned value can appear
 * in future log messages that do not specify a `progname` argument.
 */
private class LoggerSetPrognameCall extends LoggerLoggingCall {
  LoggerSetPrognameCall() { this.getMethodName() = "progname=" }

  override DataFlow::Node getAnInput() {
    exists(CfgNodes::ExprNodes::AssignExprCfgNode a | this.getArgument(0).asExpr() = a |
      result.asExpr() = a.getRhs()
    )
  }
}

private class SplatSummary extends SummarizedCallable {
  SplatSummary() { this = "*(splat)" }

  override SplatExpr getACall() { any() }

  override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
    (
      // *1 = [1]
      input = "Receiver" and
      output = "ArrayElement[0] of ReturnValue"
      or
      // *[1] = [1]
      input = "Receiver" and
      output = "ReturnValue"
    ) and
    preservesValue = true
  }
}

private class ArrayIndex extends int {
  ArrayIndex() { this = any(DataFlow::Content::KnownArrayElementContent c).getIndex() }
}

/**
 * Provides flow summaries for the `Array` class.
 *
 * The summaries are ordered (and implemented) based on
 * https://ruby-doc.org/core-2.7.0/Array.html, however for methods that have the
 * more general `Enumerable` scope, they are implemented in the `Enumerable`
 * module instead.
 */
module Array {
  bindingset[arg]
  private DataFlow::Content::KnownArrayElementContent getKnownArrayElementContent(Expr arg) {
    result.getIndex() = arg.getValueText().toInt()
  }

  bindingset[arg]
  private predicate isUnknownArrayElementContent(Expr arg) {
    not exists(getKnownArrayElementContent(arg)) and
    not arg instanceof RangeLiteral
  }

  private class ArrayLiteralSummary extends SummarizedCallable {
    ArrayLiteralSummary() { this = "Array.[]" }

    override MethodCall getACall() {
      result = API::getTopLevelMember("Array").getAMethodCall("[]").getExprNode().getExpr()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      exists(ArrayIndex i |
        input = "Argument[" + i + "]" and
        output = "ArrayElement[" + i + "] of ReturnValue" and
        preservesValue = true
      )
    }
  }

  private class NewSummary extends SummarizedCallable {
    NewSummary() { this = "Array.new" }

    override MethodCall getACall() {
      result = API::getTopLevelMember("Array").getAnInstantiation().getExprNode().getExpr()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "Argument[1]" and
        output = "ArrayElement[?] of ReturnValue"
        or
        exists(ArrayIndex i |
          input = "ArrayElement[" + i + "] of Argument[0]" and
          output = "ArrayElement[" + i + "] of ReturnValue"
        )
        or
        input = "ArrayElement[?] of Argument[0]" and
        output = "ArrayElement[?] of ReturnValue"
        or
        input = "ReturnValue of BlockArgument" and
        output = "ArrayElement[?] of ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class TryConvertSummary extends SummarizedCallable {
    TryConvertSummary() { this = "Array.try_convert" }

    override MethodCall getACall() {
      result = API::getTopLevelMember("Array").getAMethodCall("try_convert").getExprNode().getExpr()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        exists(ArrayIndex i |
          input = "ArrayElement[" + i + "] of Argument[0]" and
          output = "ArrayElement[" + i + "] of ReturnValue"
        )
        or
        input = "ArrayElement[?] of Argument[0]" and
        output = "ArrayElement[?] of ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class SetIntersectionSummary extends SummarizedCallable {
    SetIntersectionSummary() { this = "&" }

    override BitwiseAndExpr getACall() { any() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = ["ArrayElement of Receiver", "ArrayElement of Argument[0]"] and
      output = "ArrayElement[?] of ReturnValue" and
      preservesValue = true
    }
  }

  private class RepetitionSummary extends SummarizedCallable {
    RepetitionSummary() { this = "*" }

    override MulExpr getACall() { any() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "ArrayElement[?] of ReturnValue" and
      preservesValue = true
    }
  }

  private class ConcatenationSummary extends SummarizedCallable {
    ConcatenationSummary() { this = "+" }

    override AddExpr getACall() { any() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        exists(ArrayIndex i |
          input = "ArrayElement[" + i + "] of Receiver" and
          output = "ArrayElement[" + i + "] of ReturnValue"
        )
        or
        input = ["ArrayElement[?] of Receiver", "ArrayElement of Argument[0]"] and
        output = "ArrayElement[?] of ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class SetDifferenceSummary extends SummarizedCallable {
    SetDifferenceSummary() { this = "-" }

    override SubExpr getACall() { any() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "ArrayElement[?] of ReturnValue" and
      preservesValue = true
    }
  }

  private class AppendSummary extends SummarizedCallable {
    AppendSummary() { this = "<<" }

    override LShiftExpr getACall() { any() }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        exists(ArrayIndex i |
          input = "ArrayElement[" + i + "] of Receiver" and
          output = "ArrayElement[" + i + "] of ReturnValue"
        )
        or
        input = ["ArrayElement[?] of Receiver", "Argument[0]"] and
        output = "ArrayElement[?] of ReturnValue"
      ) and
      preservesValue = true
    }
  }

  /** A call to `[]`. */
  abstract private class ElementReferenceReadSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    ElementReferenceReadSummary() { mc.getMethodName() = "[]" }

    override MethodCall getACall() { result = mc }
  }

  /** A call to `[]` with a known index. */
  private class ElementReferenceReadKnownSummary extends ElementReferenceReadSummary {
    private int i;

    ElementReferenceReadKnownSummary() {
      this = "[" + i + "]" and
      mc.getNumberOfArguments() = 1 and
      i = getKnownArrayElementContent(mc.getArgument(0)).getIndex()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement[" + [i.toString(), "?"] + "] of Receiver" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  /** A call to `[]` with an unknown index. */
  private class ElementReferenceReadUnknownSummary extends ElementReferenceReadSummary {
    ElementReferenceReadUnknownSummary() {
      this = "[](index)" and
      mc.getNumberOfArguments() = 1 and
      isUnknownArrayElementContent(mc.getArgument(0))
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  /** A call to `[]` with two arguments or a range argument. */
  private class ElementReferenceSliceReadSummary extends ElementReferenceReadSummary {
    ElementReferenceSliceReadSummary() {
      this = "[](slice)" and
      (
        mc.getNumberOfArguments() = 2
        or
        mc.getNumberOfArguments() = 1 and
        mc.getArgument(0) instanceof RangeLiteral
      )
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "ArrayElement[?] of ReturnValue" and
      preservesValue = true
    }
  }

  /** A call to `[]=`. */
  abstract private class ElementReferenceStoreSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    ElementReferenceStoreSummary() { mc.getMethodName() = "[]=" }

    final override MethodCall getACall() { result = mc }
  }

  /** A call to `[]=` with a known index. */
  private class ElementReferenceStoreKnownSummary extends ElementReferenceStoreSummary {
    private DataFlow::Content::KnownArrayElementContent c;

    ElementReferenceStoreKnownSummary() {
      mc.getNumberOfArguments() = 2 and
      c = getKnownArrayElementContent(mc.getArgument(0)) and
      this = "[" + c.getIndex() + "]="
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[1]" and
      output = "ArrayElement[" + c.getIndex() + "] of Receiver" and
      preservesValue = true
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::Content content) {
      pos.isSelf() and
      content = c
    }
  }

  /** A call to `[]=` with an unknown index. */
  private class ElementReferenceStoreUnknownSummary extends ElementReferenceStoreSummary {
    ElementReferenceStoreUnknownSummary() {
      mc.getNumberOfArguments() = 2 and
      isUnknownArrayElementContent(mc.getArgument(0)) and
      this = "[]="
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "Argument[1]" and
      output = "ArrayElement[?] of Receiver" and
      preservesValue = true
    }
  }

  /** A call to `[]=` with two arguments or a range argument. */
  private class ElementReferenceSliceStoreUnknownSummary extends ElementReferenceStoreSummary {
    ElementReferenceSliceStoreUnknownSummary() {
      this = "[]=(slice)" and
      (
        mc.getNumberOfArguments() > 2
        or
        mc.getNumberOfArguments() = 2 and
        mc.getArgument(0) instanceof RangeLiteral
      )
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      exists(string arg |
        arg = "Argument[" + (mc.getNumberOfArguments() - 1) + "]" and
        input = ["ArrayElement of " + arg, arg, "ArrayElement of Receiver"] and
        output = "ArrayElement[?] of Receiver" and
        preservesValue = true
      )
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::Content content) {
      pos.isSelf() and
      content instanceof DataFlow::Content::KnownArrayElementContent
    }
  }

  private class AssocSummary extends SimpleSummarizedCallable {
    AssocSummary() { this = "assoc" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of ArrayElement of Receiver" and
      output = "ArrayElement[?] of ReturnValue" and
      preservesValue = true
    }
  }

  abstract private class AtSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    AtSummary() { mc.getMethodName() = "at" }

    override MethodCall getACall() { result = mc }
  }

  private class AtKnownSummary extends AtSummary {
    private int i;

    AtKnownSummary() {
      this = "at(" + i + "]" and
      mc.getNumberOfArguments() = 1 and
      i = getKnownArrayElementContent(mc.getArgument(0)).getIndex()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement[" + [i.toString(), "?"] + "] of Receiver" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class AtUnknownSummary extends AtSummary {
    AtUnknownSummary() {
      this = "at" and
      mc.getNumberOfArguments() = 1 and
      isUnknownArrayElementContent(mc.getArgument(0))
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class BSearchSummary extends SimpleSummarizedCallable {
    BSearchSummary() { this = "bsearch" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = ["Parameter[0] of BlockArgument", "ReturnValue"] and
      preservesValue = true
    }
  }

  private class BSearchIndexSummary extends SimpleSummarizedCallable {
    BSearchIndexSummary() { this = "bsearch_index" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "Parameter[0] of BlockArgument" and
      preservesValue = true
    }
  }

  private class ClearSummary extends SimpleSummarizedCallable {
    ClearSummary() { this = "clear" }

    override predicate clearsContent(ParameterPosition pos, DataFlow::Content content) {
      pos.isSelf() and
      content instanceof DataFlow::Content::ArrayElementContent
    }
  }

  private class CombinationSummary extends SimpleSummarizedCallable {
    CombinationSummary() { this = "combination" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "ArrayElement[?] of Parameter[0] of BlockArgument" and
      preservesValue = true
    }
  }

  private class CompactSummary extends SimpleSummarizedCallable {
    CompactSummary() { this = "compact" + ["", "!"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "ArrayElement[?] of ReturnValue" and
      preservesValue = true
    }
  }

  private class ConcatSummary extends SimpleSummarizedCallable {
    ConcatSummary() { this = "concat" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Argument[_]" and
      output = "ArrayElement[?] of Receiver" and
      preservesValue = true
    }
  }

  private class DeleteSummary extends SimpleSummarizedCallable {
    DeleteSummary() { this = "delete" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = ["ArrayElement of Receiver", "ReturnValue of BlockArgument"] and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class DeleteAtSummary extends SimpleSummarizedCallable {
    DeleteAtSummary() { this = "delete_at" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class DeleteIfSummary extends SimpleSummarizedCallable {
    DeleteIfSummary() { this = "delete_if" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = ["Parameter[0] of BlockArgument", "ArrayElement[?] of ReturnValue"] and
      preservesValue = true
    }
  }

  private class DifferenceSummary extends SimpleSummarizedCallable {
    DifferenceSummary() { this = "difference" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      any(SetDifferenceSummary s).propagatesFlowExt(input, output, preservesValue)
    }
  }

  private string getDigArg(MethodCall dig, int i) {
    dig.getMethodName() = "dig" and
    exists(Expr arg | arg = dig.getArgument(i) |
      result = arg.getValueText().toInt().toString()
      or
      not exists(arg.getValueText()) and
      result = "?"
    )
  }

  private class RelevantDigMethodCall extends MethodCall {
    RelevantDigMethodCall() {
      forall(int i | i in [0 .. this.getNumberOfArguments() - 1] | exists(getDigArg(this, i)))
    }
  }

  private string buildDigInputSpecComponent(RelevantDigMethodCall dig, int i) {
    exists(string s |
      s = getDigArg(dig, i) and
      if s = "?" then result = "" else result = "[" + [s, "?"] + "]"
    )
  }

  language[monotonicAggregates]
  private string buildDigInputSpec(RelevantDigMethodCall dig) {
    result =
      strictconcat(int i |
        i in [0 .. dig.getNumberOfArguments() - 1]
      |
        "ArrayElement" + buildDigInputSpecComponent(dig, i) + " of " order by i desc
      )
  }

  private class DigSummary extends SummarizedCallable {
    private RelevantDigMethodCall dig;

    DigSummary() {
      this =
        "dig(" +
          strictconcat(int i |
            i in [0 .. dig.getNumberOfArguments() - 1]
          |
            getDigArg(dig, i), "," order by i
          ) + ")"
    }

    override MethodCall getACall() { result = dig }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = buildDigInputSpec(dig) + "Receiver" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class EachSummary extends SimpleSummarizedCallable {
    EachSummary() { this = "each" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "ArrayElement of Receiver" and
        output = "Parameter[0] of BlockArgument"
        or
        input = "ArrayElement[?] of Receiver" and
        output = "ArrayElement[?] of ReturnValue"
        or
        exists(ArrayIndex i |
          input = "ArrayElement[" + i + "] of Receiver" and
          output = "ArrayElement[" + i + "] of ReturnValue"
        )
      ) and
      preservesValue = true
    }
  }

  private class EachIndexSummary extends SimpleSummarizedCallable {
    EachIndexSummary() { this = "each_index" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "ArrayElement[?] of Receiver" and
        output = "ArrayElement[?] of ReturnValue"
        or
        exists(ArrayIndex i |
          input = "ArrayElement[" + i + "] of Receiver" and
          output = "ArrayElement[" + i + "] of ReturnValue"
        )
      ) and
      preservesValue = true
    }
  }

  private class FetchSummary extends SimpleSummarizedCallable {
    FetchSummary() { this = "fetch" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "ArrayElement of Receiver" and
        output = "ReturnValue"
        or
        input = "Argument[0]" and
        output = "Parameter[0] of BlockArgument"
      ) and
      preservesValue = true
    }
  }

  abstract private class FillSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    FillSummary() { mc.getMethodName() = "fill" }

    override MethodCall getACall() { result = mc }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = ["Argument[0]", "ReturnValue of BlockArgument"] and
      output = "ArrayElement[?] of Receiver" and
      preservesValue = true
    }
  }

  private class FillAllSummary extends FillSummary {
    FillAllSummary() {
      this = "fill(all)" and
      if exists(mc.getBlock()) then mc.getNumberOfArguments() = 0 else mc.getNumberOfArguments() = 1
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::Content content) {
      pos.isSelf() and
      content instanceof DataFlow::Content::ArrayElementContent
    }
  }

  private class FillSomeSummary extends FillSummary {
    FillSomeSummary() {
      this = "fill(some)" and
      if exists(mc.getBlock()) then mc.getNumberOfArguments() > 0 else mc.getNumberOfArguments() > 1
    }
  }

  private class FilterBangSummary extends SimpleSummarizedCallable {
    FilterBangSummary() { this = "filter!" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = ["Parameter[0] of BlockArgument", "ArrayElement[?] of ReturnValue"] and
      preservesValue = true
    }
  }

  private class FlattenSummary extends SimpleSummarizedCallable {
    FlattenSummary() { this = "flatten" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input =
          [
            "ArrayElement of Receiver", "ArrayElement of ArrayElement of Receiver",
            "ArrayElement of ArrayElement of ArrayElement of Receiver"
          ] and
        output = "ArrayElement[?] of ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class FlattenBangSummary extends SimpleSummarizedCallable {
    FlattenBangSummary() { this = "flatten!" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input =
          [
            "ArrayElement of Receiver", "ArrayElement of ArrayElement of Receiver",
            "ArrayElement of ArrayElement of ArrayElement of Receiver"
          ] and
        output = "ArrayElement[?] of Receiver"
      ) and
      preservesValue = true
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::Content content) {
      pos.isSelf() and
      content instanceof DataFlow::Content::ArrayElementContent
    }
  }

  private class IndexSummary extends SimpleSummarizedCallable {
    IndexSummary() { this = "index" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "Parameter[0] of BlockArgument" and
      preservesValue = true
    }
  }

  private class ReplaceSummary extends SimpleSummarizedCallable {
    ReplaceSummary() { this = "replace" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "ArrayElement[?] of Argument[0]" and
        output = "ArrayElement[?] of Receiver"
        or
        exists(ArrayIndex i |
          input = "ArrayElement[" + i + "] of Argument[0]" and
          output = "ArrayElement[" + i + "] of Receiver"
        )
      ) and
      preservesValue = true
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::Content content) {
      pos.isSelf() and
      content instanceof DataFlow::Content::ArrayElementContent
    }
  }

  private class PrependSummary extends SummarizedCallable {
    private MethodCall mc;

    PrependSummary() {
      mc.getMethodName() = "prepend" and
      this = "prepend(" + mc.getNumberOfArguments() + ")"
    }

    override MethodCall getACall() { result = mc }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      exists(ArrayIndex i, int num | num = mc.getNumberOfArguments() and preservesValue = true |
        input = "ArrayElement[" + i + "] of Receiver" and
        output = "ArrayElement[" + (i + num) + "] of Receiver"
        or
        input = "Argument[" + i + "]" and
        output = "ArrayElement[" + i + "] of Receiver"
      )
    }

    override predicate clearsContent(ParameterPosition pos, DataFlow::Content content) {
      pos.isSelf() and
      content instanceof DataFlow::Content::KnownArrayElementContent
    }
  }
}

/**
 * Provides flow summaries for the `Enumerable` class.
 *
 * The summaries are ordered (and implemented) based on
 * https://ruby-doc.org/core-2.7.0/Enumerable.html.
 */
module Enumerable {
  private class AllSummary extends SimpleSummarizedCallable {
    AllSummary() { this = "all?" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "Parameter[0] of BlockArgument" and
      preservesValue = true
      or
      input = "ReturnValue of BlockArgument" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  private class AnySummary extends SimpleSummarizedCallable {
    AnySummary() { this = "any?" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "Parameter[0] of BlockArgument" and
      preservesValue = true
      or
      input = "ReturnValue of BlockArgument" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  private class CollectSummary extends SimpleSummarizedCallable {
    CollectSummary() { this = ["collect", "collect!"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "Parameter[0] of BlockArgument" and
      preservesValue = true
      or
      input = "ReturnValue of BlockArgument" and
      output = "ArrayElement[?] of ReturnValue" and
      preservesValue = true
    }
  }

  private class CollectConcatSummary extends SimpleSummarizedCallable {
    CollectConcatSummary() { this = "collect_concat" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "Parameter[0] of BlockArgument" and
      preservesValue = true
      or
      input = "ArrayElement of ReturnValue of BlockArgument" and
      output = "ArrayElement[?] of ReturnValue" and
      preservesValue = true
    }
  }

  private class CountSummary extends SimpleSummarizedCallable {
    CountSummary() { this = "count" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "Parameter[0] of BlockArgument" and
      preservesValue = true
    }
  }

  private class CycleSummary extends SimpleSummarizedCallable {
    CycleSummary() { this = "cycle" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "Parameter[0] of BlockArgument" and
      preservesValue = true
    }
  }

  private class DetectSummary extends SimpleSummarizedCallable {
    DetectSummary() { this = "detect" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "ArrayElement of Receiver" and
        output = ["Parameter[0] of BlockArgument", "ReturnValue"]
        or
        input = "ReturnValue of Argument[0]" and
        output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  abstract private class DropSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    DropSummary() { mc.getMethodName() = "drop" }

    override MethodCall getACall() { result = mc }
  }

  private class DropKnownSummary extends DropSummary {
    private int i;

    DropKnownSummary() {
      this = "drop(" + i + ")" and
      i = mc.getArgument(0).getValueText().toInt()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "ArrayElement[?] of Receiver" and
        output = "ArrayElement[?] of ReturnValue"
        or
        exists(ArrayIndex j |
          input = "ArrayElement[" + j + "] of Receiver" and
          output = "ArrayElement[" + (j - i) + "] of ReturnValue"
        )
      ) and
      preservesValue = true
    }
  }

  private class DropUnknownSummary extends DropSummary {
    DropUnknownSummary() {
      this = "drop(index)" and
      not exists(mc.getArgument(0).getValueText().toInt())
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "ArrayElement[?] of ReturnValue" and
      preservesValue = true
    }
  }

  private class DropWhileSummary extends SimpleSummarizedCallable {
    DropWhileSummary() { this = "drop_while" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = ["ArrayElement[?] of ReturnValue", "Parameter[0] of BlockArgument"] and
      preservesValue = true
    }
  }

  private class EachConsSummary extends SimpleSummarizedCallable {
    EachConsSummary() { this = "each_cons" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "ArrayElement[?] of Parameter[0] of BlockArgument" and
      preservesValue = true
    }
  }

  private class EachEntrySummary extends SimpleSummarizedCallable {
    EachEntrySummary() { this = "each_entry" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "ArrayElement of Receiver" and
        output = "Parameter[0] of BlockArgument"
        or
        input = "ArrayElement[?] of Receiver" and
        output = "ArrayElement[?] of ReturnValue"
        or
        exists(ArrayIndex i |
          input = "ArrayElement[" + i + "] of Receiver" and
          output = "ArrayElement[" + i + "] of ReturnValue"
        )
      ) and
      preservesValue = true
    }
  }

  private class EachSliceSummary extends SimpleSummarizedCallable {
    EachSliceSummary() { this = "each_slice" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "ArrayElement of Receiver" and
        output = "ArrayElement[?] of Parameter[0] of BlockArgument"
        or
        input = "ArrayElement[?] of Receiver" and
        output = "ArrayElement[?] of ReturnValue"
        or
        exists(ArrayIndex i |
          input = "ArrayElement[" + i + "] of Receiver" and
          output = "ArrayElement[" + i + "] of ReturnValue"
        )
      ) and
      preservesValue = true
    }
  }

  private class EachWithIndexSummary extends SimpleSummarizedCallable {
    EachWithIndexSummary() { this = "each_with_index" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "ArrayElement of Receiver" and
        output = "Parameter[0] of BlockArgument"
        or
        input = "ArrayElement[?] of Receiver" and
        output = "ArrayElement[?] of ReturnValue"
        or
        exists(ArrayIndex i |
          input = "ArrayElement[" + i + "] of Receiver" and
          output = "ArrayElement[" + i + "] of ReturnValue"
        )
      ) and
      preservesValue = true
    }
  }

  private class EachWithObjectSummary extends SimpleSummarizedCallable {
    EachWithObjectSummary() { this = "each_with_object" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "ArrayElement of Receiver" and
        output = "Parameter[0] of BlockArgument"
        or
        input = "Argument[0]" and
        output = ["Parameter[1] of BlockArgument", "ReturnValue"]
      ) and
      preservesValue = true
    }
  }

  private class FilterSummary extends SimpleSummarizedCallable {
    FilterSummary() { this = ["filter", "filter_map"] }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = ["Parameter[0] of BlockArgument", "ArrayElement[?] of ReturnValue"] and
      preservesValue = true
    }
  }

  private class FindSummary extends SimpleSummarizedCallable {
    FindSummary() { this = "find" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "ArrayElement of Receiver" and
        output = ["Parameter[0] of BlockArgument", "ReturnValue"]
        or
        input = "ReturnValue of Argument[0]" and
        output = "ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class FindAllSummary extends SimpleSummarizedCallable {
    FindAllSummary() { this = "find_all" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      any(FilterSummary f).propagatesFlowExt(input, output, preservesValue)
    }
  }

  private class FindIndexSummary extends SimpleSummarizedCallable {
    FindIndexSummary() { this = "find_index" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "Parameter[0] of BlockArgument" and
      preservesValue = true
    }
  }

  abstract private class FirstSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    FirstSummary() { mc.getMethodName() = "first" }

    override MethodCall getACall() { result = mc }
  }

  private class FirstNoArgSummary extends FirstSummary {
    FirstNoArgSummary() { this = "first(no_arg)" and mc.getNumberOfArguments() = 0 }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = ["ArrayElement[0] of Receiver", "ArrayElement[?] of Receiver"] and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  private class FirstArgKnownSummary extends FirstSummary {
    private int n;

    FirstArgKnownSummary() {
      this = "first(" + n + ")" and n = mc.getArgument(0).getValueText().toInt()
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        exists(ArrayIndex i |
          i < n and
          input = "ArrayElement[" + i + "] of Receiver" and
          output = "ArrayElement[" + i + "] of ReturnValue"
        )
        or
        input = "ArrayElement[?] of Receiver" and
        output = "ArrayElement[?] of ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class FirstArgUnknownSummary extends FirstSummary {
    FirstArgUnknownSummary() {
      this = "first(?)" and
      mc.getNumberOfArguments() > 0 and
      not exists(mc.getArgument(0).getValueText().toInt())
    }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        exists(ArrayIndex i |
          input = "ArrayElement[" + i + "] of Receiver" and
          output = "ArrayElement[" + i + "] of ReturnValue"
        )
        or
        input = "ArrayElement[?] of Receiver" and
        output = "ArrayElement[?] of ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class FlatMapSummary extends SimpleSummarizedCallable {
    FlatMapSummary() { this = "flat_map" }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "ArrayElement of Receiver" and
        output = "Parameter[0] of BlockArgument"
        or
        input = "ArrayElement of ReturnValue of BlockArgument" and
        output = "ArrayElement[?] of ReturnValue"
      ) and
      preservesValue = true
    }
  }

  abstract private class GrepSummary extends SummarizedCallable {
    MethodCall mc;

    bindingset[this]
    GrepSummary() { mc.getMethodName() = ["grep", "grep_v"] }

    override MethodCall getACall() { result = mc }
  }

  private class GrepBlockSummary extends GrepSummary {
    GrepBlockSummary() { this = "grep(block)" and exists(mc.getBlock()) }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      (
        input = "ArrayElement of Receiver" and
        output = "Parameter[0] of BlockArgument"
        or
        input = "ReturnValue of BlockArgument" and
        output = "ArrayElement[?] of ReturnValue"
      ) and
      preservesValue = true
    }
  }

  private class GrepNoBlockSummary extends GrepSummary {
    GrepNoBlockSummary() { this = "grep(no_block)" and not exists(mc.getBlock()) }

    override predicate propagatesFlowExt(string input, string output, boolean preservesValue) {
      input = "ArrayElement of Receiver" and
      output = "ArrayElement[?] of ReturnValue" and
      preservesValue = true
    }
  }
  // TODO: Implement `group_by` when we have flow through hashes
}
