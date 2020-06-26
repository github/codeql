import javascript
private import semmle.javascript.dataflow.TypeTracking
private import FlowSteps

class PropertyName extends string {
  PropertyName() {
    this = any(DataFlow::PropRef pr).getPropertyName()
    or
    AccessPath::isAssignedInUniqueFile(this)
    or
    exists(AccessPath::getAnAssignmentTo(_, this))
    or
    this instanceof TypeTrackingPseudoProperty
  }
}

class OptionalPropertyName extends string {
  OptionalPropertyName() { this instanceof PropertyName or this = "" }
}

/**
 * A pseudo-property that can be used in type-tracking.
 */
abstract class TypeTrackingPseudoProperty extends string {
  bindingset[this]
  TypeTrackingPseudoProperty() { any() }

  /**
   * Gets a property name that `this` can be copied to in a `LoadStoreStep(this, result)`.
   */
  string getLoadStoreToProp() { none() }
}

/**
 * A description of a step on an inter-procedural data flow path.
 */
newtype TStepSummary =
  LevelStep() or
  CallStep() or
  ReturnStep() or
  StoreStep(PropertyName prop) or
  LoadStep(PropertyName prop) or
  CopyStep(PropertyName prop) or
  LoadStoreStep(PropertyName fromProp, PropertyName toProp) {
    exists(TypeTrackingPseudoProperty prop | fromProp = prop and toProp = prop.getLoadStoreToProp())
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
  }
}

module StepSummary {
  /**
   * INTERNAL: Use `SourceNode.track()` or `SourceNode.backtrack()` instead.
   */
  cached
  predicate step(DataFlow::SourceNode pred, DataFlow::SourceNode succ, StepSummary summary) {
    exists(DataFlow::Node mid | pred.flowsTo(mid) | smallstep(mid, succ, summary))
  }

  /**
   * INTERNAL: Use `TypeBackTracker.smallstep()` instead.
   */
  predicate smallstep(DataFlow::Node pred, DataFlow::Node succ, StepSummary summary) {
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
      any(AdditionalTypeTrackingStep st).storeStep(pred, succ, prop) and
      summary = StoreStep(prop)
      or
      any(AdditionalTypeTrackingStep st).loadStep(pred, succ, prop) and
      summary = LoadStep(prop)
      or
      any(AdditionalTypeTrackingStep st).loadStoreStep(pred, succ, prop) and
      summary = CopyStep(prop)
    )
    or
    any(AdditionalTypeTrackingStep st).step(pred, succ) and
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
