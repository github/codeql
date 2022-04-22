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
private import semmle.python.frameworks.internal.PoorMansFunctionResolution
private import semmle.python.frameworks.internal.SelfRefMixin
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper
// modeling split over multiple files to keep this file from becoming too big
private import semmle.python.frameworks.Stdlib.Urllib
private import semmle.python.frameworks.Stdlib.Urllib2

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

  /** DEPRECATED: Alias for HttpMessage */
  deprecated module HTTPMessage = HttpMessage;

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
    private API::Node classRef() {
      result = API::moduleImport("urllib").getMember("parse").getMember("SplitResult")
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
    /** Gets a reference to the `logging.Logger` class or any subclass. */
    private API::Node subclassRef() {
      result = API::moduleImport("logging").getMember("Logger").getASubclass*()
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
        this = API::moduleImport("logging").getMember("root").getAnImmediateUse()
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
  private module OsFileSystemAccessModeling {
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
    private class OsOpenCall extends FileSystemAccess::Range, DataFlow::CallCfgNode {
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
  private class OsExecCall extends SystemCommandExecution::Range, FileSystemAccess::Range,
    DataFlow::CallCfgNode {
    OsExecCall() {
      exists(string name |
        name in ["execl", "execle", "execlp", "execlpe", "execv", "execve", "execvp", "execvpe"] and
        this = os().getMember(name).getACall()
      )
    }

    override DataFlow::Node getCommand() { result = this.getArg(0) }

    override DataFlow::Node getAPathArgument() { result = this.getCommand() }
  }

  /**
   * A call to any of the `os.spawn*` functions
   * See https://docs.python.org/3.8/library/os.html#os.spawnl
   */
  private class OsSpawnCall extends SystemCommandExecution::Range, FileSystemAccess::Range,
    DataFlow::CallCfgNode {
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
  }

  /**
   * A call to any of the `os.posix_spawn*` functions
   * See https://docs.python.org/3.8/library/os.html#os.posix_spawn
   */
  private class OsPosixSpawnCall extends SystemCommandExecution::Range, FileSystemAccess::Range,
    DataFlow::CallCfgNode {
    OsPosixSpawnCall() { this = os().getMember(["posix_spawn", "posix_spawnp"]).getACall() }

    override DataFlow::Node getCommand() { result in [this.getArg(0), this.getArgByName("path")] }

    override DataFlow::Node getAPathArgument() { result = this.getCommand() }
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
        arg_args = this.get_args_arg() and
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
  API::Node pickle() { result = API::moduleImport(["pickle", "cPickle", "_pickle"]) }

  /**
   * A call to `pickle.load`
   * See https://docs.python.org/3/library/pickle.html#pickle.load
   */
  private class PickleLoadCall extends Decoding::Range, DataFlow::CallCfgNode {
    PickleLoadCall() { this = pickle().getMember("load").getACall() }

    override predicate mayExecuteInput() { any() }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("file")] }

    override DataFlow::Node getOutput() { result = this }

    override string getFormat() { result = "pickle" }
  }

  /**
   * A call to `pickle.loads`
   * See https://docs.python.org/3/library/pickle.html#pickle.loads
   */
  private class PickleLoadsCall extends Decoding::Range, DataFlow::CallCfgNode {
    PickleLoadsCall() { this = pickle().getMember("loads").getACall() }

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
    DataFlow::CallCfgNode {
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
  /** Gets a reference to the `BaseHttpServer` module. */
  API::Node baseHttpServer() { result = API::moduleImport("BaseHTTPServer") }

  /** DEPRECATED: Alias for baseHttpServer */
  deprecated API::Node baseHTTPServer() { result = baseHttpServer() }

  /** Provides models for the `BaseHttpServer` module. */
  module BaseHttpServer {
    /**
     * Provides models for the `BaseHTTPServer.BaseHTTPRequestHandler` class (Python 2 only).
     */
    module BaseHttpRequestHandler {
      /** Gets a reference to the `BaseHttpServer.BaseHttpRequestHandler` class. */
      API::Node classRef() { result = baseHttpServer().getMember("BaseHTTPRequestHandler") }
    }

    /** DEPRECATED: Alias for BaseHttpRequestHandler */
    deprecated module BaseHTTPRequestHandler = BaseHttpRequestHandler;
  }

  /** DEPRECATED: Alias for BaseHttpServer */
  deprecated module BaseHTTPServer = BaseHttpServer;

  // ---------------------------------------------------------------------------
  // SimpleHTTPServer (Python 2 only)
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `SimpleHttpServer` module. */
  API::Node simpleHttpServer() { result = API::moduleImport("SimpleHTTPServer") }

  /** DEPRECATED: Alias for simpleHttpServer */
  deprecated API::Node simpleHTTPServer() { result = simpleHttpServer() }

  /** Provides models for the `SimpleHttpServer` module. */
  module SimpleHttpServer {
    /**
     * Provides models for the `SimpleHTTPServer.SimpleHTTPRequestHandler` class (Python 2 only).
     */
    module SimpleHttpRequestHandler {
      /** Gets a reference to the `SimpleHttpServer.SimpleHttpRequestHandler` class. */
      API::Node classRef() { result = simpleHttpServer().getMember("SimpleHTTPRequestHandler") }
    }

    /** DEPRECATED: Alias for SimpleHttpRequestHandler */
    deprecated module SimpleHTTPRequestHandler = SimpleHttpRequestHandler;
  }

  /** DEPRECATED: Alias for SimpleHttpServer */
  deprecated module SimpleHTTPServer = SimpleHttpServer;

  // ---------------------------------------------------------------------------
  // CGIHTTPServer (Python 2 only)
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `CGIHTTPServer` module. */
  API::Node cgiHttpServer() { result = API::moduleImport("CGIHTTPServer") }

  /** DEPRECATED: Alias for cgiHttpServer */
  deprecated API::Node cgiHTTPServer() { result = cgiHttpServer() }

  /** Provides models for the `CGIHTTPServer` module. */
  module CGIHTTPServer {
    /**
     * Provides models for the `CGIHTTPServer.CGIHTTPRequestHandler` class (Python 2 only).
     */
    module CGIHTTPRequestHandler {
      /** Gets a reference to the `CGIHTTPServer.CGIHTTPRequestHandler` class. */
      API::Node classRef() { result = cgiHttpServer().getMember("CGIHTTPRequestHandler") }
    }
  }

  // ---------------------------------------------------------------------------
  // http (Python 3 only)
  // ---------------------------------------------------------------------------
  /** Gets a reference to the `http` module. */
  API::Node http() { result = API::moduleImport("http") }

  /** Provides models for the `http` module. */
  module Http {
    // -------------------------------------------------------------------------
    // http.server
    // -------------------------------------------------------------------------
    /** Gets a reference to the `http.server` module. */
    API::Node server() { result = http().getMember("server") }

    /** Provides models for the `http.server` module */
    module Server {
      /**
       * Provides models for the `http.server.BaseHTTPRequestHandler` class (Python 3 only).
       *
       * See https://docs.python.org/3.9/library/http.server.html#http.server.BaseHTTPRequestHandler.
       */
      module BaseHttpRequestHandler {
        /** Gets a reference to the `http.server.BaseHttpRequestHandler` class. */
        API::Node classRef() { result = server().getMember("BaseHTTPRequestHandler") }
      }

      /** DEPRECATED: Alias for BaseHttpRequestHandler */
      deprecated module BaseHTTPRequestHandler = BaseHttpRequestHandler;

      /**
       * Provides models for the `http.server.SimpleHTTPRequestHandler` class (Python 3 only).
       *
       * See https://docs.python.org/3.9/library/http.server.html#http.server.SimpleHTTPRequestHandler.
       */
      module SimpleHttpRequestHandler {
        /** Gets a reference to the `http.server.SimpleHttpRequestHandler` class. */
        API::Node classRef() { result = server().getMember("SimpleHTTPRequestHandler") }
      }

      /** DEPRECATED: Alias for SimpleHttpRequestHandler */
      deprecated module SimpleHTTPRequestHandler = SimpleHttpRequestHandler;

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
  private module HttpRequestHandler {
    /** Gets a reference to the `BaseHttpRequestHandler` class or any subclass. */
    API::Node subclassRef() {
      result =
        [
          // Python 2
          BaseHttpServer::BaseHttpRequestHandler::classRef(),
          SimpleHttpServer::SimpleHttpRequestHandler::classRef(),
          CGIHTTPServer::CGIHTTPRequestHandler::classRef(),
          // Python 3
          Http::Server::BaseHttpRequestHandler::classRef(),
          Http::Server::SimpleHttpRequestHandler::classRef(),
          Http::Server::CGIHTTPRequestHandler::classRef()
        ].getASubclass*()
    }

    /** A HttpRequestHandler class definition (most likely in project code). */
    class HttpRequestHandlerClassDef extends Class {
      HttpRequestHandlerClassDef() { this.getParent() = subclassRef().getAnImmediateUse().asExpr() }
    }

    /** DEPRECATED: Alias for HttpRequestHandlerClassDef */
    deprecated class HTTPRequestHandlerClassDef = HttpRequestHandlerClassDef;

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
    private class SelfParam extends InstanceSource, RemoteFlowSource::Range, DataFlow::ParameterNode {
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
    private class BaseHttpRequestHandlerHeadersInstances extends Stdlib::HttpMessage::InstanceSource {
      BaseHttpRequestHandlerHeadersInstances() {
        this.(DataFlow::AttrRead).accesses(instance(), "headers")
      }
    }

    /** A file-like object that originates from a `BaseHttpRequestHandler` instance. */
    private class BaseHttpRequestHandlerFileLikeObjectInstances extends Stdlib::FileLikeObject::InstanceSource {
      BaseHttpRequestHandlerFileLikeObjectInstances() {
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
        this = any(HttpRequestHandlerClassDef cls).getAMethod() and
        this.getName() = "do_" + HTTP::httpVerb()
      }

      override Parameter getARoutedParameter() { none() }

      override string getFramework() { result = "Stdlib" }
    }
  }

  // ---------------------------------------------------------------------------
  // wsgiref.simple_server
  // ---------------------------------------------------------------------------
  /** Provides models for the `wsgiref.simple_server` module. */
  private module WsgirefSimpleServer {
    class WsgiServerSubclass extends Class, SelfRefMixin {
      WsgiServerSubclass() {
        this.getParent() =
          API::moduleImport("wsgiref")
              .getMember("simple_server")
              .getMember("WSGIServer")
              .getASubclass*()
              .getAnImmediateUse()
              .asExpr()
      }
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
    class WsgirefSimpleServerApplication extends HTTP::Server::RequestHandler::Range {
      WsgirefSimpleServerApplication() {
        exists(DataFlow::Node appArg, DataFlow::CallCfgNode setAppCall |
          (
            setAppCall =
              API::moduleImport("wsgiref")
                  .getMember("simple_server")
                  .getMember("WSGIServer")
                  .getASubclass*()
                  .getReturn()
                  .getMember("set_app")
                  .getACall()
            or
            setAppCall
                .(DataFlow::MethodCallNode)
                .calls(any(WsgiServerSubclass cls).getASelfRef(), "set_app")
          ) and
          appArg in [setAppCall.getArg(0), setAppCall.getArgByName("application")]
        |
          appArg = poorMansFunctionTracker(this)
        )
      }

      override Parameter getARoutedParameter() { none() }

      override string getFramework() { result = "Stdlib: wsgiref.simple_server application" }
    }

    /**
     * The parameter of a `WsgirefSimpleServerApplication` that takes the WSGI environment
     * when processing a request.
     *
     * See https://docs.python.org/3.10/library/wsgiref.html#wsgiref.simple_server.WSGIRequestHandler.get_environ
     */
    class WSGIEnvirontParameter extends RemoteFlowSource::Range, DataFlow::ParameterNode {
      WSGIEnvirontParameter() {
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
    class WsgirefSimpleServerApplicationWriteCall extends HTTP::Server::HttpResponse::Range,
      DataFlow::CallCfgNode {
      WsgirefSimpleServerApplicationWriteCall() { this.getFunction() = writeFunction() }

      override DataFlow::Node getBody() { result in [this.getArg(0), this.getArgByName("data")] }

      override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

      override string getMimetypeDefault() { none() }
    }

    /**
     * A return from a `WsgirefSimpleServerApplication`, which is included in the response body.
     */
    class WsgirefSimpleServerApplicationReturn extends HTTP::Server::HttpResponse::Range,
      DataFlow::CfgNode {
      WsgirefSimpleServerApplicationReturn() {
        exists(WsgirefSimpleServerApplication requestHandler |
          node = requestHandler.getAReturnValueFlowNode()
        )
      }

      override DataFlow::Node getBody() { result = this }

      override DataFlow::Node getMimetypeOrContentTypeArg() { none() }

      override string getMimetypeDefault() { none() }
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
    private API::Node classRef() {
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
    private class RequestCall extends HTTP::Client::Request::Range, DataFlow::MethodCallNode {
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
      HttpResponse::InstanceSource {
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

  /** DEPRECATED: Alias for HttpConnection */
  deprecated module HTTPConnection = HttpConnection;

  /**
   * Provides models for the `http.client.HTTPResponse` class
   *
   * See
   * - https://docs.python.org/3.10/library/http.client.html#httpresponse-objects
   * - https://docs.python.org/3/library/http.client.html#http.client.HTTPResponse.
   */
  module HttpResponse {
    /** Gets a reference to the `http.client.HttpResponse` class. */
    private API::Node classRef() {
      result = API::moduleImport("http").getMember("client").getMember("HTTPResponse")
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
      DataFlow::LocalSourceNode { }

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

  /** DEPRECATED: Alias for HttpResponse */
  deprecated module HTTPResponse = HttpResponse;

  // ---------------------------------------------------------------------------
  // sqlite3
  // ---------------------------------------------------------------------------
  /**
   * A model of sqlite3 as a module that implements PEP 249, providing ways to execute SQL statements
   * against a database.
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
    string attrbuteName;

    PathlibFileAccess() {
      attrbuteName = fileAccess.getAttributeName() and
      attrbuteName in [
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
    PathlibFileWrites() { attrbuteName in ["write_bytes", "write_text"] }

    override DataFlow::Node getADataNode() { result in [this.getArg(0), this.getArgByName("data")] }
  }

  /** A call to the `open` method on a `pathlib.Path` instance. */
  private class PathLibOpenCall extends PathlibFileAccess, Stdlib::FileLikeObject::InstanceSource {
    PathLibOpenCall() { attrbuteName = "open" }
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
    PathLibLinkToCall() { attrbuteName in ["link_to", "hardlink_to", "symlink_to"] }

    override DataFlow::Node getAPathArgument() {
      result = super.getAPathArgument()
      or
      result = this.getParameter(0, "target").getARhs()
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
    PathLibReplaceCall() { attrbuteName in ["replace", "rename"] }

    override DataFlow::Node getAPathArgument() {
      result = super.getAPathArgument()
      or
      result = this.getParameter(0, "target").getARhs()
    }
  }

  /**
   * A call to the `samefile` method on a `pathlib.Path` instance.
   *
   * See https://docs.python.org/3/library/pathlib.html#pathlib.Path.samefile
   */
  private class PathLibSameFileCall extends PathlibFileAccess, API::CallNode {
    PathLibSameFileCall() { attrbuteName = "samefile" }

    override DataFlow::Node getAPathArgument() {
      result = super.getAPathArgument()
      or
      result = this.getParameter(0, "other_path").getARhs()
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
      result.getParameter(0, "name").getAValueReachingRhs().asExpr().(StrConst).getText() and
    result = API::moduleImport("hashlib").getMember("new").getACall()
  }

  /**
   * A hashing operation by supplying initial data when calling the `hashlib.new` function.
   */
  class HashlibNewCall extends Cryptography::CryptographicOperation::Range, API::CallNode {
    string hashName;

    HashlibNewCall() {
      this = hashlibNewCall(hashName) and
      exists(this.getParameter(1, "data"))
    }

    override Cryptography::CryptographicAlgorithm getAlgorithm() { result.matchesName(hashName) }

    override DataFlow::Node getAnInput() { result = this.getParameter(1, "data").getARhs() }
  }

  /**
   * A hashing operation by using the `update` method on the result of calling the `hashlib.new` function.
   */
  class HashlibNewUpdateCall extends Cryptography::CryptographicOperation::Range, API::CallNode {
    string hashName;

    HashlibNewUpdateCall() {
      this = hashlibNewCall(hashName).getReturn().getMember("update").getACall()
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

  /** Helper module for tracking compiled regexes. */
  private module CompiledRegexes {
    private DataFlow::TypeTrackingNode compiledRegex(DataFlow::TypeTracker t, DataFlow::Node regex) {
      t.start() and
      result = API::moduleImport("re").getMember("compile").getACall() and
      regex in [
          result.(DataFlow::CallCfgNode).getArg(0),
          result.(DataFlow::CallCfgNode).getArgByName("pattern")
        ]
      or
      exists(DataFlow::TypeTracker t2 | result = compiledRegex(t2, regex).track(t2, t))
    }

    DataFlow::Node compiledRegex(DataFlow::Node regex) {
      compiledRegex(DataFlow::TypeTracker::end(), regex).flowsTo(result)
    }
  }

  private import CompiledRegexes

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

    CompiledRegexExecution() { this.calls(compiledRegex(regexNode), method) }

    override DataFlow::Node getRegex() { result = regexNode }

    override DataFlow::Node getString() {
      result in [this.getArg(method.getStringArgIndex() - 1), this.getArgByName("string")]
    }

    override string getName() { result = "re." + method }
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

  // ---------------------------------------------------------------------------
  // xml.etree.ElementTree
  // ---------------------------------------------------------------------------
  /**
   * An instance of `xml.etree.ElementTree.ElementTree`.
   *
   * See https://docs.python.org/3.10/library/xml.etree.elementtree.html#xml.etree.ElementTree.ElementTree
   */
  private API::Node elementTreeInstance() {
    //parse to a tree
    result =
      API::moduleImport("xml")
          .getMember("etree")
          .getMember("ElementTree")
          .getMember("parse")
          .getReturn()
    or
    // construct a tree without parsing
    result =
      API::moduleImport("xml")
          .getMember("etree")
          .getMember("ElementTree")
          .getMember("ElementTree")
          .getReturn()
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
    result =
      API::moduleImport("xml")
          .getMember("etree")
          .getMember("ElementTree")
          .getMember(["fromstring", "fromstringlist", "XML"])
          .getReturn()
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
  private class UrllibParseUrlsplitCallAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
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
    DataFlow::CallCfgNode {
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
    DataFlow::CallCfgNode {
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
    DataFlow::CallCfgNode {
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
