/**
 * Provides classes and predicates for simple data-flow reachability suitable
 * for tracking types.
 */

/**
 * The step relations for type tracking.
 */
signature module TypeTrackingInput {
  /** A node that is used by the type-trackers. */
  class Node {
    /** Gets a textual representation of this node. */
    string toString();
  }

  /**
   * A node that is the source of local flow. This defines the end-points of the
   * big-step relation used by type-trackers once the transitive closure of
   * `simpleLocalFlowStep` is prepended to the other steps.
   */
  class LocalSourceNode extends Node;

  /** A type of content to be used with the store and read steps. */
  class Content {
    /** Gets a textual representation of this content. */
    string toString();
  }

  /**
   * A label to use for `withContentStep` and `withoutContentStep` steps,
   * restricting which `Content`s may pass through.
   */
  class ContentFilter {
    /** Gets the content that matches this filter. */
    Content getAMatchingContent();
  }

  /**
   * Holds if a value stored with `storeContents` can be read back with
   * `loadContents`.
   */
  predicate compatibleContents(Content storeContents, Content loadContents);

  /**
   * Holds if there is a simple local flow step from `nodeFrom` to `nodeTo`.
   * A transitive closure of such steps is prepended to the non-simple
   * type-tracking steps.
   */
  predicate simpleLocalSmallStep(Node nodeFrom, Node nodeTo);

  /**
   * Holds if there is a level step from `nodeFrom` to `nodeTo` that does not
   * depend on the call graph.
   */
  predicate levelStepNoCall(Node nodeFrom, LocalSourceNode nodeTo);

  /**
   * Holds if there is a level step from `nodeFrom` to `nodeTo` that may depend
   * on the call graph.
   */
  predicate levelStepCall(Node nodeFrom, LocalSourceNode nodeTo);

  /**
   * Holds if `nodeFrom` steps to `nodeTo` by being passed as a parameter in a
   * call.
   */
  predicate callStep(Node nodeFrom, LocalSourceNode nodeTo);

  /**
   * Holds if `nodeFrom` steps to `nodeTo` by being returned from a call.
   */
  predicate returnStep(Node nodeFrom, LocalSourceNode nodeTo);

  /**
   * Holds if `nodeFrom` is being written to the content `c` of the object in
   * `nodeTo`.
   */
  predicate storeStep(Node nodeFrom, Node nodeTo, Content c);

  /**
   * Holds if `nodeTo` is the result of accessing the content `c` of `nodeFrom`.
   */
  predicate loadStep(Node nodeFrom, LocalSourceNode nodeTo, Content c);

  /**
   * Holds if the content `c1` of `nodeFrom` is stored in the content `c2` of
   * `nodeTo`.
   */
  predicate loadStoreStep(Node nodeFrom, Node nodeTo, Content c1, Content c2);

  /**
   * Holds if type-tracking should step from `nodeFrom` to `nodeTo` if inside a
   * content matched by `filter`.
   */
  predicate withContentStep(Node nodeFrom, LocalSourceNode nodeTo, ContentFilter filter);

  /**
   * Holds if type-tracking should step from `nodeFrom` to `nodeTo` but block
   * flow of contents matched by `filter`.
   */
  predicate withoutContentStep(Node nodeFrom, LocalSourceNode nodeTo, ContentFilter filter);

  /**
   * Holds if data can flow from `nodeFrom` to `nodeTo` in a way that discards
   * call contexts.
   */
  predicate jumpStep(Node nodeFrom, LocalSourceNode nodeTo);

  /**
   * Holds if the target of store steps should be backtracked via
   * `simpleLocalSmallStep` to a `LocalSourceNode`. If this flag is not set,
   * then the targets of store steps are assumed to be `LocalSourceNode`s
   * themselves.
   */
  predicate hasFeatureBacktrackStoreTarget();

  /**
   * Holds if a non-standard `flowsTo` predicate is needed, i.e., one that is not
   * simply `simpleLocalSmallStep*(localSource, dst)`.
   */
  default predicate nonStandardFlowsTo(LocalSourceNode localSource, Node dst) { none() }
}

private import internal.TypeTrackingImpl as Impl

/**
 * Given a set of step relations, this module provides classes and predicates
 * for simple data-flow reachability suitable for tracking types.
 */
module TypeTracking<TypeTrackingInput I> {
  private module MkImpl = Impl::TypeTracking<I>;

  private module ConsistencyChecksInput implements MkImpl::ConsistencyChecksInputSig { }

  deprecated module ConsistencyChecks = MkImpl::ConsistencyChecks<ConsistencyChecksInput>;

  class TypeTracker = MkImpl::TypeTracker;

  module TypeTracker = MkImpl::TypeTracker;

  class TypeBackTracker = MkImpl::TypeBackTracker;

  module TypeBackTracker = MkImpl::TypeBackTracker;

  signature module TypeTrackInputSig {
    predicate source(I::Node n);

    /**
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
     */
    default predicate isAdditionalLevelStep(I::Node node1, I::Node node2) { none() }

    /**
     * Holds if data may flow from `node1` to `node2` in addition to the normal data-flow steps.
     */
    default predicate isAdditionalJumpStep(I::Node node1, I::Node node2) { none() }
  }

  /**
   * Given a source definition, constructs the default forward type tracking from
   * those sources.
   */
  module TypeTrackExt<TypeTrackInputSig Input> {
    private module Inp implements MkImpl::TypeTrackInputSig {
      import Input
    }

    import MkImpl::TypeTrack<Inp>
  }

  signature predicate endpoint(I::Node node);

  /**
   * Given a source definition, constructs the default forward type tracking from
   * those sources.
   */
  module TypeTrack<endpoint/1 source> {
    private predicate sourceAlias = source/1;

    private module Inp implements MkImpl::TypeTrackInputSig {
      predicate source = sourceAlias/1;

      predicate isAdditionalLevelStep(I::Node node1, I::Node node2) { none() }

      predicate isAdditionalJumpStep(I::Node node1, I::Node node2) { none() }
    }

    import MkImpl::TypeTrack<Inp>
  }
}
