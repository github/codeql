import javascript
private import semmle.javascript.dataflow.TypeTracking
private import semmle.javascript.internal.CachedStages
private import FlowSteps

cached
private module Cached {
  cached
  module Public {
    cached
    predicate forceStage() { Stages::TypeTracking::ref() }

    cached
    class PropertyName extends string {
      cached
      PropertyName() {
        this = any(DataFlow::PropRef pr).getPropertyName()
        or
        AccessPath::isAssignedInUniqueFile(this)
        or
        exists(AccessPath::getAnAssignmentTo(_, this))
        or
        SharedTypeTrackingStep::loadStep(_, _, this)
        or
        SharedTypeTrackingStep::storeStep(_, _, this)
        or
        SharedTypeTrackingStep::loadStoreStep(_, _, this, _)
        or
        SharedTypeTrackingStep::loadStoreStep(_, _, _, this)
        or
        this = DataFlow::PseudoProperties::arrayLikeElement()
      }
    }

    /**
     * A description of a step on an inter-procedural data flow path.
     */
    cached
    newtype TStepSummary =
      LevelStep() or
      CallStep() or
      ReturnStep() or
      StoreStep(PropertyName prop) or
      LoadStep(PropertyName prop) or
      CopyStep(PropertyName prop) or
      LoadStoreStep(PropertyName fromProp, PropertyName toProp) {
        SharedTypeTrackingStep::loadStoreStep(_, _, fromProp, toProp)
      } or
      ReverseLevelStep() or
      ReverseCallStep() or
      ReverseCopyStep(PropertyName prop) or
      ReverseLoadStoreStep(PropertyName fromProp, PropertyName toProp) {
        SharedTypeTrackingStep::loadStoreStep(_, _, fromProp, toProp)
      }
  }

  /**
   * INTERNAL: Use `SourceNode.track()` or `SourceNode.backtrack()` instead.
   */
  cached
  predicate step(DataFlow::SourceNode pred, DataFlow::SourceNode succ, StepSummary summary) {
    stepAux(pred, succ, summary)
    or
    stepAux(succ, pred, summary.reverse())
  }

  private predicate stepAux(DataFlow::SourceNode pred, DataFlow::SourceNode succ, StepSummary summary) {
    exists(DataFlow::Node mid | pred.flowsTo(mid) | smallstepAux(mid, succ, summary))
  }

  /**
   * INTERNAL: Use `TypeBackTracker.smallstep()` instead.
   */
  cached
  predicate smallstep(DataFlow::Node pred, DataFlow::Node succ, StepSummary summary) {
    smallstepAux(pred, succ, summary)
    or
    smallstepAux(succ, pred, summary.reverse())
  }

