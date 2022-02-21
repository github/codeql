/**
 * Provides class and predicates to track external data that
 * may represent malicious OS commands.
 *
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintKind` and `TaintSink`.
 */

import python
import semmle.python.dataflow.TaintTracking
import semmle.python.security.strings.Untrusted

/** Abstract taint sink that is potentially vulnerable to malicious shell commands. */
abstract deprecated class CommandSink extends TaintSink { }

deprecated private ModuleObject osOrPopenModule() { result.getName() = ["os", "popen2"] }

deprecated private Object makeOsCall() {
  exists(string name | result = ModuleObject::named("subprocess").attr(name) |
    name = ["Popen", "call", "check_call", "check_output", "run"]
  )
}

/**Special case for first element in sequence. */
deprecated class FirstElementKind extends TaintKind {
  FirstElementKind() { this = "sequence[" + any(ExternalStringKind key) + "][0]" }

  override string repr() { result = "first item in sequence of " + this.getItem().repr() }

  /** Gets the taint kind for item in this sequence. */
  ExternalStringKind getItem() { this = "sequence[" + result + "][0]" }
}

deprecated class FirstElementFlow extends DataFlowExtension::DataFlowNode {
  FirstElementFlow() { this = any(SequenceNode s).getElement(0) }

  override ControlFlowNode getASuccessorNode(TaintKind fromkind, TaintKind tokind) {
    result.(SequenceNode).getElement(0) = this and tokind.(FirstElementKind).getItem() = fromkind
  }
}

/**
 * A taint sink that is potentially vulnerable to malicious shell commands.
 * The `vuln` in `subprocess.call(shell=vuln)` and similar calls.
 */
deprecated class ShellCommand extends CommandSink {
  override string toString() { result = "shell command" }

  ShellCommand() {
    exists(CallNode call, Object istrue |
      call.getFunction().refersTo(makeOsCall()) and
      call.getAnArg() = this and
      call.getArgByName("shell").refersTo(istrue) and
      istrue.booleanValue() = true
    )
    or
    exists(CallNode call, string name |
      call.getAnArg() = this and
      call.getFunction().refersTo(osOrPopenModule().attr(name))
    |
      name = ["system", "popen"] or
      name.matches("popen_")
    )
    or
    exists(CallNode call |
      call.getAnArg() = this and
      call.getFunction().refersTo(ModuleObject::named("commands"))
    )
  }

  override predicate sinks(TaintKind kind) {
    /* Tainted string command */
    kind instanceof ExternalStringKind
    or
    /* List (or tuple) containing a tainted string command */
    kind instanceof ExternalStringSequenceKind
  }
}

/**
 * A taint sink that is potentially vulnerable to malicious shell commands.
 * The `vuln` in `subprocess.call(vuln, ...)` and similar calls.
 */
deprecated class OsCommandFirstArgument extends CommandSink {
  override string toString() { result = "OS command first argument" }

  OsCommandFirstArgument() {
    not this instanceof ShellCommand and
    exists(CallNode call |
      call.getFunction().refersTo(makeOsCall()) and
      call.getArg(0) = this
    )
  }

  override predicate sinks(TaintKind kind) {
    /* Tainted string command */
    kind instanceof ExternalStringKind
    or
    /* List (or tuple) whose first element is tainted */
    kind instanceof FirstElementKind
  }
}

// -------------------------------------------------------------------------- //
// Modeling of the 'invoke' package and 'fabric' package (v 2.x)
//
// Since fabric build so closely upon invoke, we model them together to avoid
// duplication
// -------------------------------------------------------------------------- //
/**
 * A taint sink that is potentially vulnerable to malicious shell commands.
 * The `vuln` in `invoke.run(vuln, ...)` and similar calls.
 */
deprecated class InvokeRun extends CommandSink {
  InvokeRun() {
    this = Value::named("invoke.run").(FunctionValue).getArgumentForCall(_, 0)
    or
    this = Value::named("invoke.sudo").(FunctionValue).getArgumentForCall(_, 0)
  }

  override string toString() { result = "InvokeRun" }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}

/**
 * Internal TaintKind to track the invoke.Context instance passed to functions
 * marked with @invoke.task
 */
deprecated private class InvokeContextArg extends TaintKind {
  InvokeContextArg() { this = "InvokeContextArg" }
}

