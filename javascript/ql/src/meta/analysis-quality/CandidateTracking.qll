/**
 * Provides an auxiliary predicate shared among the unpromoted-candidate queries.
 */

import javascript

/**
 * Gets a source node to which `cand` may flow inter-procedurally, with `t` tracking
 * the state of flow.
 */
DataFlow::SourceNode track(HTTP::RouteHandlerCandidate cand, DataFlow::TypeTracker t) {
  t.start() and
  result = cand
  or
  exists(DataFlow::TypeTracker t2 | result = track(cand, t2).track(t2, t))
}
