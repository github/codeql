/**
 * Provides classes and predicates for discovering points of interest
 * in an unknown code base.
 *
 * To use this module, subclass the
 * `Poi::PoI` class, override *one* of its `is` predicates, and use
 * `PoI::alertQuery` as a `@kind problem` query .  This will present
 * the desired points of interest as alerts that are easily browsable
 * in a codeql IDE.  By itself, this is no different from an ordinary
 * query, but the strength of this module lies in its extensibility
 * and standard library:
 *
 * - points of interest can be added, removed and mixed seamlessly
 * - this module comes with a collection of standard points of interest (see `PoI::StandardPoIs`)
 * - this modules comes with groupings of related points of interest (see `PoI::StandardPoIConfigurations`)
 *
 * A global configuration for the points of interest (see
 * `PoI::PoIConfg`) can be used to easily manage multiple points of
 * interests, and to restrict the points of interest to specific
 * corners of the code base.
 *
 * Below is an example use of this module that will produce an alert
 * for each route handler and route handler setup in a file named
 * "server-core.js". The route setup alerts will contain a link to its
 * associated route handler.
 *
 * ```
 * /**
 *  * @kind problem
 *  *\/
 *
 * import PoI
 *
 * class Configuration extends PoI::PoIConfiguration {
 *   Configuration() { this = "Configuration" }
 *
 *   override predicate shown(DataFlow::Node n) { n.getFile().getBaseName() = "server-core.js" }
 * }
 *
 * class RouteHandlerPoI extends PoI::PoI {
 *   RouteHandlerPoI() { this = "RouteHandlerPoI" }
 *   override predicate is(DataFlow::Node l0) { l0 instanceof Express::RouteHandler }
 * }
 *
 * class RouteSetupAndRouteHandlerPoI extends PoI::PoI {
 *   RouteSetupAndRouteHandlerPoI() { this = "RouteSetupAndRouteHandlerPoI" }
 *
 *   override predicate is(DataFlow::Node l0, DataFlow::Node l1, string t1) {
 *     l0.asExpr().(Express::RouteSetup).getARouteHandler() = l1 and t1 = "routehandler"
 *   }
 * }
 *
 * query predicate problems = PoI::alertQuery/6;
 * ```
 */

import javascript
private import DataFlow
private import filters.ClassifyFiles
private import semmle.javascript.RestrictedLocations

module PoI {
  /**
   * Provides often used points of interest.
   */
  module StandardPoIs {
    /**
     * An unpromoted route setup candidate.
     */
    class UnpromotedRouteSetupPoI extends StandardPoI {
      UnpromotedRouteSetupPoI() { this = "UnpromotedRouteSetupPoI" }

      override predicate is(Node l0) {
        l0 instanceof HTTP::RouteSetupCandidate and not l0.asExpr() instanceof HTTP::RouteSetup
      }
    }

    /**
     * An unpromoted route handler candidate.
     */
    class UnpromotedRouteHandlerPoI extends StandardPoI {
      UnpromotedRouteHandlerPoI() { this = "UnpromotedRouteHandlerPoI" }

      override predicate is(Node l0) {
        l0 instanceof HTTP::RouteHandlerCandidate and not l0 instanceof HTTP::RouteHandler
      }
    }

    /**
     * An unpromoted route handler candidate, with explnatory data flow information.
     */
    class UnpromotedRouteHandlerWithFlowPoI extends StandardPoI {
      UnpromotedRouteHandlerWithFlowPoI() { this = "UnpromotedRouteHandlerWithFlowPoI" }

      private DataFlow::SourceNode track(HTTP::RouteHandlerCandidate cand, DataFlow::TypeTracker t) {
        t.start() and
        result = cand
        or
        exists(DataFlow::TypeTracker t2 | result = track(cand, t2).track(t2, t))
      }

      override predicate is(Node l0, Node l1, string t1) {
        l0 instanceof HTTP::RouteHandlerCandidate and
        not l0 instanceof HTTP::RouteHandler and
        l1 = track(l0, TypeTracker::end()) and
        (if l1 = l0 then t1 = "ends here" else t1 = "starts/ends here")
      }
    }

    /**
     * A callee that is unknown.
     */
    class UnknownCalleePoI extends StandardPoI {
      UnknownCalleePoI() { this = "UnknownCalleePoI" }

      override predicate is(Node l0) {
        exists(InvokeNode invk | l0 = invk.getCalleeNode() and not exists(invk.getACallee()))
      }
    }

    /**
     * A source of remote flow.
     */
    class RemoteFlowSourcePoI extends StandardPoI {
      RemoteFlowSourcePoI() { this = "RemoteFlowSourcePoI" }

      override predicate is(Node l0) { l0 instanceof RemoteFlowSource }
    }

    /**
     * A "source" for any active configuration.
     */
    class SourcePoI extends StandardPoI {
      SourcePoI() { this = "SourcePoI" }

      override predicate is(Node l0) {
        exists(Configuration cfg | cfg.isSource(l0) or cfg.isSource(l0, _))
      }
    }

