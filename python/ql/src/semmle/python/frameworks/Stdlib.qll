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
private import PEP249

/** Provides models for the Python standard library. */
private module Stdlib {
  // ---------------------------------------------------------------------------
  // os
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `os` module. */
  API::Node os() { result = API::moduleImport("os") }

  /**
   * Gets a reference to the attribute `attr_name` of the `os` module.
   * WARNING: Only holds for a few predefined attributes.
   *
   * For example, using `"system"` will get all uses of `os.system`.
   */
  private API::Node os_attr(string attr_name) { result = os().getMember(attr_name) }

  /** Provides models for the `os` module. */
  module os {
    /** Gets a reference to the `os.path` module. */
    API::Node path() { result = os_attr("path") }

    /** Provides models for the `os.path` module */
    module path {
      /**
       * Gets a reference to the attribute `attr_name` of the `os.path` module.
       * WARNING: Only holds for a few predefined attributes.
       *
       * For example, using `attr_name = "join"` will get all uses of `os.path.join`.
       */
      API::Node path_attr(string attr_name) { result = path().getMember(attr_name) }

      /** Gets a reference to the `os.path.join` function. */
      API::Node join() { result = path_attr("join") }
    }
  }

  /**
   * A call to `os.path.normpath`.
   * See https://docs.python.org/3/library/os.path.html#os.path.normpath
   */
  private class OsPathNormpathCall extends Path::PathNormalization::Range, DataFlow::CallCfgNode {
    OsPathNormpathCall() { this = os::path::path_attr("normpath").getACall() }

