/**
 * Provides classes modeling security-relevant aspects of the standard libraries.
 * Note: some modeling is done internally in the dataflow/taint tracking implementation.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.dataflow.new.RemoteFlowSources
private import semmle.python.Concepts
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.PEP249
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper

/** Provides models for the Python standard library. */
module Stdlib {
  /**
   * Provides models for file-like objects,
   * mostly to define standard set of extra taint-steps.
   *
   * See
   * - https://docs.python.org/3.9/glossary.html#term-file-like-object
   * - https://docs.python.org/3.9/library/io.html#io.IOBase
   */
  module FileLikeObject {
    /**
     * A source of a file-like object, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `like::instance()` to get references to instances of `file.like`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to a file-like object. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to a file-like object. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for file-like objects.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "<file-like object>" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() { none() }

      override string getMethodName() { result in ["read", "readline", "readlines"] }

      override string getAsyncMethodName() { none() }
    }

    /**
     * Extra taint propagation for file-like objects, not covered by `InstanceTaintSteps`.",
     */
    private class AdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        // taint-propagation back to instance from `foo.write(tainted_data)`
        exists(DataFlow::AttrRead write, DataFlow::CallCfgNode call, DataFlow::Node instance_ |
          instance_ = instance() and
          write.accesses(instance_, "write")
        |
          nodeTo.(DataFlow::PostUpdateNode).getPreUpdateNode() = instance_ and
          call.getFunction() = write and
          nodeFrom = call.getArg(0)
        )
      }
    }
  }

  /**
   * Provides models for the `http.client.HTTPMessage` class
   *
   * Has no official docs, but see
   * https://github.com/python/cpython/blob/64f54b7ccd49764b0304e076bfd79b5482988f53/Lib/http/client.py#L175
   * and https://docs.python.org/3.9/library/email.compat32-message.html#email.message.Message
   */
  module HTTPMessage {
    /**
     * A source of instances of `http.client.HTTPMessage`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `HTTPMessage::instance()` to get references to instances of `http.client.HTTPMessage`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `http.client.HTTPMessage`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `http.client.HTTPMessage`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `http.client.HTTPMessage`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "http.client.HTTPMessage" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() { none() }

      override string getMethodName() { result in ["get_all", "as_bytes", "as_string", "keys"] }

      override string getAsyncMethodName() { none() }
    }
  }

  /**
   * Provides models for the `http.cookies.Morsel` class
   *
   * See https://docs.python.org/3.9/library/http.cookies.html#http.cookies.Morsel.
   */
  module Morsel {
    /**
     * A source of instances of `http.cookies.Morsel`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `Morsel::instance()` to get references to instances of `http.cookies.Morsel`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `http.cookies.Morsel`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `http.cookies.Morsel`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `http.cookies.Morsel`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "http.cookies.Morsel" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() { result in ["key", "value", "coded_value"] }

      override string getMethodName() { result in ["output", "js_output"] }

      override string getAsyncMethodName() { none() }
    }
  }
}

/**
 * Provides models for the Python standard library.
 *
 * This module is marked private as exposing it means committing to 1-year deprecation
 * policy, and the code is not in a polished enough state that we want to do so -- at
 * least not without having convincing use-cases for it :)
 */
private module StdlibPrivate {
  // ---------------------------------------------------------------------------
  // os
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `os` module. */
  API::Node os() { result = API::moduleImport("os") }

  /** Provides models for the `os` module. */
  module os {
    /** Gets a reference to the `os.path` module. */
    API::Node path() { result = os().getMember("path") }

    /** Provides models for the `os.path` module */
    module path {
      /** Gets a reference to the `os.path.join` function. */
      API::Node join() { result = path().getMember("join") }
    }
  }

  /**
   * A call to `os.path.normpath`.
   * See https://docs.python.org/3/library/os.path.html#os.path.normpath
   */
  private class OsPathNormpathCall extends Path::PathNormalization::Range, DataFlow::CallCfgNode {
    OsPathNormpathCall() { this = os::path().getMember("normpath").getACall() }

    DataFlow::Node getPathArg() { result in [this.getArg(0), this.getArgByName("path")] }
  }

  /** An additional taint step for calls to `os.path.normpath` */
  private class OsPathNormpathCallAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(OsPathNormpathCall call |
        nodeTo = call and
        nodeFrom = call.getPathArg()
      )
    }
  }

  /**
   * A call to `os.path.abspath`.
   * See https://docs.python.org/3/library/os.path.html#os.path.abspath
   */
  private class OsPathAbspathCall extends Path::PathNormalization::Range, DataFlow::CallCfgNode {
    OsPathAbspathCall() { this = os::path().getMember("abspath").getACall() }

    DataFlow::Node getPathArg() { result in [this.getArg(0), this.getArgByName("path")] }
  }

  /** An additional taint step for calls to `os.path.abspath` */
  private class OsPathAbspathCallAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(OsPathAbspathCall call |
        nodeTo = call and
        nodeFrom = call.getPathArg()
      )
    }
  }

  /**
   * A call to `os.path.realpath`.
   * See https://docs.python.org/3/library/os.path.html#os.path.realpath
   */
  private class OsPathRealpathCall extends Path::PathNormalization::Range, DataFlow::CallCfgNode {
    OsPathRealpathCall() { this = os::path().getMember("realpath").getACall() }

    DataFlow::Node getPathArg() { result in [this.getArg(0), this.getArgByName("path")] }
  }

  /** An additional taint step for calls to `os.path.realpath` */
  private class OsPathRealpathCallAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(OsPathRealpathCall call |
        nodeTo = call and
        nodeFrom = call.getPathArg()
      )
    }
  }

  /**
   * A call to `os.system`.
   * See https://docs.python.org/3/library/os.html#os.system
   */
  private class OsSystemCall extends SystemCommandExecution::Range, DataFlow::CallCfgNode {
    OsSystemCall() { this = os().getMember("system").getACall() }

    override DataFlow::Node getCommand() { result = this.getArg(0) }
  }

  /**
   * A call to any of the `os.popen*` functions
   * See https://docs.python.org/3/library/os.html#os.popen
   *
   * Note that in Python 2, there are also `popen2`, `popen3`, and `popen4` functions.
   * Although deprecated since version 2.6, they still work in 2.7.
   * See https://docs.python.org/2.7/library/os.html#os.popen2
   */
  private class OsPopenCall extends SystemCommandExecution::Range, DataFlow::CallCfgNode {
    string name;

    OsPopenCall() {
      name in ["popen", "popen2", "popen3", "popen4"] and
      this = os().getMember(name).getACall()
    }

    override DataFlow::Node getCommand() {
      result = this.getArg(0)
      or
      not name = "popen" and
      result = this.getArgByName("cmd")
    }
  }

  /**
   * A call to any of the `os.exec*` functions
   * See https://docs.python.org/3.8/library/os.html#os.execl
   */
  private class OsExecCall extends SystemCommandExecution::Range, DataFlow::CallCfgNode {
    OsExecCall() {
      exists(string name |
        name in ["execl", "execle", "execlp", "execlpe", "execv", "execve", "execvp", "execvpe"] and
        this = os().getMember(name).getACall()
      )
    }

    override DataFlow::Node getCommand() { result = this.getArg(0) }
  }

  /**
   * A call to any of the `os.spawn*` functions
   * See https://docs.python.org/3.8/library/os.html#os.spawnl
   */
  private class OsSpawnCall extends SystemCommandExecution::Range, DataFlow::CallCfgNode {
    OsSpawnCall() {
      exists(string name |
        name in [
            "spawnl", "spawnle", "spawnlp", "spawnlpe", "spawnv", "spawnve", "spawnvp", "spawnvpe"
          ] and
        this = os().getMember(name).getACall()
      )
    }

    override DataFlow::Node getCommand() { result = this.getArg(1) }
  }

  /**
   * A call to any of the `os.posix_spawn*` functions
   * See https://docs.python.org/3.8/library/os.html#os.posix_spawn
   */
  private class OsPosixSpawnCall extends SystemCommandExecution::Range, DataFlow::CallCfgNode {
    OsPosixSpawnCall() { this = os().getMember(["posix_spawn", "posix_spawnp"]).getACall() }

    override DataFlow::Node getCommand() { result = this.getArg(0) }
  }

  /** An additional taint step for calls to `os.path.join` */
  private class OsPathJoinCallAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(CallNode call |
        nodeTo.asCfgNode() = call and
        call = os::path::join().getACall().asCfgNode() and
        call.getAnArg() = nodeFrom.asCfgNode()
      )
      // TODO: Handle pathlib (like we do for os.path.join)
    }
  }

  // ---------------------------------------------------------------------------
  // subprocess
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `subprocess` module. */
  API::Node subprocess() { result = API::moduleImport("subprocess") }

  /**
   * A call to `subprocess.Popen` or helper functions (call, check_call, check_output, run)
   * See https://docs.python.org/3.8/library/subprocess.html#subprocess.Popen
   */
  private class SubprocessPopenCall extends SystemCommandExecution::Range, DataFlow::CallCfgNode {
    SubprocessPopenCall() {
      exists(string name |
        name in ["Popen", "call", "check_call", "check_output", "run"] and
        this = subprocess().getMember(name).getACall()
      )
    }

    /** Gets the ControlFlowNode for the `args` argument, if any. */
    private DataFlow::Node get_args_arg() { result in [this.getArg(0), this.getArgByName("args")] }

    /** Gets the ControlFlowNode for the `shell` argument, if any. */
    private DataFlow::Node get_shell_arg() {
      result in [this.getArg(8), this.getArgByName("shell")]
    }

    private boolean get_shell_arg_value() {
      not exists(this.get_shell_arg()) and
      result = false
      or
      exists(DataFlow::Node shell_arg | shell_arg = this.get_shell_arg() |
        result = shell_arg.asCfgNode().getNode().(ImmutableLiteral).booleanValue()
        or
        // TODO: Track the "shell" argument to determine possible values
        not shell_arg.asCfgNode().getNode() instanceof ImmutableLiteral and
        (
          result = true
          or
          result = false
        )
      )
    }

    /** Gets the ControlFlowNode for the `executable` argument, if any. */
    private DataFlow::Node get_executable_arg() {
      result in [this.getArg(2), this.getArgByName("executable")]
    }

    override DataFlow::Node getCommand() {
      // TODO: Track arguments ("args" and "shell")
      // TODO: Handle using `args=["sh", "-c", <user-input>]`
      result = this.get_executable_arg()
      or
      exists(DataFlow::Node arg_args, boolean shell |
        arg_args = get_args_arg() and
        shell = get_shell_arg_value()
      |
        // When "executable" argument is set, and "shell" argument is `False`, the
        // "args" argument will only be used to set the program name and arguments to
        // the program, so we should not consider any of them as command execution.
        not (
          exists(this.get_executable_arg()) and
          shell = false
        ) and
        (
          // When the "args" argument is an iterable, first element is the command to
          // run, so if we're able to, we only mark the first element as the command
          // (and not the arguments to the command).
          //
          result.asCfgNode() = arg_args.asCfgNode().(SequenceNode).getElement(0)
          or
          // Either the "args" argument is not a sequence (which is valid) or we where
          // just not able to figure it out. Simply mark the "args" argument as the
          // command.
          //
          not arg_args.asCfgNode() instanceof SequenceNode and
          result = arg_args
        )
      )
    }
  }

  // ---------------------------------------------------------------------------
  // marshal
  // ---------------------------------------------------------------------------
  /**
   * A call to `marshal.loads`
   * See https://docs.python.org/3/library/marshal.html#marshal.loads
   */
  private class MarshalLoadsCall extends Decoding::Range, DataFlow::CallCfgNode {
    MarshalLoadsCall() { this = API::moduleImport("marshal").getMember("loads").getACall() }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "marshal" }
  }

  // ---------------------------------------------------------------------------
  // pickle
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `pickle` module. */
  DataFlow::Node pickle() { result = API::moduleImport(["pickle", "cPickle", "_pickle"]).getAUse() }

  /** Provides models for the `pickle` module. */
  module pickle {
    /** Gets a reference to the `pickle.loads` function. */
    DataFlow::Node loads() {
      result = API::moduleImport(["pickle", "cPickle", "_pickle"]).getMember("loads").getAUse()
    }
  }

  /**
   * A call to `pickle.loads`
   * See https://docs.python.org/3/library/pickle.html#pickle.loads
   */
  private class PickleLoadsCall extends Decoding::Range, DataFlow::CallCfgNode {
    PickleLoadsCall() { this.getFunction() = pickle::loads() }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "pickle" }
  }

  // ---------------------------------------------------------------------------
  // popen2
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `popen2` module (only available in Python 2). */
  API::Node popen2() { result = API::moduleImport("popen2") }

  /**
   * A call to any of the `popen.popen*` functions, or instantiation of a `popen.Popen*` class.
   * See https://docs.python.org/2.7/library/popen2.html
   */
  private class Popen2PopenCall extends SystemCommandExecution::Range, DataFlow::CallCfgNode {
    Popen2PopenCall() {
      exists(string name |
        name in ["popen2", "popen3", "popen4", "Popen3", "Popen4"] and
        this = popen2().getMember(name).getACall()
      )
    }

    override DataFlow::Node getCommand() { result in [this.getArg(0), this.getArgByName("cmd")] }
  }

  // ---------------------------------------------------------------------------
  // platform
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `platform` module. */
  API::Node platform() { result = API::moduleImport("platform") }

  /**
   * A call to the `platform.popen` function.
   * See https://docs.python.org/2.7/library/platform.html#platform.popen
   */
  private class PlatformPopenCall extends SystemCommandExecution::Range, DataFlow::CallCfgNode {
    PlatformPopenCall() { this = platform().getMember("popen").getACall() }

    override DataFlow::Node getCommand() { result in [this.getArg(0), this.getArgByName("cmd")] }
  }

  // ---------------------------------------------------------------------------
  // builtins
  // ---------------------------------------------------------------------------
  /**
   * A call to the builtin `exec` function.
   * See https://docs.python.org/3/library/functions.html#exec
   */
  private class BuiltinsExecCall extends CodeExecution::Range, DataFlow::CallCfgNode {
    BuiltinsExecCall() { this = API::builtin("exec").getACall() }

    override DataFlow::Node getCode() { result = this.getArg(0) }
  }

  /**
   * A call to the builtin `eval` function.
   * See https://docs.python.org/3/library/functions.html#eval
   */
  private class BuiltinsEvalCall extends CodeExecution::Range, DataFlow::CallCfgNode {
    override CallNode node;

    BuiltinsEvalCall() { this = API::builtin("eval").getACall() }

    override DataFlow::Node getCode() { result = this.getArg(0) }
  }

  /** An additional taint step for calls to the builtin function `compile` */
  private class BuiltinsCompileCallAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(DataFlow::CallCfgNode call |
        nodeTo = call and
        call = API::builtin("compile").getACall() and
        nodeFrom in [call.getArg(0), call.getArgByName("source")]
      )
    }
  }

  /** Gets a reference to the builtin `open` function */
  private API::Node getOpenFunctionRef() {
    result = API::builtin("open")
    or
    // io.open is a special case, since it is an alias for the builtin `open`
    result = API::moduleImport("io").getMember("open")
  }

  /**
   * A call to the builtin `open` function.
   * See https://docs.python.org/3/library/functions.html#open
   */
  private class OpenCall extends FileSystemAccess::Range, Stdlib::FileLikeObject::InstanceSource,
    DataFlow::CallCfgNode {
    OpenCall() { this = getOpenFunctionRef().getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("file")]
    }
  }

  /** Gets a reference to an open file. */
  private DataFlow::TypeTrackingNode openFile(DataFlow::TypeTracker t, FileSystemAccess openCall) {
    t.start() and
    result = openCall and
    (
      openCall instanceof OpenCall
      or
      openCall instanceof PathLibOpenCall
    )
    or
    exists(DataFlow::TypeTracker t2 | result = openFile(t2, openCall).track(t2, t))
  }

  /** Gets a reference to an open file. */
  private DataFlow::Node openFile(FileSystemAccess openCall) {
    openFile(DataFlow::TypeTracker::end(), openCall).flowsTo(result)
  }

  /** Gets a reference to the `write` or `writelines` method on an open file. */
  private DataFlow::TypeTrackingNode writeMethodOnOpenFile(
    DataFlow::TypeTracker t, FileSystemAccess openCall
  ) {
    t.startInAttr(["write", "writelines"]) and
    result = openFile(openCall)
    or
    exists(DataFlow::TypeTracker t2 | result = writeMethodOnOpenFile(t2, openCall).track(t2, t))
  }

  /** Gets a reference to the `write` or `writelines` method on an open file. */
  private DataFlow::Node writeMethodOnOpenFile(FileSystemAccess openCall) {
    writeMethodOnOpenFile(DataFlow::TypeTracker::end(), openCall).flowsTo(result)
  }

  /** A call to the `write` or `writelines` method on an opened file, such as `open("foo", "w").write(...)`. */
  private class WriteCallOnOpenFile extends FileSystemWriteAccess::Range, DataFlow::CallCfgNode {
    FileSystemAccess openCall;

    WriteCallOnOpenFile() { this.getFunction() = writeMethodOnOpenFile(openCall) }

    override DataFlow::Node getAPathArgument() {
      // best effort attempt to give the path argument, that was initially given to the
      // `open` call.
      result = openCall.getAPathArgument()
    }

    override DataFlow::Node getADataNode() { result in [this.getArg(0), this.getArgByName("data")] }
  }

  /**
   * An exec statement (only Python 2).
   * See https://docs.python.org/2/reference/simple_stmts.html#the-exec-statement.
   */
  private class ExecStatement extends CodeExecution::Range {
    ExecStatement() {
      // since there are no DataFlow::Nodes for a Statement, we can't do anything like
      // `this = any(Exec exec)`
      this.asExpr() = any(Exec exec).getBody()
    }

    override DataFlow::Node getCode() { result = this }
  }

  // ---------------------------------------------------------------------------
  // base64
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `base64` module. */
  API::Node base64() { result = API::moduleImport("base64") }

  /** A call to any of the encode functions in the `base64` module. */
  private class Base64EncodeCall extends Encoding::Range, DataFlow::CallCfgNode {
    string name;

    Base64EncodeCall() {
      name in [
          "b64encode", "standard_b64encode", "urlsafe_b64encode", "b32encode", "b16encode",
          "encodestring", "a85encode", "b85encode", "encodebytes"
        ] and
      this = base64().getMember(name).getACall()
    }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() {
      name in [
          "b64encode", "standard_b64encode", "urlsafe_b64encode", "encodestring", "encodebytes"
        ] and
      result = "Base64"
      or
      name = "b32encode" and result = "Base32"
      or
      name = "b16encode" and result = "Base16"
      or
      name = "a85encode" and result = "Ascii85"
      or
      name = "b85encode" and result = "Base85"
    }
  }

  /** A call to any of the decode functions in the `base64` module. */
  private class Base64DecodeCall extends Decoding::Range, DataFlow::CallCfgNode {
    string name;

    Base64DecodeCall() {
      name in [
          "b64decode", "standard_b64decode", "urlsafe_b64decode", "b32decode", "b16decode",
          "decodestring", "a85decode", "b85decode", "decodebytes"
        ] and
      this = base64().getMember(name).getACall()
    }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() {
      name in [
          "b64decode", "standard_b64decode", "urlsafe_b64decode", "decodestring", "decodebytes"
        ] and
      result = "Base64"
      or
      name = "b32decode" and result = "Base32"
      or
      name = "b16decode" and result = "Base16"
      or
      name = "a85decode" and result = "Ascii85"
      or
      name = "b85decode" and result = "Base85"
    }
  }

  // ---------------------------------------------------------------------------
  // json
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `json` module. */
  API::Node json() { result = API::moduleImport("json") }

  /**
   * A call to `json.loads`
   * See https://docs.python.org/3/library/json.html#json.loads
   */
  private class JsonLoadsCall extends Decoding::Range, DataFlow::CallCfgNode {
    JsonLoadsCall() { this = json().getMember("loads").getACall() }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("s")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "JSON" }
  }

  /**
   * A call to `json.load`
   * See https://docs.python.org/3/library/json.html#json.load
   */
  private class JsonLoadCall extends Decoding::Range, DataFlow::CallCfgNode {
    JsonLoadCall() { this = json().getMember("load").getACall() }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("fp")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "JSON" }
  }

  /**
   * A call to `json.dumps`
   * See https://docs.python.org/3/library/json.html#json.dumps
   */
  private class JsonDumpsCall extends Encoding::Range, DataFlow::CallCfgNode {
    JsonDumpsCall() { this = json().getMember("dumps").getACall() }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("obj")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "JSON" }
  }

  /**
   * A call to `json.dump`
   * See https://docs.python.org/3/library/json.html#json.dump
   */
  private class JsonDumpCall extends Encoding::Range, DataFlow::CallCfgNode {
    JsonDumpCall() { this = json().getMember("dump").getACall() }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("obj")] }

    override DataFlow::Node getOutput() {
      result.(DataFlow::PostUpdateNode).getPreUpdateNode() in [
          this.getArg(1), this.getArgByName("fp")
        ]
    }

    override string getFormat() { result = "JSON" }
  }

  // ---------------------------------------------------------------------------
  // cgi
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `cgi` module. */
  API::Node cgi() { result = API::moduleImport("cgi") }

  /** Provides models for the `cgi` module. */
  module cgi {
    /**
     * Provides models for the `cgi.FieldStorage` class
     *
     * See https://docs.python.org/3/library/cgi.html.
     */
    module FieldStorage {
      /** Gets a reference to the `cgi.FieldStorage` class. */
      API::Node classRef() { result = cgi().getMember("FieldStorage") }

      /**
       * A source of instances of `cgi.FieldStorage`, extend this class to model new instances.
       *
       * This can include instantiations of the class, return values from function
       * calls, or a special parameter that will be set when functions are called by an external
       * library.
       *
       * Use the predicate `FieldStorage::instance()` to get references to instances of `cgi.FieldStorage`.
       */
      abstract class InstanceSource extends DataFlow::Node { }

      /**
       * A direct instantiation of `cgi.FieldStorage`.
       *
       * We currently consider ALL instantiations to be `RemoteFlowSource`. This seems
       * reasonable since it's used to parse form data for incoming POST requests, but
       * if it turns out to be a problem, we'll have to refine.
       */
      private class ClassInstantiation extends InstanceSource, RemoteFlowSource::Range,
        DataFlow::CallCfgNode {
        ClassInstantiation() { this = classRef().getACall() }

        override string getSourceType() { result = "cgi.FieldStorage" }
      }

      /** Gets a reference to an instance of `cgi.FieldStorage`. */
      API::Node instance() { result = classRef().getReturn() }

      /** Gets a reference to the `getvalue` method on a `cgi.FieldStorage` instance. */
      API::Node getvalueRef() { result = instance().getMember("getvalue") }

      /** Gets a reference to the result of calling the `getvalue` method on a `cgi.FieldStorage` instance. */
      API::Node getvalueResult() { result = getvalueRef().getReturn() }

      /** Gets a reference to the `getfirst` method on a `cgi.FieldStorage` instance. */
      API::Node getfirstRef() { result = instance().getMember("getfirst") }

      /** Gets a reference to the result of calling the `getfirst` method on a `cgi.FieldStorage` instance. */
      API::Node getfirstResult() { result = getfirstRef().getReturn() }

      /** Gets a reference to the `getlist` method on a `cgi.FieldStorage` instance. */
      API::Node getlistRef() { result = instance().getMember("getlist") }

      /** Gets a reference to the result of calling the `getlist` method on a `cgi.FieldStorage` instance. */
      API::Node getlistResult() { result = getlistRef().getReturn() }

      /** Gets a reference to a list of fields. */
      private DataFlow::TypeTrackingNode fieldList(DataFlow::TypeTracker t) {
        t.start() and
        // TODO: Should have better handling of subscripting
        result.asCfgNode().(SubscriptNode).getObject() = instance().getAUse().asCfgNode()
        or
        exists(DataFlow::TypeTracker t2 | result = fieldList(t2).track(t2, t))
      }

      /** Gets a reference to a list of fields. */
      DataFlow::Node fieldList() {
        result = getlistResult().getAUse() or
        result = getvalueResult().getAUse() or
        fieldList(DataFlow::TypeTracker::end()).flowsTo(result)
      }

      /** Gets a reference to a field. */
      private DataFlow::TypeTrackingNode field(DataFlow::TypeTracker t) {
        t.start() and
        // TODO: Should have better handling of subscripting
        result.asCfgNode().(SubscriptNode).getObject() =
          [instance().getAUse(), fieldList()].asCfgNode()
        or
        exists(DataFlow::TypeTracker t2 | result = field(t2).track(t2, t))
      }

      /** Gets a reference to a field. */
      DataFlow::Node field() {
        result = getfirstResult().getAUse()
        or
        result = getvalueResult().getAUse()
        or
        field(DataFlow::TypeTracker::end()).flowsTo(result)
      }

      private class AdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
        override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
          // Methods
          nodeFrom = nodeTo.(DataFlow::AttrRead).getObject() and
          nodeFrom = instance().getAUse() and
          nodeTo = [getvalueRef(), getfirstRef(), getlistRef()].getAUse()
          or
          nodeFrom.asCfgNode() = nodeTo.asCfgNode().(CallNode).getFunction() and
          (
            nodeFrom = getvalueRef().getAUse() and nodeTo = getvalueResult().getAnImmediateUse()
            or
            nodeFrom = getfirstRef().getAUse() and nodeTo = getfirstResult().getAnImmediateUse()
            or
            nodeFrom = getlistRef().getAUse() and nodeTo = getlistResult().getAnImmediateUse()
          )
          or
          // Indexing
          nodeFrom in [instance().getAUse(), fieldList()] and
          nodeTo.asCfgNode().(SubscriptNode).getObject() = nodeFrom.asCfgNode()
          or
          // Attributes on Field
          nodeFrom = field() and
          exists(DataFlow::AttrRead read | nodeTo = read and read.getObject() = nodeFrom |
            read.getAttributeName() in ["value", "file", "filename"]
          )
        }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // BaseHTTPServer (Python 2 only)
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `BaseHTTPServer` module. */
  API::Node baseHTTPServer() { result = API::moduleImport("BaseHTTPServer") }

  /** Provides models for the `BaseHTTPServer` module. */
  module BaseHTTPServer {
    /**
     * Provides models for the `BaseHTTPServer.BaseHTTPRequestHandler` class (Python 2 only).
     */
    module BaseHTTPRequestHandler {
      /** Gets a reference to the `BaseHTTPServer.BaseHTTPRequestHandler` class. */
      API::Node classRef() { result = baseHTTPServer().getMember("BaseHTTPRequestHandler") }
    }
  }

  // ---------------------------------------------------------------------------
  // SimpleHTTPServer (Python 2 only)
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `SimpleHTTPServer` module. */
  API::Node simpleHTTPServer() { result = API::moduleImport("SimpleHTTPServer") }

  /** Provides models for the `SimpleHTTPServer` module. */
  module SimpleHTTPServer {
    /**
     * Provides models for the `SimpleHTTPServer.SimpleHTTPRequestHandler` class (Python 2 only).
     */
    module SimpleHTTPRequestHandler {
      /** Gets a reference to the `SimpleHTTPServer.SimpleHTTPRequestHandler` class. */
      API::Node classRef() { result = simpleHTTPServer().getMember("SimpleHTTPRequestHandler") }
    }
  }

  // ---------------------------------------------------------------------------
  // CGIHTTPServer (Python 2 only)
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `CGIHTTPServer` module. */
  API::Node cgiHTTPServer() { result = API::moduleImport("CGIHTTPServer") }

  /** Provides models for the `CGIHTTPServer` module. */
  module CGIHTTPServer {
    /**
     * Provides models for the `CGIHTTPServer.CGIHTTPRequestHandler` class (Python 2 only).
     */
    module CGIHTTPRequestHandler {
      /** Gets a reference to the `CGIHTTPServer.CGIHTTPRequestHandler` class. */
      API::Node classRef() { result = cgiHTTPServer().getMember("CGIHTTPRequestHandler") }
    }
  }

  // ---------------------------------------------------------------------------
  // http (Python 3 only)
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `http` module. */
  API::Node http() { result = API::moduleImport("http") }

  /** Provides models for the `http` module. */
  module http {
    // -------------------------------------------------------------------------
    // http.server
    // -------------------------------------------------------------------------
    /** Gets a reference to the `http.server` module. */
    API::Node server() { result = http().getMember("server") }

    /** Provides models for the `http.server` module */
    module server {
      /**
       * Provides models for the `http.server.BaseHTTPRequestHandler` class (Python 3 only).
       *
       * See https://docs.python.org/3.9/library/http.server.html#http.server.BaseHTTPRequestHandler.
       */
      module BaseHTTPRequestHandler {
        /** Gets a reference to the `http.server.BaseHTTPRequestHandler` class. */
        API::Node classRef() { result = server().getMember("BaseHTTPRequestHandler") }
      }

      /**
       * Provides models for the `http.server.SimpleHTTPRequestHandler` class (Python 3 only).
       *
       * See https://docs.python.org/3.9/library/http.server.html#http.server.SimpleHTTPRequestHandler.
       */
      module SimpleHTTPRequestHandler {
        /** Gets a reference to the `http.server.SimpleHTTPRequestHandler` class. */
        API::Node classRef() { result = server().getMember("SimpleHTTPRequestHandler") }
      }

      /**
       * Provides models for the `http.server.CGIHTTPRequestHandler` class (Python 3 only).
       *
       * See https://docs.python.org/3.9/library/http.server.html#http.server.CGIHTTPRequestHandler.
       */
      module CGIHTTPRequestHandler {
        /** Gets a reference to the `http.server.CGIHTTPRequestHandler` class. */
        API::Node classRef() { result = server().getMember("CGIHTTPRequestHandler") }
      }
    }
  }

  /**
   * Provides models for the `BaseHTTPRequestHandler` class and subclasses.
   *
   * See
   *  - https://docs.python.org/3.9/library/http.server.html#http.server.BaseHTTPRequestHandler
   *  - https://docs.python.org/2.7/library/basehttpserver.html#BaseHTTPServer.BaseHTTPRequestHandler
   */
  private module HTTPRequestHandler {
    /** Gets a reference to the `BaseHTTPRequestHandler` class or any subclass. */
    API::Node subclassRef() {
      result =
        [
          // Python 2
          BaseHTTPServer::BaseHTTPRequestHandler::classRef(),
          SimpleHTTPServer::SimpleHTTPRequestHandler::classRef(),
          CGIHTTPServer::CGIHTTPRequestHandler::classRef(),
          // Python 3
          http::server::BaseHTTPRequestHandler::classRef(),
          http::server::SimpleHTTPRequestHandler::classRef(),
          http::server::CGIHTTPRequestHandler::classRef()
        ].getASubclass*()
    }

    /** A HTTPRequestHandler class definition (most likely in project code). */
    class HTTPRequestHandlerClassDef extends Class {
      HTTPRequestHandlerClassDef() { this.getParent() = subclassRef().getAUse().asExpr() }
    }

    /**
     * A source of instances of the `BaseHTTPRequestHandler` class or any subclass, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `classname::instance()` to get references to instances of the `BaseHTTPRequestHandler` class or any subclass.
     */
    abstract class InstanceSource extends DataFlow::Node { }

    /** The `self` parameter in a method on the `BaseHTTPRequestHandler` class or any subclass. */
    private class SelfParam extends InstanceSource, RemoteFlowSource::Range, DataFlow::ParameterNode {
      SelfParam() {
        exists(HTTPRequestHandlerClassDef cls | cls.getAMethod().getArg(0) = this.getParameter())
      }

      override string getSourceType() { result = "stdlib HTTPRequestHandler" }
    }

    /** Gets a reference to an instance of the `BaseHTTPRequestHandler` class or any subclass. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of the `BaseHTTPRequestHandler` class or any subclass. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    private class AdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        nodeFrom = instance() and
        exists(DataFlow::AttrRead read | nodeTo = read and read.getObject() = nodeFrom |
          read.getAttributeName() in [
              // str
              "requestline", "path",
              // by default dict-like http.client.HTTPMessage, which is a subclass of email.message.Message
              // see https://docs.python.org/3.9/library/email.compat32-message.html#email.message.Message
              // TODO: Implement custom methods (at least `get_all`, `as_bytes`, `as_string`)
              "headers",
              // file-like
              "rfile"
            ]
        )
      }
    }

    /** An `HTTPMessage` instance that originates from a `BaseHTTPRequestHandler` instance. */
    private class BaseHTTPRequestHandlerHeadersInstances extends Stdlib::HTTPMessage::InstanceSource {
      BaseHTTPRequestHandlerHeadersInstances() {
        this.(DataFlow::AttrRead).accesses(instance(), "headers")
      }
    }

    /** A file-like object that originates from a `BaseHTTPRequestHandler` instance. */
    private class BaseHTTPRequestHandlerFileLikeObjectInstances extends Stdlib::FileLikeObject::InstanceSource {
      BaseHTTPRequestHandlerFileLikeObjectInstances() {
        this.(DataFlow::AttrRead).accesses(instance(), "rfile")
      }
    }

    /**
     * The entry-point for handling a request with a `BaseHTTPRequestHandler` subclass.
     *
     * Not essential for any functionality, but provides a consistent modeling.
     */
    private class RequestHandlerFunc extends HTTP::Server::RequestHandler::Range {
      RequestHandlerFunc() {
        this = any(HTTPRequestHandlerClassDef cls).getAMethod() and
        this.getName() = "do_" + HTTP::httpVerb()
      }

      override Parameter getARoutedParameter() { none() }

      override string getFramework() { result = "Stdlib" }
    }
  }

  // ---------------------------------------------------------------------------
  // sqlite3
  // ---------------------------------------------------------------------------
  /**
   * sqlite3 implements PEP 249, providing ways to execute SQL statements against a database.
   *
   * See https://devdocs.io/python~3.9/library/sqlite3
   */
  class Sqlite3 extends PEP249::PEP249ModuleApiNode {
    Sqlite3() { this = API::moduleImport("sqlite3") }
  }

  // ---------------------------------------------------------------------------
  // pathlib
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `pathlib` module. */
  private API::Node pathlib() { result = API::moduleImport("pathlib") }

  /**
   * Gets a name of a constructor for a `pathlib.Path` object.
   * We include the pure paths, as they can be "exported" (say with `as_posix`) and then used to acces the underlying file system.
   */
  private string pathlibPathConstructor() {
    result in ["Path", "PurePath", "PurePosixPath", "PureWindowsPath", "PosixPath", "WindowsPath"]
  }

  /**
   * Gets a name of an attribute of a `pathlib.Path` object that is also a `pathlib.Path` object.
   */
  private string pathlibPathAttribute() { result in ["parent"] }

  /**
   * Gets a name of a method of a `pathlib.Path` object that returns a `pathlib.Path` object.
   */
  private string pathlibPathMethod() {
    result in ["absolute", "relative_to", "rename", "replace", "resolve"]
  }

  /**
   * Gets a name of a method of a `pathlib.Path` object that modifies a `pathlib.Path` object based on new data.
   */
  private string pathlibPathInjection() {
    result in ["joinpath", "with_name", "with_stem", "with_suffix"]
  }

  /**
   * Gets a name of an attribute of a `pathlib.Path` object that exports information about the `pathlib.Path` object.
   */
  private string pathlibPathAttributeExport() {
    result in ["drive", "root", "anchor", "name", "suffix", "stem"]
  }

  /**
   * Gets a name of a method of a `pathlib.Path` object that exports information about the `pathlib.Path` object.
   */
  private string pathlibPathMethodExport() { result in ["as_posix", "as_uri"] }

  /**
   * Flow for attributes and methods that return a `pathlib.Path` object.
   */
  private predicate pathlibPathStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    exists(DataFlow::AttrRead returnsPath |
      (
        // attribute access
        returnsPath.getAttributeName() = pathlibPathAttribute() and
        nodeTo = returnsPath
        or
        // method call
        returnsPath.getAttributeName() = pathlibPathMethod() and
        returnsPath
            .(DataFlow::LocalSourceNode)
            .flowsTo(nodeTo.(DataFlow::CallCfgNode).getFunction())
      ) and
      nodeFrom = returnsPath.getObject()
    )
  }

  /**
   * Gets a reference to a `pathlib.Path` object.
   * This type tracker makes the monomorphic API use assumption.
   */
  private DataFlow::TypeTrackingNode pathlibPath(DataFlow::TypeTracker t) {
    // Type construction
    t.start() and
    result = pathlib().getMember(pathlibPathConstructor()).getACall()
    or
    // Type-preserving step
    exists(DataFlow::Node nodeFrom, DataFlow::TypeTracker t2 |
      pathlibPath(t2).flowsTo(nodeFrom) and
      t2.end()
    |
      t.start() and
      pathlibPathStep(nodeFrom, result)
    )
    or
    // Data injection
    //   Special handling of the `/` operator
    exists(BinaryExprNode slash, DataFlow::Node pathOperand, DataFlow::TypeTracker t2 |
      slash.getOp() instanceof Div and
      pathOperand.asCfgNode() = slash.getAnOperand() and
      pathlibPath(t2).flowsTo(pathOperand) and
      t2.end()
    |
      t.start() and
      result.asCfgNode() = slash
    )
    or
    //   standard case
    exists(DataFlow::AttrRead returnsPath, DataFlow::TypeTracker t2 |
      returnsPath.getAttributeName() = pathlibPathInjection() and
      pathlibPath(t2).flowsTo(returnsPath.getObject()) and
      t2.end()
    |
      t.start() and
      result.(DataFlow::CallCfgNode).getFunction() = returnsPath
    )
    or
    // Track further
    exists(DataFlow::TypeTracker t2 | result = pathlibPath(t2).track(t2, t))
  }

  /** Gets a reference to a `pathlib.Path` object. */
  DataFlow::LocalSourceNode pathlibPath() { result = pathlibPath(DataFlow::TypeTracker::end()) }

  /** A file system access from a `pathlib.Path` method call. */
  private class PathlibFileAccess extends FileSystemAccess::Range, DataFlow::CallCfgNode {
    DataFlow::AttrRead fileAccess;
    string attrbuteName;

    PathlibFileAccess() {
      attrbuteName = fileAccess.getAttributeName() and
      attrbuteName in [
          "stat", "chmod", "exists", "expanduser", "glob", "group", "is_dir", "is_file", "is_mount",
          "is_symlink", "is_socket", "is_fifo", "is_block_device", "is_char_device", "iter_dir",
          "lchmod", "lstat", "mkdir", "open", "owner", "read_bytes", "read_text", "readlink",
          "rename", "replace", "resolve", "rglob", "rmdir", "samefile", "symlink_to", "touch",
          "unlink", "link_to", "write_bytes", "write_text"
        ] and
      pathlibPath().flowsTo(fileAccess.getObject()) and
      fileAccess.(DataFlow::LocalSourceNode).flowsTo(this.getFunction())
    }

    override DataFlow::Node getAPathArgument() { result = fileAccess.getObject() }
  }

  /** A file system write from a `pathlib.Path` method call. */
  private class PathlibFileWrites extends PathlibFileAccess, FileSystemWriteAccess::Range {
    PathlibFileWrites() { attrbuteName in ["write_bytes", "write_text"] }

    override DataFlow::Node getADataNode() { result in [this.getArg(0), this.getArgByName("data")] }
  }

  /** A call to the `open` method on a `pathlib.Path` instance. */
  private class PathLibOpenCall extends PathlibFileAccess, Stdlib::FileLikeObject::InstanceSource {
    PathLibOpenCall() { attrbuteName = "open" }
  }

  /** An additional taint steps for objects of type `pathlib.Path` */
  private class PathlibPathTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      // Type construction
      nodeTo = pathlib().getMember(pathlibPathConstructor()).getACall() and
      nodeFrom = nodeTo.(DataFlow::CallCfgNode).getArg(_)
      or
      // Type preservation
      pathlibPath().flowsTo(nodeFrom) and
      pathlibPathStep(nodeFrom, nodeTo)
      or
      // Data injection
      pathlibPath().flowsTo(nodeTo) and
      (
        // Special handling of the `/` operator
        exists(BinaryExprNode slash, DataFlow::Node pathOperand |
          slash.getOp() instanceof Div and
          pathOperand.asCfgNode() = slash.getAnOperand() and
          pathlibPath().flowsTo(pathOperand)
        |
          nodeTo.asCfgNode() = slash and
          // Taint can flow either from the left or the right operand as long as one of them is a path.
          nodeFrom.asCfgNode() = slash.getAnOperand()
        )
        or
        // standard case
        exists(DataFlow::AttrRead augmentsPath |
          augmentsPath.getAttributeName() = pathlibPathInjection()
        |
          augmentsPath
              .(DataFlow::LocalSourceNode)
              .flowsTo(nodeTo.(DataFlow::CallCfgNode).getFunction()) and
          (
            // type-preserving call
            nodeFrom = augmentsPath.getObject()
            or
            // data injection
            nodeFrom = nodeTo.(DataFlow::CallCfgNode).getArg(_)
          )
        )
      )
      or
      // Export data from type
      pathlibPath().flowsTo(nodeFrom) and
      exists(DataFlow::AttrRead exportPath |
        // exporting attribute
        exportPath.getAttributeName() = pathlibPathAttributeExport() and
        nodeTo = exportPath
        or
        // exporting method
        exportPath.getAttributeName() = pathlibPathMethodExport() and
        exportPath.(DataFlow::LocalSourceNode).flowsTo(nodeTo.(DataFlow::CallCfgNode).getFunction())
      |
        nodeFrom = exportPath.getObject()
      )
    }
  }

  // ---------------------------------------------------------------------------
  // hashlib
  // ---------------------------------------------------------------------------
  /** Gets a call to `hashlib.new` with `algorithmName` as the first argument. */
  private DataFlow::CallCfgNode hashlibNewCall(string algorithmName) {
    exists(DataFlow::Node nameArg |
      result = API::moduleImport("hashlib").getMember("new").getACall() and
      nameArg in [result.getArg(0), result.getArgByName("name")] and
      exists(StrConst str |
        nameArg.getALocalSource() = DataFlow::exprNode(str) and
        algorithmName = str.getText()
      )
    )
  }

  /** Gets a reference to the result of calling `hashlib.new` with `algorithmName` as the first argument. */
  private DataFlow::TypeTrackingNode hashlibNewResult(DataFlow::TypeTracker t, string algorithmName) {
    t.start() and
    result = hashlibNewCall(algorithmName)
    or
    exists(DataFlow::TypeTracker t2 | result = hashlibNewResult(t2, algorithmName).track(t2, t))
  }

  /** Gets a reference to the result of calling `hashlib.new` with `algorithmName` as the first argument. */
  DataFlow::Node hashlibNewResult(string algorithmName) {
    hashlibNewResult(DataFlow::TypeTracker::end(), algorithmName).flowsTo(result)
  }

  /**
   * A hashing operation by supplying initial data when calling the `hashlib.new` function.
   */
  class HashlibNewCall extends Cryptography::CryptographicOperation::Range, DataFlow::CallCfgNode {
    string hashName;

    HashlibNewCall() {
      this = hashlibNewCall(hashName) and
      exists([this.getArg(1), this.getArgByName("data")])
    }

    override Cryptography::CryptographicAlgorithm getAlgorithm() { result.matchesName(hashName) }

    override DataFlow::Node getAnInput() { result in [this.getArg(1), this.getArgByName("data")] }
  }

  /**
   * A hashing operation by using the `update` method on the result of calling the `hashlib.new` function.
   */
  class HashlibNewUpdateCall extends Cryptography::CryptographicOperation::Range,
    DataFlow::CallCfgNode {
    string hashName;

    HashlibNewUpdateCall() {
      exists(DataFlow::AttrRead attr |
        attr.getObject() = hashlibNewResult(hashName) and
        this.getFunction() = attr and
        attr.getAttributeName() = "update"
      )
    }

    override Cryptography::CryptographicAlgorithm getAlgorithm() { result.matchesName(hashName) }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }
  }

  /** Helper predicate for the `HashLibGenericHashOperation` charpred, to prevent a bad join order. */
  pragma[nomagic]
  private API::Node hashlibMember(string hashName) {
    result = API::moduleImport("hashlib").getMember(hashName) and
    hashName != "new"
  }

  /**
   * A hashing operation from the `hashlib` package using one of the predefined classes
   * (such as `hashlib.md5`). `hashlib.new` is not included, since it is handled by
   * `HashlibNewCall` and `HashlibNewUpdateCall`.
   */
  abstract class HashlibGenericHashOperation extends Cryptography::CryptographicOperation::Range,
    DataFlow::CallCfgNode {
    string hashName;
    API::Node hashClass;

    bindingset[this]
    HashlibGenericHashOperation() { hashClass = hashlibMember(hashName) }

    override Cryptography::CryptographicAlgorithm getAlgorithm() { result.matchesName(hashName) }
  }

  /**
   * A hashing operation from the `hashlib` package using one of the predefined classes
   * (such as `hashlib.md5`), by calling its' `update` mehtod.
   */
  class HashlibHashClassUpdateCall extends HashlibGenericHashOperation {
    HashlibHashClassUpdateCall() { this = hashClass.getReturn().getMember("update").getACall() }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }
  }

  /**
   * A hashing operation from the `hashlib` package using one of the predefined classes
   * (such as `hashlib.md5`), by passing data to when instantiating the class.
   */
  class HashlibDataPassedToHashClass extends HashlibGenericHashOperation {
    HashlibDataPassedToHashClass() {
      // we only want to model calls to classes such as `hashlib.md5()` if initial data
      // is passed as an argument
      this = hashClass.getACall() and
      exists([this.getArg(0), this.getArgByName("string")])
    }

    override DataFlow::Node getAnInput() {
      result = this.getArg(0)
      or
      // in Python 3.9, you are allowed to use `hashlib.md5(string=<bytes-like>)`.
      result = this.getArgByName("string")
    }
  }

  // ---------------------------------------------------------------------------
  // logging
  // ---------------------------------------------------------------------------
  /**
   * Provides models for the `logging.Logger` class and subclasses.
   *
   * See https://docs.python.org/3.9/library/logging.html#logging.Logger.
   */
  module Logger {
    /** Gets a reference to the `logging.Logger` class or any subclass. */
    API::Node subclassRef() {
      result = API::moduleImport("logging").getMember("Logger").getASubclass*()
    }

    /** Gets a reference to an instance of `logging.Logger` or any subclass. */
    API::Node instance() {
      result = subclassRef().getReturn()
      or
      result = API::moduleImport("logging").getMember("root")
      or
      result = API::moduleImport("logging").getMember("getLogger").getReturn()
    }
  }

  /**
   * A call to one of the logging methods from `logging` or on a `logging.Logger`
   * subclass.
   *
   * See:
   * - https://docs.python.org/3.9/library/logging.html#logging.debug
   * - https://docs.python.org/3.9/library/logging.html#logging.Logger.debug
   */
  class LoggerLogCall extends Logging::Range, DataFlow::CallCfgNode {
    /** The argument-index where the message is passed. */
    int msgIndex;

    LoggerLogCall() {
      exists(string method |
        method in ["critical", "fatal", "error", "warning", "warn", "info", "debug", "exception"] and
        msgIndex = 0
        or
        method = "log" and
        msgIndex = 1
      |
        this = Logger::instance().getMember(method).getACall()
        or
        this = API::moduleImport("logging").getMember(method).getACall()
      )
    }

    override DataFlow::Node getAnInput() {
      result = this.getArgByName("msg")
      or
      result = this.getArg(any(int i | i >= msgIndex))
    }
  }
}

// ---------------------------------------------------------------------------
// OTHER
// ---------------------------------------------------------------------------
/**
 * A call to the `startswith` method on a string.
 * See https://docs.python.org/3.9/library/stdtypes.html#str.startswith
 */
private class StartswithCall extends Path::SafeAccessCheck::Range {
  StartswithCall() { this.(CallNode).getFunction().(AttrNode).getName() = "startswith" }

  override predicate checks(ControlFlowNode node, boolean branch) {
    node = this.(CallNode).getFunction().(AttrNode).getObject() and
    branch = true
  }
}
