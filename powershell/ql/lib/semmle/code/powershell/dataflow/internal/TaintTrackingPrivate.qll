private import powershell
private import DataFlowPrivate
private import TaintTrackingPublic
private import semmle.code.powershell.Cfg
private import semmle.code.powershell.dataflow.DataFlow

/**
 * Holds if `node` should be a sanitizer in all global taint flow configurations
 * but not in local taint.
 */
predicate defaultTaintSanitizer(DataFlow::Node node) { none() }

/**
 * Holds if default `TaintTracking::Configuration`s should allow implicit reads
 * of `c` at sinks and inputs to additional taint steps.
 */
bindingset[node]
predicate defaultImplicitTaintRead(DataFlow::Node node, DataFlow::ContentSet c) { none() }

cached
private module Cached {
  private import semmle.code.powershell.dataflow.internal.DataFlowImplCommon as DataFlowImplCommon

  cached
  predicate forceCachingInSameStage() { DataFlowImplCommon::forceCachingInSameStage() }

  /**
   * Holds if the additional step from `nodeFrom` to `nodeTo` should be included
   * in all global taint flow configurations.
   */
  cached
  predicate defaultAdditionalTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo, string model) {
    // Although flow through collections is modeled precisely using stores/reads, we still
    // allow flow out of a _tainted_ collection. This is needed in order to support taint-
    // tracking configurations where the source is a collection.
    exists(DataFlow::ContentSet c | readStep(nodeFrom, c, nodeTo) |
      c.isSingleton(any(DataFlow::Content::ElementContent ec))
      or
      c.isKnownOrUnknownElement(_)
      // or
      // TODO: We do't generate this one from readSteps yet, but we will as
      // soon as we start on models-as-data.
      // c.isAnyElement()
    ) and
    model = ""
  }

  /**
   * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
   * (intra-procedural) step.
   */
  cached
  predicate localTaintStepCached(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    DataFlow::localFlowStep(nodeFrom, nodeTo) or
    defaultAdditionalTaintStep(nodeFrom, nodeTo, _)
  }
}

import Cached
