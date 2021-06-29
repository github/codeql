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
        /** DEPRECATED. Use `InstanceSourceApiNode` instead. */
        abstract deprecated class InstanceSource extends DataFlow::Node { }

        /**
         * A source of instances of `werkzeug.datastructures.MultiDict`, extend this class to model new instances.
         *
         * This can include instantiations of the class, return values from function
         * calls, or a special parameter that will be set when functions are called by an external
         * library.
         *
         * Use the predicate `MultiDict::instance()` to get references to instances of `werkzeug.datastructures.MultiDict`.
         */
        abstract class InstanceSourceApiNode extends API::Node { }

        /**
         * Gets a reference to the `getlist` method on an instance of `werkzeug.datastructures.MultiDict`.
         *
         * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.Headers.getlist
         */
        DataFlow::Node getlist() {
          result = any(InstanceSourceApiNode a).getMember("getlist").getAUse()
        }
      }

      /**
       * Provides models for the `werkzeug.datastructures.FileStorage` class
       *
       * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.FileStorage.
       */
      module FileStorage {
        /** DEPRECATED. Use `InstanceSourceApiNode` instead. */
        abstract deprecated class InstanceSource extends DataFlow::Node { }

        /**
         * A source of instances of `werkzeug.datastructures.FileStorage`, extend this class to model new instances.
         *
         * This can include instantiations of the class, return values from function
         * calls, or a special parameter that will be set when functions are called by an external
         * library.
         *
         * Use the predicate `FileStorage::instance()` to get references to instances of `werkzeug.datastructures.FileStorage`.
         */
        abstract class InstanceSourceApiNode extends API::Node { }

        /** Gets a reference to an instance of `werkzeug.datastructures.FileStorage`. */
        DataFlow::Node instance() { result = any(InstanceSourceApiNode a).getAUse() }
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
      nodeTo.(DataFlow::CallCfgNode).getFunction() = nodeFrom
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
