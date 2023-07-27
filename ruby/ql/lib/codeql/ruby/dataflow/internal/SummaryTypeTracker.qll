/**
 * Provides the implementation of type tracking steps through flow summaries.
 * To use this, you must implement the `Input` signature. You can then use the predicates in the `Output`
 * signature to implement the predicates of the same names inside `TypeTrackerSpecific.qll`.
 */

/** The classes and predicates needed to generate type-tracking steps from summaries. */
signature module Input {
  // Dataflow nodes
  class Node;

  // Content
  class TypeTrackerContent;

  class TypeTrackerContentFilter;

  // Relating content and filters
  /**
   * Gets a content filter to use for a `WithoutContent[content]` step, (data is not allowed to be stored in `content`)
   * or has no result if
   * the step should be treated as ordinary flow.
   *
   * `WithoutContent` is often used to perform strong updates on individual collection elements, but for
   * type-tracking this is rarely beneficial and quite expensive. However, `WithoutContent` can be quite useful
   * for restricting the type of an object, and in these cases we translate it to a filter.
   */
  TypeTrackerContentFilter getFilterFromWithoutContentStep(TypeTrackerContent content);

  /**
   * Gets a content filter to use for a `WithContent[content]` step, (data must be stored in `content`)
   * or has no result if
   * the step cannot be handled by type-tracking.
   *
   * `WithContent` is often used to perform strong updates on individual collection elements (or rather
   * to preserve those that didn't get updated). But for type-tracking this is rarely beneficial and quite expensive.
   * However, `WithContent` can be quite useful for restricting the type of an object, and in these cases we translate it to a filter.
   */
  TypeTrackerContentFilter getFilterFromWithContentStep(TypeTrackerContent content);

  // Summaries and their stacks
  class SummaryComponent;

  class SummaryComponentStack {
    SummaryComponent head();
  }

  /** Gets a singleton stack containing `component`. */
  SummaryComponentStack singleton(SummaryComponent component);

  /**
   * Gets the stack obtained by pushing `head` onto `tail`.
   */
  SummaryComponentStack push(SummaryComponent head, SummaryComponentStack tail);

  /** Gets a singleton stack representing a return. */
  SummaryComponent return();

  // Relating content to summaries
  /** Gets a summary component for content `c`. */
  SummaryComponent content(TypeTrackerContent contents);

  /** Gets a summary component where data is not allowed to be stored in `contents`. */
  SummaryComponent withoutContent(TypeTrackerContent contents);

  /** Gets a summary component where data must be stored in `contents`. */
  SummaryComponent withContent(TypeTrackerContent contents);

  // Callables
  class SummarizedCallable {
    predicate propagatesFlow(
      SummaryComponentStack input, SummaryComponentStack output, boolean preservesValue
    );
  }

  // Relating nodes to summaries
  /** Gets a dataflow node respresenting the argument of `call` indicated by `arg`. */
  Node argumentOf(Node call, SummaryComponent arg);

  /** Gets a dataflow node respresenting the parameter of `callable` indicated by `param`. */
  Node parameterOf(Node callable, SummaryComponent param);

  /** Gets a dataflow node respresenting the return of `callable` indicated by `return`. */
  Node returnOf(Node callable, SummaryComponent return);

  // Relating callables to nodes
  /** Gets a dataflow node respresenting a call to `callable`. */
  Node callTo(SummarizedCallable callable);
}

/**
 * The predicates provided by a summary type tracker.
 * These are meant to be used in `TypeTrackerSpecific.qll`
 * inside the predicates of the same names.
 */
signature module Output<Input I> {
  /**
   *  Holds if there is a level step from `nodeFrom` to `nodeTo`, which does not depend on the call graph.
   */
  predicate levelStepNoCall(I::Node nodeFrom, I::Node nodeTo);

  /**
   * Holds if `nodeTo` is the result of accessing the `content` content of `nodeFrom`.
   */
  predicate basicLoadStep(I::Node nodeFrom, I::Node nodeTo, I::TypeTrackerContent content);

  /**
   * Holds if `nodeFrom` is being written to the `content` content of the object in `nodeTo`.
   */
  predicate basicStoreStep(I::Node nodeFrom, I::Node nodeTo, I::TypeTrackerContent content);

  /**
   * Holds if the `loadContent` of `nodeFrom` is stored in the `storeContent` of `nodeTo`.
   */
  predicate basicLoadStoreStep(
    I::Node nodeFrom, I::Node nodeTo, I::TypeTrackerContent loadContent,
    I::TypeTrackerContent storeContent
  );

  /**
   * Holds if type-tracking should step from `nodeFrom` to `nodeTo` but block flow of contents matched by `filter` through here.
   */
  predicate basicWithoutContentStep(
    I::Node nodeFrom, I::Node nodeTo, I::TypeTrackerContentFilter filter
  );

  /**
   * Holds if type-tracking should step from `nodeFrom` to `nodeTo` if inside a content matched by `filter`.
   */
  predicate basicWithContentStep(
    I::Node nodeFrom, I::Node nodeTo, I::TypeTrackerContentFilter filter
  );
}