    DataFlow::Node getPathArg() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("path")]
    }
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
  private class OsPathAbspathCall extends Path::PathNormalization::Range, DataFlow::CfgNode {
    override CallNode node;

    OsPathAbspathCall() { this = os::path::path_attr("abspath").getACall() }

    DataFlow::Node getPathArg() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("path")]
    }
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
  private class OsPathRealpathCall extends Path::PathNormalization::Range, DataFlow::CfgNode {
    override CallNode node;

    OsPathRealpathCall() { this = os::path::path_attr("realpath").getACall() }

    DataFlow::Node getPathArg() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("path")]
    }
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
  private class OsSystemCall extends SystemCommandExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    OsSystemCall() { this = os_attr("system").getACall() }

    override DataFlow::Node getCommand() { result.asCfgNode() = node.getArg(0) }
  }

  /**
   * A call to any of the `os.popen*` functions
   * See https://docs.python.org/3/library/os.html#os.popen
   *
   * Note that in Python 2, there are also `popen2`, `popen3`, and `popen4` functions.
   * Although deprecated since version 2.6, they still work in 2.7.
   * See https://docs.python.org/2.7/library/os.html#os.popen2
   */
  private class OsPopenCall extends SystemCommandExecution::Range, DataFlow::CfgNode {
    override CallNode node;
    string name;

    OsPopenCall() {
      name in ["popen", "popen2", "popen3", "popen4"] and
      this = os_attr(name).getACall()
    }

    override DataFlow::Node getCommand() {
      result.asCfgNode() = node.getArg(0)
      or
      not name = "popen" and
      result.asCfgNode() = node.getArgByName("cmd")
    }
  }

  /**
   * A call to any of the `os.exec*` functions
   * See https://docs.python.org/3.8/library/os.html#os.execl
   */
  private class OsExecCall extends SystemCommandExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    OsExecCall() {
      exists(string name |
        name in ["execl", "execle", "execlp", "execlpe", "execv", "execve", "execvp", "execvpe"] and
        this = os_attr(name).getACall()
      )
    }

    override DataFlow::Node getCommand() { result.asCfgNode() = node.getArg(0) }
  }

  /**
   * A call to any of the `os.spawn*` functions
   * See https://docs.python.org/3.8/library/os.html#os.spawnl
   */
  private class OsSpawnCall extends SystemCommandExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    OsSpawnCall() {
      exists(string name |
        name in [
            "spawnl", "spawnle", "spawnlp", "spawnlpe", "spawnv", "spawnve", "spawnvp", "spawnvpe"
          ] and
        this = os_attr(name).getACall()
      )
    }

    override DataFlow::Node getCommand() { result.asCfgNode() = node.getArg(1) }
  }

  /**
   * A call to any of the `os.posix_spawn*` functions
   * See https://docs.python.org/3.8/library/os.html#os.posix_spawn
   */
  private class OsPosixSpawnCall extends SystemCommandExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    OsPosixSpawnCall() { this = os_attr(["posix_spawn", "posix_spawnp"]).getACall() }

    override DataFlow::Node getCommand() { result.asCfgNode() = node.getArg(0) }
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
  deprecated DataFlow::Node subprocess() { result = API::moduleImport("subprocess").getAUse() }

  /**
   * Gets a reference to the attribute `attr_name` of the `subprocess` module.
   * WARNING: Only holds for a few predefined attributes.
   *
   * For example, using `attr_name = "Popen"` will get all uses of `subprocess.Popen`.
   */
  private DataFlow::Node subprocess_attr(string attr_name) {
    result = API::moduleImport("subprocess").getMember(attr_name).getAUse()
  }

  /**
   * A call to `subprocess.Popen` or helper functions (call, check_call, check_output, run)
   * See https://docs.python.org/3.8/library/subprocess.html#subprocess.Popen
   */
  private class SubprocessPopenCall extends SystemCommandExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    SubprocessPopenCall() {
      exists(string name |
        name in ["Popen", "call", "check_call", "check_output", "run"] and
        node.getFunction() = subprocess_attr(name).asCfgNode()
      )
    }

    /** Gets the ControlFlowNode for the `args` argument, if any. */
    private ControlFlowNode get_args_arg() { result in [node.getArg(0), node.getArgByName("args")] }

    /** Gets the ControlFlowNode for the `shell` argument, if any. */
    private ControlFlowNode get_shell_arg() {
      result in [node.getArg(8), node.getArgByName("shell")]
    }

    private boolean get_shell_arg_value() {
      not exists(this.get_shell_arg()) and
      result = false
      or
      exists(ControlFlowNode shell_arg | shell_arg = this.get_shell_arg() |
        result = shell_arg.getNode().(ImmutableLiteral).booleanValue()
        or
        // TODO: Track the "shell" argument to determine possible values
        not shell_arg.getNode() instanceof ImmutableLiteral and
        (
          result = true
          or
          result = false
        )
      )
    }

    /** Gets the ControlFlowNode for the `executable` argument, if any. */
    private ControlFlowNode get_executable_arg() {
      result in [node.getArg(2), node.getArgByName("executable")]
    }

    override DataFlow::Node getCommand() {
      // TODO: Track arguments ("args" and "shell")
      // TODO: Handle using `args=["sh", "-c", <user-input>]`
      result.asCfgNode() = this.get_executable_arg()
      or
      exists(ControlFlowNode arg_args, boolean shell |
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
          result.asCfgNode() = arg_args.(SequenceNode).getElement(0)
          or
          // Either the "args" argument is not a sequence (which is valid) or we where
          // just not able to figure it out. Simply mark the "args" argument as the
          // command.
          //
          not arg_args instanceof SequenceNode and
          result.asCfgNode() = arg_args
        )
      )
    }
  }

  // ---------------------------------------------------------------------------
  // marshal
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `marshal` module. */
  deprecated DataFlow::Node marshal() { result = API::moduleImport("marshal").getAUse() }

  /** Provides models for the `marshal` module. */
  module marshal {
    /** Gets a reference to the `marshal.loads` function. */
    deprecated DataFlow::Node loads() {
      result = API::moduleImport("marshal").getMember("loads").getAUse()
    }
  }

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
  private string pickleModuleName() { result in ["pickle", "cPickle", "_pickle"] }

  /** Gets a reference to the `pickle` module. */
  deprecated DataFlow::Node pickle() {
    result = API::moduleImport(["pickle", "cPickle", "_pickle"]).getAUse()
  }

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
   * Gets a reference to the attribute `attr_name` of the `popen2` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private API::Node popen2_attr(string attr_name) {
    result = API::moduleImport("popen2").getMember(attr_name)
  }

  /**
   * A call to any of the `popen.popen*` functions, or instantiation of a `popen.Popen*` class.
   * See https://docs.python.org/2.7/library/popen2.html
   */
  private class Popen2PopenCall extends SystemCommandExecution::Range, DataFlow::CfgNode {
    override CallNode node;

    Popen2PopenCall() {
      exists(string name |
        name in ["popen2", "popen3", "popen4", "Popen3", "Popen4"] and
        this = popen2_attr(name).getACall()
      )
    }

    override DataFlow::Node getCommand() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("cmd")]
    }
  }

  // ---------------------------------------------------------------------------
  // platform
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `platform` module. */
  API::Node platform() { result = API::moduleImport("platform") }

  /**
   * Gets a reference to the attribute `attr_name` of the `platform` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private API::Node platform_attr(string attr_name) { result = platform().getMember(attr_name) }

  /**
   * A call to the `platform.popen` function.
   * See https://docs.python.org/2.7/library/platform.html#platform.popen
   */
  private class PlatformPopenCall extends SystemCommandExecution::Range, DataFlow::CallCfgNode {
    PlatformPopenCall() { this = platform_attr("popen").getACall() }

    override DataFlow::Node getCommand() {
      result.asCfgNode() in [node.getArg(0), node.getArgByName("cmd")]
    }
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

  /**
   * A call to the builtin `open` function.
   * See https://docs.python.org/3/library/functions.html#open
   */
  private class OpenCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
    OpenCall() {
      this = API::builtin("open").getACall()
      or
      // io.open is a special case, since it is an alias for the builtin `open`
      this = API::moduleImport("io").getMember("open").getACall()
    }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("file")]
    }
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

  /**
   * Gets a reference to the attribute `attr_name` of the `base64` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private API::Node base64_attr(string attr_name) { result = base64().getMember(attr_name) }

  /** A call to any of the encode functions in the `base64` module. */
  private class Base64EncodeCall extends Encoding::Range, DataFlow::CallCfgNode {
    string name;

    Base64EncodeCall() {
      name in [
          "b64encode", "standard_b64encode", "urlsafe_b64encode", "b32encode", "b16encode",
          "encodestring", "a85encode", "b85encode", "encodebytes"
        ] and
      this = base64_attr(name).getACall()
    }

    override DataFlow::Node getAnInput() { result.asCfgNode() = node.getArg(0) }

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
      this = base64_attr(name).getACall()
    }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getAnInput() { result.asCfgNode() = node.getArg(0) }

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
  API::Node json() { result = API::moduleImport("node") }

  /**
   * Gets a reference to the attribute `attr_name` of the `json` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private API::Node json_attr(string attr_name) { result = json().getMember(attr_name) }

  /**
   * A call to `json.loads`
   * See https://docs.python.org/3/library/json.html#json.loads
   */
  private class JsonLoadsCall extends Decoding::Range, DataFlow::CallCfgNode {
    JsonLoadsCall() { this = json_attr("loads").getACall() }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getAnInput() { result.asCfgNode() = node.getArg(0) }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "JSON" }
  }

  /**
   * A call to `json.dumps`
   * See https://docs.python.org/3/library/json.html#json.dumps
   */
  private class JsonDumpsCall extends Encoding::Range, DataFlow::CallCfgNode {
    JsonDumpsCall() { this = json_attr("dumps").getACall() }

    override DataFlow::Node getAnInput() { result.asCfgNode() = node.getArg(0) }

    override DataFlow::Node getOutput() { result = this }

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
      private DataFlow::LocalSourceNode fieldList(DataFlow::TypeTracker t) {
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
      private DataFlow::LocalSourceNode field(DataFlow::TypeTracker t) {
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

  /**
   * Gets a reference to the attribute `attr_name` of the `http` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private API::Node http_attr(string attr_name) { result = http().getMember(attr_name) }

  /** Provides models for the `http` module. */
  module http {
    // -------------------------------------------------------------------------
    // http.server
    // -------------------------------------------------------------------------
    /** Gets a reference to the `http.server` module. */
    API::Node server() { result = http_attr("server") }

    /** Provides models for the `http.server` module */
    module server {
      /**
       * Gets a reference to the attribute `attr_name` of the `http.server` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private API::Node server_attr(string attr_name) { result = server().getMember(attr_name) }

      /**
       * Provides models for the `http.server.BaseHTTPRequestHandler` class (Python 3 only).
       *
       * See https://docs.python.org/3.9/library/http.server.html#http.server.BaseHTTPRequestHandler.
       */
      module BaseHTTPRequestHandler {
        /** Gets a reference to the `http.server.BaseHTTPRequestHandler` class. */
        API::Node classRef() { result = server_attr("BaseHTTPRequestHandler") }
      }

      /**
       * Provides models for the `http.server.SimpleHTTPRequestHandler` class (Python 3 only).
       *
       * See https://docs.python.org/3.9/library/http.server.html#http.server.SimpleHTTPRequestHandler.
       */
      module SimpleHTTPRequestHandler {
        /** Gets a reference to the `http.server.SimpleHTTPRequestHandler` class. */
        API::Node classRef() { result = server_attr("SimpleHTTPRequestHandler") }
      }

      /**
       * Provides models for the `http.server.CGIHTTPRequestHandler` class (Python 3 only).
       *
       * See https://docs.python.org/3.9/library/http.server.html#http.server.CGIHTTPRequestHandler.
       */
      module CGIHTTPRequestHandler {
        /** Gets a reference to the `http.server.CGIHTTPRequestHandler` class. */
        API::Node classRef() { result = server_attr("CGIHTTPRequestHandler") }
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
    private DataFlow::LocalSourceNode instance(DataFlow::TypeTracker t) {
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
  /** Gets a reference to the `sqlite3` module. */
  private DataFlow::Node sqlite3(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("sqlite3")
    or
    exists(DataFlow::TypeTracker t2 | result = sqlite3(t2).track(t2, t))
  }

  /** Gets a reference to the `sqlite3` module. */
  DataFlow::Node sqlite3() { result = sqlite3(DataFlow::TypeTracker::end()) }

  /**
   * sqlite3 implements PEP 249, providing ways to execute SQL statements against a database.
   *
   * See https://devdocs.io/python~3.9/library/sqlite3
   */
  class Sqlite3 extends PEP249Module {
    Sqlite3() { this = sqlite3() }
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
