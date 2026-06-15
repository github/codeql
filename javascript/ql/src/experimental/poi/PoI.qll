/**
 * Provides classes and predicates for discovering points of interest
 * in an unknown code base.
 *
 * To use this module, subclass the
 * `ActivePoI` class, override *one* of its `is` predicates, and use
 * `alertQuery` as a `@kind problem` query .  This will present
 * the desired points of interest as alerts that are easily browsable
 * in a codeql IDE.  By itself, this is no different from an ordinary
 * query, but the strength of this module lies in its extensibility
 * and standard library:
 *
 * - points of interest can be added, removed and mixed seamlessly
 * - this module comes with a collection of standard points of interest (see `StandardPoIs`)
 *
 * A global configuration for the points of interest (see
 * `PoIConfiguration`) can be used to easily manage multiple points of
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
 * class Configuration extends PoIConfiguration {
 *   Configuration() { this = "Configuration" }
 *
 *   override predicate shown(DataFlow::Node n) { n.getFile().getBaseName() = "server-core.js" }
 * }
 *
 * class RouteHandlerPoI extends ActivePoI {
 *   RouteHandlerPoI() { this = "RouteHandlerPoI" }
 *   override predicate is(DataFlow::Node l0) { l0 instanceof Express::RouteHandler }
 * }
 *
 * class RouteSetupAndRouteHandlerPoI extends ActivePoI {
 *   RouteSetupAndRouteHandlerPoI() { this = "RouteSetupAndRouteHandlerPoI" }
 *
 *   override predicate is(DataFlow::Node l0, DataFlow::Node l1, string t1) {
 *     l0.asExpr().(Express::RouteSetup).getARouteHandler() = l1 and t1 = "routehandler"
 *   }
 * }
 *
 * query predicate problems = alertQuery/6;
 * ```
 */

import javascript
private import DataFlow
private import semmle.javascript.filters.ClassifyFiles
private import semmle.javascript.RestrictedLocations

/**
 * Provides often used points of interest.
 *
 * Note that these points of interest should not extend
 * `ActivePoI`, and that they can be enabled on
 * demand like this:
 *
 * ```
 * class MyPoI extends ServerRelatedPoI, ActivePoI {}
 * ```
 */
private module StandardPoIs {
  /**
   * An unpromoted route setup candidate.
   */
  class UnpromotedRouteSetupPoI extends PoI {
    UnpromotedRouteSetupPoI() { this = "UnpromotedRouteSetupPoI" }

    override predicate is(Node l0) {
      l0 instanceof Http::RouteSetupCandidate and not l0 instanceof Http::RouteSetup
    }
  }

  /**
   * An unpromoted route handler candidate.
   */
  class UnpromotedRouteHandlerPoI extends PoI {
    UnpromotedRouteHandlerPoI() { this = "UnpromotedRouteHandlerPoI" }

    override predicate is(Node l0) {
      l0 instanceof Http::RouteHandlerCandidate and not l0 instanceof Http::RouteHandler
    }
  }

  /**
   * An unpromoted route handler candidate, with explanatory data flow information.
   */
  class UnpromotedRouteHandlerWithFlowPoI extends PoI {
    UnpromotedRouteHandlerWithFlowPoI() { this = "UnpromotedRouteHandlerWithFlowPoI" }

    private DataFlow::SourceNode track(Http::RouteHandlerCandidate cand, DataFlow::TypeTracker t) {
      t.start() and
      result = cand
      or
      exists(DataFlow::TypeTracker t2 | result = this.track(cand, t2).track(t2, t))
    }

    override predicate is(Node l0, Node l1, string t1) {
      l0 instanceof Http::RouteHandlerCandidate and
      not l0 instanceof Http::RouteHandler and
      l1 = this.track(l0, TypeTracker::end()) and
      (if l1 = l0 then t1 = "ends here" else t1 = "starts/ends here")
    }
  }

  /**
   * A callee that is unknown.
   */
  class UnknownCalleePoI extends PoI {
    UnknownCalleePoI() { this = "UnknownCalleePoI" }

    override predicate is(Node l0) {
      exists(InvokeNode invk | l0 = invk.getCalleeNode() and not exists(invk.getACallee()))
    }
  }

  /**
   * A source of remote flow.
   */
  class RemoteFlowSourcePoI extends PoI {
    RemoteFlowSourcePoI() { this = "RemoteFlowSourcePoI" }

    override predicate is(Node l0) { l0 instanceof RemoteFlowSource }
  }

  /**
   * Provides groups of often used points of interest.
   */
  module StandardPoIGroups {
    /**
     * A server-related point of interest.
     */
    class ServerRelatedPoI extends PoI {
      ServerRelatedPoI() {
        this instanceof UnpromotedRouteSetupPoI or
        this instanceof UnpromotedRouteHandlerPoI or
        this instanceof UnpromotedRouteHandlerWithFlowPoI
      }
    }
  }

  import StandardPoIGroups
}

import StandardPoIs

/**
 * A tagging interface for a custom point of interest that should be
 * enabled in the absence of an explicit
 * `PoIConfiguration::enabled/1`.
 */
abstract class ActivePoI extends PoI {
  bindingset[this]
  ActivePoI() { any() }
}

private module PoIConfigDefaults {
  predicate enabled(PoI poi) { poi instanceof ActivePoI }

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
    this.is(_) and result = ""
    or
    this.is(_, _, _) and result = "$@"
    or
    this.is(_, _, _, _, _) and result = "$@ $@"
  }
}

/**
 * An alert query for a point of interest.
 *
 * Should be used as:
 *
 * ```
 * query predicate problems = alertQuery/6;
 * ```
 *
 * Or alternatively:
 *
 * ```
 * from Locatable l1line, string msg, Node l2, string s2, Node l3, string s3
 * where alertQuery(l1line, msg, l2, s2, l3, s3)
 * select l1line, msg, l2, s2, l3, s3
 * ```
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
      PoIConfigDefaults::shown(l1)
      or
      exists(PoIConfiguration cfg |
        cfg.enabled(poi) and
        cfg.shown(l1)
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
