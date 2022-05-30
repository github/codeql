/**
 * Provides predicates for measuring the quality of the call graph, that is,
 * the number of calls that could be resolved to a target.
 */

import python
import meta.MetaMetrics

newtype TTarget =
  TFunction(Function func) or
  TClass(Class cls)

class Target extends TTarget {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Gets the location of this dataflow call. */
  abstract Location getLocation();

  /** Whether this target is relevant. */
  predicate isRelevant() { exists(this.getLocation().getFile().getRelativePath()) }
}

class TargetFunction extends Target, TFunction {
  Function func;

  TargetFunction() { this = TFunction(func) }

  override string toString() { result = func.toString() }

  override Location getLocation() { result = func.getLocation() }

  Function getFunction() { result = func }
}

class TargetClass extends Target, TClass {
  Class cls;

  TargetClass() { this = TClass(cls) }

  override string toString() { result = cls.toString() }

  override Location getLocation() { result = cls.getLocation() }

  Class getClass() { result = cls }
}

/**
 * A call that is (possibly) relevant for analysis quality.
 * See `IgnoredFile` for details on what is excluded.
 */
class RelevantCall extends CallNode {
  RelevantCall() { not this.getLocation().getFile() instanceof IgnoredFile }
}

/** Provides classes for call-graph resolution by using points-to. */
module PointsToBasedCallGraph {
  /** A call that can be resolved by points-to. */
  class ResolvableCall extends RelevantCall {
    Value targetValue;

    ResolvableCall() { targetValue.getACall() = this }

    /** Gets a resolved target of this call. */
    Target getTarget() {
      result.(TargetFunction).getFunction() = targetValue.(CallableValue).getScope()
      or
      result.(TargetClass).getClass() = targetValue.(ClassValue).getScope()
    }
  }

  /** A call that cannot be resolved by points-to. */
  class UnresolvableCall extends RelevantCall {
    UnresolvableCall() { not this instanceof ResolvableCall }
  }

  /**
   * A call that can be resolved by points-to, where the resolved target is relevant.
   * Relevant targets include:
   * - source code of the project
   */
  class ResolvableCallRelevantTarget extends ResolvableCall {
    ResolvableCallRelevantTarget() {
      exists(Target target | target = getTarget() |
        exists(target.getLocation().getFile().getRelativePath())
      )
    }
  }

  /**
   * A call that can be resolved by points-to, where the resolved target is not considered relevant.
   * See `ResolvableCallRelevantTarget` for the definition of relevance.
   */
  class ResolvableCallIrrelevantTarget extends ResolvableCall {
    ResolvableCallIrrelevantTarget() { not this instanceof ResolvableCallRelevantTarget }
  }
}

/** Provides classes for call-graph resolution by using type-tracking. */
module TypeTrackingBasedCallGraph {
  private import semmle.python.dataflow.new.internal.DataFlowDispatch as TT

  /** A call that can be resolved by type-tracking. */
  class ResolvableCall extends RelevantCall {
    TT::DataFlowCallable dataflowTarget;

    ResolvableCall() { dataflowTarget = TT::viableCallable(TT::TNormalCall(this)) }

    /** Gets a resolved target of this call. */
    Target getTarget() {
      result.(TargetFunction).getFunction() = dataflowTarget.(TT::DataFlowFunction).getScope()
      // TODO: class calls
      // result.(TargetClass).getClass()
    }
  }

  /** A call that cannot be resolved by type-tracking. */
  class UnresolvableCall extends RelevantCall {
    UnresolvableCall() { not this instanceof ResolvableCall }
  }

  /**
   * A call that can be resolved by type-tracking, where the resolved callee is relevant.
   * Relevant targets include:
   * - source code of the project
   */
  class ResolvableCallRelevantTarget extends ResolvableCall {
    ResolvableCallRelevantTarget() {
      exists(Target target | target = getTarget() |
        exists(target.getLocation().getFile().getRelativePath())
      )
    }
  }

  /**
   * A call that can be resolved by type-tracking, where the resolved target is not considered relevant.
   * See `ResolvableCallRelevantTarget` for the definition of relevance.
   */
  class ResolvableCallIrrelevantTarget extends ResolvableCall {
    ResolvableCallIrrelevantTarget() { not this instanceof ResolvableCallRelevantTarget }
  }
}
