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
      DataFlow::LocalSourceNode { }

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

  import WerkzeugOld
}

/**
 * Old version that contains the deprecated modules.
 */
private module WerkzeugOld {
  /**
   * DEPRECATED: Use the modeling available directly in the `Werkzeug` module instead.
   *
   * Provides models for the `werkzeug` module.
   */
  deprecated module werkzeug {
    /**
     * DEPRECATED: Use the modeling available directly in the `Werkzeug` module instead.
     *
     * Provides models for the `werkzeug.datastructures` module.
     */
    deprecated module datastructures {
      /**
       * DEPRECATED: Use `Werkzeug::MultiDict` instead.
       *
       * Provides models for the `werkzeug.datastructures.MultiDict` class
       *
       * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.MultiDict.
       */
      deprecated module MultiDict {
        /**
         * DEPRECATED. Use `Werkzeug::MultiDict::InstanceSource` instead.
         */
        abstract deprecated class InstanceSource extends DataFlow::Node { }

        /**
         * DEPRECATED. Use `Werkzeug::MultiDict::InstanceSource` instead.
         *
         * A source of instances of `werkzeug.datastructures.MultiDict`, extend this class to model new instances.
         *
         * This can include instantiations of the class, return values from function
         * calls, or a special parameter that will be set when functions are called by an external
         * library.
         *
         * Use the predicate `MultiDict::instance()` to get references to instances of `werkzeug.datastructures.MultiDict`.
         */
        abstract deprecated class InstanceSourceApiNode extends API::Node { }

        /**
         * DEPRECATED
         *
         * Gets a reference to the `getlist` method on an instance of `werkzeug.datastructures.MultiDict`.
         *
         * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.Headers.getlist
         */
        deprecated DataFlow::Node getlist() {
          result = any(InstanceSourceApiNode a).getMember("getlist").getAUse()
        }

        private class MultiDictAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
          override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
            // obj -> obj.getlist
            exists(DataFlow::AttrRead read |
              read.getObject() = nodeFrom and
              nodeTo = read and
              nodeTo = getlist()
            )
            or
            // getlist -> getlist()
            nodeFrom = getlist() and
            nodeTo.(DataFlow::CallCfgNode).getFunction() = nodeFrom
          }
        }
      }

      /**
       * DEPRECATED: Use `Werkzeug::FileStorage` instead.
       *
       * Provides models for the `werkzeug.datastructures.FileStorage` class
       *
       * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.FileStorage.
       */
      deprecated module FileStorage {
        /**
         * DEPRECATED. Use `Werkzeug::FileStorage::InstanceSource` instead.
         */
        abstract deprecated class InstanceSource extends DataFlow::Node { }

        /**
         * DEPRECATED. Use `Werkzeug::FileStorage::InstanceSource` instead.
         *
         * A source of instances of `werkzeug.datastructures.FileStorage`, extend this class to model new instances.
         *
         * This can include instantiations of the class, return values from function
         * calls, or a special parameter that will be set when functions are called by an external
         * library.
         *
         * Use the predicate `FileStorage::instance()` to get references to instances of `werkzeug.datastructures.FileStorage`.
         */
        abstract deprecated class InstanceSourceApiNode extends API::Node { }

        /** Gets a reference to an instance of `werkzeug.datastructures.FileStorage`. */
        deprecated DataFlow::Node instance() { result = any(InstanceSourceApiNode a).getAUse() }

        private class FileStorageAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
          override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
            nodeFrom = instance() and
            exists(DataFlow::AttrRead read | nodeTo = read |
              read.getAttributeName() in [
                  // str
                  "filename", "name", "content_type", "mimetype",
                  // file-like
                  "stream",
                  // TODO: werkzeug.datastructures.Headers
                  "headers",
                  // dict[str, str]
                  "mimetype_params"
                ] and
              read.getObject() = nodeFrom
            )
          }
        }
      }
    }
  }
}
