/**
 * Provides classes modeling security-relevant aspects of the `Werkzeug` PyPI package.
 * See
 * - https://pypi.org/project/Werkzeug/
 * - https://werkzeug.palletsprojects.com/en/1.0.x/#werkzeug
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking
private import semmle.python.ApiGraphs
private import semmle.python.frameworks.Stdlib
private import semmle.python.Concepts
private import semmle.python.frameworks.internal.InstanceTaintStepsHelper
private import semmle.python.frameworks.data.ModelsAsData

/**
 * Provides models for the `Werkzeug` PyPI package.
 * See
 * - https://pypi.org/project/Werkzeug/
 * - https://werkzeug.palletsprojects.com/en/1.0.x/#werkzeug
 */
module Werkzeug {
  /**
   * Provides models for the `werkzeug.datastructures.MultiDict` class
   *
   * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.MultiDict.
   */
  module MultiDict {
    /**
     * A source of instances of `werkzeug.datastructures.MultiDict`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `MultiDict::instance()` to get references to instances of `werkzeug.datastructures.MultiDict`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `werkzeug.datastructures.MultiDict`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `werkzeug.datastructures.MultiDict`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `werkzeug.datastructures.MultiDict`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "werkzeug.datastructures.MultiDict" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() { none() }

      override string getMethodName() { result = "getlist" }

      override string getAsyncMethodName() { none() }
    }
  }

  /**
   * Provides models for the `werkzeug.datastructures.FileStorage` class
   *
   * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.FileStorage.
   */
  module FileStorage {
    /**
     * A source of instances of `werkzeug.datastructures.FileStorage`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `FileStorage::instance()` to get references to instances of `werkzeug.datastructures.FileStorage`.
     */
    // All the attributes of the wrapper stream are proxied by the file storage so it’s
    // possible to do storage.read() instead of the long form storage.stream.read(). So
    // that's why InstanceSource also extends `Stdlib::FileLikeObject::InstanceSource`
    abstract class InstanceSource extends Stdlib::FileLikeObject::InstanceSource,
      DataFlow::LocalSourceNode
    { }

    /** Gets a reference to an instance of `werkzeug.datastructures.FileStorage`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `werkzeug.datastructures.FileStorage`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `werkzeug.datastructures.FileStorage`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "werkzeug.datastructures.FileStorage" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() {
        result in [
            // str
            "filename", "name", "content_type", "mimetype",
            // file-like
            "stream",
            // TODO: werkzeug.datastructures.Headers
            "headers",
            // dict[str, str]
            "mimetype_params"
          ]
      }

      override string getMethodName() { none() }

      override string getAsyncMethodName() { none() }
    }

    /** A file-like object instance that originates from a `FileStorage`. */
    private class FileStorageFileLikeInstances extends Stdlib::FileLikeObject::InstanceSource {
      FileStorageFileLikeInstances() { this.(DataFlow::AttrRead).accesses(instance(), "stream") }
    }

    /** A call to the `save` method of a `FileStorage`. */
    private class FileStorageSaveCall extends FileSystemAccess::Range, DataFlow::MethodCallNode {
      FileStorageSaveCall() { this.calls(instance(), "save") }

      override DataFlow::Node getAPathArgument() {
        result in [this.getArg(0), this.getArgByName("dst")]
      }
    }
  }

  /**
   * Provides models for the `werkzeug.datastructures.Headers` class
   *
   * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.Headers.
   */
  module Headers {
    /** Gets a reference to the `werkzeug.datastructures.Headers` class. */
    API::Node classRef() {
      result = API::moduleImport("werkzeug").getMember("datastructures").getMember("Headers")
      or
      result = ModelOutput::getATypeNode("werkzeug.datastructures.Headers~Subclass").getASubclass*()
    }

    /** A direct instantiation of `werkzeug.datastructures.Headers`. */
    private class ClassInstantiation extends InstanceSource, DataFlow::CallCfgNode {
      ClassInstantiation() { this = classRef().getACall() }
    }

    /**
     * A source of instances of `werkzeug.datastructures.Headers`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `Headers::instance()` to get references to instances of `werkzeug.datastructures.Headers`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `werkzeug.datastructures.Headers`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `werkzeug.datastructures.Headers`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `werkzeug.datastructures.Headers`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "werkzeug.datastructures.Headers" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() { none() }

      override string getMethodName() {
        result in ["getlist", "get_all", "popitem", "to_wsgi_list"]
      }

      override string getAsyncMethodName() { none() }
    }

    /** A call to a method that writes to a header, assumed to be a response header. */
    private class HeaderWriteCall extends Http::Server::ResponseHeaderWrite::Range,
      DataFlow::MethodCallNode
    {
      HeaderWriteCall() {
        this.calls(instance(), ["add", "add_header", "set", "setdefault", "__setitem__"])
      }

      override DataFlow::Node getNameArg() { result = this.getArg(0) }

      override DataFlow::Node getValueArg() { result = this.getArg(1) }

      override predicate nameAllowsNewline() { any() }

      override predicate valueAllowsNewline() { none() }
    }

    /** A dict-like write to a header, assumed to be a response header. */
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

      override predicate nameAllowsNewline() { any() }

      override predicate valueAllowsNewline() { none() }
    }

    /** A call to `Headers.extend`, assumed to be a response header. */
    private class HeaderExtendCall extends Http::Server::ResponseHeaderBulkWrite::Range,
      DataFlow::MethodCallNode
    {
      HeaderExtendCall() { this.calls(instance(), "extend") }

      override DataFlow::Node getBulkArg() { result = this.getArg(0) }

      override predicate nameAllowsNewline() { any() }

      override predicate valueAllowsNewline() { none() }
    }
  }

  /**
   * Provides models for the `werkzeug.datastructures.Authorization` class
   *
   * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.Authorization.
   */
  module Authorization {
    /**
     * A source of instances of `werkzeug.datastructures.Authorization`, extend this class to model new instances.
     *
     * This can include instantiations of the class, return values from function
     * calls, or a special parameter that will be set when functions are called by an external
     * library.
     *
     * Use the predicate `Authorization::instance()` to get references to instances of `werkzeug.datastructures.Authorization`.
     */
    abstract class InstanceSource extends DataFlow::LocalSourceNode { }

    /** Gets a reference to an instance of `werkzeug.datastructures.Authorization`. */
    private DataFlow::TypeTrackingNode instance(DataFlow::TypeTracker t) {
      t.start() and
      result instanceof InstanceSource
      or
      exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
    }

    /** Gets a reference to an instance of `werkzeug.datastructures.Authorization`. */
    DataFlow::Node instance() { instance(DataFlow::TypeTracker::end()).flowsTo(result) }

    /**
     * Taint propagation for `werkzeug.datastructures.Authorization`.
     */
    private class InstanceTaintSteps extends InstanceTaintStepsHelper {
      InstanceTaintSteps() { this = "werkzeug.datastructures.Authorization" }

      override DataFlow::Node getInstance() { result = instance() }

      override string getAttributeName() {
        result in [
            "username", "password", "realm", "nonce", "uri", "nc", "cnonce", "response", "opaque",
            "qop"
          ]
      }

      override string getMethodName() { none() }

      override string getAsyncMethodName() { none() }
    }
  }
}