/**
 * Implementation of the summary type tracker, that is type tracking through flow summaries.
 */
module SummaryFlow<Input I> implements Output<I> {
  pragma[nomagic]
  private predicate isNonLocal(I::SummaryComponent component) {
    component = I::content(_)
    or
    component = I::withContent(_)
  }

  pragma[nomagic]
  private predicate hasLoadSummary(
    I::SummarizedCallable callable, I::TypeTrackerContent contents, I::SummaryComponentStack input,
    I::SummaryComponentStack output
  ) {
    callable.propagatesFlow(I::push(I::content(contents), input), output, true) and
    not isNonLocal(input.head()) and
    not isNonLocal(output.head())
  }

  pragma[nomagic]
  private predicate hasStoreSummary(
    I::SummarizedCallable callable, I::TypeTrackerContent contents, I::SummaryComponentStack input,
    I::SummaryComponentStack output
  ) {
    not isNonLocal(input.head()) and
    not isNonLocal(output.head()) and
    (
      callable.propagatesFlow(input, I::push(I::content(contents), output), true)
      or
      // Allow the input to start with an arbitrary WithoutContent[X].
      // Since type-tracking only tracks one content deep, and we're about to store into another content,
      // we're already preventing the input from being in a content.
      callable
          .propagatesFlow(I::push(I::withoutContent(_), input),
            I::push(I::content(contents), output), true)
    )
  }

  pragma[nomagic]
  private predicate hasLoadStoreSummary(
    I::SummarizedCallable callable, I::TypeTrackerContent loadContents,
    I::TypeTrackerContent storeContents, I::SummaryComponentStack input,
    I::SummaryComponentStack output
  ) {
    callable
        .propagatesFlow(I::push(I::content(loadContents), input),
          I::push(I::content(storeContents), output), true) and
    not isNonLocal(input.head()) and
    not isNonLocal(output.head())
  }

  pragma[nomagic]
  private predicate hasWithoutContentSummary(
    I::SummarizedCallable callable, I::TypeTrackerContentFilter filter,
    I::SummaryComponentStack input, I::SummaryComponentStack output
  ) {
    exists(I::TypeTrackerContent content |
      callable.propagatesFlow(I::push(I::withoutContent(content), input), output, true) and
      filter = I::getFilterFromWithoutContentStep(content) and
      not isNonLocal(input.head()) and
      not isNonLocal(output.head()) and
      input != output
    )
  }

  pragma[nomagic]
  private predicate hasWithContentSummary(
    I::SummarizedCallable callable, I::TypeTrackerContentFilter filter,
    I::SummaryComponentStack input, I::SummaryComponentStack output
  ) {
    exists(I::TypeTrackerContent content |
      callable.propagatesFlow(I::push(I::withContent(content), input), output, true) and
      filter = I::getFilterFromWithContentStep(content) and
      not isNonLocal(input.head()) and
      not isNonLocal(output.head()) and
      input != output
    )
  }

  private predicate componentLevelStep(I::SummaryComponent component) {
    exists(I::TypeTrackerContent content |
      component = I::withoutContent(content) and
      not exists(I::getFilterFromWithoutContentStep(content))
    )
  }

  /**
   * Gets a data flow `I::Node` corresponding an argument or return value of `call`,
   * as specified by `component`.
   */
  bindingset[call, component]
  private I::Node evaluateSummaryComponentLocal(I::Node call, I::SummaryComponent component) {
    result = I::argumentOf(call, component)
    or
    component = I::return() and
    result = call
  }

  /**
   * Holds if `callable` is relevant for type-tracking and we therefore want `stack` to
   * be evaluated locally at its call sites.
   */
  pragma[nomagic]
  private predicate dependsOnSummaryComponentStack(
    I::SummarizedCallable callable, I::SummaryComponentStack stack
  ) {
    exists(I::callTo(callable)) and
    (
      callable.propagatesFlow(stack, _, true)
      or
      callable.propagatesFlow(_, stack, true)
      or
      // include store summaries as they may skip an initial step at the input
      hasStoreSummary(callable, _, stack, _)
    )
    or
    dependsOnSummaryComponentStackCons(callable, _, stack)
  }

  pragma[nomagic]
  private predicate dependsOnSummaryComponentStackCons(
    I::SummarizedCallable callable, I::SummaryComponent head, I::SummaryComponentStack tail
  ) {
    dependsOnSummaryComponentStack(callable, I::push(head, tail))
  }

  pragma[nomagic]
  private predicate dependsOnSummaryComponentStackConsLocal(
    I::SummarizedCallable callable, I::SummaryComponent head, I::SummaryComponentStack tail
  ) {
    dependsOnSummaryComponentStackCons(callable, head, tail) and
    not isNonLocal(head)
  }

