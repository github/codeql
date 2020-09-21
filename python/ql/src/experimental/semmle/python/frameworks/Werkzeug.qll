/**
 * Provides classes modeling security-relevant aspects of the `flask` package.
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.TaintTracking

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

    private DataFlow::Node multiDictTrack(MultiDict multiDict, DataFlow::TypeTracker t) {
      t.start() and
      result instanceof MultiDict
      or
      exists(DataFlow::TypeTracker t2 | result = multiDictTrack(multiDict, t2).track(t2, t))
    }

    /** Gets a reference to the MultiDict attributes of `flask.request`. */
    private DataFlow::Node multiDictTrack(MultiDict multiDict) {
      result = multiDictTrack(multiDict, DataFlow::TypeTracker::end())
    }

    class MultiDictTracked extends DataFlow::Node, DataFlow::DictLike {
      MultiDict multiDict;

      MultiDictTracked() { this = multiDictTrack(multiDict) }

      MultiDict getMultiDict() { result = multiDict }

      override DataFlow::Node getElementAccess() {
        result = DataFlow::DictLike.super.getElementAccess()
        or
        exists(MultiDictGetListCallResultTracked tracked_call_result |
          tracked_call_result.getCall().getMultiDict() = this and
          result = tracked_call_result.getElementAccess()
        )
      }
    }

    private DataFlow::Node multiDictGetListTrack(MultiDictTracked multiDict, DataFlow::TypeTracker t) {
      /*
       * using t.startInAttr("getlist") was not good solution
       * ```py
       * a = request.args
       * b = a
       * a.getlist("key")
       * b.getlist("key")
       * ```
       * would give `request.args` -> `b.getlist` -- this is correct, but not helpful in a taint-path explanation,
       * we REALLY WANT it to be `request.args -> a -> b -> b.getlist`
       * This requirement means that we do need the predicate `multiDictTrack`, which could be spared otherwise.
       */

      t.start() and
      result.asCfgNode().(AttrNode).getObject("getlist") = multiDict.asCfgNode()
      or
      exists(DataFlow::TypeTracker t2 | result = multiDictGetListTrack(multiDict, t2).track(t2, t))
    }

    private DataFlow::Node multiDictGetListTrack(MultiDictTracked multiDict) {
      result = multiDictGetListTrack(multiDict, DataFlow::TypeTracker::end())
    }

    private class MultiDictGetListCall extends DataFlow::Node {
      MultiDictTracked multiDict;

      MultiDictGetListCall() {
        this.asCfgNode().(CallNode).getFunction() = multiDictGetListTrack(multiDict).asCfgNode()
      }

      MultiDictTracked getMultiDict() { result = multiDict }
    }

    private DataFlow::Node multiDictGetListCallTrack(
      MultiDictGetListCall call, DataFlow::TypeTracker t
    ) {
      t.start() and
      result = call
      or
      exists(DataFlow::TypeTracker t2 | result = multiDictGetListCallTrack(call, t2).track(t2, t))
    }

    /** Gets a reference to the MultiDict attributes of `flask.request`. */
    private DataFlow::Node multiDictGetListCallTrack(MultiDictGetListCall call) {
      result = multiDictGetListCallTrack(call, DataFlow::TypeTracker::end())
    }

    private class MultiDictGetListCallResultTracked extends DataFlow::Node, DataFlow::ListLike {
      MultiDictGetListCall call;

      MultiDictGetListCallResultTracked() { this = multiDictGetListCallTrack(call) }

      MultiDictGetListCall getCall() { result = call }
    }

    private class MultiDictAdditionalTaintStep extends TaintTracking::AdditionalTaintStep {
      override predicate step(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
        nodeTo.(MultiDictGetListCall).getMultiDict() = nodeFrom.(MultiDictTracked)
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
