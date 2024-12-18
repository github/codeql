/**
 * The unpacking assignment takes the general form
 * ```python
 *   sequence = iterable
 * ```
 * where `sequence` is either a tuple or a list and it can contain wildcards.
 * The iterable can be any iterable, which means that (CodeQL modeling of) content
 * will need to change type if it should be transferred from the LHS to the RHS.
 *
 * Note that (CodeQL modeling of) content does not have to change type on data-flow
 * paths _inside_ the LHS, as the different allowed syntaxes here are merely a convenience.
 * Consequently, we model all LHS sequences as tuples, which have the more precise content
 * model, making flow to the elements more precise. If an element is a starred variable,
 * we will have to mutate the content type to be list content.
 *
 * We may for instance have
 * ```python
 *    (a, b) = ["a", SOURCE]  # RHS has content `ListElementContent`
 * ```
 * Due to the abstraction for list content, we do not know whether `SOURCE`
 * ends up in `a` or in `b`, so we want to overapproximate and see it in both.
 *
 * Using wildcards we may have
 * ```python
 *   (a, *b) = ("a", "b", SOURCE)  # RHS has content `TupleElementContent(2)`
 * ```
 * Since the starred variables are always assigned (Python-)type list, `*b` will be
 * `["b", SOURCE]`, and we will again overapproximate and assign it
 * content corresponding to anything found in the RHS.
 *
 * For a precise transfer
 * ```python
 *    (a, b) = ("a", SOURCE)  # RHS has content `TupleElementContent(1)`
 * ```
 * we wish to keep the precision, so only `b` receives the tuple content at index 1.
 *
 * Finally, `sequence` is actually a pattern and can have a more complicated structure,
 * such as
 * ```python
 *   (a, [b, *c]) = ("a", ["b", SOURCE])  # RHS has content `TupleElementContent(1); ListElementContent`
 * ```
 * where `a` should not receive content, but `b` and `c` should. `c` will be `[SOURCE]` so
 * should have the content transferred, while `b` should read it.
 *
 * To transfer content from RHS to the elements of the LHS in the expression `sequence = iterable`,
 * we use two synthetic nodes:
 *
 * - `TIterableSequence(sequence)` which captures the content-modeling the entire `sequence` will have
 * (essentially just a copy of the content-modeling the RHS has)
 *
 * - `TIterableElement(sequence)` which captures the content-modeling that will be assigned to an element.
 * Note that an empty access path means that the value we are tracking flows directly to the element.
 *
 *
 * The `TIterableSequence(sequence)` is at this point superfluous but becomes useful when handling recursive
 * structures in the LHS, where `sequence` is some internal sequence node. We can have a uniform treatment
 * by always having these two synthetic nodes. So we transfer to (or, in the recursive case, read into)
 * `TIterableSequence(sequence)`, from which we take a read step to `TIterableElement(sequence)` and then a
 * store step to `sequence`.
 *
 * This allows the unknown content from the RHS to be read into `TIterableElement(sequence)` and tuple content
 * to then be stored into `sequence`. If the content is already tuple content, this indirection creates crosstalk
 * between indices. Therefore, tuple content is never read into `TIterableElement(sequence)`; it is instead
 * transferred directly from `TIterableSequence(sequence)` to `sequence` via a flow step. Such a flow step will
 * also transfer other content, but only tuple content is further read from `sequence` into its elements.
 *
 * The strategy is then via several read-, store-, and flow steps:
 * 1. a) [Flow] Content is transferred from `iterable` to `TIterableSequence(sequence)` via a
 *    flow step. From here, everything happens on the LHS.
 *
 *    b) [Read] If the unpacking happens inside a for as in
 *    ```python
 *       for sequence in iterable
 *    ```
 *    then content is read from `iterable` to `TIterableSequence(sequence)`.
 *
 * 2. [Flow] Content is transferred from `TIterableSequence(sequence)` to `sequence` via a
 *    flow step. (Here only tuple content is relevant.)
 *
 * 3. [Read] Content is read from `TIterableSequence(sequence)` into  `TIterableElement(sequence)`.
 *    As `sequence` is modeled as a tuple, we will not read tuple content as that would allow
 *    crosstalk.
 *
 * 4. [Store] Content is stored from `TIterableElement(sequence)` to `sequence`.
 *    Content type is `TupleElementContent` with indices taken from the syntax.
 *    For instance, if `sequence` is `(a, *b, c)`, content is written to index 0, 1, and 2.
 *    This is adequate as the route through `TIterableElement(sequence)` does not transfer precise content.
 *
 * 5. [Read] Content is read from `sequence` to its elements.
 *    a) If the element is a plain variable, the target is the corresponding control flow node.
 *
 *    b) If the element is itself a sequence, with control-flow node `seq`, the target is `TIterableSequence(seq)`.
 *
 *    c) If the element is a starred variable, with control-flow node `v`, the target is `TIterableElement(v)`.
 *
 * 6. [Store] Content is stored from `TIterableElement(v)` to the control flow node for variable `v`, with
 *    content type `ListElementContent`.
 *
 * 7. [Flow, Read, Store] Steps 2 through 7 are repeated for all recursive elements which are sequences.
 *
 *
 * We illustrate the above steps on the assignment
 *
 * ```python
 * (a, b) = ["a", SOURCE]
 * ```
 *
 * Looking at the content propagation to `a`:
 *   `["a", SOURCE]`: [ListElementContent]
 *
 * --Step 1a-->
 *
 *   `TIterableSequence((a, b))`: [ListElementContent]
 *
 * --Step 3-->
 *
 *   `TIterableElement((a, b))`: []
 *
 * --Step 4-->
 *
 *   `(a, b)`: [TupleElementContent(0)]
 *
 * --Step 5a-->
 *
 *   `a`: []
 *
 * Meaning there is data-flow from the RHS to `a` (an over approximation). The same logic would be applied to show there is data-flow to `b`. Note that _Step 3_ and _Step 4_ would not have been needed if the RHS had been a tuple (since that would have been able to use _Step 2_ instead).
 *
 * Another, more complicated example:
 * ```python
 *   (a, [b, *c]) = ["a", [SOURCE]]
 * ```
 * where the path to `c` is
 *
 *   `["a", [SOURCE]]`: [ListElementContent; ListElementContent]
 *
 * --Step 1a-->
 *
 *   `TIterableSequence((a, [b, *c]))`: [ListElementContent; ListElementContent]
 *
 * --Step 3-->
 *
 *   `TIterableElement((a, [b, *c]))`: [ListElementContent]
 *
 * --Step 4-->
 *
 *   `(a, [b, *c])`: [TupleElementContent(1); ListElementContent]
 *
 * --Step 5b-->
 *
 *   `TIterableSequence([b, *c])`: [ListElementContent]
 *
 * --Step 3-->
 *
 *   `TIterableElement([b, *c])`: []
 *
 * --Step 4-->
 *
 *   `[b, *c]`: [TupleElementContent(1)]
 *
 * --Step 5c-->
 *
 *   `TIterableElement(c)`: []
 *
 * --Step 6-->
 *
 *  `c`: [ListElementContent]
 */