  private predicate smallstepAux(DataFlow::Node pred, DataFlow::Node succ, StepSummary summary) {
    // Flow through properties of objects
    propertyFlowStep(pred, succ) and
    summary = LevelStep()
    or
    // Flow through global variables
    globalFlowStep(pred, succ) and
    summary = LevelStep()
    or
    // Flow into function
    callStep(pred, succ) and
    summary = CallStep()
    or
    // Flow out of function
    returnStep(pred, succ) and
    summary = ReturnStep()
    or
    // Flow through an instance field between members of the same class
    DataFlow::localFieldStep(pred, succ) and
    summary = LevelStep()
    or
    exists(string prop |
      basicStoreStep(pred, succ, prop) and
      summary = StoreStep(prop)
      or
      basicLoadStep(pred, succ, prop) and
      summary = LoadStep(prop)
      or
      SharedTypeTrackingStep::storeStep(pred, succ, prop) and
      summary = StoreStep(prop)
      or
      SharedTypeTrackingStep::loadStep(pred, succ, prop) and
      summary = LoadStep(prop)
      or
      SharedTypeTrackingStep::loadStoreStep(pred, succ, prop) and
      summary = CopyStep(prop)
    )
    or
    exists(string fromProp, string toProp |
      SharedTypeTrackingStep::loadStoreStep(pred, succ, fromProp, toProp) and
      summary = LoadStoreStep(fromProp, toProp)
    )
    or
    SharedTypeTrackingStep::step(pred, succ) and
    summary = LevelStep()
    or
    // Store to global access path
    exists(string name |
      pred = AccessPath::getAnAssignmentTo(name) and
      AccessPath::isAssignedInUniqueFile(name) and
      succ = DataFlow::globalAccessPathRootPseudoNode() and
      summary = StoreStep(name)
    )
    or
    // Load from global access path
    exists(string name |
      succ = AccessPath::getAReferenceTo(name) and
      AccessPath::isAssignedInUniqueFile(name) and
      pred = DataFlow::globalAccessPathRootPseudoNode() and
      summary = LoadStep(name)
    )
    or
    // Store to non-global access path
    exists(string name |
      pred = AccessPath::getAnAssignmentTo(succ, name) and
      summary = StoreStep(name)
    )
    or
    // Load from non-global access path
    exists(string name |
      succ = AccessPath::getAReferenceTo(pred, name) and
      summary = LoadStep(name) and
      name != ""
    )
    or
    // Summarize calls with flow directly from a parameter to a return.
    exists(DataFlow::ParameterNode param, DataFlow::FunctionNode fun |
      (
        param.flowsTo(fun.getAReturn()) and
        summary = LevelStep()
        or
        exists(string prop |
          param.getAPropertyRead(prop).flowsTo(fun.getAReturn()) and
          summary = LoadStep(prop)
        )
      ) and
      if param = fun.getAParameter()
      then
        // Step from argument to call site.
        argumentPassing(succ, pred, fun.getFunction(), param)
      else (
        // Step from captured parameter to local call sites
        pred = param and
        succ = fun.getAnInvocation()
      )
    )
  }
}

import Cached::Public

class OptionalPropertyName extends string {
  OptionalPropertyName() { this instanceof PropertyName or this = "" }
}

/**
 * INTERNAL: Use `TypeTracker` or `TypeBackTracker` instead.
 *
 * A description of a step on an inter-procedural data flow path.
 */
class StepSummary extends TStepSummary {
  /** Gets a textual representation of this step summary. */
  string toString() {
    this instanceof LevelStep and result = "level"
    or
    this instanceof CallStep and result = "call"
    or
    this instanceof ReturnStep and result = "return"
    or
    exists(string prop | this = StoreStep(prop) | result = "store " + prop)
    or
    exists(string prop | this = LoadStep(prop) | result = "load " + prop)
    or
    exists(string prop | this = CopyStep(prop) | result = "copy " + prop)
    or
    exists(string fromProp, string toProp | this = LoadStoreStep(fromProp, toProp) |
      result = "load " + fromProp + " and store to " + toProp
    )
    or
    this instanceof ReverseLevelStep and result = "reverse level"
    or
    this instanceof ReverseCallStep and result = "reverse call"
    or
    exists(string prop | this = ReverseCopyStep(prop) | result = "reverse copy " + prop)
    or
    exists(string fromProp, string toProp | this = ReverseLoadStoreStep(fromProp, toProp) |
      result = "reverse load " + fromProp + " and store to " + toProp
    )
  }

  /**
   * Maps a forward step to the corresponding reverse step, if any.
   * Does not map reverse steps back to forward steps.
   */
  StepSummary toReverse() {
    this = LevelStep() and result = ReverseLevelStep()
    or
    this = CallStep() and result = ReverseCallStep()
    or
    exists(PropertyName prop |
      this = CopyStep(prop) and result = ReverseCopyStep(prop)
    )
    or
    exists(PropertyName fromProp, PropertyName toProp |
      this = LoadStoreStep(fromProp, toProp) and
      result = ReverseLoadStoreStep(fromProp, toProp)
    )
  }

  /**
   * Maps a forward step to the correpsonding reverse step, if any,
   * and vice versa.
   */
  StepSummary reverse() {
    result = this.toReverse()
    or
    result.toReverse() = this
  }
}

module StepSummary {
  /**
   * INTERNAL: Use `SourceNode.track()` or `SourceNode.backtrack()` instead.
   */
  predicate step = Cached::step/3;

  /**
   * INTERNAL: Use `TypeBackTracker.smallstep()` instead.
   */
  predicate smallstep = Cached::smallstep/3;
}
