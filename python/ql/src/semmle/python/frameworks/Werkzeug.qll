/**
 * Provides classes modeling security-relevant aspects of the `flask` package.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.TaintTracking

/**
 * Provides models for the `Werkzeug` PyPI package.
 * See
 * - https://pypi.org/project/Werkzeug/
 * - https://werkzeug.palletsprojects.com/en/1.0.x/#werkzeug
 */
module Werkzeug {
  /** Provides models for the `werkzeug` module. */
  module werkzeug {
    /** Provides models for the `werkzeug.datastructures` module. */
    module datastructures {
      /**
       * Provides models for the `werkzeug.datastructures.MultiDict` class
       *
       * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.MultiDict.
       */
      module MultiDict {
        /**
         * A source of an instance of `werkzeug.datastructures.MultiDict`.
         *
         * This can include instantiation of the class, return value from function
         * calls, or a special parameter that will be set when functions are call by external
         * library.
         *
         * Use `MultiDict::instance()` predicate to get references to instances of `werkzeug.datastructures.MultiDict`.
         */
        abstract class InstanceSource extends DataFlow::Node { }

        /** Gets a reference to an instance of `werkzeug.datastructures.MultiDict`. */
        private DataFlow::Node instance(DataFlow::TypeTracker t) {
          t.start() and
          result instanceof InstanceSource
          or
          exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
        }

        /** Gets a reference to an instance of `werkzeug.datastructures.MultiDict`. */
        DataFlow::Node instance() { result = instance(DataFlow::TypeTracker::end()) }

        /**
         * Gets a reference to the `getlist` method on an instance of `werkzeug.datastructures.MultiDict`.
         *
         * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.Headers.getlist
         */
        private DataFlow::Node getlist(DataFlow::TypeTracker t) {
          t.startInAttr("getlist") and
          result = instance()
          or
          exists(DataFlow::TypeTracker t2 | result = getlist(t2).track(t2, t))
        }

        /**
         * Gets a reference to the `getlist` method on an instance of `werkzeug.datastructures.MultiDict`.
         *
         * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.Headers.getlist
         */
        DataFlow::Node getlist() { result = getlist(DataFlow::TypeTracker::end()) }
      }

      /**
       * Provides models for the `werkzeug.datastructures.FileStorage` class
       *
       * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.FileStorage.
       */
      module FileStorage {
        /**
         * A source of an instance of `werkzeug.datastructures.FileStorage`.
         *
         * This can include instantiation of the class, return value from function
         * calls, or a special parameter that will be set when functions are called by an external
         * library.
         *
         * Use `FileStorage::instance()` predicate to get references to instances of `werkzeug.datastructures.FileStorage`.
         */
        abstract class InstanceSource extends DataFlow::Node { }

        /** Gets a reference to an instance of `werkzeug.datastructures.FileStorage`. */
        private DataFlow::Node instance(DataFlow::TypeTracker t) {
          t.start() and
          result instanceof InstanceSource
          or
          exists(DataFlow::TypeTracker t2 | result = instance(t2).track(t2, t))
        }

        /** Gets a reference to an instance of `werkzeug.datastructures.FileStorage`. */
        DataFlow::Node instance() { result = instance(DataFlow::TypeTracker::end()) }
      }
    }
  }

  private class MultiDictAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      // obj -> obj.getlist
      exists(DataFlow::AttrRead read |
        read.getObject() = nodeFrom and
        nodeTo = read and
        nodeTo = werkzeug::datastructures::MultiDict::getlist()
      )
      or
      // getlist -> getlist()
      nodeFrom = werkzeug::datastructures::MultiDict::getlist() and
      nodeTo.asCfgNode().(CallNode).getFunction() = nodeFrom.asCfgNode()
    }
  }

  private class FileStorageAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
    override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
      nodeFrom = werkzeug::datastructures::FileStorage::instance() and
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