private import python
private import DataFlowPublic

/**
 * The target of a `for`, e.g. `x` in `for x in list` or in `[42 for x in list]`.
 * This class also records the source, which in both above cases is `list`.
 * This class abstracts away the differing representations of comprehensions and
 * for statements.
 */
class ForTarget extends ControlFlowNode {
  Expr source;

  ForTarget() {
    exists(For for |
      source = for.getIter() and
      this.getNode() = for.getTarget() and
      not for = any(Comp comp).getNthInnerLoop(0)
    )
    or
    exists(Comp comp |
      source = comp.getFunction().getArg(0) and
      this.getNode() = comp.getNthInnerLoop(0).getTarget()
    )
  }

  Expr getSource() { result = source }
}

/** The LHS of an assignment, it also records the assigned value. */
class AssignmentTarget extends ControlFlowNode {
  Expr value;

  AssignmentTarget() {
    exists(Assign assign | this.getNode() = assign.getATarget() | value = assign.getValue())
  }

  Expr getValue() { result = value }
}

/** A direct (or top-level) target of an unpacking assignment. */
class UnpackingAssignmentDirectTarget extends ControlFlowNode instanceof SequenceNode {
  Expr value;

  UnpackingAssignmentDirectTarget() {
    value = this.(AssignmentTarget).getValue()
    or
    value = this.(ForTarget).getSource()
  }

  Expr getValue() { result = value }
}

/** A (possibly recursive) target of an unpacking assignment. */
class UnpackingAssignmentTarget extends ControlFlowNode {
  UnpackingAssignmentTarget() {
    this instanceof UnpackingAssignmentDirectTarget
    or
    this = any(UnpackingAssignmentSequenceTarget parent).getAnElement()
  }
}

/** A (possibly recursive) target of an unpacking assignment which is also a sequence. */
class UnpackingAssignmentSequenceTarget extends UnpackingAssignmentTarget instanceof SequenceNode {
  ControlFlowNode getElement(int i) { result = super.getElement(i) }

  ControlFlowNode getAnElement() { result = this.getElement(_) }
}

/**
 * Step 1a
 * Data flows from `iterable` to `TIterableSequence(sequence)`
 */
predicate iterableUnpackingAssignmentFlowStep(Node nodeFrom, Node nodeTo) {
  exists(AssignmentTarget target |
    nodeFrom.(CfgNode).getNode().getNode() = target.getValue() and
    nodeTo = TIterableSequenceNode(target)
  )
}

/**
 * Step 1b
 * Data is read from `iterable` to `TIterableSequence(sequence)`
 */
predicate iterableUnpackingForReadStep(CfgNode nodeFrom, Content c, Node nodeTo) {
  exists(ForTarget target |
    nodeFrom.getNode().getNode() = target.getSource() and
    target instanceof SequenceNode and
    nodeTo = TIterableSequenceNode(target)
  ) and
  (
    c instanceof ListElementContent
    or
    c instanceof SetElementContent
  )
}

