/**
 * Provides classes modeling security-relevant aspects of the `fabric` PyPI package, for
 * both version 1.x and 2.x.
 *
 * See
 * - http://docs.fabfile.org/en/1.14/tutorial.html and
 * - http://docs.fabfile.org/en/2.5/getting-started.html
 */

private import python
private import experimental.dataflow.DataFlow
private import experimental.dataflow.RemoteFlowSources
private import experimental.semmle.python.Concepts

/**
 * Provides classes modeling security-relevant aspects of the `fabric` PyPI package, for
 * version 1.x.
 *
 * See http://docs.fabfile.org/en/1.14/tutorial.html.
 */
private module FabricV1 {
  /** Gets a reference to the `fabric` module. */
  private DataFlow::Node fabric(DataFlow::TypeTracker t) {
    t.start() and
    result = DataFlow::importNode("fabric")
    or
    exists(DataFlow::TypeTracker t2 | result = fabric(t2).track(t2, t))
  }

  /** Gets a reference to the `fabric` module. */
  DataFlow::Node fabric() { result = fabric(DataFlow::TypeTracker::end()) }

  /**
   * Gets a reference to the attribute `attr_name` of the `fabric` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node fabric_attr(DataFlow::TypeTracker t, string attr_name) {
    attr_name in ["api"] and
    (
      t.start() and
      result = DataFlow::importNode("fabric" + "." + attr_name)
      or
      t.startInAttr(attr_name) and
      result = fabric()
    )
    or
    // Due to bad performance when using normal setup with `fabric_attr(t2, attr_name).track(t2, t)`
    // we have inlined that code and forced a join
    exists(DataFlow::TypeTracker t2 |
      exists(DataFlow::StepSummary summary |
        fabric_attr_first_join(t2, attr_name, result, summary) and
        t = t2.append(summary)
      )
    )
  }

  pragma[nomagic]
  private predicate fabric_attr_first_join(
    DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res, DataFlow::StepSummary summary
  ) {
    DataFlow::StepSummary::step(fabric_attr(t2, attr_name), res, summary)
  }

  /**
   * Gets a reference to the attribute `attr_name` of the `fabric` module.
   * WARNING: Only holds for a few predefined attributes.
   */
  private DataFlow::Node fabric_attr(string attr_name) {
    result = fabric_attr(DataFlow::TypeTracker::end(), attr_name)
  }

  /** Provides models for the `fabric` module. */
  module fabric {
    // -------------------------------------------------------------------------
    // fabric.api
    // -------------------------------------------------------------------------
    /** Gets a reference to the `fabric.api` module. */
    DataFlow::Node api() { result = fabric_attr("api") }

    /** Provides models for the `fabric.api` module */
    module api {
      /**
       * Gets a reference to the attribute `attr_name` of the `fabric.api` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node api_attr(DataFlow::TypeTracker t, string attr_name) {
        attr_name in ["run", "local", "sudo"] and
        (
          t.start() and
          result = DataFlow::importNode("fabric.api" + "." + attr_name)
          or
          t.startInAttr(attr_name) and
          result = api()
        )
        or
        // Due to bad performance when using normal setup with `api_attr(t2, attr_name).track(t2, t)`
        // we have inlined that code and forced a join
        exists(DataFlow::TypeTracker t2 |
          exists(DataFlow::StepSummary summary |
            api_attr_first_join(t2, attr_name, result, summary) and
            t = t2.append(summary)
          )
        )
      }

      pragma[nomagic]
      private predicate api_attr_first_join(
        DataFlow::TypeTracker t2, string attr_name, DataFlow::Node res,
        DataFlow::StepSummary summary
      ) {
        DataFlow::StepSummary::step(api_attr(t2, attr_name), res, summary)
      }

      /**
       * Gets a reference to the attribute `attr_name` of the `fabric.api` module.
       * WARNING: Only holds for a few predefined attributes.
       */
      private DataFlow::Node api_attr(string attr_name) {
        result = api_attr(DataFlow::TypeTracker::end(), attr_name)
      }

      /**
       * A call to either
       * - `fabric.api.local`
       * - `fabric.api.run`
       * - `fabric.api.sudo`
       * See
       * - https://docs.fabfile.org/en/1.14/api/core/operations.html#fabric.operations.local
       * - https://docs.fabfile.org/en/1.14/api/core/operations.html#fabric.operations.run
       * - https://docs.fabfile.org/en/1.14/api/core/operations.html#fabric.operations.sudo
       */
      private class FabricApiLocalRunSudoCall extends SystemCommandExecution::Range,
        DataFlow::CfgNode {
        override CallNode node;

        FabricApiLocalRunSudoCall() {
          node.getFunction() = api_attr(["local", "run", "sudo"]).asCfgNode()
        }

        override DataFlow::Node getCommand() {
          result.asCfgNode() = [node.getArg(0), node.getArgByName("command")]
        }
      }
    }
  }
}