/** Internal TaintSource to track the context passed to functions marked with @invoke.task */
deprecated private class InvokeContextArgSource extends TaintSource {
  InvokeContextArgSource() {
    exists(Function f, Expr decorator |
      count(f.getADecorator()) = 1 and
      (
        decorator = f.getADecorator() and not decorator instanceof Call
        or
        decorator = f.getADecorator().(Call).getFunc()
      ) and
      (
        decorator.pointsTo(Value::named("invoke.task"))
        or
        decorator.pointsTo(Value::named("fabric.task"))
      )
    |
      this.(ControlFlowNode).getNode() = f.getArg(0)
    )
  }

  override predicate isSourceOf(TaintKind kind) { kind instanceof InvokeContextArg }
}

/**
 * A taint sink that is potentially vulnerable to malicious shell commands.
 * The `vuln` in `invoke.Context().run(vuln, ...)` and similar calls.
 */
deprecated class InvokeContextRun extends CommandSink {
  InvokeContextRun() {
    exists(CallNode call |
      any(InvokeContextArg k).taints(call.getFunction().(AttrNode).getObject("run"))
      or
      call = Value::named("invoke.Context").(ClassValue).lookup("run").getACall()
      or
      // fabric.connection.Connection is a subtype of invoke.context.Context
      // since fabric.Connection.run has a decorator, it doesn't work with FunctionValue :|
      // and `Value::named("fabric.Connection").(ClassValue).lookup("run").getACall()` returned no results,
      // so here is the hacky solution that works :\
      call.getFunction().(AttrNode).getObject("run").pointsTo().getClass() =
        Value::named("fabric.Connection")
    |
      this = call.getArg(0)
      or
      this = call.getArgByName("command")
    )
  }

  override string toString() { result = "InvokeContextRun" }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}

/**
 * A taint sink that is potentially vulnerable to malicious shell commands.
 * The `vuln` in `fabric.Group().run(vuln, ...)` and similar calls.
 */
deprecated class FabricGroupRun extends CommandSink {
  FabricGroupRun() {
    exists(ClassValue cls |
      cls.getASuperType() = Value::named("fabric.Group") and
      this = cls.lookup("run").(FunctionValue).getArgumentForCall(_, 1)
    )
  }

  override string toString() { result = "FabricGroupRun" }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}

// -------------------------------------------------------------------------- //
// Modeling of the 'invoke' package and 'fabric' package (v 1.x)
// -------------------------------------------------------------------------- //
deprecated class FabricV1Commands extends CommandSink {
  FabricV1Commands() {
    // since `run` and `sudo` are decorated, we can't use FunctionValue's :(
    exists(CallNode call |
      call = Value::named("fabric.api.local").getACall()
      or
      call = Value::named("fabric.api.run").getACall()
      or
      call = Value::named("fabric.api.sudo").getACall()
    |
      this = call.getArg(0)
      or
      this = call.getArgByName("command")
    )
  }

  override string toString() { result = "FabricV1Commands" }

  override predicate sinks(TaintKind kind) { kind instanceof ExternalStringKind }
}

/**
 * An extension that propagates taint from the arguments of `fabric.api.execute(func, arg0, arg1, ...)`
 * to the parameters of `func`, since this will call `func(arg0, arg1, ...)`.
 */
deprecated class FabricExecuteExtension extends DataFlowExtension::DataFlowNode {
  CallNode call;

  FabricExecuteExtension() {
    call = Value::named("fabric.api.execute").getACall() and
    (
      this = call.getArg(any(int i | i > 0))
      or
      this = call.getArgByName(any(string s | not s = "task"))
    )
  }

  override ControlFlowNode getASuccessorNode(TaintKind fromkind, TaintKind tokind) {
    tokind = fromkind and
    exists(CallableValue func |
      (
        call.getArg(0).pointsTo(func)
        or
        call.getArgByName("task").pointsTo(func)
      ) and
      exists(int i |
        // execute(func, arg0, arg1) => func(arg0, arg1)
        this = call.getArg(i) and
        result = func.getParameter(i - 1)
      )
      or
      exists(string name |
        this = call.getArgByName(name) and
        result = func.getParameterByName(name)
      )
    )
  }
}