  pragma[nomagic]
  private predicate dependsOnSummaryComponentStackLeaf(
    I::SummarizedCallable callable, I::SummaryComponent leaf
  ) {
    dependsOnSummaryComponentStack(callable, I::singleton(leaf))
  }

  /**
   * Gets a data flow I::Node corresponding to the local input or output of `call`
   * identified by `stack`, if possible.
   */
  pragma[nomagic]
  private I::Node evaluateSummaryComponentStackLocal(
    I::SummarizedCallable callable, I::Node call, I::SummaryComponentStack stack
  ) {
    exists(I::SummaryComponent component |
      dependsOnSummaryComponentStackLeaf(callable, component) and
      stack = I::singleton(component) and
      call = I::callTo(callable) and
      result = evaluateSummaryComponentLocal(call, component)
    )
    or
    exists(I::Node prev, I::SummaryComponent head, I::SummaryComponentStack tail |
      prev = evaluateSummaryComponentStackLocal(callable, call, tail) and
      dependsOnSummaryComponentStackConsLocal(callable, pragma[only_bind_into](head),
        pragma[only_bind_out](tail)) and
      stack = I::push(pragma[only_bind_out](head), pragma[only_bind_out](tail))
    |
      result = I::parameterOf(prev, head)
      or
      result = I::returnOf(prev, head)
      or
      componentLevelStep(head) and
      result = prev
    )
  }

  // Implement Output
  predicate levelStepNoCall(I::Node nodeFrom, I::Node nodeTo) {
    exists(
      I::SummarizedCallable callable, I::Node call, I::SummaryComponentStack input,
      I::SummaryComponentStack output
    |
      callable.propagatesFlow(input, output, true) and
      call = I::callTo(callable) and
      nodeFrom = evaluateSummaryComponentStackLocal(callable, call, input) and
      nodeTo = evaluateSummaryComponentStackLocal(callable, call, output)
    )
  }

  predicate basicLoadStep(I::Node nodeFrom, I::Node nodeTo, I::TypeTrackerContent content) {
    exists(
      I::SummarizedCallable callable, I::Node call, I::SummaryComponentStack input,
      I::SummaryComponentStack output
    |
      hasLoadSummary(callable, content, pragma[only_bind_into](input),
        pragma[only_bind_into](output)) and
      call = I::callTo(callable) and
      nodeFrom = evaluateSummaryComponentStackLocal(callable, call, input) and
      nodeTo = evaluateSummaryComponentStackLocal(callable, call, output)
    )
  }

  predicate basicStoreStep(I::Node nodeFrom, I::Node nodeTo, I::TypeTrackerContent content) {
    exists(
      I::SummarizedCallable callable, I::Node call, I::SummaryComponentStack input,
      I::SummaryComponentStack output
    |
      hasStoreSummary(callable, content, pragma[only_bind_into](input),
        pragma[only_bind_into](output)) and
      call = I::callTo(callable) and
      nodeFrom = evaluateSummaryComponentStackLocal(callable, call, input) and
      nodeTo = evaluateSummaryComponentStackLocal(callable, call, output)
    )
  }

  predicate basicLoadStoreStep(
    I::Node nodeFrom, I::Node nodeTo, I::TypeTrackerContent loadContent,
    I::TypeTrackerContent storeContent
  ) {
    exists(
      I::SummarizedCallable callable, I::Node call, I::SummaryComponentStack input,
      I::SummaryComponentStack output
    |
      hasLoadStoreSummary(callable, loadContent, storeContent, pragma[only_bind_into](input),
        pragma[only_bind_into](output)) and
      call = I::callTo(callable) and
      nodeFrom = evaluateSummaryComponentStackLocal(callable, call, input) and
      nodeTo = evaluateSummaryComponentStackLocal(callable, call, output)
    )
  }

  predicate basicWithoutContentStep(
    I::Node nodeFrom, I::Node nodeTo, I::TypeTrackerContentFilter filter
  ) {
    exists(
      I::SummarizedCallable callable, I::Node call, I::SummaryComponentStack input,
      I::SummaryComponentStack output
    |
      hasWithoutContentSummary(callable, filter, pragma[only_bind_into](input),
        pragma[only_bind_into](output)) and
      call = I::callTo(callable) and
      nodeFrom = evaluateSummaryComponentStackLocal(callable, call, input) and
      nodeTo = evaluateSummaryComponentStackLocal(callable, call, output)
    )
  }

  predicate basicWithContentStep(
    I::Node nodeFrom, I::Node nodeTo, I::TypeTrackerContentFilter filter
  ) {
    exists(
      I::SummarizedCallable callable, I::Node call, I::SummaryComponentStack input,
      I::SummaryComponentStack output
    |
      hasWithContentSummary(callable, filter, pragma[only_bind_into](input),
        pragma[only_bind_into](output)) and
      call = I::callTo(callable) and
      nodeFrom = evaluateSummaryComponentStackLocal(callable, call, input) and
      nodeTo = evaluateSummaryComponentStackLocal(callable, call, output)
    )
  }
}