    /**
     * A "sink" for any active configuration.
     */
    class SinkPoI extends StandardPoI {
      SinkPoI() { this = "SinkPoI" }

      override predicate is(Node l0) {
        exists(Configuration cfg | cfg.isSink(l0) or cfg.isSink(l0, _))
      }
    }

    /**
     * A "barrier" for any active configuration.
     */
    class BarrierPoI extends StandardPoI {
      BarrierPoI() { this = "BarrierPoI" }

      override predicate is(Node l0) {
        exists(Configuration cfg |
          cfg.isBarrier(_) or
          cfg.isBarrierEdge(l0, _) or
          cfg.isBarrierEdge(l0, _, _) or
          cfg.isLabeledBarrier(l0, _)
        )
      }
    }
  }

  /**
   * Provides often used point of interest configurations.
   */
  module StandardPoIConfigurations {
    private import StandardPoIs

    /**
     * A configuration that enables some server related points of interest.
     */
    abstract class ServerPoIConfiguration extends PoIConfiguration {
      bindingset[this]
      ServerPoIConfiguration() { any() }

      override predicate enabled(PoI poi) {
        poi instanceof UnpromotedRouteSetupPoI or
        poi instanceof UnpromotedRouteHandlerPoI or
        poi instanceof UnpromotedRouteHandlerWithFlowPoI
      }
    }

    /**
     * A configuration that enables some `DataFlow::Configuration` related points of interest.
     */
    abstract class DataFlowConfigurationPoIConfiguration extends PoIConfiguration {
      bindingset[this]
      DataFlowConfigurationPoIConfiguration() { any() }

      override predicate enabled(PoI poi) {
        poi instanceof SourcePoI or
        poi instanceof SinkPoI
      }
    }
  }

  /**
   * A tagging interface for the standard points of interest.
   */
  abstract private class StandardPoI extends PoI {
    bindingset[this]
    StandardPoI() { any() }
  }

  private module PoIConfigDefaults {
    predicate enabled(PoI poi) { not poi instanceof StandardPoI }

    predicate shown(Node n) { not classify(n.getFile(), _) }
  }

  /**
   * A configuration for the points of interest to display.
   */
  abstract class PoIConfiguration extends string {
    bindingset[this]
    PoIConfiguration() { any() }

    /**
     * Holds if the points of interest from `poi` should be shown.
     */
    predicate enabled(PoI poi) { PoIConfigDefaults::enabled(poi) }

    /**
     * Holds if the points of interest `n` should be shown.
     */
    predicate shown(Node n) { PoIConfigDefaults::shown(n) }
  }

  /**
   * A class of points of interest.
   *
   * Note that only one of the `is/1`, `is/3`, `is/5` methods should
   * be overridden, as two overrides will degrade the alert UI
   * slightly.
   */
  abstract class PoI extends string {
    bindingset[this]
    PoI() { any() }

    /**
     * Holds if `l0` is a point of interest.
     */
    predicate is(Node l0) { none() }

    /**
     * Holds if `l0` is a point of interest, with `l1` as an auxiliary location described by `t1`.
     */
    predicate is(Node l0, Node l1, string t1) { none() }

    /**
     * Holds if `l0` is a point of interest, with `l1` and `l2` as auxiliary locations described by `t1` and `t2`.
     */
    predicate is(Node l0, Node l1, string t1, Node l2, string t2) { none() }

    /**
     * Gets the message format for the point of interest.
     */
    string getFormat() {
      is(_) and result = ""
      or
      is(_, _, _) and result = "$@"
      or
      is(_, _, _, _, _) and result = "$@ $@"
    }
  }

  /**
   * An alert query for a point of interest.
   *
   * Should be used as: `query predicate problems = PoI::alertQuery/6;`
   *
   * Note that some points of interest do not have auxiliary
   * locations, so `l2`,`l3`, `s2`, `s3` may have placeholder values.
   */
  predicate alertQuery(Locatable l1line, string msg, Node l2, string s2, Node l3, string s3) {
    exists(PoI poi, Node l1, string m |
      l1.getAstNode().(FirstLineOf) = l1line and
      (
        not exists(PoIConfiguration cfg) and
        PoIConfigDefaults::enabled(poi) and
        PoIConfigDefaults::shown(l1) and
        PoIConfigDefaults::shown(l2) and
        PoIConfigDefaults::shown(l3)
        or
        exists(PoIConfiguration cfg |
          cfg.enabled(poi) and
          cfg.shown(l1) and
          cfg.shown(l2) and
          cfg.shown(l3)
        )
      ) and
      m = poi.getFormat() and
      if m = "" then msg = poi else msg = poi + ": " + m
    |
      poi.is(l1) and
      l1 = l2 and
      s2 = "irrelevant" and
      l1 = l3 and
      s3 = "irrelevant"
      or
      poi.is(l1, l2, s2) and
      l1 = l3 and
      s3 = "irrelevant"
      or
      poi.is(l1, l2, s2, l3, s3)
    )
  }
}