/**
 * Step 2
 * Data flows from `TIterableSequence(sequence)` to `sequence`
 */
predicate iterableUnpackingTupleFlowStep(Node nodeFrom, Node nodeTo) {
  exists(UnpackingAssignmentSequenceTarget target |
    nodeFrom = TIterableSequenceNode(target) and
    nodeTo.(CfgNode).getNode() = target
  )
}

/**
 * Step 3
 * Data flows from `TIterableSequence(sequence)` into  `TIterableElement(sequence)`.
 * As `sequence` is modeled as a tuple, we will not read tuple content as that would allow
 * crosstalk.
 */
predicate iterableUnpackingConvertingReadStep(Node nodeFrom, Content c, Node nodeTo) {
  exists(UnpackingAssignmentSequenceTarget target |
    nodeFrom = TIterableSequenceNode(target) and
    nodeTo = TIterableElementNode(target) and
    (
      c instanceof ListElementContent
      or
      c instanceof SetElementContent
      // TODO: dict content in iterable unpacking not handled
    )
  )
}

/**
 * Step 4
 * Data flows from `TIterableElement(sequence)` to `sequence`.
 * Content type is `TupleElementContent` with indices taken from the syntax.
 * For instance, if `sequence` is `(a, *b, c)`, content is written to index 0, 1, and 2.
 */
predicate iterableUnpackingConvertingStoreStep(Node nodeFrom, Content c, Node nodeTo) {
  exists(UnpackingAssignmentSequenceTarget target |
    nodeFrom = TIterableElementNode(target) and
    nodeTo.(CfgNode).getNode() = target and
    exists(int index | exists(target.getElement(index)) |
      c.(TupleElementContent).getIndex() = index
    )
  )
}

/**
 * Step 5
 * For a sequence node inside an iterable unpacking, data flows from the sequence to its elements. There are
 * three cases for what `toNode` should be:
 *    a) If the element is a plain variable, `toNode` is the corresponding control flow node.
 *
 *    b) If the element is itself a sequence, with control-flow node `seq`, `toNode` is `TIterableSequence(seq)`.
 *
 *    c) If the element is a starred variable, with control-flow node `v`, `toNode` is `TIterableElement(v)`.
 */
predicate iterableUnpackingElementReadStep(Node nodeFrom, Content c, Node nodeTo) {
  exists(
    UnpackingAssignmentSequenceTarget target, int index, ControlFlowNode element, int starIndex
  |
    target.getElement(starIndex) instanceof StarredNode
    or
    not exists(target.getAnElement().(StarredNode)) and
    starIndex = -1
  |
    nodeFrom.(CfgNode).getNode() = target and
    element = target.getElement(index) and
    (
      if starIndex = -1 or index < starIndex
      then c.(TupleElementContent).getIndex() = index
      else
        // This could get big if big tuples exist
        if index = starIndex
        then c.(TupleElementContent).getIndex() >= index
        else c.(TupleElementContent).getIndex() >= index - 1
    ) and
    (
      if element instanceof SequenceNode
      then
        // Step 5b
        nodeTo = TIterableSequenceNode(element)
      else
        if element instanceof StarredNode
        then
          // Step 5c
          nodeTo = TIterableElementNode(element)
        else
          // Step 5a
          exists(MultiAssignmentDefinition mad | element = mad.getDefiningNode() |
            nodeTo.(CfgNode).getNode() = element
          )
    )
  )
}

/**
 * Step 6
 * Data flows from `TIterableElement(v)` to the control flow node for variable `v`, with
 * content type `ListElementContent`.
 */
predicate iterableUnpackingStarredElementStoreStep(Node nodeFrom, Content c, Node nodeTo) {
  exists(ControlFlowNode starred, MultiAssignmentDefinition mad |
    starred.getNode() instanceof Starred and
    starred = mad.getDefiningNode()
  |
    nodeFrom = TIterableElementNode(starred) and
    nodeTo.asCfgNode() = starred and
    c instanceof ListElementContent
  )
}

/** All read steps associated with unpacking assignment. */
predicate iterableUnpackingReadStep(Node nodeFrom, Content c, Node nodeTo) {
  iterableUnpackingForReadStep(nodeFrom, c, nodeTo)
  or
  iterableUnpackingElementReadStep(nodeFrom, c, nodeTo)
  or
  iterableUnpackingConvertingReadStep(nodeFrom, c, nodeTo)
}

/** All store steps associated with unpacking assignment. */
predicate iterableUnpackingStoreStep(Node nodeFrom, Content c, Node nodeTo) {
  iterableUnpackingStarredElementStoreStep(nodeFrom, c, nodeTo)
  or
  iterableUnpackingConvertingStoreStep(nodeFrom, c, nodeTo)
}

/** All flow steps associated with unpacking assignment. */
predicate iterableUnpackingFlowStep(Node nodeFrom, Node nodeTo) {
  iterableUnpackingAssignmentFlowStep(nodeFrom, nodeTo)
  or
  iterableUnpackingTupleFlowStep(nodeFrom, nodeTo)
}
