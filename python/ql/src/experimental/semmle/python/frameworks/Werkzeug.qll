/**
 * Provides classes modeling security-relevant aspects of the `flask` package.
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.TaintTracking

// for old impl see
// https://github.com/github/codeql/blob/9f95212e103c68d0c1dfa4b6f30fb5d53954ccef/python/ql/src/semmle/python/libraries/Werkzeug.qll
module Werkzeug {
  module Datastructures {
    // ---------------------------------------------------------------------- //
    // MultiDict                                                              //
    // ---------------------------------------------------------------------- //
    /**
     * A Node representing an instance of a werkzeug.datastructures.MultiDict
     *
     * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.MultiDict
     */
    abstract class MultiDict extends DataFlow::Node { }

    private module MultiDictTracking {
      private DataFlow::Node getlist(DataFlow::TypeTracker t) {
        t.startInAttr("getlist") and
        result instanceof MultiDict
        or
        exists(DataFlow::TypeTracker t2 | result = getlist(t2).track(t2, t))
      }

      DataFlow::Node getlist() { result = getlist(DataFlow::TypeTracker::end()) }
    }

    private class MultiDictAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        // obj -> obj.getlist
        nodeTo.asCfgNode().(AttrNode).getObject("getlist") = nodeFrom.asCfgNode() and
        nodeTo = MultiDictTracking::getlist()
        or
        // getlist -> getlist()
        nodeFrom = MultiDictTracking::getlist() and
        nodeTo.asCfgNode().(CallNode).getFunction() = nodeFrom.asCfgNode()
      }
    }

    // ---------------------------------------------------------------------- //
    // FileStorage                                                              //
    // ---------------------------------------------------------------------- //
    /**
     * A Node representing an instance of a werkzeug.datastructures.FileStorage
     *
     * See https://werkzeug.palletsprojects.com/en/1.0.x/datastructures/#werkzeug.datastructures.FileStorage
     */
    abstract class FileStorage extends DataFlow::Node { }

    private class FileStorageAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        // TODO: should be `nodeFrom = tracked(any(FileStorage fs))`
        nodeFrom instanceof FileStorage and
        exists(string name |
          name in ["filename",
                // str
                "name", "content_type", "mimetype",
                // file-like
                "stream",
                // TODO: werkzeug.datastructures.Headers
                "headers",
                // dict[str, str]
                "mimetype_params"] and
          nodeTo.asCfgNode().(AttrNode).getObject(name) = nodeFrom.asCfgNode()
        )
      }
    }
  }
}
