/** Provides class and predicates to track external data that
 * may represent malicious OS commands.
 *
 * This module is intended to be imported into a taint-tracking query
 * to extend `TaintKind` and `TaintSink`.
 *
 */
import python

import semmle.python.security.TaintTracking
import semmle.python.security.strings.Untrusted


private ModuleObject osOrPopenModule() {
    result.getName() = "os" or
    result.getName() = "popen2"
}

private Object makeOsCall() {
    exists(string name |
        result = ModuleObject::named("subprocess").attr(name) |
        name = "Popen" or
        name = "call" or 
        name = "check_call" or
        name = "check_output" or
        name = "run"
    )
}

/**Special case for first element in sequence. */
class FirstElementKind extends TaintKind {

    FirstElementKind() {
        this = "sequence[" + any(ExternalStringKind key) + "][0]"
    }

    override string repr() {
        result = "first item in sequence of " + this.getItem().repr()
    }

    /** Gets the taint kind for item in this sequence. */
    ExternalStringKind getItem() {
        this = "sequence[" + result + "][0]"
    }

}

class FirstElementFlow extends DataFlowExtension::DataFlowNode {

    FirstElementFlow() {
        this = any(SequenceNode s).getElement(0)
    }

    override
    ControlFlowNode getASuccessorNode(TaintKind fromkind, TaintKind tokind) {
        result.(SequenceNode).getElement(0) = this and tokind.(FirstElementKind).getItem() = fromkind
    }

}

/** A taint sink that is potentially vulnerable to malicious shell commands.
 *  The `vuln` in `subprocess.call(shell=vuln)` and similar calls.
 */
class ShellCommand extends TaintSink {

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
            call.getFunction().refersTo(osOrPopenModule().attr(name)) |
            name = "system" or
            name = "popen" or
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

/** A taint sink that is potentially vulnerable to malicious shell commands.
 *  The `vuln` in `subprocess.call(vuln, ...)` and similar calls.
 */
class OsCommandFirstArgument extends TaintSink {

    override string toString() { result = "OS command first argument" }

    OsCommandFirstArgument() {
        not this instanceof ShellCommand and
        exists(CallNode call|
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
