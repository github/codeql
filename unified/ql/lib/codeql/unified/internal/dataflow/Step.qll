private import unified
private import AllDataFlow

private newtype TStep =
  TValueStep() or
  TJumpStep() or
  TTaintStep() or
  TReadStep(ContentSet contents) or
  TStoreStep(ContentSet contents)

/**
 * A type of data flow step, used during construction of the data flow graph.
 */
class Step extends TStep {
  /** Holds if this represents a value-preserving step. */
  predicate value() { this = TValueStep() }

  /** Holds if this represents a value-preserving jump step (propagating across unrelated call stacks). */
  predicate jump() { this = TJumpStep() }

  /** Holds if this represents a taint-preserving step. */
  predicate taint() { this = TTaintStep() }

  /** Holds if this represents a step reading `contents`. */
  predicate read(ContentSet contents) { this = TReadStep(contents) }

  /** Holds if this represents a step reading the named member `name`. */
  pragma[nomagic]
  predicate readName(string name) { this.read(ContentSet::namedMember(name)) }

  /** Holds if this represents a step storing into `contents`. */
  predicate store(ContentSet contents) { this = TStoreStep(contents) }

  /** Holds if this represents a step storing into the named member `name`. */
  pragma[nomagic]
  predicate storeName(string name) { this.store(ContentSet::namedMember(name)) }

  string toString() {
    this.value() and result = "value"
    or
    this.jump() and result = "jump"
    or
    this.taint() and result = "taint"
    or
    exists(ContentSet contents |
      this.read(contents) and result = "read[" + contents + "]"
      or
      this.store(contents) and result = "store[" + contents + "]"
    )
  }
}
