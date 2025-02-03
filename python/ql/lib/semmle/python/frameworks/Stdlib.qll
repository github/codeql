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
private import semmle.python.dataflow.new.FlowSummary
private import semmle.python.frameworks.PEP249
private import semmle.python.frameworks.internal.PoorMansFunctionResolution
private import semmle.python.frameworks.internal.SelfRefMixin
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper
// modeling split over multiple files to keep this file from becoming too big
private import semmle.python.frameworks.Stdlib.Urllib
private import semmle.python.frameworks.Stdlib.Urllib2
private import semmle.python.frameworks.data.ModelsAsData

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
  module HttpMessage {
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

    /** Gets a reference to an instance of `http.client.HttpMessage`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `http.client.HttpMessage`. */
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

  /**
   * Provides models for the `urllib.parse.SplitResult` class
   *
   * See https://docs.python.org/3.9/library/urllib.parse.html#urllib.parse.SplitResult.
   */
  module SplitResult {
    /** Gets a reference to the `urllib.parse.SplitResult` class. */
    API::Node classRef() {
      result = API::moduleImport("urllib").getMember("parse").getMember("SplitResult")
      or
      result = ModelOutput::getATypeNode("urllib.parse.SplitResult~Subclass").getASubclass*()
    }

    /**
     * A source of instances of `urllib.parse.SplitResult`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `SplitResult::instance()` to get references to instances of `urllib.parse.SplitResult`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** A direct instantiation of `urllib.parse.SplitResult`. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      ClassInstantiation() { this = classRef().getACall() }
    }

    /** Gets a reference to an instance of `urllib.parse.SplitResult`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `urllib.parse.SplitResult`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `urllib.parse.SplitResult`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "urllib.parse.SplitResult" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() {
        result in [
            "netloc", "path", "query", "fragment", "username", "password", "hostname", "port"
          ]
      }

      override string getMethodName() { none() }

      override string getAsyncMethodName() { none() }
    }

    /**
     * Extra taint propagation for `urllib.parse.SplitResult`, not covered by `InstanceTaintSteps`.
     */
    private class AdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        // TODO
        none()
      }
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
    private import semmle.python.dataflow.new.internal.DataFlowDispatch as DD

    /** Gets a reference to the `logging.Logger` class or any subclass. */
    API::Node subclassRef() {
      result = API::moduleImport("logging").getMember("Logger").getASubclass*()
      or
      result = API::moduleImport("logging").getMember("getLoggerClass").getReturn().getASubclass*()
      or
      result = ModelOutput::getATypeNode("logging.Logger~Subclass").getASubclass*()
    }

    /**
     * A source of instances of `logging.Logger`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `Logger::instance()` to get references to instances of `logging.Logger`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** A direct instantiation of `logging.Logger`. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CfgNode {
      ClassInstantiation() {
        this = subclassRef().getACall()
        or
        this =
          DD::selfTracker(subclassRef()
                .getAValueReachableFromSource()
                .asExpr()
                .(ClassExpr)
                .getInnerScope())
        or
        this = API::moduleImport("logging").getMember("root").asSource()
        or
        this = API::moduleImport("logging").getMember("getLogger").getACall()
      }
    }

    /** Gets a reference to an instance of `logging.Logger`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `logging.Logger`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }
  }
}

/**
 * INTERNAL: Do not use.
 *
 * Provides models for the Python standard library.
 *
 * This module is marked private as exposing it means committing to 1-year deprecation
 * policy, and the code is not in a polished enough state that we want to do so -- at
 * least not without having convincing use-cases for it :)
 */
module StdlibPrivate {
  // ---------------------------------------------------------------------------
  // os
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `os` module. */
  API::Node os() { result = API::moduleImport("os") }

  /** Provides models for the `os` module. */
  module OS {
    /** Gets a reference to the `os.path` module. */
    API::Node path() {
      result = os().getMember("path")
      or
      // although the following modules should not be used directly, they certainly can.
      // Each one doesn't expose the full `os.path` API, so this is an overapproximation
      // that made implementation easy. See
      // - https://github.com/python/cpython/blob/b567b9d74bd9e476a3027335873bb0508d6e450f/Lib/posixpath.py#L31-L38
      // - https://github.com/python/cpython/blob/b567b9d74bd9e476a3027335873bb0508d6e450f/Lib/ntpath.py#L26-L32
      // - https://github.com/python/cpython/blob/b567b9d74bd9e476a3027335873bb0508d6e450f/Lib/genericpath.py#L9-L11
      result = API::moduleImport(["posixpath", "ntpath", "genericpath"])
    }

    /** Provides models for the `os.path` module */
    module OsPath {
      /** Gets a reference to the `os.path.join` function. */
      API::Node join() { result = path().getMember("join") }
    }
  }

  /**
   * Modeling of path related functions in the `os` module.
   * Wrapped in QL module to make it easy to fold/unfold.
   */
  module OsFileSystemAccessModeling {
    /**
     * A call to the `os.fsencode` function.
     *
     * See https://docs.python.org/3/library/os.html#os.fsencode
     */
    private class OsFsencodeCall extends Encoding::Range, DataFlow::CallCfgNode {
      OsFsencodeCall() { this = os().getMember("fsencode").getACall() }

      override DataFlow::Node getAnInput() {
        result in [this.getArg(0), this.getArgByName("filename")]
      }

      override DataFlow::Node getOutput() { result = this }

      override string getFormat() { result = "filesystem" }
    }

    /**
     * A call to the `os.fsdecode` function.
     *
     * See https://docs.python.org/3/library/os.html#os.fsdecode
     */
    private class OsFsdecodeCall extends Decoding::Range, DataFlow::CallCfgNode {
      OsFsdecodeCall() { this = os().getMember("fsdecode").getACall() }

      override DataFlow::Node getAnInput() {
        result in [this.getArg(0), this.getArgByName("filename")]
      }

      override DataFlow::Node getOutput() { result = this }

      override string getFormat() { result = "filesystem" }

      override predicate mayExecuteInput() { none() }
    }

    /**
     * Additional taint step from a call to the `os.fspath` function.
     *
     * See https://docs.python.org/3/library/os.html#os.fspath
     */
    private class OsFspathCallAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        exists(DataFlow::CallCfgNode call |
          call = os().getMember("fspath").getACall() and
          nodeFrom in [call.getArg(0), call.getArgByName("path")] and
          nodeTo = call
        )
      }
    }

    /**
     * A call to the `os.open` function.
     *
     * See https://docs.python.org/3/library/os.html#os.open
     */
    class OsOpenCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsOpenCall() { this = os().getMember("open").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.access` function.
     *
     * See https://docs.python.org/3/library/os.html#os.access
     */
    private class OsAccessCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsAccessCall() { this = os().getMember("access").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.chdir` function.
     *
     * See https://docs.python.org/3/library/os.html#os.chdir
     */
    private class OsChdirCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsChdirCall() { this = os().getMember("chdir").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.chflags` function.
     *
     * See https://docs.python.org/3/library/os.html#os.chflags
     */
    private class OsChflagsCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsChflagsCall() { this = os().getMember("chflags").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.chmod` function.
     *
     * See https://docs.python.org/3/library/os.html#os.chmod
     */
    private class OsChmodCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsChmodCall() { this = os().getMember("chmod").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.chown` function.
     *
     * See https://docs.python.org/3/library/os.html#os.chown
     */
    private class OsChownCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsChownCall() { this = os().getMember("chown").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.chroot` function.
     *
     * See https://docs.python.org/3/library/os.html#os.chroot
     */
    private class OsChrootCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsChrootCall() { this = os().getMember("chroot").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.lchflags` function.
     *
     * See https://docs.python.org/3/library/os.html#os.lchflags
     */
    private class OsLchflagsCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsLchflagsCall() { this = os().getMember("lchflags").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.lchmod` function.
     *
     * See https://docs.python.org/3/library/os.html#os.lchmod
     */
    private class OsLchmodCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsLchmodCall() { this = os().getMember("lchmod").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.lchown` function.
     *
     * See https://docs.python.org/3/library/os.html#os.lchown
     */
    private class OsLchownCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsLchownCall() { this = os().getMember("lchown").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.link` function.
     *
     * See https://docs.python.org/3/library/os.html#os.link
     */
    private class OsLinkCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsLinkCall() { this = os().getMember("link").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [
            this.getArg(0), this.getArgByName("src"), this.getArg(1), this.getArgByName("dst")
          ]
      }
    }

    /**
     * A call to the `os.listdir` function.
     *
     * See https://docs.python.org/3/library/os.html#os.listdir
     */
    private class OsListdirCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsListdirCall() { this = os().getMember("listdir").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.lstat` function.
     *
     * See https://docs.python.org/3/library/os.html#os.lstat
     */
    private class OsLstatCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsLstatCall() { this = os().getMember("lstat").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.mkdir` function.
     *
     * See https://docs.python.org/3/library/os.html#os.mkdir
     */
    private class OsMkdirCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsMkdirCall() { this = os().getMember("mkdir").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.makedirs` function.
     *
     * See https://docs.python.org/3/library/os.html#os.makedirs
     */
    private class OsMakedirsCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsMakedirsCall() { this = os().getMember("makedirs").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("name")]
      }
    }

    /**
     * A call to the `os.mkfifo` function.
     *
     * See https://docs.python.org/3/library/os.html#os.mkfifo
     */
    private class OsMkfifoCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsMkfifoCall() { this = os().getMember("mkfifo").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.mknod` function.
     *
     * See https://docs.python.org/3/library/os.html#os.mknod
     */
    private class OsMknodCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsMknodCall() { this = os().getMember("mknod").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.pathconf` function.
     *
     * See https://docs.python.org/3/library/os.html#os.pathconf
     */
    private class OsPathconfCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsPathconfCall() { this = os().getMember("pathconf").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.readlink` function.
     *
     * See https://docs.python.org/3/library/os.html#os.readlink
     */
    private class OsReadlinkCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsReadlinkCall() { this = os().getMember("readlink").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.remove` function.
     *
     * See https://docs.python.org/3/library/os.html#os.remove
     */
    private class OsRemoveCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsRemoveCall() { this = os().getMember("remove").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.removedirs` function.
     *
     * See https://docs.python.org/3/library/os.html#os.removedirs
     */
    private class OsRemovedirsCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsRemovedirsCall() { this = os().getMember("removedirs").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("name")]
      }
    }

    /**
     * A call to the `os.rename` function.
     *
     * See https://docs.python.org/3/library/os.html#os.rename
     */
    private class OsRenameCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsRenameCall() { this = os().getMember("rename").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [
            this.getArg(0), this.getArgByName("src"), this.getArg(1), this.getArgByName("dst")
          ]
      }
    }

    /**
     * A call to the `os.renames` function.
     *
     * See https://docs.python.org/3/library/os.html#os.renames
     */
    private class OsRenamesCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsRenamesCall() { this = os().getMember("renames").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [
            this.getArg(0), this.getArgByName("old"), this.getArg(1), this.getArgByName("new")
          ]
      }
    }

    /**
     * A call to the `os.replace` function.
     *
     * See https://docs.python.org/3/library/os.html#os.replace
     */
    private class OsReplaceCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsReplaceCall() { this = os().getMember("replace").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [
            this.getArg(0), this.getArgByName("src"), this.getArg(1), this.getArgByName("dst")
          ]
      }
    }

    /**
     * A call to the `os.rmdir` function.
     *
     * See https://docs.python.org/3/library/os.html#os.rmdir
     */
    private class OsRmdirCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsRmdirCall() { this = os().getMember("rmdir").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.scandir` function.
     *
     * See https://docs.python.org/3/library/os.html#os.scandir
     */
    private class OsScandirCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsScandirCall() { this = os().getMember("scandir").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.stat` function.
     *
     * See https://docs.python.org/3/library/os.html#os.stat
     */
    private class OsStatCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsStatCall() { this = os().getMember("stat").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.statvfs` function.
     *
     * See https://docs.python.org/3/library/os.html#os.statvfs
     */
    private class OsStatvfsCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsStatvfsCall() { this = os().getMember("statvfs").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.symlink` function.
     *
     * See https://docs.python.org/3/library/os.html#os.symlink
     */
    private class OsSymlinkCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsSymlinkCall() { this = os().getMember("symlink").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [
            this.getArg(0), this.getArgByName("src"), this.getArg(1), this.getArgByName("dst")
          ]
      }
    }

    /**
     * A call to the `os.truncate` function.
     *
     * See https://docs.python.org/3/library/os.html#os.truncate
     */
    private class OsTruncateCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsTruncateCall() { this = os().getMember("truncate").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.unlink` function.
     *
     * See https://docs.python.org/3/library/os.html#os.unlink
     */
    private class OsUnlinkCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsUnlinkCall() { this = os().getMember("unlink").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.utime` function.
     *
     * See https://docs.python.org/3/library/os.html#os.utime
     */
    private class OsUtimeCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsUtimeCall() { this = os().getMember("utime").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.walk` function.
     *
     * See https://docs.python.org/3/library/os.html#os.walk
     */
    private class OsWalkCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsWalkCall() { this = os().getMember("walk").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("top")]
      }
    }

    /**
     * A call to the `os.fwalk` function.
     *
     * See https://docs.python.org/3/library/os.html#os.fwalk
     */
    private class OsFwalkCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsFwalkCall() { this = os().getMember("fwalk").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("top")]
      }
    }

    /**
     * A call to the `os.getxattr` function.
     *
     * See https://docs.python.org/3/library/os.html#os.getxattr
     */
    private class OsGetxattrCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsGetxattrCall() { this = os().getMember("getxattr").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.listxattr` function.
     *
     * See https://docs.python.org/3/library/os.html#os.listxattr
     */
    private class OsListxattrCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsListxattrCall() { this = os().getMember("listxattr").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.removexattr` function.
     *
     * See https://docs.python.org/3/library/os.html#os.removexattr
     */
    private class OsRemovexattrCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsRemovexattrCall() { this = os().getMember("removexattr").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.setxattr` function.
     *
     * See https://docs.python.org/3/library/os.html#os.setxattr
     */
    private class OsSetxattrCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsSetxattrCall() { this = os().getMember("setxattr").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.add_dll_directory` function.
     *
     * See https://docs.python.org/3/library/os.html#os.add_dll_directory
     */
    private class OsAdd_dll_directoryCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsAdd_dll_directoryCall() { this = os().getMember("add_dll_directory").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }

    /**
     * A call to the `os.startfile` function.
     *
     * See https://docs.python.org/3/library/os.html#os.startfile
     */
    private class OsStartfileCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
      OsStartfileCall() { this = os().getMember("startfile").getACall() }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("path")]
      }
    }
  }

  /**
   * The `os.path` module offers a number of methods for checking if a file exists and/or has certain
   * properties, leading to a file system access.
   * A call to `os.path.exists` or `os.path.lexists` will check if a file exists on the file system.
   * (Although, on some platforms, the check may return `false` due to missing permissions.)
   * A call to `os.path.getatime` will raise `OSError` if the file does not exist or is inaccessible.
   * See:
   * - https://docs.python.org/3/library/os.path.html#os.path.exists
   * - https://docs.python.org/3/library/os.path.html#os.path.lexists
   * - https://docs.python.org/3/library/os.path.html#os.path.isfile
   * - https://docs.python.org/3/library/os.path.html#os.path.isdir
   * - https://docs.python.org/3/library/os.path.html#os.path.islink
   * - https://docs.python.org/3/library/os.path.html#os.path.ismount
   * - https://docs.python.org/3/library/os.path.html#os.path.getatime
   * - https://docs.python.org/3/library/os.path.html#os.path.getmtime
   * - https://docs.python.org/3/library/os.path.html#os.path.getctime
   * - https://docs.python.org/3/library/os.path.html#os.path.getsize
   * - https://docs.python.org/3/library/os.path.html#os.path.realpath
   */
  private class OsPathProbingCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
    string name;

    OsPathProbingCall() {
      name in [
          // these check if the file exists
          "exists", "lexists", "isfile", "isdir", "islink", "ismount",
          // these raise errors if the file does not exist
          "getatime", "getmtime", "getctime", "getsize"
        ] and
      this = OS::path().getMember(name).getACall()
    }

    override DataFlow::Node getAPathArgument() {
      not name = "isdir" and
      result in [this.getArg(0), this.getArgByName("path")]
      or
      // although the Python docs say the parameter is called `path`, the implementation
      // actually uses `s`.
      name = "isdir" and
      result in [this.getArg(0), this.getArgByName("s")]
    }
  }

  /**
   * A call to `os.path.samefile` will raise an exception if an `os.stat()` call on either pathname fails.
   *
   * See https://docs.python.org/3.10/library/os.path.html#os.path.samefile
   */
  private class OsPathSamefileCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
    OsPathSamefileCall() { this = OS::path().getMember("samefile").getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [
          // note that the f1/f2 names doesn't match the documentation, but is what actually works (tested on 3.8.10)
          this.getArg(0), this.getArgByName("f1"), this.getArg(1), this.getArgByName("f2")
        ]
    }
  }

  // Functions with non-standard arguments:
  // - os.path.join(path, *paths)
  // - os.path.relpath(path, start=os.curdir)
  // these functions need special treatment when computing `getPathArg`.
  //
  // Functions that excluded because they can act as sanitizers:
  // - os.path.commonpath(paths): takes a sequence
  // - os.path.commonprefix(list): takes a list argument
  // unless the user control all arguments, we are comparing with a known value.
  private string pathComputation() {
    result in [
        "abspath", "basename", "commonpath", "dirname", "expanduser", "expandvars", "join",
        "normcase", "normpath", "realpath", "relpath", "split", "splitdrive", "splitext"
      ]
  }

  /**
   * The `os.path` module offers a number of methods for computing new paths from existing paths.
   * These should all propagate taint.
   */
  private class OsPathComputation extends DataFlow::CallCfgNode {
    string methodName;

    OsPathComputation() {
      methodName = pathComputation() and
      this = OS::path().getMember(methodName).getACall()
    }

    DataFlow::Node getPathArg() {
      result in [this.getArg(0), this.getArgByName("path")]
      or
      methodName = "join" and result = this.getArg(_)
      or
      methodName = "relpath" and result in [this.getArg(1), this.getArgByName("start")]
    }
  }

  /** An additional taint step for path computations. */
  private class OsPathComputationAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(OsPathComputation call |
        nodeTo = call and
        nodeFrom = call.getPathArg()
      )
    }
  }

  /**
   * A call to `os.path.normpath`.
   * See https://docs.python.org/3/library/os.path.html#os.path.normpath
   */
  private class OsPathNormpathCall extends Path::PathNormalization::Range, DataFlow::CallCfgNode {
    OsPathNormpathCall() { this = OS::path().getMember("normpath").getACall() }

    override DataFlow::Node getPathArg() { result in [this.getArg(0), this.getArgByName("path")] }
  }

  /**
   * A call to `os.path.abspath`.
   * See https://docs.python.org/3/library/os.path.html#os.path.abspath
   */
  private class OsPathAbspathCall extends Path::PathNormalization::Range, DataFlow::CallCfgNode {
    OsPathAbspathCall() { this = OS::path().getMember("abspath").getACall() }

    override DataFlow::Node getPathArg() { result in [this.getArg(0), this.getArgByName("path")] }
  }

  /**
   * A call to `os.path.realpath`.
   * See https://docs.python.org/3/library/os.path.html#os.path.realpath
   */
  private class OsPathRealpathCall extends Path::PathNormalization::Range, DataFlow::CallCfgNode {
    OsPathRealpathCall() { this = OS::path().getMember("realpath").getACall() }

    override DataFlow::Node getPathArg() { result in [this.getArg(0), this.getArgByName("path")] }
  }

  /**
   * A call to `os.system`.
   * See https://docs.python.org/3/library/os.html#os.system
   */
  private class OsSystemCall extends SystemCommandExecution::Range, DataFlow::CallCfgNode {
    OsSystemCall() { this = os().getMember("system").getACall() }

    override DataFlow::Node getCommand() {
      result in [this.getArg(0), this.getArgByName("command")]
    }

    override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getCommand() }
  }

  /**
   * A call to any of the `os.popen*` functions
   * See https://docs.python.org/3/library/os.html#os.popen
   *
   * Note that in Python 2, there are also `popen2`, `popen3`, and `popen4` functions.
   * Although deprecated since version 2.6, they still work in 2.7.
   * See https://docs.python.org/2.7/library/os.html#os.popen2
   */
  private class OsPopenCall extends SystemCommandExecution::Range, API::CallNode {
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

    override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getCommand() }
  }

  /**
   * A call to any of the `os.exec*` functions
   * See https://docs.python.org/3.8/library/os.html#os.execl
   */
  private class OsExecCall extends SystemCommandExecution::Range, FileSystemAccess::Range,
    DataFlow::CallCfgNode
  {
    OsExecCall() {
      exists(string name |
        name in ["execl", "execle", "execlp", "execlpe", "execv", "execve", "execvp", "execvpe"] and
        this = os().getMember(name).getACall()
      )
    }

    override DataFlow::Node getCommand() { result = this.getArg(0) }

    override DataFlow::Node getAPathArgument() { result = this.getCommand() }

    override predicate isShellInterpreted(DataFlow::Node arg) {
      none() // this is a safe API.
    }
  }

  /**
   * A call to any of the `os.spawn*` functions
   * See https://docs.python.org/3.8/library/os.html#os.spawnl
   */
  private class OsSpawnCall extends SystemCommandExecution::Range, FileSystemAccess::Range,
    DataFlow::CallCfgNode
  {
    OsSpawnCall() {
      exists(string name |
        name in [
            "spawnl", "spawnle", "spawnlp", "spawnlpe", "spawnv", "spawnve", "spawnvp", "spawnvpe"
          ] and
        this = os().getMember(name).getACall()
      )
    }

    override DataFlow::Node getCommand() {
      result = this.getArg(1)
      or
      // `file` keyword argument only valid for the `v` variants, but this
      // over-approximation is not hurting anyone, and is easy to implement.
      result = this.getArgByName("file")
    }

    override DataFlow::Node getAPathArgument() { result = this.getCommand() }

    override predicate isShellInterpreted(DataFlow::Node arg) {
      none() // this is a safe API.
    }
  }

  /**
   * A call to any of the `os.posix_spawn*` functions
   * See https://docs.python.org/3.8/library/os.html#os.posix_spawn
   */
  private class OsPosixSpawnCall extends SystemCommandExecution::Range, FileSystemAccess::Range,
    DataFlow::CallCfgNode
  {
    OsPosixSpawnCall() { this = os().getMember(["posix_spawn", "posix_spawnp"]).getACall() }

    override DataFlow::Node getCommand() { result in [this.getArg(0), this.getArgByName("path")] }

    override DataFlow::Node getAPathArgument() { result = this.getCommand() }

    override predicate isShellInterpreted(DataFlow::Node arg) {
      none() // this is a safe API.
    }
  }

  /** An additional taint step for calls to `os.path.join` */
  private class OsPathJoinCallAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      exists(CallNode call |
        nodeTo.asCfgNode() = call and
        call = OS::OsPath::join().getACall().asCfgNode() and
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
   * A call to `subprocess.Popen` or helper functions (call, check_call, check_output, run, getoutput, getstatusoutput)
   * See https://docs.python.org/3.8/library/subprocess.html#subprocess.Popen
   * ref: https://docs.python.org/3/library/subprocess.html#legacy-shell-invocation-functions
   */
  private class SubprocessPopenCall extends SystemCommandExecution::Range, API::CallNode {
    SubprocessPopenCall() {
      exists(string name |
        name in [
            "Popen", "call", "check_call", "check_output", "run", "getoutput", "getstatusoutput"
          ] and
        this = subprocess().getMember(name).getACall()
      )
    }

    /** Gets the API-node for the `args` argument, if any. */
    private API::Node get_args_arg() { result = this.getParameter(0, "args") }

    /** Gets the API-node for the `shell` argument, if any. */
    private API::Node get_shell_arg() { result = this.getParameter(8, "shell") }

    private boolean get_shell_arg_value() {
      not exists(this.get_shell_arg()) and
      result = false
      or
      result =
        this.get_shell_arg().getAValueReachingSink().asExpr().(ImmutableLiteral).booleanValue()
      or
      not this.get_shell_arg().getAValueReachingSink().asExpr() instanceof ImmutableLiteral and
      result = false // defaults to `False`
    }

    /** Gets the API-node for the `executable` argument, if any. */
    private API::Node get_executable_arg() { result = this.getParameter(2, "executable") }

    override DataFlow::Node getCommand() {
      // TODO: Track arguments ("args" and "shell")
      // TODO: Handle using `args=["sh", "-c", <user-input>]`
      result = this.get_executable_arg().asSink()
      or
      exists(DataFlow::Node arg_args, boolean shell |
        arg_args = this.get_args_arg().asSink() and
        shell = this.get_shell_arg_value()
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

    override predicate isShellInterpreted(DataFlow::Node arg) {
      arg = [this.get_executable_arg(), this.get_args_arg()].asSink() and
      this.get_shell_arg_value() = true
    }
  }

  // ---------------------------------------------------------------------------
  // marshal
  // ---------------------------------------------------------------------------
  /**
   * A call to `marshal.load`
   * See https://docs.python.org/3/library/marshal.html#marshal.load
   */
  private class MarshalLoadCall extends Decoding::Range, DataFlow::CallCfgNode {
    MarshalLoadCall() { this = API::moduleImport("marshal").getMember("load").getACall() }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "marshal" }
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
  /** Gets a reference to any of the `pickle` modules. */
  API::Node pickle() {
    result = API::moduleImport(["pickle", "cPickle", "_pickle"])
    or
    result = ModelOutput::getATypeNode("pickle~Alias")
  }

  /**
   * Gets a reference to `pickle.load`
   */
  API::Node pickle_load() {
    result = pickle().getMember("load")
    or
    result = ModelOutput::getATypeNode("pickle.load~Alias")
  }

  /**
   * Gets a reference to `pickle.loads`
   */
  API::Node pickle_loads() {
    result = pickle().getMember("loads")
    or
    result = ModelOutput::getATypeNode("pickle.loads~Alias")
  }

  /**
   * A call to `pickle.load`
   * See https://docs.python.org/3/library/pickle.html#pickle.load
   */
  private class PickleLoadCall extends Decoding::Range, API::CallNode {
    PickleLoadCall() { this = pickle_load().getACall() }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("file")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "pickle" }
  }

  /**
   * A call to `pickle.loads`
   * See https://docs.python.org/3/library/pickle.html#pickle.loads
   */
  private class PickleLoadsCall extends Decoding::Range, API::CallNode {
    PickleLoadsCall() { this = pickle_loads().getACall() }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("data")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "pickle" }
  }

  /**
   * A construction of a `pickle.Unpickler`
   * See https://docs.python.org/3/library/pickle.html#pickle.Unpickler
   */
  private class PickleUnpicklerCall extends Decoding::Range, DataFlow::CallCfgNode {
    PickleUnpicklerCall() { this = pickle().getMember("Unpickler").getACall() }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("file")] }

    override DataFlow::Node getOutput() { result = this.getAMethodCall("load") }

    override string getFormat() { result = "pickle" }
  }

  // ---------------------------------------------------------------------------
  // shelve
  // ---------------------------------------------------------------------------
  /**
   * A call to `shelve.open`
   * See https://docs.python.org/3/library/shelve.html#shelve.open
   *
   * Claiming there is decoding of the input to `shelve.open` is a bit questionable, since
   * it's not the filename, but the contents of the file that is decoded.
   *
   * However, we definitely want to be able to alert if a user is able to control what
   * file is used, since that can lead to code execution (even if that file is free of
   * path injection).
   *
   * So right now the best way we have of modeling this seems to be to treat the filename
   * argument as being deserialized...
   */
  private class ShelveOpenCall extends Decoding::Range, FileSystemAccess::Range,
    DataFlow::CallCfgNode
  {
    ShelveOpenCall() { this = API::moduleImport("shelve").getMember("open").getACall() }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() {
      result in [this.getArg(0), this.getArgByName("filename")]
    }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("filename")]
    }

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

    override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getCommand() }
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

    override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getCommand() }
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
    or
    // similarly, coecs.open calls the builtin `open`: https://github.com/python/cpython/blob/3.12/Lib/codecs.py#L918
    result = API::moduleImport("codecs").getMember("open")
  }

  /**
   * A call to the builtin `open` function.
   * See https://docs.python.org/3/library/functions.html#open
   */
  private class OpenCall extends FileSystemAccess::Range, Stdlib::FileLikeObject::InstanceSource,
    ThreatModelSource::Range, DataFlow::CallCfgNode
  {
    OpenCall() {
      this = getOpenFunctionRef().getACall() and
      // when analyzing stdlib code for os.py we wrongly assume that `os.open` is an
      // alias of the builtins `open` function
      not this instanceof OsFileSystemAccessModeling::OsOpenCall
    }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("file")]
    }

    override string getThreatModel() { result = "file" }

    override string getSourceType() { result = "open()" }
  }

  /**
   * A call to the `io.FileIO` constructor.
   * See https://docs.python.org/3/library/io.html#io.FileIO
   */
  private class FileIOCall extends FileSystemAccess::Range, API::CallNode {
    FileIOCall() { this = API::moduleImport("io").getMember("FileIO").getACall() }

    override DataFlow::Node getAPathArgument() { result = this.getParameter(0, "file").asSink() }
  }

  /**
   * A call to the `io.open_code` function.
   * See https://docs.python.org/3.11/library/io.html#io.open_code
   */
  private class OpenCodeCall extends FileSystemAccess::Range, API::CallNode {
    OpenCodeCall() { this = API::moduleImport("io").getMember("open_code").getACall() }

    override DataFlow::Node getAPathArgument() { result = this.getParameter(0, "path").asSink() }
  }

  /** Gets a reference to an open file. */
  private DataFlow::TypeTrackingNode openFile(DataFlow::TypeTracker t, FileSystemAccess openCall) {
    t.start() and
    result = openCall and
    (
      openCall instanceof OpenCall and
      // don't include the open call inside of Path.open in pathlib.py since
      // the call to `path_obj.open` is covered by `PathLibOpenCall`.
      not exists(Module mod, Class cls, Function func |
        openCall.(OpenCall).asCfgNode().getScope() = func and
        func.getName() = "open" and
        func.getScope() = cls and
        cls.getName() = "Path" and
        cls.getScope() = mod and
        mod.getName() = "pathlib" and
        // do allow this call if we're analyzing pathlib.py as part of CPython though
        not exists(mod.getFile().getRelativePath())
      )
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
          "encodestring", "a85encode", "b85encode", "encodebytes", "b32hexencode"
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
      name in ["b32encode", "b32hexencode"] and result = "Base32"
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
          "decodestring", "a85decode", "b85decode", "decodebytes", "b32hexdecode"
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
      name in ["b32decode", "b32hexdecode"] and result = "Base32"
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
  module Cgi {
    /**
     * Provides models for the `cgi.FieldStorage` class
     *
     * See https://docs.python.org/3/library/cgi.html.
     */
    module FieldStorage {
      /** Gets a reference to the `cgi.FieldStorage` class or any subclass. */
      API::Node subclassRef() {
        result = API::moduleImport("cgi").getMember("FieldStorage").getASubclass*()
        or
        result = ModelOutput::getATypeNode("cgi.FieldStorage~Subclass").getASubclass*()
      }

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
        DataFlow::CallCfgNode
      {
        ClassInstantiation() { this = subclassRef().getACall() }

        override string getSourceType() { result = "cgi.FieldStorage" }
      }

      /** Gets a reference to an instance of `cgi.FieldStorage`. */
      API::Node instance() { result = subclassRef().getReturn() }

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
      API::Node fieldList() {
        result = getlistResult()
        or
        result = getvalueResult()
        or
        result = instance().getASubscript()
      }

      /** Gets a reference to a field. */
      API::Node field() {
        result = getfirstResult()
        or
        result = getvalueResult()
        or
        result = [instance(), fieldList()].getASubscript()
      }

      private class AdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
        override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
          // Methods
          nodeFrom = nodeTo.(DataFlow::AttrRead).getObject() and
          nodeFrom = instance().getAValueReachableFromSource() and
          nodeTo = [getvalueRef(), getfirstRef(), getlistRef()].getAValueReachableFromSource()
          or
          nodeFrom.asCfgNode() = nodeTo.asCfgNode().(CallNode).getFunction() and
          (
            nodeFrom = getvalueRef().getAValueReachableFromSource() and
            nodeTo = getvalueResult().asSource()
            or
            nodeFrom = getfirstRef().getAValueReachableFromSource() and
            nodeTo = getfirstResult().asSource()
            or
            nodeFrom = getlistRef().getAValueReachableFromSource() and
            nodeTo = getlistResult().asSource()
          )
          or
          // Indexing
          nodeFrom in [
              instance().getAValueReachableFromSource(), fieldList().getAValueReachableFromSource()
            ] and
          nodeTo.asCfgNode().(SubscriptNode).getObject() = nodeFrom.asCfgNode()
          or
          // Attributes on Field
          nodeFrom = field().getAValueReachableFromSource() and
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
  // ---------------------------------------------------------------------------
  // SimpleHTTPServer (Python 2 only)
  // ---------------------------------------------------------------------------
  // ---------------------------------------------------------------------------
  // CGIHTTPServer (Python 2 only)
  // ---------------------------------------------------------------------------
  // ---------------------------------------------------------------------------
  // http (Python 3 only)
  // ---------------------------------------------------------------------------
  /**
   * Provides models for the `BaseHTTPRequestHandler` class and subclasses.
   *
   * See
   *  - https://docs.python.org/3.9/library/http.server.html#http.server.BaseHTTPRequestHandler
   *  - https://docs.python.org/2.7/library/basehttpserver.html#BaseHTTPServer.BaseHTTPRequestHandler
   */
  module BaseHttpRequestHandler {
    /** Gets a reference to the `BaseHttpRequestHandler` class or any subclass. */
    API::Node subclassRef() {
      result =
        [
          // Python 2
          API::moduleImport("BaseHTTPServer").getMember("BaseHTTPRequestHandler"),
          API::moduleImport("SimpleHTTPServer").getMember("SimpleHTTPRequestHandler"),
          API::moduleImport("CGIHTTPServer").getMember("CGIHTTPRequestHandler"),
          // Python 3
          API::moduleImport("http").getMember("server").getMember("BaseHTTPRequestHandler"),
          API::moduleImport("http").getMember("server").getMember("SimpleHTTPRequestHandler"),
          API::moduleImport("http").getMember("server").getMember("CGIHTTPRequestHandler"),
        ].getASubclass*()
      or
      result =
        ModelOutput::getATypeNode("http.server.BaseHTTPRequestHandler~Subclass").getASubclass*()
    }

    /** A HttpRequestHandler class definition (most likely in project code). */
    class HttpRequestHandlerClassDef extends Class {
      HttpRequestHandlerClassDef() { this.getParent() = subclassRef().asSource().asExpr() }
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

    /** The `self` parameter in a method on the `BaseHttpRequestHandler` class or any subclass. */
    private class SelfParam extends InstanceSource, RemoteFlowSource::Range, DataFlow::ParameterNode
    {
      SelfParam() {
        exists(HttpRequestHandlerClassDef cls | cls.getAMethod().getArg(0) = this.getParameter())
      }

      override string getSourceType() { result = "stdlib HTTPRequestHandler" }
    }

    /** Gets a reference to an instance of the `BaseHttpRequestHandler` class or any subclass. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of the `BaseHttpRequestHandler` class or any subclass. */
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

    /** An `HttpMessage` instance that originates from a `BaseHttpRequestHandler` instance. */
    private class BaseHttpRequestHandlerHeadersInstances extends Stdlib::HttpMessage::InstanceSource
    {
      BaseHttpRequestHandlerHeadersInstances() {
        this.(DataFlow::AttrRead).accesses(instance(), "headers")
      }
    }

    /** A file-like object that originates from a `BaseHttpRequestHandler` instance. */
    private class BaseHttpRequestHandlerFileLikeObjectInstances extends Stdlib::FileLikeObject::InstanceSource
    {
      BaseHttpRequestHandlerFileLikeObjectInstances() {
        this.(DataFlow::AttrRead).accesses(instance(), "rfile")
      }
    }

    /**
     * The entry-point for handling a request with a `BaseHTTPRequestHandler` subclass.
     *
     * Not essential for any functionality, but provides a consistent modeling.
     */
    private class RequestHandlerFunc extends Http::Server::RequestHandler::Range {
      RequestHandlerFunc() {
        this = any(HttpRequestHandlerClassDef cls).getAMethod() and
        this.getName() = "do_" + Http::httpVerb()
      }

      override Parameter getARoutedParameter() { none() }

      override string getFramework() { result = "Stdlib" }
    }
  }

  // ---------------------------------------------------------------------------
  // wsgiref.simple_server
  // ---------------------------------------------------------------------------
  /** Provides models for the `wsgiref.simple_server` module. */
  module WsgirefSimpleServer {
    API::Node subclassRef() {
      result =
        API::moduleImport("wsgiref")
            .getMember("simple_server")
            .getMember("WSGIServer")
            .getASubclass*()
      or
      result =
        ModelOutput::getATypeNode("wsgiref.simple_server.WSGIServer~Subclass").getASubclass*()
    }

    class WsgiServerSubclass extends Class, SelfRefMixin {
      WsgiServerSubclass() { this.getParent() = subclassRef().asSource().asExpr() }
    }

    /**
     * A function that was passed to the `set_app` method of a
     * `wsgiref.simple_server.WSGIServer` instance.
     *
     * See https://docs.python.org/3.10/library/wsgiref.html#wsgiref.simple_server.WSGIServer.set_app
     *
     * See https://github.com/python/cpython/blob/b567b9d74bd9e476a3027335873bb0508d6e450f/Lib/wsgiref/handlers.py#L137
     * for how a request is processed and given to an application.
     */
    class WsgirefSimpleServerApplication extends Http::Server::RequestHandler::Range {
      boolean validator;

      WsgirefSimpleServerApplication() {
        exists(DataFlow::Node appArg, DataFlow::CallCfgNode setAppCall |
          (
            setAppCall =
              WsgirefSimpleServer::subclassRef().getReturn().getMember("set_app").getACall() and
            validator = false
            or
            setAppCall
                .(DataFlow::MethodCallNode)
                .calls(any(WsgiServerSubclass cls).getASelfRef(), "set_app") and
            validator = false
            or
            // assume an application that is passed to `wsgiref.validate.validator` is eventually passed to `set_app`
            setAppCall =
              API::moduleImport("wsgiref").getMember("validate").getMember("validator").getACall() and
            validator = true
          ) and
          appArg in [setAppCall.getArg(0), setAppCall.getArgByName("application")]
          or
          // `make_server` calls `set_app`
          setAppCall =
            API::moduleImport("wsgiref")
                .getMember("simple_server")
                .getMember("make_server")
                .getACall() and
          appArg in [setAppCall.getArg(2), setAppCall.getArgByName("app")] and
          validator = false
        |
          appArg = poorMansFunctionTracker(this)
        )
      }

      override Parameter getARoutedParameter() { none() }

      override string getFramework() { result = "Stdlib: wsgiref.simple_server application" }

      /** Holds if this simple server application was passed to `wsgiref.validate.validator`. */
      predicate isValidated() { validator = true }
    }

    /**
     * The parameter of a `WsgirefSimpleServerApplication` that takes the WSGI environment
     * when processing a request.
     *
     * See https://docs.python.org/3.10/library/wsgiref.html#wsgiref.simple_server.WSGIRequestHandler.get_environ
     */
    class WsgiEnvirontParameter extends RemoteFlowSource::Range, DataFlow::ParameterNode {
      WsgiEnvirontParameter() {
        exists(WsgirefSimpleServerApplication func |
          if func.isMethod()
          then this.getParameter() = func.getArg(1)
          else this.getParameter() = func.getArg(0)
        )
      }

      override string getSourceType() {
        result = "Stdlib: wsgiref.simple_server application: WSGI environment parameter"
      }
    }

    /**
     * Gets a reference to the parameter of a `WsgirefSimpleServerApplication` that
     * takes the `start_response` function.
     *
     * See https://github.com/python/cpython/blob/b567b9d74bd9e476a3027335873bb0508d6e450f/Lib/wsgiref/handlers.py#L225-L252
     */
    private DataFlow::TypeTrackingNode startResponse(DataFlow::TypeTracker t) {
      t.start() and
      exists(WsgirefSimpleServerApplication func |
        if func.isMethod()
        then result.(DataFlow::ParameterNode).getParameter() = func.getArg(2)
        else result.(DataFlow::ParameterNode).getParameter() = func.getArg(1)
      )
      or
      exists(DataFlow::TypeTracker t2 | result = startResponse(t2).track(t2, t))
    }

    /**
     * Gets a reference to the parameter of a `WsgirefSimpleServerApplication` that
     * takes the `start_response` function.
     *
     * See https://github.com/python/cpython/blob/b567b9d74bd9e476a3027335873bb0508d6e450f/Lib/wsgiref/handlers.py#L225-L252
     */
    DataFlow::Node startResponse() { startResponse(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Gets a reference to the `write` function (that will write data to the response),
     * which is the return value from calling the `start_response` function.
     *
     * See https://github.com/python/cpython/blob/b567b9d74bd9e476a3027335873bb0508d6e450f/Lib/wsgiref/handlers.py#L225-L252
     */
    private DataFlow::TypeTrackingNode writeFunction(DataFlow::TypeTracker t) {
      t.start() and
      result.(DataFlow::CallCfgNode).getFunction() = startResponse()
      or
      exists(DataFlow::TypeTracker t2 | result = writeFunction(t2).track(t2, t))
    }

    /**
     * Gets a reference to the `write` function (that will write data to the response),
     * which is the return value from calling the `start_response` function.
     *
     * See https://github.com/python/cpython/blob/b567b9d74bd9e476a3027335873bb0508d6e450f/Lib/wsgiref/handlers.py#L225-L252
     */
    DataFlow::Node writeFunction() { writeFunction(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * A call to the `write` function.
     *
     * See https://github.com/python/cpython/blob/b567b9d74bd9e476a3027335873bb0508d6e450f/Lib/wsgiref/handlers.py#L276
     */
    class WsgirefSimpleServerApplicationWriteCall extends Http::Server::HttpResponse::Range,
      DataFlow::CallCfgNode
    {
      WsgirefSimpleServerApplicationWriteCall() { this.getFunction() = writeFunction() }

      override DataFlow::Node getBody() { result in [this.getArg(0), this.getArgByName("data")] }

      override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

      override string getMimetypeDefault() { none() }
    }

    /**
     * A return from a `WsgirefSimpleServerApplication`, which is included in the response body.
     */
    class WsgirefSimpleServerApplicationReturn extends Http::Server::HttpResponse::Range,
      DataFlow::CfgNode
    {
      WsgirefSimpleServerApplicationReturn() {
        exists(WsgirefSimpleServerApplication requestHandler |
          node = requestHandler.getAReturnValueFlowNode()
        )
      }

      override DataFlow::Node getBody() { result = this }

      override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

      override string getMimetypeDefault() { none() }
    }

    /**
     * Provides models for the `wsgiref.headers.Headers` class
     *
     * See https://docs.python.org/3/library/wsgiref.html#module-wsgiref.headers.
     */
    module Headers {
      /** Gets a reference to the `wsgiref.headers.Headers` class. */
      API::Node classRef() {
        result = API::moduleImport("wsgiref").getMember("headers").getMember("Headers")
        or
        result = ModelOutput::getATypeNode("wsgiref.headers.Headers~Subclass").getASubclass*()
      }

      /** Gets a reference to an instance of `wsgiref.headers.Headers`. */
      private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
        t.start() and
        result = classRef().getACall()
        or
        exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
      }

      /** Gets a reference to an instance of `wsgiref.headers.Headers`. */
      DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

      /** Holds if there exists an application that is validated by `wsgiref.validate.validator`. */
      private predicate existsValidatedApplication() {
        exists(WsgirefSimpleServerApplication app | app.isValidated())
      }

      /** A class instantiation of `wsgiref.headers.Headers`, conidered as a write to a response header. */
      private class WsgirefHeadersInstantiation extends Http::Server::ResponseHeaderBulkWrite::Range,
        DataFlow::CallCfgNode
      {
        WsgirefHeadersInstantiation() { this = classRef().getACall() }

        override DataFlow::Node getBulkArg() {
          result = [this.getArg(0), this.getArgByName("headers")]
        }

        // TODO: These checks perhaps could be made more precise.
        override predicate nameAllowsNewline() { not existsValidatedApplication() }

        override predicate valueAllowsNewline() { not existsValidatedApplication() }
      }

      /** A call to a method that writes to a response header. */
      private class HeaderWriteCall extends Http::Server::ResponseHeaderWrite::Range,
        DataFlow::MethodCallNode
      {
        HeaderWriteCall() {
          this.calls(instance(), ["add_header", "set", "setdefault", "__setitem__"])
        }

        override DataFlow::Node getNameArg() { result = this.getArg(0) }

        override DataFlow::Node getValueArg() { result = this.getArg(1) }

        // TODO: These checks perhaps could be made more precise.
        override predicate nameAllowsNewline() { not existsValidatedApplication() }

        override predicate valueAllowsNewline() { not existsValidatedApplication() }
      }

      /** A dict-like write to a response header. */
      private class HeaderWriteSubscript extends Http::Server::ResponseHeaderWrite::Range,
        DataFlow::Node
      {
        DataFlow::Node name;
        DataFlow::Node value;

        HeaderWriteSubscript() {
          exists(SubscriptNode subscript |
            this.asCfgNode() = subscript and
            value.asCfgNode() = subscript.(DefinitionNode).getValue() and
            name.asCfgNode() = subscript.getIndex() and
            subscript.getObject() = instance().asCfgNode()
          )
        }

        override DataFlow::Node getNameArg() { result = name }

        override DataFlow::Node getValueArg() { result = value }

        // TODO: These checks perhaps could be made more precise.
        override predicate nameAllowsNewline() { not existsValidatedApplication() }

        override predicate valueAllowsNewline() { not existsValidatedApplication() }
      }

      /**
       * A call to a `start_response` function that sets the response headers.
       */
      private class WsgirefSimpleServerSetHeaders extends Http::Server::ResponseHeaderBulkWrite::Range,
        DataFlow::CallCfgNode
      {
        WsgirefSimpleServerSetHeaders() { this.getFunction() = startResponse() }

        override DataFlow::Node getBulkArg() {
          result = [this.getArg(1), this.getArgByName("headers")]
        }

        // TODO: These checks perhaps could be made more precise.
        override predicate nameAllowsNewline() { not existsValidatedApplication() }

        override predicate valueAllowsNewline() { not existsValidatedApplication() }
      }
    }
  }

  // ---------------------------------------------------------------------------
  // http.client (Python 3)
  // httplib (Python 2)
  // ---------------------------------------------------------------------------
  /**
   * Provides models for the `http.client.HTTPConnection` and `HTTPSConnection` classes
   *
   * See
   * - https://docs.python.org/3.10/library/http.client.html#http.client.HTTPConnection
   * - https://docs.python.org/3.10/library/http.client.html#http.client.HTTPSConnection
   * - https://docs.python.org/2.7/library/httplib.html#httplib.HTTPConnection
   * - https://docs.python.org/2.7/library/httplib.html#httplib.HTTPSConnection
   */
  module HttpConnection {
    /** Gets a reference to the `http.client.HttpConnection` class. */
    API::Node classRef() {
      exists(string className | className in ["HTTPConnection", "HTTPSConnection"] |
        // Python 3
        result = API::moduleImport("http").getMember("client").getMember(className)
        or
        // Python 2
        result = API::moduleImport("httplib").getMember(className)
        or
        result =
          API::moduleImport("six").getMember("moves").getMember("http_client").getMember(className)
      )
      or
      result = ModelOutput::getATypeNode("http.client.HTTPConnection~Subclass").getASubclass*()
    }

    /**
     * A source of instances of `http.client.HTTPConnection`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `HTTPConnection::instance()` to get references to instances of `http.client.HTTPConnection`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode {
      /** Gets the argument that specified the host, if any. */
      abstract DataFlow::Node getHostArgument();
    }

    /** A direct instantiation of `http.client.HttpConnection`. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      ClassInstantiation() { this = classRef().getACall() }

      override DataFlow::Node getHostArgument() {
        result in [this.getArg(0), this.getArgByName("host")]
      }
    }

    /**
     * Gets a reference to an instance of `http.client.HTTPConnection`,
     * that was instantiated with host argument `hostArg`.
     */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t, DataFlow::Node hostArg) {
      t.start() and
      hostArg = result.(InstanceSource).getHostArgument()
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2, hostArg).track(t2, t))
    }

    /**
     * Gets a reference to an instance of `http.client.HTTPConnection`,
     * that was instantiated with host argument `hostArg`.
     */
    DataFlow::Node instance(DataFlow::Node hostArg) {
      instance(DataFlow::TypeTracker::end(), hostArg).flowsTo(result)
    }

    /** A method call on a HttpConnection that sends off a request */
    private class RequestCall extends Http::Client::Request::Range, DataFlow::MethodCallNode {
      RequestCall() { this.calls(instance(_), ["request", "_send_request", "putrequest"]) }

      DataFlow::Node getUrlArg() { result in [this.getArg(1), this.getArgByName("url")] }

      override DataFlow::Node getAUrlPart() {
        result = this.getUrlArg()
        or
        this.getObject() = instance(result)
      }

      override string getFramework() { result = "http.client.HTTP[S]Connection" }

      override predicate disablesCertificateValidation(
        DataFlow::Node disablingNode, DataFlow::Node argumentOrigin
      ) {
        // TODO: Proper alerting of insecure verification settings on SSLContext.
        // Because that is not restricted to HTTP[S]Connection usage, we need something
        // more general, and I would like to tackle that in future PR.
        none()
      }
    }

    /** A call to the `getresponse` method. */
    private class HttpConnectionGetResponseCall extends DataFlow::MethodCallNode,
      HttpResponse::InstanceSource
    {
      HttpConnectionGetResponseCall() { this.calls(instance(_), "getresponse") }
    }

    /**
     * Extra taint propagation for `http.client.HTTPConnection`,
     * to ensure that responses to user-controlled URL are tainted.
     */
    private class AdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        // constructor
        exists(InstanceSource instanceSource |
          nodeFrom = instanceSource.getHostArgument() and
          nodeTo = instanceSource
        )
        or
        // a request method
        exists(RequestCall call |
          nodeFrom = call.getUrlArg() and
          nodeTo.(DataFlow::PostUpdateNode).getPreUpdateNode() = call.getObject()
        )
        or
        // `getresponse` call
        exists(HttpConnectionGetResponseCall call |
          nodeFrom = call.getObject() and
          nodeTo = call
        )
      }
    }
  }

  /**
   * Provides models for the `http.client.HTTPResponse` class
   *
   * See
   * - https://docs.python.org/3.10/library/http.client.html#httpresponse-objects
   * - https://docs.python.org/3/library/http.client.html#http.client.HTTPResponse.
   */
  module HttpResponse {
    /** Gets a reference to the `http.client.HttpResponse` class. */
    API::Node classRef() {
      result = API::moduleImport("http").getMember("client").getMember("HTTPResponse")
      or
      result = ModelOutput::getATypeNode("http.client.HTTPResponse~Subclass").getASubclass*()
    }

    /**
     * A source of instances of `http.client.HTTPResponse`, extend this class to model new instances.
     *
     * A `http.client.HTTPResponse` is itself a file-like object.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `HTTPResponse::instance()` to get references to instances of `http.client.HTTPResponse`.
     */
    abstract class InstanceSource extends Stdlib::FileLikeObject::InstanceSource,
      DataFlow::LocalSourceNode
    { }

    /** A direct instantiation of `http.client.HttpResponse`. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      ClassInstantiation() { this = classRef().getACall() }
    }

    /** Gets a reference to an instance of `http.client.HttpResponse`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `http.client.HttpResponse`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `http.client.HTTPResponse`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "http.client.HTTPResponse" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() { result in ["headers", "msg", "reason", "url"] }

      override string getMethodName() { result in ["getheader", "getheaders", "info", "geturl",] }

      override string getAsyncMethodName() { none() }
    }

    /** An attribute read that is a HttpMessage instance. */
    private class HttpMessageInstances extends Stdlib::HttpMessage::InstanceSource {
      HttpMessageInstances() {
        this.(DataFlow::AttrRead).accesses(instance(), ["headers", "msg"])
        or
        this.(DataFlow::MethodCallNode).calls(instance(), "info")
      }
    }
  }

  // ---------------------------------------------------------------------------
  // sqlite3
  // ---------------------------------------------------------------------------
  /**
   * A model of sqlite3 as a module that implements PEP 249, providing ways to execute SQL statements
   * against a database.
   *
   * See https://devdocs.io/python~3.9/library/sqlite3
   * https://github.com/python/cpython/blob/3.11/Lib/sqlite3/dbapi2.py
   */
  class Sqlite3 extends PEP249::PEP249ModuleApiNode {
    Sqlite3() {
      this = API::moduleImport("sqlite3")
      or
      this = API::moduleImport("sqlite3").getMember("dbapi2")
    }
  }

  // ---------------------------------------------------------------------------
  // pathlib
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `pathlib` module. */
  private API::Node pathlib() { result = API::moduleImport("pathlib") }

  /**
   * Gets a name of a constructor for a `pathlib.Path` object.
   * We include the pure paths, as they can be "exported" (say with `as_posix`) and then used to access the underlying file system.
   */
  private string pathlibPathConstructor() {
    result in ["Path", "PurePath", "PurePosixPath", "PureWindowsPath", "PosixPath", "WindowsPath"]
  }

  /**
   * Gets a name of an attribute of a `pathlib.Path` object that is also a `pathlib.Path` object.
   */
  private string pathlibPathAttribute() { result = "parent" }

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
    string attributeName;

    PathlibFileAccess() {
      attributeName = fileAccess.getAttributeName() and
      attributeName in [
          "stat", "chmod", "exists", "expanduser", "glob", "group", "is_dir", "is_file", "is_mount",
          "is_symlink", "is_socket", "is_fifo", "is_block_device", "is_char_device", "iter_dir",
          "lchmod", "lstat", "mkdir", "open", "owner", "read_bytes", "read_text", "readlink",
          "rename", "replace", "resolve", "rglob", "rmdir", "samefile", "symlink_to", "touch",
          "unlink", "link_to", "write_bytes", "write_text", "hardlink_to"
        ] and
      pathlibPath().flowsTo(fileAccess.getObject()) and
      fileAccess.(DataFlow::LocalSourceNode).flowsTo(this.getFunction())
    }

    override DataFlow::Node getAPathArgument() { result = fileAccess.getObject() }
  }

  /** A file system write from a `pathlib.Path` method call. */
  private class PathlibFileWrites extends PathlibFileAccess, FileSystemWriteAccess::Range {
    PathlibFileWrites() { attributeName in ["write_bytes", "write_text"] }

    override DataFlow::Node getADataNode() { result in [this.getArg(0), this.getArgByName("data")] }
  }

  /** A call to the `open` method on a `pathlib.Path` instance. */
  private class PathLibOpenCall extends PathlibFileAccess, Stdlib::FileLikeObject::InstanceSource {
    PathLibOpenCall() { attributeName = "open" }
  }

  /**
   * A call to the `link_to`, `hardlink_to`, or `symlink_to` method on a `pathlib.Path` instance.
   *
   * See
   * - https://docs.python.org/3/library/pathlib.html#pathlib.Path.link_to
   * - https://docs.python.org/3/library/pathlib.html#pathlib.Path.hardlink_to
   * - https://docs.python.org/3/library/pathlib.html#pathlib.Path.symlink_to
   */
  private class PathLibLinkToCall extends PathlibFileAccess, API::CallNode {
    PathLibLinkToCall() { attributeName in ["link_to", "hardlink_to", "symlink_to"] }

    override DataFlow::Node getAPathArgument() {
      result = super.getAPathArgument()
      or
      result = this.getParameter(0, "target").asSink()
    }
  }

  /**
   * A call to the `replace` or `rename` method on a `pathlib.Path` instance.
   *
   * See
   * - https://docs.python.org/3/library/pathlib.html#pathlib.Path.replace
   * - https://docs.python.org/3/library/pathlib.html#pathlib.Path.rename
   */
  private class PathLibReplaceCall extends PathlibFileAccess, API::CallNode {
    PathLibReplaceCall() { attributeName in ["replace", "rename"] }

    override DataFlow::Node getAPathArgument() {
      result = super.getAPathArgument()
      or
      result = this.getParameter(0, "target").asSink()
    }
  }

  /**
   * A call to the `samefile` method on a `pathlib.Path` instance.
   *
   * See https://docs.python.org/3/library/pathlib.html#pathlib.Path.samefile
   */
  private class PathLibSameFileCall extends PathlibFileAccess, API::CallNode {
    PathLibSameFileCall() { attributeName = "samefile" }

    override DataFlow::Node getAPathArgument() {
      result = super.getAPathArgument()
      or
      result = this.getParameter(0, "other_path").asSink()
    }
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
  private API::CallNode hashlibNewCall(string algorithmName) {
    algorithmName =
      result.getParameter(0, "name").getAValueReachingSink().asExpr().(StringLiteral).getText() and
    result = API::moduleImport("hashlib").getMember("new").getACall()
  }

  /**
   * A hashing operation by supplying initial data when calling the `hashlib.new` function.
   */
  class HashlibNewCall extends Cryptography::CryptographicOperation::Range, API::CallNode {
    string hashName;

    HashlibNewCall() {
      this = hashlibNewCall(hashName) and
      // we only want to consider it as an cryptographic operation if the input is available
      exists(this.getParameter(1, "data"))
    }

    override DataFlow::Node getInitialization() { result = this }

    override Cryptography::CryptographicAlgorithm getAlgorithm() { result.matchesName(hashName) }

    override DataFlow::Node getAnInput() { result = this.getParameter(1, "data").asSink() }

    override Cryptography::BlockMode getBlockMode() { none() }
  }

  /**
   * A hashing operation by using the `update` method on the result of calling the `hashlib.new` function.
   */
  class HashlibNewUpdateCall extends Cryptography::CryptographicOperation::Range, API::CallNode {
    API::CallNode init;
    string hashName;

    HashlibNewUpdateCall() {
      init = hashlibNewCall(hashName) and
      this = init.getReturn().getMember("update").getACall()
    }

    override DataFlow::Node getInitialization() { result = init }

    override Cryptography::CryptographicAlgorithm getAlgorithm() { result.matchesName(hashName) }

    override DataFlow::Node getAnInput() { result = this.getArg(0) }

    override Cryptography::BlockMode getBlockMode() { none() }
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
    DataFlow::CallCfgNode
  {
    string hashName;
    API::Node hashClass;

    bindingset[this]
    HashlibGenericHashOperation() { hashClass = hashlibMember(hashName) }

    override Cryptography::CryptographicAlgorithm getAlgorithm() { result.matchesName(hashName) }

    override Cryptography::BlockMode getBlockMode() { none() }
  }

  /**
   * A hashing operation from the `hashlib` package using one of the predefined classes
   * (such as `hashlib.md5`), by calling its' `update` method.
   */
  class HashlibHashClassUpdateCall extends HashlibGenericHashOperation {
    API::CallNode init;

    HashlibHashClassUpdateCall() {
      init = hashClass.getACall() and
      this = hashClass.getReturn().getMember("update").getACall()
    }

    override DataFlow::Node getInitialization() { result = init }

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

    override DataFlow::Node getInitialization() { result = this }

    override DataFlow::Node getAnInput() {
      result = this.getArg(0)
      or
      // in Python 3.9, you are allowed to use `hashlib.md5(string=<bytes-like>)`.
      result = this.getArgByName("string")
    }
  }

  // ---------------------------------------------------------------------------
  // hmac
  // ---------------------------------------------------------------------------
  abstract class HmacCryptographicOperation extends Cryptography::CryptographicOperation::Range,
    API::CallNode
  {
    abstract API::Node getDigestArg();

    override Cryptography::CryptographicAlgorithm getAlgorithm() {
      exists(string algorithmName | result.matchesName(algorithmName) |
        this.getDigestArg().asSink() = hashlibMember(algorithmName).asSource()
        or
        this.getDigestArg().getAValueReachingSink().asExpr().(StringLiteral).getText() =
          algorithmName
      )
    }

    override Cryptography::BlockMode getBlockMode() { none() }
  }

  API::CallNode getHmacConstructorCall(API::Node digestArg) {
    result = API::moduleImport("hmac").getMember(["new", "HMAC"]).getACall() and
    digestArg = result.getParameter(2, "digestmod")
  }

  /**
   * A call to `hmac.new`/`hmac.HMAC`.
   *
   * See https://docs.python.org/3.11/library/hmac.html#hmac.new
   */
  class HmacNewCall extends HmacCryptographicOperation {
    API::Node digestArg;

    HmacNewCall() {
      this = getHmacConstructorCall(digestArg) and
      // we only want to consider it as an cryptographic operation if the input is available
      exists(this.getParameter(1, "msg").asSink())
    }

    override DataFlow::Node getInitialization() { result = this }

    override API::Node getDigestArg() { result = digestArg }

    override DataFlow::Node getAnInput() { result = this.getParameter(1, "msg").asSink() }
  }

  /**
   * A call to `.update` on an HMAC object.
   *
   * See https://docs.python.org/3.11/library/hmac.html#hmac.HMAC.update
   */
  class HmacUpdateCall extends HmacCryptographicOperation {
    API::CallNode init;
    API::Node digestArg;

    HmacUpdateCall() {
      init = getHmacConstructorCall(digestArg) and
      this = init.getReturn().getMember("update").getACall()
    }

    override DataFlow::Node getInitialization() { result = init }

    override API::Node getDigestArg() { result = digestArg }

    override DataFlow::Node getAnInput() { result = this.getParameter(0, "msg").asSink() }
  }

  /**
   * A call to `hmac.digest`.
   *
   * See https://docs.python.org/3.11/library/hmac.html#hmac.digest
   */
  class HmacDigestCall extends HmacCryptographicOperation {
    HmacDigestCall() { this = API::moduleImport("hmac").getMember("digest").getACall() }

    override DataFlow::Node getInitialization() { result = this }

    override API::Node getDigestArg() { result = this.getParameter(2, "digest") }

    override DataFlow::Node getAnInput() { result = this.getParameter(1, "msg").asSink() }
  }

  // ---------------------------------------------------------------------------
  // logging
  // ---------------------------------------------------------------------------
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
        this.(DataFlow::MethodCallNode).calls(Stdlib::Logger::instance(), method)
        or
        this = API::moduleImport("logging").getMember(method).getACall()
      )
    }

    override DataFlow::Node getAnInput() {
      result = this.getArgByName(["msg", "extra"])
      or
      result = this.getArg(any(int i | i >= msgIndex))
    }
  }

  // ---------------------------------------------------------------------------
  // re
  // ---------------------------------------------------------------------------
  /**
   * List of methods in the `re` module immediately executing a regular expression.
   *
   * See https://docs.python.org/3/library/re.html#module-contents
   */
  private class RegexExecutionMethod extends string {
    RegexExecutionMethod() {
      this in ["match", "fullmatch", "search", "split", "findall", "finditer", "sub", "subn"]
    }

    /** Gets the index of the argument representing the string to be searched by a regex. */
    int getStringArgIndex() {
      this in ["match", "fullmatch", "search", "split", "findall", "finditer"] and
      result = 1
      or
      this in ["sub", "subn"] and
      result = 2
    }
  }

  /**
   * A a call to a method from the `re` module immediately executing a regular expression.
   *
   * See `RegexExecutionMethods`
   */
  private class DirectRegexExecution extends DataFlow::CallCfgNode, RegexExecution::Range {
    RegexExecutionMethod method;

    DirectRegexExecution() { this = API::moduleImport("re").getMember(method).getACall() }

    override DataFlow::Node getRegex() { result in [this.getArg(0), this.getArgByName("pattern")] }

    override DataFlow::Node getString() {
      result in [this.getArg(method.getStringArgIndex()), this.getArgByName("string")]
    }

    override string getName() { result = "re." + method }
  }

  API::Node compiledRegex(API::Node regex) {
    exists(API::CallNode compilation |
      compilation = API::moduleImport("re").getMember("compile").getACall()
    |
      result = compilation.getReturn() and
      regex = compilation.getParameter(0, "pattern")
    )
  }

  /**
   * A call on compiled regular expression (obtained via `re.compile`) executing a
   * regular expression.
   *
   * Given the following example:
   *
   * ```py
   * pattern = re.compile(input)
   * pattern.match(s)
   * ```
   *
   * This class will identify that `re.compile` compiles `input` and afterwards
   * executes `re`'s `match`. As a result, `this` will refer to `pattern.match(s)`
   * and `this.getRegexNode()` will return the node for `input` (`re.compile`'s first argument).
   *
   *
   * See `RegexExecutionMethods`
   *
   * See https://docs.python.org/3/library/re.html#regular-expression-objects
   */
  private class CompiledRegexExecution extends DataFlow::MethodCallNode, RegexExecution::Range {
    DataFlow::Node regexNode;
    RegexExecutionMethod method;

    CompiledRegexExecution() {
      exists(API::Node regex | regexNode = regex.asSink() |
        this.calls(compiledRegex(regex).getAValueReachableFromSource(), method)
      )
    }

    override DataFlow::Node getRegex() { result = regexNode }

    override DataFlow::Node getString() {
      result in [this.getArg(method.getStringArgIndex() - 1), this.getArgByName("string")]
    }

    override string getName() { result = "re." + method }
  }

  /**
   * A flow summary for compiled regex objects
   *
   * See https://docs.python.org/3.11/library/re.html#re-objects
   */
  class RePatternSummary extends SummarizedCallable {
    RePatternSummary() { this = "re.Pattern" }

    override DataFlow::CallCfgNode getACall() {
      result = API::moduleImport("re").getMember("compile").getACall()
    }

    override DataFlow::ArgumentNode getACallback() {
      result = API::moduleImport("re").getMember("compile").getAValueReachableFromSource()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input in ["Argument[0]", "Argument[pattern:]"] and
      (
        output = "ReturnValue.Attribute[pattern]" and
        preservesValue = true
        or
        output = "ReturnValue" and
        preservesValue = false
      )
    }
  }

  /**
   * A base API node for regular expression functions.
   * Either the `re` module or a compiled regular expression.
   */
  private API::Node re(boolean compiled) {
    result = API::moduleImport("re") and
    compiled = false
    or
    result = any(RePatternSummary c).getACall().(API::CallNode).getReturn() and
    compiled = true
  }

  /**
   * A flow summary for methods returning a `re.Match` object
   *
   * See https://docs.python.org/3/library/re.html#re.Match
   */
  class ReMatchSummary extends SummarizedCallable {
    ReMatchSummary() { this = ["re.Match", "compiled re.Match"] }

    override DataFlow::CallCfgNode getACall() {
      exists(API::Node re, boolean compiled |
        re = re(compiled) and
        (
          compiled = false and
          this = "re.Match"
          or
          compiled = true and
          this = "compiled re.Match"
        )
      |
        result = re.getMember(["match", "search", "fullmatch"]).getACall()
      )
    }

    override DataFlow::ArgumentNode getACallback() { none() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      exists(string arg |
        this = "re.Match" and arg = "Argument[1]"
        or
        this = "compiled re.Match" and arg = "Argument[0]"
      |
        input in [arg, "Argument[string:]"] and
        (
          output = "ReturnValue.Attribute[string]" and
          preservesValue = true
          or
          // indexing such as `match[g]` is the same as `match.group(g)`
          // since you can index with both integers and strings, we model it as
          // both list element and dictionary... a bit of a hack, but no way to model
          // subscript operators directly with flow-summaries :|
          output in ["ReturnValue.ListElement", "ReturnValue.DictionaryElementAny"] and
          preservesValue = false
        )
      )
      or
      // regex pattern
      (
        this = "re.Match" and input in ["Argument[0]", "Argument[pattern:]"]
        or
        // for compiled regexes, this it is already stored in the `pattern` attribute
        this = "compiled re.Match" and input = "Argument[self].Attribute[pattern]"
      ) and
      output = "ReturnValue.Attribute[re].Attribute[pattern]" and
      preservesValue = true
    }
  }

  /** An API node for a `re.Match` object */
  private API::Node match() {
    result = any(ReMatchSummary c).getACall().(API::CallNode).getReturn()
    or
    result = re(_).getMember("finditer").getReturn().getASubscript()
  }

  /**
   * A flow summary for methods on a `re.Match` object
   *
   * See https://docs.python.org/3/library/re.html#re.Match
   */
  class ReMatchMethodsSummary extends SummarizedCallable {
    string methodName;

    ReMatchMethodsSummary() {
      this = "re.Match." + methodName and
      methodName in ["expand", "group", "groups", "groupdict"]
    }

    override DataFlow::CallCfgNode getACall() { result = match().getMember(methodName).getACall() }

    override DataFlow::ArgumentNode getACallback() { none() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      methodName = "expand" and
      preservesValue = false and
      (
        input = "Argument[0]" and output = "ReturnValue"
        or
        input = "Argument[self].Attribute[string]" and
        output = "ReturnValue"
      )
      or
      methodName = "group" and
      input = "Argument[self].Attribute[string]" and
      output in ["ReturnValue", "ReturnValue.ListElement"] and
      preservesValue = false
      or
      methodName = "groups" and
      input = "Argument[self].Attribute[string]" and
      output = "ReturnValue.ListElement" and
      preservesValue = false
      or
      methodName = "groupdict" and
      input = "Argument[self].Attribute[string]" and
      output = "ReturnValue.DictionaryElementAny" and
      preservesValue = false
    }
  }

  /**
   * A flow summary for `re` methods not returning a `re.Match` object
   *
   * See https://docs.python.org/3/library/re.html#functions
   */
  class ReFunctionsSummary extends SummarizedCallable {
    string methodName;

    ReFunctionsSummary() {
      methodName in ["split", "findall", "finditer", "sub", "subn"] and
      this = ["re.", "compiled re."] + methodName
    }

    override DataFlow::CallCfgNode getACall() {
      this = "re." + methodName and
      result = API::moduleImport("re").getMember(methodName).getACall()
      or
      this = "compiled re." + methodName and
      result =
        any(RePatternSummary c)
            .getACall()
            .(API::CallNode)
            .getReturn()
            .getMember(methodName)
            .getACall()
    }

    override DataFlow::ArgumentNode getACallback() { none() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      exists(int offset |
        // for non-compiled regex the first argument is the pattern, so we need to
        // account for this difference
        this = "re." + methodName and offset = 0
        or
        this = "compiled re." + methodName and offset = 1
      |
        // flow from input string to results
        exists(int arg | arg = methodName.(RegexExecutionMethod).getStringArgIndex() - offset |
          preservesValue = false and
          input in ["Argument[" + arg + "]", "Argument[string:]"] and
          (
            methodName in ["split", "findall", "finditer"] and
            output = "ReturnValue.ListElement"
            or
            // TODO: Since we currently model iterables as tainted when their elements
            // are, the result of findall, finditer, split needs to be tainted
            methodName in ["split", "findall", "finditer"] and
            output = "ReturnValue"
            or
            methodName = "sub" and
            output = "ReturnValue"
            or
            methodName = "subn" and
            output = "ReturnValue.TupleElement[0]"
          )
        )
        or
        // flow from replacement value for substitution
        exists(string argumentSpec |
          argumentSpec in ["Argument[" + (1 - offset) + "]", "Argument[repl:]"] and
          // `repl` can also be a function
          input = [argumentSpec, argumentSpec + ".ReturnValue"]
        |
          (
            methodName = "sub" and output = "ReturnValue"
            or
            methodName = "subn" and output = "ReturnValue.TupleElement[0]"
          ) and
          preservesValue = false
        )
        or
        // flow from input string to attribute on match object
        exists(int arg | arg = methodName.(RegexExecutionMethod).getStringArgIndex() - offset |
          input in ["Argument[" + arg + "]", "Argument[string:]"] and
          methodName = "finditer" and
          output = "ReturnValue.ListElement.Attribute[string]" and
          preservesValue = true
        )
      )
    }
  }

  /**
   * A call to 're.escape'.
   * See https://docs.python.org/3/library/re.html#re.escape
   */
  private class ReEscapeCall extends Escaping::Range, DataFlow::CallCfgNode {
    ReEscapeCall() { this = API::moduleImport("re").getMember("escape").getACall() }

    override DataFlow::Node getAnInput() {
      result in [this.getArg(0), this.getArgByName("pattern")]
    }

    override DataFlow::Node getOutput() { result = this }

    override string getKind() { result = Escaping::getRegexKind() }
  }

  /**
   * A node interpreted as a regular expression.
   * Speficically nodes where string values are interpreted as regular expressions.
   */
  private class StdLibRegExpInterpretation extends RegExpInterpretation::Range {
    StdLibRegExpInterpretation() {
      this =
        API::moduleImport("re").getMember("compile").getACall().getParameter(0, "pattern").asSink()
    }
  }

  // ---------------------------------------------------------------------------
  // urllib
  // ---------------------------------------------------------------------------
  /**
   * A call to `urllib.parse.urlsplit`
   *
   * See https://docs.python.org/3.9/library/urllib.parse.html#urllib.parse.urlsplit
   */
  class UrllibParseUrlsplitCall extends Stdlib::SplitResult::InstanceSource, DataFlow::CallCfgNode {
    UrllibParseUrlsplitCall() {
      this = API::moduleImport("urllib").getMember("parse").getMember("urlsplit").getACall()
    }

    /** Gets the argument that specifies the URL. */
    DataFlow::Node getUrl() { result in [this.getArg(0), this.getArgByName("url")] }
  }

  /** Extra taint-step such that the result of `urllib.parse.urlsplit(tainted_string)` is tainted. */
  private class UrllibParseUrlsplitCallAdditionalTaintStep extends TaintTracking::AdditionalTaintStep
  {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      nodeTo.(UrllibParseUrlsplitCall).getUrl() = nodeFrom
    }
  }

  // ---------------------------------------------------------------------------
  // tempfile
  // ---------------------------------------------------------------------------
  /**
   * A call to `tempfile.mkstemp`.
   *
   * See https://docs.python.org/3/library/tempfile.html#tempfile.mkstemp
   */
  private class TempfileMkstempCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
    TempfileMkstempCall() { this = API::moduleImport("tempfile").getMember("mkstemp").getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [
          this.getArg(0), this.getArgByName("suffix"), this.getArg(1), this.getArgByName("prefix"),
          this.getArg(2), this.getArgByName("dir")
        ]
    }
  }

  /**
   * A call to `tempfile.NamedTemporaryFile`.
   *
   * See https://docs.python.org/3/library/tempfile.html#tempfile.NamedTemporaryFile
   */
  private class TempfileNamedTemporaryFileCall extends FileSystemAccess::Range,
    DataFlow::CallCfgNode
  {
    TempfileNamedTemporaryFileCall() {
      this = API::moduleImport("tempfile").getMember("NamedTemporaryFile").getACall()
    }

    override DataFlow::Node getAPathArgument() {
      result in [
          this.getArg(4), this.getArgByName("suffix"), this.getArg(5), this.getArgByName("prefix"),
          this.getArg(6), this.getArgByName("dir")
        ]
    }
  }

  /**
   * A call to `tempfile.TemporaryFile`.
   *
   * See https://docs.python.org/3/library/tempfile.html#tempfile.TemporaryFile
   */
  private class TempfileTemporaryFileCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
    TempfileTemporaryFileCall() {
      this = API::moduleImport("tempfile").getMember("TemporaryFile").getACall()
    }

    override DataFlow::Node getAPathArgument() {
      result in [
          this.getArg(4), this.getArgByName("suffix"), this.getArg(5), this.getArgByName("prefix"),
          this.getArg(6), this.getArgByName("dir")
        ]
    }
  }

  /**
   * A call to `tempfile.SpooledTemporaryFile`.
   *
   * See https://docs.python.org/3/library/tempfile.html#tempfile.SpooledTemporaryFile
   */
  private class TempfileSpooledTemporaryFileCall extends FileSystemAccess::Range,
    DataFlow::CallCfgNode
  {
    TempfileSpooledTemporaryFileCall() {
      this = API::moduleImport("tempfile").getMember("SpooledTemporaryFile").getACall()
    }

    override DataFlow::Node getAPathArgument() {
      result in [
          this.getArg(5), this.getArgByName("suffix"), this.getArg(6), this.getArgByName("prefix"),
          this.getArg(7), this.getArgByName("dir")
        ]
    }
  }

  /**
   * A call to `tempfile.mkdtemp`.
   *
   * See https://docs.python.org/3/library/tempfile.html#tempfile.mkdtemp
   */
  private class TempfileMkdtempCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
    TempfileMkdtempCall() { this = API::moduleImport("tempfile").getMember("mkdtemp").getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [
          this.getArg(0), this.getArgByName("suffix"), this.getArg(1), this.getArgByName("prefix"),
          this.getArg(2), this.getArgByName("dir")
        ]
    }
  }

  /**
   * A call to `tempfile.TemporaryDirectory`.
   *
   * See https://docs.python.org/3/library/tempfile.html#tempfile.TemporaryDirectory
   */
  private class TempfileTemporaryDirectoryCall extends FileSystemAccess::Range,
    DataFlow::CallCfgNode
  {
    TempfileTemporaryDirectoryCall() {
      this = API::moduleImport("tempfile").getMember("TemporaryDirectory").getACall()
    }

    override DataFlow::Node getAPathArgument() {
      result in [
          this.getArg(0), this.getArgByName("suffix"), this.getArg(1), this.getArgByName("prefix"),
          this.getArg(2), this.getArgByName("dir")
        ]
    }
  }

  // ---------------------------------------------------------------------------
  // shutil
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `shutil` module. */
  private API::Node shutil() { result = API::moduleImport("shutil") }

  /**
   * A call to the `shutil.rmtree` function.
   *
   * See https://docs.python.org/3/library/shutil.html#shutil.rmtree
   */
  private class ShutilRmtreeCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
    ShutilRmtreeCall() { this = shutil().getMember("rmtree").getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("path")]
    }
  }

  /**
   * The `shutil` module provides methods to copy, move files or copy file attributes.
   * See:
   * - https://docs.python.org/3/library/shutil.html#shutil.copyfile
   * - https://docs.python.org/3/library/shutil.html#shutil.copymode
   * - https://docs.python.org/3/library/shutil.html#shutil.copystat
   * - https://docs.python.org/3/library/shutil.html#shutil.copy
   * - https://docs.python.org/3/library/shutil.html#shutil.copy2
   * - https://docs.python.org/3/library/shutil.html#shutil.copytree
   * - https://docs.python.org/3/library/shutil.html#shutil.move
   */
  private class ShutilCopyCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
    ShutilCopyCall() {
      this =
        shutil()
            .getMember([
                // these are used to copy files
                "copyfile", "copy", "copy2", "copytree",
                // these are used to move files
                "move",
                // these are used to copy some attributes of the file
                "copymode", "copystat"
              ])
            .getACall()
    }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("src"), this.getArg(1), this.getArgByName("dst")]
    }
  }

  // TODO: once we have flow summaries, model `shutil.copyfileobj` which copies the content between its' file-like arguments.
  // See https://docs.python.org/3/library/shutil.html#shutil.copyfileobj
  private class ShutilCopyfileobjCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
    ShutilCopyfileobjCall() { this = shutil().getMember("copyfileobj").getACall() }

    override DataFlow::Node getAPathArgument() { none() }
  }

  /**
   * A call to the `shutil.disk_usage` function.
   *
   * See https://docs.python.org/3/library/shutil.html#shutil.disk_usage
   */
  private class ShutilDiskUsageCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
    ShutilDiskUsageCall() { this = shutil().getMember("disk_usage").getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("path")]
    }
  }

  /**
   * A call to the `shutil.chown` function.
   *
   * See https://docs.python.org/3/library/shutil.html#shutil.chown
   */
  private class ShutilChownCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
    ShutilChownCall() { this = shutil().getMember("chown").getACall() }

    override DataFlow::Node getAPathArgument() {
      result in [this.getArg(0), this.getArgByName("path")]
    }
  }

  // ---------------------------------------------------------------------------
  // io
  // ---------------------------------------------------------------------------
  /**
   * Provides models for the `io.StringIO`/`io.BytesIO` classes
   *
   * See https://docs.python.org/3.10/library/io.html#io.StringIO.
   */
  module StringIO {
    /** Gets a reference to the `io.StringIO` class. */
    API::Node classRef() {
      result = API::moduleImport("io").getMember(["StringIO", "BytesIO"])
      or
      result = ModelOutput::getATypeNode("io.StringIO~Subclass").getASubclass*()
    }

    /**
     * A source of instances of `io.StringIO`/`io.BytesIO`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `StringIO::instance()` to get references to instances of `io.StringIO`.
     */
    abstract class InstanceSource extends Stdlib::FileLikeObject::InstanceSource { }

    /** A direct instantiation of `io.StringIO`/`io.BytesIO`. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      ClassInstantiation() { this = classRef().getACall() }

      DataFlow::Node getInitialValue() {
        result = this.getArg(0)
        or
        // `initial_value` for StringIO, `initial_bytes` for BytesIO
        result = this.getArgByName(["initial_value", "initial_bytes"])
      }
    }

    /** Gets a reference to an instance of `io.StringIO`/`io.BytesIO`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `io.StringIO`/`io.BytesIO`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Extra taint propagation for `io.StringIO`/`io.BytesIO`.
     */
    private class AdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        nodeTo.(ClassInstantiation).getInitialValue() = nodeFrom
      }
    }
  }

  // ---------------------------------------------------------------------------
  // xml.etree.ElementTree
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `xml.etree.ElementTree` class */
  API::Node elementTreeClassRef() {
    result = API::moduleImport("xml").getMember("etree").getMember("ElementTree").getASubclass*() or
    result = ModelOutput::getATypeNode("xml.etree.ElementTree~Subclass").getASubclass*()
  }

  /**
   * An instance of `xml.etree.ElementTree.ElementTree`.
   *
   * See https://docs.python.org/3.10/library/xml.etree.elementtree.html#xml.etree.ElementTree.ElementTree
   */
  private API::Node elementTreeInstance() {
    //parse to a tree
    result = elementTreeClassRef().getMember("parse").getReturn()
    or
    // construct a tree without parsing
    result = elementTreeClassRef().getMember("ElementTree").getReturn()
  }

  /**
   * An instance of `xml.etree.ElementTree.Element`.
   *
   * See https://docs.python.org/3.10/library/xml.etree.elementtree.html#xml.etree.ElementTree.Element
   */
  private API::Node elementInstance() {
    // parse or go to the root of a tree
    result = elementTreeInstance().getMember(["parse", "getroot"]).getReturn()
    or
    // parse directly to an element
    result = elementTreeClassRef().getMember(["fromstring", "fromstringlist", "XML"]).getReturn()
    or
    result = elementTreeClassRef().getMember("XMLParser").getReturn().getMember("close").getReturn()
  }

  /**
   * A call to a find method on a tree or an element will execute an XPath expression.
   */
  private class ElementTreeFindCall extends XML::XPathExecution::Range, DataFlow::CallCfgNode {
    string methodName;

    ElementTreeFindCall() {
      methodName in ["find", "findall", "findtext"] and
      (
        this = elementTreeInstance().getMember(methodName).getACall()
        or
        this = elementInstance().getMember(methodName).getACall()
      )
    }

    override DataFlow::Node getXPath() { result in [this.getArg(0), this.getArgByName("match")] }

    override string getName() { result = "xml.etree" }
  }

  /**
   * Provides models for `xml.etree` parsers
   *
   * See
   * - https://docs.python.org/3.10/library/xml.etree.elementtree.html#xml.etree.ElementTree.XMLParser
   * - https://docs.python.org/3.10/library/xml.etree.elementtree.html#xml.etree.ElementTree.XMLPullParser
   */
  module XmlParser {
    /**
     * A source of instances of `xml.etree` parsers, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `XmlParser::instance()` to get references to instances of `xml.etree` parsers.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** A direct instantiation of `xml.etree` parsers. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      ClassInstantiation() {
        this = elementTreeClassRef().getMember(["XMLParser", "XMLPullParser"]).getACall()
      }
    }

    /** Gets a reference to an `xml.etree` parser instance. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an `xml.etree` parser instance. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * A call to the `feed` method of an `xml.etree` parser.
     */
    private class XmlEtreeParserFeedCall extends DataFlow::MethodCallNode, XML::XmlParsing::Range {
      XmlEtreeParserFeedCall() { this.calls(instance(), "feed") }

      override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("data")] }

      override predicate vulnerableTo(XML::XmlParsingVulnerabilityKind kind) { kind.isXmlBomb() }

      override predicate mayExecuteInput() { none() }

      override DataFlow::Node getOutput() {
        exists(DataFlow::Node objRef |
          DataFlow::localFlow(this.getObject(), objRef) and
          result.(DataFlow::MethodCallNode).calls(objRef, "close")
        )
      }
    }
  }

  /**
   * A call to either of:
   * - `xml.etree.ElementTree.fromstring`
   * - `xml.etree.ElementTree.fromstringlist`
   * - `xml.etree.ElementTree.XML`
   * - `xml.etree.ElementTree.XMLID`
   * - `xml.etree.ElementTree.parse`
   * - `xml.etree.ElementTree.iterparse`
   * - `parse` method on an `xml.etree.ElementTree.ElementTree` instance
   *
   * See
   * - https://docs.python.org/3/library/xml.etree.elementtree.html#xml.etree.ElementTree.fromstring
   * - https://docs.python.org/3/library/xml.etree.elementtree.html#xml.etree.ElementTree.fromstringlist
   * - https://docs.python.org/3/library/xml.etree.elementtree.html#xml.etree.ElementTree.XML
   * - https://docs.python.org/3/library/xml.etree.elementtree.html#xml.etree.ElementTree.XMLID
   * - https://docs.python.org/3/library/xml.etree.elementtree.html#xml.etree.ElementTree.parse
   * - https://docs.python.org/3/library/xml.etree.elementtree.html#xml.etree.ElementTree.iterparse
   */
  private class XmlEtreeParsing extends DataFlow::CallCfgNode, XML::XmlParsing::Range {
    XmlEtreeParsing() {
      this =
        elementTreeClassRef()
            .getMember(["fromstring", "fromstringlist", "XML", "XMLID", "parse", "iterparse"])
            .getACall()
      or
      this = elementTreeInstance().getMember("parse").getACall()
    }

    override DataFlow::Node getAnInput() {
      result in [
          this.getArg(0),
          // fromstring / XML / XMLID
          this.getArgByName("text"),
          // fromstringlist
          this.getArgByName("sequence"),
          // parse / iterparse
          this.getArgByName("source"),
        ]
    }

    override predicate vulnerableTo(XML::XmlParsingVulnerabilityKind kind) {
      // note: it does not matter what `xml.etree` parser you are using, you cannot
      // change the security features anyway :|
      kind.isXmlBomb()
    }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getOutput() {
      // Note: for `XMLID` the result of the call is a tuple with `(root, dict)`, so
      // maybe we should not just say that the entire tuple is the decoding output... my
      // gut feeling is that THIS instance doesn't matter too much, but that it would be
      // nice to be able to do this in general. (this is a problem for both `lxml.etree`
      // and `xml.etree`)
      result = this
    }
  }

  /**
   * A call to `xml.etree.ElementTree.parse` or `xml.etree.ElementTree.iterparse`, which
   * takes either a filename or a file-like object as argument. To capture the filename
   * for path-injection, we have this subclass.
   *
   * See
   * - https://docs.python.org/3/library/xml.etree.elementtree.html#xml.etree.ElementTree.parse
   * - https://docs.python.org/3/library/xml.etree.elementtree.html#xml.etree.ElementTree.iterparse
   */
  private class FileAccessFromXmlEtreeParsing extends XmlEtreeParsing, FileSystemAccess::Range {
    FileAccessFromXmlEtreeParsing() {
      this = elementTreeClassRef().getMember(["parse", "iterparse"]).getACall()
      or
      this = elementTreeInstance().getMember("parse").getACall()
      // I considered whether we should try to reduce FPs from people passing file-like
      // objects, which will not be a file system access (and couldn't cause a
      // path-injection).
      //
      // I suppose that once we have proper flow-summary support for file-like objects,
      // we can make the XXE/XML-bomb sinks allow an access-path, while the
      // path-injection sink wouldn't, and then we will not end up with such FPs.
    }

    override DataFlow::Node getAPathArgument() { result = this.getAnInput() }
  }

  // ---------------------------------------------------------------------------
  // xml.sax
  // ---------------------------------------------------------------------------
  /**
   * A call to the `setFeature` method on a XML sax parser.
   *
   * See https://docs.python.org/3.10/library/xml.sax.reader.html#xml.sax.xmlreader.XMLReader.setFeature
   */
  private class SaxParserSetFeatureCall extends API::CallNode, DataFlow::MethodCallNode {
    SaxParserSetFeatureCall() {
      this =
        API::moduleImport("xml")
            .getMember("sax")
            .getMember("make_parser")
            .getReturn()
            .getMember("setFeature")
            .getACall()
    }

    // The keyword argument names does not match documentation. I checked (with Python
    // 3.9.5) that the names used here actually works.
    API::Node getFeatureArg() { result = this.getParameter(0, "name") }

    API::Node getStateArg() { result = this.getParameter(1, "state") }
  }

  /**
   * Gets a reference to a XML sax parser that has `feature_external_ges` turned on.
   *
   * See https://docs.python.org/3/library/xml.sax.handler.html#xml.sax.handler.feature_external_ges
   */
  private DataFlow::Node saxParserWithFeatureExternalGesTurnedOn(DataFlow::TypeTracker t) {
    t.start() and
    exists(SaxParserSetFeatureCall call |
      call.getFeatureArg().asSink() =
        API::moduleImport("xml")
            .getMember("sax")
            .getMember("handler")
            .getMember("feature_external_ges")
            .getAValueReachableFromSource() and
      call.getStateArg().getAValueReachingSink().asExpr().(BooleanLiteral).booleanValue() = true and
      result = call.getObject()
    )
    or
    exists(DataFlow::TypeTracker t2 |
      t = t2.smallstep(saxParserWithFeatureExternalGesTurnedOn(t2), result)
    ) and
    // take account of that we can set the feature to False, which makes the parser safe again
    not exists(SaxParserSetFeatureCall call |
      call.getObject() = result and
      call.getFeatureArg().asSink() =
        API::moduleImport("xml")
            .getMember("sax")
            .getMember("handler")
            .getMember("feature_external_ges")
            .getAValueReachableFromSource() and
      call.getStateArg().getAValueReachingSink().asExpr().(BooleanLiteral).booleanValue() = false
    )
  }

  /**
   * Gets a reference to a XML sax parser that has `feature_external_ges` turned on.
   *
   * See https://docs.python.org/3/library/xml.sax.handler.html#xml.sax.handler.feature_external_ges
   */
  DataFlow::Node saxParserWithFeatureExternalGesTurnedOn() {
    result = saxParserWithFeatureExternalGesTurnedOn(DataFlow::TypeTracker::end())
  }

  /**
   * A call to the `parse` method on a SAX XML parser.
   *
   * See https://docs.python.org/3/library/xml.sax.reader.html#xml.sax.xmlreader.XMLReader.parse
   */
  private class XmlSaxInstanceParsing extends DataFlow::MethodCallNode, XML::XmlParsing::Range,
    FileSystemAccess::Range
  {
    XmlSaxInstanceParsing() {
      this =
        API::moduleImport("xml")
            .getMember("sax")
            .getMember("make_parser")
            .getReturn()
            .getMember("parse")
            .getACall()
    }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("source")] }

    override predicate vulnerableTo(XML::XmlParsingVulnerabilityKind kind) {
      // always vuln to these
      kind.isXmlBomb()
      or
      // can be vuln to other things if features has been turned on
      this.getObject() = saxParserWithFeatureExternalGesTurnedOn() and
      (kind.isXxe() or kind.isDtdRetrieval())
    }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getOutput() {
      // note: the output of parsing with SAX is that the content handler gets the
      // data... but we don't currently model this (it's not trivial to do, and won't
      // really give us any value, at least not as of right now).
      none()
    }

    override DataFlow::Node getAPathArgument() {
      // I considered whether we should try to reduce FPs from people passing file-like
      // objects, which will not be a file system access (and couldn't cause a
      // path-injection).
      //
      // I suppose that once we have proper flow-summary support for file-like objects,
      // we can make the XXE/XML-bomb sinks allow an access-path, while the
      // path-injection sink wouldn't, and then we will not end up with such FPs.
      result = this.getAnInput()
    }
  }

  /**
   * A call to either `parse` or `parseString` from `xml.sax` module.
   *
   * See:
   * - https://docs.python.org/3.10/library/xml.sax.html#xml.sax.parse
   * - https://docs.python.org/3.10/library/xml.sax.html#xml.sax.parseString
   */
  private class XmlSaxParsing extends DataFlow::CallCfgNode, XML::XmlParsing::Range {
    XmlSaxParsing() {
      this =
        API::moduleImport("xml").getMember("sax").getMember(["parse", "parseString"]).getACall()
    }

    override DataFlow::Node getAnInput() {
      result in [
          this.getArg(0),
          // parseString
          this.getArgByName("string"),
          // parse
          this.getArgByName("source"),
        ]
    }

    override predicate vulnerableTo(XML::XmlParsingVulnerabilityKind kind) {
      // always vuln to these
      kind.isXmlBomb()
    }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getOutput() {
      // note: the output of parsing with SAX is that the content handler gets the
      // data... but we don't currently model this (it's not trivial to do, and won't
      // really give us any value, at least not as of right now).
      none()
    }
  }

  /**
   * A call to `xml.sax.parse`, which takes either a filename or a file-like object as
   * argument. To capture the filename for path-injection, we have this subclass.
   *
   * See
   * - https://docs.python.org/3/library/xml.etree.elementtree.html#xml.etree.ElementTree.parse
   * - https://docs.python.org/3/library/xml.etree.elementtree.html#xml.etree.ElementTree.iterparse
   */
  private class FileAccessFromXmlSaxParsing extends XmlSaxParsing, FileSystemAccess::Range {
    FileAccessFromXmlSaxParsing() {
      this = API::moduleImport("xml").getMember("sax").getMember("parse").getACall()
      // I considered whether we should try to reduce FPs from people passing file-like
      // objects, which will not be a file system access (and couldn't cause a
      // path-injection).
      //
      // I suppose that once we have proper flow-summary support for file-like objects,
      // we can make the XXE/XML-bomb sinks allow an access-path, while the
      // path-injection sink wouldn't, and then we will not end up with such FPs.
    }

    override DataFlow::Node getAPathArgument() { result = this.getAnInput() }
  }

  // ---------------------------------------------------------------------------
  // xml.dom.*
  // ---------------------------------------------------------------------------
  /**
   * A call to the `parse` or `parseString` methods from `xml.dom.minidom` or `xml.dom.pulldom`.
   *
   * Both of these modules are based on SAX parsers.
   *
   * See
   * - https://docs.python.org/3/library/xml.dom.minidom.html#xml.dom.minidom.parse
   * - https://docs.python.org/3/library/xml.dom.pulldom.html#xml.dom.pulldom.parse
   */
  private class XmlDomParsing extends DataFlow::CallCfgNode, XML::XmlParsing::Range {
    XmlDomParsing() {
      this =
        API::moduleImport("xml")
            .getMember("dom")
            .getMember(["minidom", "pulldom"])
            .getMember(["parse", "parseString"])
            .getACall()
    }

    override DataFlow::Node getAnInput() {
      result in [
          this.getArg(0),
          // parseString
          this.getArgByName("string"),
          // minidom.parse
          this.getArgByName("file"),
          // pulldom.parse
          this.getArgByName("stream_or_string"),
        ]
    }

    DataFlow::Node getParserArg() { result in [this.getArg(1), this.getArgByName("parser")] }

    override predicate vulnerableTo(XML::XmlParsingVulnerabilityKind kind) {
      this.getParserArg() = saxParserWithFeatureExternalGesTurnedOn() and
      (kind.isXxe() or kind.isDtdRetrieval())
      or
      kind.isXmlBomb()
    }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getOutput() { result = this }
  }

  /**
   * A call to the `parse` or `parseString` methods from `xml.dom.minidom` or
   * `xml.dom.pulldom`, which takes either a filename or a file-like object as argument.
   * To capture the filename for path-injection, we have this subclass.
   *
   * See
   * - https://docs.python.org/3/library/xml.dom.minidom.html#xml.dom.minidom.parse
   * - https://docs.python.org/3/library/xml.dom.pulldom.html#xml.dom.pulldom.parse
   */
  private class FileAccessFromXmlDomParsing extends XmlDomParsing, FileSystemAccess::Range {
    FileAccessFromXmlDomParsing() {
      this =
        API::moduleImport("xml")
            .getMember("dom")
            .getMember(["minidom", "pulldom"])
            .getMember("parse")
            .getACall()
      // I considered whether we should try to reduce FPs from people passing file-like
      // objects, which will not be a file system access (and couldn't cause a
      // path-injection).
      //
      // I suppose that once we have proper flow-summary support for file-like objects,
      // we can make the XXE/XML-bomb sinks allow an access-path, while the
      // path-injection sink wouldn't, and then we will not end up with such FPs.
    }

    override DataFlow::Node getAPathArgument() { result = this.getAnInput() }
  }

  // ---------------------------------------------------------------------------
  // Flow summaries for functions contructing containers
  // ---------------------------------------------------------------------------
  /**
   * A flow summary for `dict`.
   *
   * see https://docs.python.org/3/library/stdtypes.html#dict
   */
  class DictSummary extends SummarizedCallable {
    DictSummary() { this = "builtins.dict" }

    override DataFlow::CallCfgNode getACall() { result = API::builtin("dict").getACall() }

    override DataFlow::ArgumentNode getACallback() {
      result = API::builtin("dict").getAValueReachableFromSource()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      // The positional argument contains a mapping.
      // TODO: these values can be overwritten by keyword arguments
      //  - dict mapping
      exists(DataFlow::DictionaryElementContent dc, string key | key = dc.getKey() |
        input = "Argument[0].DictionaryElement[" + key + "]" and
        output = "ReturnValue.DictionaryElement[" + key + "]" and
        preservesValue = true
      )
      or
      //  - list-of-pairs mapping
      input = "Argument[0].ListElement.TupleElement[1]" and
      output = "ReturnValue.DictionaryElementAny" and
      preservesValue = true
      or
      // The keyword arguments are added to the dictionary.
      exists(DataFlow::DictionaryElementContent dc, string key | key = dc.getKey() |
        input = "Argument[" + key + ":]" and
        output = "ReturnValue.DictionaryElement[" + key + "]" and
        preservesValue = true
      )
      or
      // Imprecise content in the first argument ends up on the container itself.
      input = "Argument[0]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /** A flow summary for `list`. */
  class ListSummary extends SummarizedCallable {
    ListSummary() { this = "builtins.list" }

    override DataFlow::CallCfgNode getACall() { result = API::builtin("list").getACall() }

    override DataFlow::ArgumentNode getACallback() {
      result = API::builtin("list").getAValueReachableFromSource()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[0].ListElement"
        or
        input = "Argument[0].SetElement"
        or
        exists(DataFlow::TupleElementContent tc, int i | i = tc.getIndex() |
          input = "Argument[0].TupleElement[" + i.toString() + "]"
        )
        // TODO: Once we have DictKeyContent, we need to transform that into ListElementContent
      ) and
      output = "ReturnValue.ListElement" and
      preservesValue = true
      or
      input = "Argument[0]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /** A flow summary for tuple */
  class TupleSummary extends SummarizedCallable {
    TupleSummary() { this = "builtins.tuple" }

    override DataFlow::CallCfgNode getACall() { result = API::builtin("tuple").getACall() }

    override DataFlow::ArgumentNode getACallback() {
      result = API::builtin("tuple").getAValueReachableFromSource()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      exists(DataFlow::TupleElementContent tc, int i | i = tc.getIndex() |
        input = "Argument[0].TupleElement[" + i.toString() + "]" and
        output = "ReturnValue.TupleElement[" + i.toString() + "]" and
        preservesValue = true
      )
      or
      // TODO: We need to also translate iterable content such as list element
      //       but we currently lack TupleElementAny
      input = "Argument[0]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /** A flow summary for set */
  class SetSummary extends SummarizedCallable {
    SetSummary() { this = "builtins.set" }

    override DataFlow::CallCfgNode getACall() { result = API::builtin("set").getACall() }

    override DataFlow::ArgumentNode getACallback() {
      result = API::builtin("set").getAValueReachableFromSource()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[0].ListElement"
        or
        input = "Argument[0].SetElement"
        or
        exists(DataFlow::TupleElementContent tc, int i | i = tc.getIndex() |
          input = "Argument[0].TupleElement[" + i.toString() + "]"
        )
        // TODO: Once we have DictKeyContent, we need to transform that into ListElementContent
      ) and
      output = "ReturnValue.SetElement" and
      preservesValue = true
      or
      input = "Argument[0]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /** A flow summary for frozenset */
  class FrozensetSummary extends SummarizedCallable {
    FrozensetSummary() { this = "builtins.frozenset" }

    override DataFlow::CallCfgNode getACall() { result = API::builtin("frozenset").getACall() }

    override DataFlow::ArgumentNode getACallback() {
      result = API::builtin("frozenset").getAValueReachableFromSource()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      any(SetSummary s).propagatesFlow(input, output, preservesValue)
    }
  }

  // ---------------------------------------------------------------------------
  // Flow summaries for functions operating on containers
  // ---------------------------------------------------------------------------
  /** A flow summary for `reversed`. */
  class ReversedSummary extends SummarizedCallable {
    ReversedSummary() { this = "builtins.reversed" }

    override DataFlow::CallCfgNode getACall() { result = API::builtin("reversed").getACall() }

    override DataFlow::ArgumentNode getACallback() {
      result = API::builtin("reversed").getAValueReachableFromSource()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[0].ListElement"
        or
        input = "Argument[0].SetElement"
        or
        exists(DataFlow::TupleElementContent tc, int i | i = tc.getIndex() |
          input = "Argument[0].TupleElement[" + i.toString() + "]"
        )
        // TODO: Once we have DictKeyContent, we need to transform that into ListElementContent
      ) and
      output = "ReturnValue.ListElement" and
      preservesValue = true
      or
      input = "Argument[0]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /** A flow summary for `sorted`. */
  class SortedSummary extends SummarizedCallable {
    SortedSummary() { this = "builtins.sorted" }

    override DataFlow::CallCfgNode getACall() { result = API::builtin("sorted").getACall() }

    override DataFlow::ArgumentNode getACallback() {
      result = API::builtin("sorted").getAValueReachableFromSource()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      exists(string content |
        content = "ListElement"
        or
        content = "SetElement"
        or
        exists(DataFlow::TupleElementContent tc, int i | i = tc.getIndex() |
          content = "TupleElement[" + i.toString() + "]"
        )
      |
        // TODO: Once we have DictKeyContent, we need to transform that into ListElementContent
        input = "Argument[0]." + content and
        output = "ReturnValue.ListElement" and
        preservesValue = true
      )
      or
      input = "Argument[0]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /** A flow summary for `iter`. */
  class IterSummary extends SummarizedCallable {
    IterSummary() { this = "builtins.iter" }

    override DataFlow::CallCfgNode getACall() { result = API::builtin("iter").getACall() }

    override DataFlow::ArgumentNode getACallback() {
      result = API::builtin("iter").getAValueReachableFromSource()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[0].ListElement"
        or
        input = "Argument[0].SetElement"
        or
        exists(DataFlow::TupleElementContent tc, int i | i = tc.getIndex() |
          input = "Argument[0].TupleElement[" + i.toString() + "]"
        )
        // TODO: Once we have DictKeyContent, we need to transform that into ListElementContent
      ) and
      output = "ReturnValue.ListElement" and
      preservesValue = true
      or
      input = "Argument[0]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /** A flow summary for `next`. */
  class NextSummary extends SummarizedCallable {
    NextSummary() { this = "builtins.next" }

    override DataFlow::CallCfgNode getACall() { result = API::builtin("next").getACall() }

    override DataFlow::ArgumentNode getACallback() {
      result = API::builtin("next").getAValueReachableFromSource()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[0].ListElement"
        or
        input = "Argument[0].SetElement"
        or
        exists(DataFlow::TupleElementContent tc, int i | i = tc.getIndex() |
          input = "Argument[0].TupleElement[" + i.toString() + "]"
        )
        // TODO: Once we have DictKeyContent, we need to transform that into ListElementContent
      ) and
      output = "ReturnValue" and
      preservesValue = true
      or
      input = "Argument[1]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  /** A flow summary for `map`. */
  class MapSummary extends SummarizedCallable {
    MapSummary() { this = "builtins.map" }

    override DataFlow::CallCfgNode getACall() { result = API::builtin("map").getACall() }

    override DataFlow::ArgumentNode getACallback() {
      result = API::builtin("map").getAValueReachableFromSource()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      exists(int i | exists(any(Call c).getArg(i)) |
        (
          input = "Argument[" + (i + 1).toString() + "].ListElement"
          or
          input = "Argument[" + (i + 1).toString() + "].SetElement"
          or
          // We reduce generality slightly by not tracking tuple contents on list arguments beyond the first, for performance.
          // TODO: Once we have TupleElementAny, this generality can be increased.
          i = 0 and
          exists(DataFlow::TupleElementContent tc, int j | j = tc.getIndex() |
            input = "Argument[1].TupleElement[" + j.toString() + "]"
          )
          // TODO: Once we have DictKeyContent, we need to transform that into ListElementContent
        ) and
        output = "Argument[0].Parameter[" + i.toString() + "]" and
        preservesValue = true
      )
      or
      input = "Argument[0].ReturnValue" and
      output = "ReturnValue.ListElement" and
      preservesValue = true
    }
  }

  /** A flow summary for `filter`. */
  class FilterSummary extends SummarizedCallable {
    FilterSummary() { this = "builtins.filter" }

    override DataFlow::CallCfgNode getACall() { result = API::builtin("filter").getACall() }

    override DataFlow::ArgumentNode getACallback() {
      result = API::builtin("filter").getAValueReachableFromSource()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[1].ListElement"
        or
        input = "Argument[1].SetElement"
        or
        exists(DataFlow::TupleElementContent tc, int i | i = tc.getIndex() |
          input = "Argument[1].TupleElement[" + i.toString() + "]"
        )
        // TODO: Once we have DictKeyContent, we need to transform that into ListElementContent
      ) and
      (output = "Argument[0].Parameter[0]" or output = "ReturnValue.ListElement") and
      preservesValue = true
    }
  }

  /**A summary for `enumerate`. */
  class EnumerateSummary extends SummarizedCallable {
    EnumerateSummary() { this = "builtins.enumerate" }

    override DataFlow::CallCfgNode getACall() { result = API::builtin("enumerate").getACall() }

    override DataFlow::ArgumentNode getACallback() {
      result = API::builtin("enumerate").getAValueReachableFromSource()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      (
        input = "Argument[0].ListElement"
        or
        input = "Argument[0].SetElement"
        or
        exists(DataFlow::TupleElementContent tc, int i | i = tc.getIndex() |
          input = "Argument[0].TupleElement[" + i.toString() + "]"
        )
        // TODO: Once we have DictKeyContent, we need to transform that into ListElementContent
      ) and
      output = "ReturnValue.ListElement.TupleElement[1]" and
      preservesValue = true
    }
  }

  /** A flow summary for `zip`. */
  class ZipSummary extends SummarizedCallable {
    ZipSummary() { this = "builtins.zip" }

    override DataFlow::CallCfgNode getACall() { result = API::builtin("zip").getACall() }

    override DataFlow::ArgumentNode getACallback() {
      result = API::builtin("zip").getAValueReachableFromSource()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      exists(int i | exists(any(Call c).getArg(i)) |
        (
          input = "Argument[" + i.toString() + "].ListElement"
          or
          input = "Argument[" + i.toString() + "].SetElement"
          or
          // We reduce generality slightly by not tracking tuple contents on arguments beyond the first two, for performance.
          // TODO: Once we have TupleElementAny, this generality can be increased.
          i in [0 .. 1] and
          exists(DataFlow::TupleElementContent tc, int j | j = tc.getIndex() |
            input = "Argument[" + i.toString() + "].TupleElement[" + j.toString() + "]"
          )
          // TODO: Once we have DictKeyContent, we need to transform that into ListElementContent
        ) and
        output = "ReturnValue.ListElement.TupleElement[" + i.toString() + "]" and
        preservesValue = true
      )
    }
  }

  // ---------------------------------------------------------------------------
  // Flow summaries for container methods
  // ---------------------------------------------------------------------------
  /** A flow summary for `copy`. */
  class CopySummary extends SummarizedCallable {
    CopySummary() { this = "collection.copy" }

    override DataFlow::CallCfgNode getACall() {
      result.(DataFlow::MethodCallNode).getMethodName() = "copy"
    }

    override DataFlow::ArgumentNode getACallback() { none() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      exists(DataFlow::Content c |
        input = "Argument[self]." + c.getMaDRepresentation() and
        output = "ReturnValue." + c.getMaDRepresentation() and
        preservesValue = true
      )
      or
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  /** A flow summary for `copy.replace`. */
  class ReplaceSummary extends SummarizedCallable {
    ReplaceSummary() { this = "copy.replace" }

    override DataFlow::CallCfgNode getACall() {
      result = API::moduleImport("copy").getMember("replace").getACall()
    }

    override DataFlow::ArgumentNode getACallback() {
      result = API::moduleImport("copy").getMember("replace").getAValueReachableFromSource()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      exists(CallNode c, string name, ControlFlowNode n, DataFlow::AttributeContent ac |
        c.getFunction().(NameNode).getId() = "replace" or
        c.getFunction().(AttrNode).getName() = "replace"
      |
        n = c.getArgByName(name) and
        ac.getAttribute() = name and
        input = "Argument[" + name + ":]" and
        output = "ReturnValue." + ac.getMaDRepresentation() and
        preservesValue = true
      )
    }
  }

  /**
   * A flow summary for `pop` either for list or set.
   * This ignores the index if given, since content is
   * imprecise anyway.
   *
   * I also handles the default value when `pop` is called
   * on a dictionary, since that also does not depend on the key.
   */
  class PopSummary extends SummarizedCallable {
    PopSummary() { this = "collection.pop" }

    override DataFlow::CallCfgNode getACall() {
      result.(DataFlow::MethodCallNode).getMethodName() = "pop"
    }

    override DataFlow::ArgumentNode getACallback() { none() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].ListElement" and
      output = "ReturnValue" and
      preservesValue = true
      or
      input = "Argument[self].SetElement" and
      output = "ReturnValue" and
      preservesValue = true
      or
      // default value for dictionary
      input = "Argument[1]" and
      output = "ReturnValue" and
      preservesValue = true
      or
      // transfer taint on self to return value
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /** A flow summary for `dict.pop` */
  class DictPopSummary extends SummarizedCallable {
    string key;

    DictPopSummary() {
      this = "dict.pop(" + key + ")" and
      exists(DataFlow::DictionaryElementContent dc | key = dc.getKey())
    }

    override DataFlow::CallCfgNode getACall() {
      result.(DataFlow::MethodCallNode).getMethodName() = "pop" and
      result.getArg(0).getALocalSource().asExpr().(StringLiteral).getText() = key
    }

    override DataFlow::ArgumentNode getACallback() { none() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].DictionaryElement[" + key + "]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  /** A flow summary for `dict.get` at specific content. */
  class DictGetSummary extends SummarizedCallable {
    string key;

    DictGetSummary() {
      this = "dict.get(" + key + ")" and
      exists(DataFlow::DictionaryElementContent dc | key = dc.getKey())
    }

    override DataFlow::CallCfgNode getACall() {
      result.(DataFlow::MethodCallNode).getMethodName() = "get" and
      result.getArg(0).getALocalSource().asExpr().(StringLiteral).getText() = key
    }

    override DataFlow::ArgumentNode getACallback() { none() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input = "Argument[self].DictionaryElement[" + key + "]" and
      output = "ReturnValue" and
      preservesValue = true
      or
      // optional default value
      input = "Argument[1]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  /** A flow summary for `dict.get` disregarding content. */
  class DictGetAnySummary extends SummarizedCallable {
    DictGetAnySummary() { this = "dict.get" }

    override DataFlow::CallCfgNode getACall() {
      result.(DataFlow::MethodCallNode).getMethodName() = "get"
    }

    override DataFlow::ArgumentNode getACallback() { none() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      // default value
      input = "Argument[1]" and
      output = "ReturnValue" and
      preservesValue = true
      or
      // transfer taint from self to return value
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /** A flow summary for `dict.popitem` */
  class DictPopitemSummary extends SummarizedCallable {
    DictPopitemSummary() { this = "dict.popitem" }

    override DataFlow::CallCfgNode getACall() {
      result.(DataFlow::MethodCallNode).getMethodName() = "popitem"
    }

    override DataFlow::ArgumentNode getACallback() { none() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      exists(DataFlow::DictionaryElementContent dc, string key | key = dc.getKey() |
        input = "Argument[self].DictionaryElement[" + key + "]" and
        output = "ReturnValue.TupleElement[1]" and
        preservesValue = true
        // TODO: put `key` into "ReturnValue.TupleElement[0]"
      )
    }
  }

  /**
   * A flow summary for `dict.setdefault`.
   *
   * See https://docs.python.org/3.10/library/stdtypes.html#dict.setdefault
   */
  class DictSetdefaultSummary extends SummarizedCallable {
    DictSetdefaultSummary() { this = "dict.setdefault" }

    override DataFlow::CallCfgNode getACall() {
      result.(DataFlow::MethodCallNode).calls(_, "setdefault")
    }

    override DataFlow::ArgumentNode getACallback() {
      result.(DataFlow::AttrRead).getAttributeName() = "setdefault"
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      // store/read steps with dictionary content of this is modeled in DataFlowPrivate
      input = "Argument[1]" and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  /**
   * A flow summary for `dict.setdefault` at specific content.
   * See https://docs.python.org/3.10/library/stdtypes.html#dict.setdefault
   * This summary handles read and store steps. See `DictSetdefaultSummary`
   * for the dataflow steps.
   */
  class DictSetdefaultKeySummary extends SummarizedCallable {
    string key;

    DictSetdefaultKeySummary() {
      this = "dict.setdefault(" + key + ")" and
      exists(DataFlow::DictionaryElementContent dc | key = dc.getKey())
    }

    override DataFlow::CallCfgNode getACall() {
      result.(DataFlow::MethodCallNode).getMethodName() = "setdefault" and
      result.getArg(0).getALocalSource().asExpr().(StringLiteral).getText() = key
    }

    override DataFlow::ArgumentNode getACallback() { none() }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      // If key is in the dictionary, return its value.
      input = "Argument[self].DictionaryElement[" + key + "]" and
      output = "ReturnValue" and
      preservesValue = true
      or
      // If not, insert key with a value of default.
      input = "Argument[1]" and
      output = "ReturnValue.DictionaryElement[" + key + "]" and
      preservesValue = true
    }
  }

  /**
   * A flow summary for `dict.values`.
   *
   * See https://docs.python.org/3.10/library/stdtypes.html#dict.values
   */
  class DictValues extends SummarizedCallable {
    DictValues() { this = "dict.values" }

    override DataFlow::CallCfgNode getACall() {
      result.(DataFlow::MethodCallNode).calls(_, "values")
    }

    override DataFlow::ArgumentNode getACallback() {
      result.(DataFlow::AttrRead).getAttributeName() = "values"
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      exists(DataFlow::DictionaryElementContent dc, string key | key = dc.getKey() |
        input = "Argument[self].DictionaryElement[" + key + "]" and
        output = "ReturnValue.ListElement" and
        preservesValue = true
      )
      or
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /**
   * A flow summary for `dict.keys`.
   *
   * See https://docs.python.org/3.10/library/stdtypes.html#dict.keys
   */
  class DictKeys extends SummarizedCallable {
    DictKeys() { this = "dict.keys" }

    override DataFlow::CallCfgNode getACall() { result.(DataFlow::MethodCallNode).calls(_, "keys") }

    override DataFlow::ArgumentNode getACallback() {
      result.(DataFlow::AttrRead).getAttributeName() = "keys"
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      // TODO: Once we have DictKeyContent, we need to transform that into ListElementContent
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /**
   * A flow summary for `dict.items`.
   *
   * See https://docs.python.org/3.10/library/stdtypes.html#dict.items
   */
  class DictItems extends SummarizedCallable {
    DictItems() { this = "dict.items" }

    override DataFlow::CallCfgNode getACall() {
      result.(DataFlow::MethodCallNode).calls(_, "items")
    }

    override DataFlow::ArgumentNode getACallback() {
      result.(DataFlow::AttrRead).getAttributeName() = "items"
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      exists(DataFlow::DictionaryElementContent dc, string key | key = dc.getKey() |
        input = "Argument[self].DictionaryElement[" + key + "]" and
        output = "ReturnValue.ListElement.TupleElement[1]" and
        preservesValue = true
      )
      or
      // TODO: Add the keys to output list
      input = "Argument[self]" and
      output = "ReturnValue" and
      preservesValue = false
    }
  }

  /**
   * A flow summary for `list.append`.
   *
   * See https://docs.python.org/3.10/library/stdtypes.html#typesseq-mutable
   */
  class ListAppend extends SummarizedCallable {
    ListAppend() { this = "list.append" }

    override DataFlow::CallCfgNode getACall() {
      result.(DataFlow::MethodCallNode).calls(_, "append")
    }

    override DataFlow::ArgumentNode getACallback() {
      result.(DataFlow::AttrRead).getAttributeName() = "append"
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      // newly added element added to this
      input = "Argument[0]" and
      output = "Argument[self].ListElement" and
      preservesValue = true
      or
      // transfer taint from new element to this (TODO: remove in future when taint-handling is more in line with other languages)
      input = "Argument[0]" and
      output = "Argument[self]" and
      preservesValue = false
    }
  }

  /**
   * A flow summary for `set.add`.
   *
   * See https://docs.python.org/3.10/library/stdtypes.html#frozenset.add
   */
  class SetAdd extends SummarizedCallable {
    SetAdd() { this = "set.add" }

    override DataFlow::CallCfgNode getACall() { result.(DataFlow::MethodCallNode).calls(_, "add") }

    override DataFlow::ArgumentNode getACallback() {
      result.(DataFlow::AttrRead).getAttributeName() = "add"
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      // newly added element added to this
      input = "Argument[0]" and
      output = "Argument[self].SetElement" and
      preservesValue = true
      or
      // transfer taint from new element to this (TODO: remove in future when taint-handling is more in line with other languages)
      input = "Argument[0]" and
      output = "Argument[self]" and
      preservesValue = false
    }
  }

  /**
   * A flow summary for `os.getenv` / `os.getenvb`
   *
   * See https://devdocs.io/python~3.11/library/os#os.getenv
   */
  class OsGetEnv extends SummarizedCallable {
    OsGetEnv() { this = "os.getenv" }

    override DataFlow::CallCfgNode getACall() {
      result = API::moduleImport("os").getMember(["getenv", "getenvb"]).getACall()
    }

    override DataFlow::ArgumentNode getACallback() {
      result =
        API::moduleImport("os").getMember(["getenv", "getenvb"]).getAValueReachableFromSource()
    }

    override predicate propagatesFlow(string input, string output, boolean preservesValue) {
      input in ["Argument[1]", "Argument[default:]"] and
      output = "ReturnValue" and
      preservesValue = true
    }
  }

  // ---------------------------------------------------------------------------
  // asyncio
  // ---------------------------------------------------------------------------
  /** Provides models for the `asyncio` module. */
  module AsyncIO {
    /**
     * A call to the `asyncio.create_subprocess_exec` function (also accessible via the `subprocess` module of `asyncio`)
     *
     * See https://docs.python.org/3/library/asyncio-subprocess.html#creating-subprocesses
     */
    private class CreateSubprocessExec extends SystemCommandExecution::Range,
      FileSystemAccess::Range, API::CallNode
    {
      CreateSubprocessExec() {
        this = API::moduleImport("asyncio").getMember("create_subprocess_exec").getACall()
        or
        this =
          API::moduleImport("asyncio")
              .getMember("subprocess")
              .getMember("create_subprocess_exec")
              .getACall()
      }

      override DataFlow::Node getCommand() { result = this.getParameter(0, "program").asSink() }

      override DataFlow::Node getAPathArgument() { result = this.getCommand() }

      override predicate isShellInterpreted(DataFlow::Node arg) {
        none() // this is a safe API.
      }
    }

    /**
     * A call to the `asyncio.create_subprocess_shell` function (also accessible via the `subprocess` module of `asyncio`)
     *
     * See https://docs.python.org/3/library/asyncio-subprocess.html#asyncio.create_subprocess_shell
     */
    private class CreateSubprocessShell extends SystemCommandExecution::Range,
      FileSystemAccess::Range, API::CallNode
    {
      CreateSubprocessShell() {
        this = API::moduleImport("asyncio").getMember("create_subprocess_shell").getACall()
        or
        this =
          API::moduleImport("asyncio")
              .getMember("subprocess")
              .getMember("create_subprocess_shell")
              .getACall()
      }

      override DataFlow::Node getCommand() { result = this.getParameter(0, "cmd").asSink() }

      override DataFlow::Node getAPathArgument() { result = this.getCommand() }

      override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getCommand() }
    }

    /**
     * Get an asyncio event loop (an object with basetype `AbstractEventLoop`).
     *
     * See https://docs.python.org/3/library/asyncio-eventloop.html
     */
    private API::Node getAsyncioEventLoop() {
      result = API::moduleImport("asyncio").getMember("get_running_loop").getReturn()
      or
      result = API::moduleImport("asyncio").getMember("get_event_loop").getReturn() // deprecated in Python 3.10.0 and later
      or
      result = API::moduleImport("asyncio").getMember("new_event_loop").getReturn()
    }

    /**
     * A call to `subprocess_exec` on an event loop instance.
     *
     * See https://docs.python.org/3/library/asyncio-eventloop.html#asyncio.loop.subprocess_exec
     */
    private class EventLoopSubprocessExec extends API::CallNode, SystemCommandExecution::Range,
      FileSystemAccess::Range
    {
      EventLoopSubprocessExec() {
        this = getAsyncioEventLoop().getMember("subprocess_exec").getACall()
      }

      override DataFlow::Node getCommand() { result = this.getArg(1) }

      override DataFlow::Node getAPathArgument() { result = this.getCommand() }

      override predicate isShellInterpreted(DataFlow::Node arg) {
        none() // this is a safe API.
      }
    }

    /**
     * A call to `subprocess_shell` on an event loop instance.
     *
     * See https://docs.python.org/3/library/asyncio-eventloop.html#asyncio.loop.subprocess_shell
     */
    private class EventLoopSubprocessShell extends API::CallNode, SystemCommandExecution::Range,
      FileSystemAccess::Range
    {
      EventLoopSubprocessShell() {
        this = getAsyncioEventLoop().getMember("subprocess_shell").getACall()
      }

      override DataFlow::Node getCommand() { result = this.getParameter(1, "cmd").asSink() }

      override DataFlow::Node getAPathArgument() { result = this.getCommand() }

      override predicate isShellInterpreted(DataFlow::Node arg) { arg = this.getCommand() }
    }
  }

  // ---------------------------------------------------------------------------
  // html
  // ---------------------------------------------------------------------------
  /**
   * A call to 'html.escape'.
   * See https://docs.python.org/3/library/html.html#html.escape
   */
  private class HtmlEscapeCall extends Escaping::Range, API::CallNode {
    HtmlEscapeCall() {
      this = API::moduleImport("html").getMember("escape").getACall() and
      // if quote escaping is disabled, that might lead to XSS if the result is inserted
      // in the attribute value of a tag, such as `<foo bar="escape_result">`. Since we
      // don't know how values are being inserted, and we don't want to lose these
      // results (FNs), we require quote escaping to be enabled. This might lead to some
      // FPs, so we might need to revisit this in the future.
      not this.getParameter(1, "quote")
          .getAValueReachingSink()
          .asExpr()
          .(ImmutableLiteral)
          .booleanValue() = false
    }

    override DataFlow::Node getAnInput() { result = this.getParameter(0, "s").asSink() }

    override DataFlow::Node getOutput() { result = this }

    override string getKind() { result = Escaping::getHtmlKind() }
  }

  // ---------------------------------------------------------------------------
  // argparse
  // ---------------------------------------------------------------------------
  /**
   * if result of `parse_args` is tainted (because it uses command-line arguments),
   *    then the parsed values accesssed on any attribute lookup is also tainted.
   */
  private class ArgumentParserAnyAttributeStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      nodeFrom =
        API::moduleImport("argparse")
            .getMember("ArgumentParser")
            .getReturn()
            .getMember("parse_args")
            .getReturn()
            .getAValueReachableFromSource() and
      nodeTo.(DataFlow::AttrRead).getObject() = nodeFrom
    }
  }

  // ---------------------------------------------------------------------------
  // sys
  // ---------------------------------------------------------------------------
  /**
   * An access of `sys.stdin`/`sys.stdout`/`sys.stderr`, to get additional FileLike
   * modeling.
   */
  private class SysStandardStreams extends Stdlib::FileLikeObject::InstanceSource, DataFlow::Node {
    SysStandardStreams() {
      this = API::moduleImport("sys").getMember(["stdin", "stdout", "stderr"]).asSource()
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
