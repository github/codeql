/**
 * Provides classes for different types of handler.
 */

private import CIL

/**
 * A handler is a piece of code that can be executed out of sequence, for example
 * when an instruction generates an exception or leaves a `finally` block.
 *
 * Each handler has a scope representing the block of instructions guarded by
 * this handler (corresponding to a C# `try { ... }` block), and a block of instructions
 * to execute when the handler is triggered (corresponding to a `catch` or `finally` block).
 *
 * Handlers are entry points (`EntryPoint`) so that they can
 * provide values on the stack, for example the value of the current exception. This is why
 * some handlers have a push count of 1.
 *
 * Either a finally handler (`FinallyHandler`), filter handler (`FilterHandler`),
 * catch handler (`CatchHandler`), or a fault handler (`FaultHandler`).
 */
class Handler extends Element, EntryPoint, @cil_handler {
  override MethodImplementation getImplementation() { cil_handler(this, result, _, _, _, _, _) }

  /** Gets the 0-based index of this handler. Handlers are evaluated in this sequence. */
  int getIndex() { cil_handler(this, _, result, _, _, _, _) }

  /** Gets the first instruction in the `try` block of this handler. */
  Instruction getTryStart() { cil_handler(this, _, _, _, result, _, _) }

  /** Gets the last instruction in the `try` block of this handler. */
  Instruction getTryEnd() { cil_handler(this, _, _, _, _, result, _) }

  /** Gets the first instruction in the `catch`/`finally` block. */
  Instruction getHandlerStart() { cil_handler(this, _, _, _, _, _, result) }

  /**
   * Holds if the instruction `i` is in the scope of this handler.
   */
  predicate isInScope(Instruction i) {
    i.getImplementation() = getImplementation() and
    i.getIndex() in [getTryStart().getIndex() .. getTryEnd().getIndex()]
  }

  override string toString() { none() }

  override Instruction getASuccessorType(FlowType t) {
    result = getHandlerStart() and
    t instanceof NormalFlow
  }

  /** Gets the type of the caught exception, if any. */
  Type getCaughtType() { cil_handler_type(this, result) }

  override Location getLocation() { result = getTryStart().getLocation() }
}

/** A handler corresponding to a `finally` block. */
class FinallyHandler extends Handler, @cil_finally_handler {
  override string toString() { result = "finally {...}" }
}

/** A handler corresponding to a `where()` clause. */
class FilterHandler extends Handler, @cil_filter_handler {
  override string toString() { result = "where (...)" }

  /** Gets the filter clause - the start of a sequence of instructions to evaluate the filter function. */
  Instruction getFilterClause() { cil_handler_filter(this, result) }

  override int getPushCount() { result = 1 }
}

/** A handler corresponding to a `catch` clause. */
class CatchHandler extends Handler, @cil_catch_handler {
  override string toString() { result = "catch(" + getCaughtType().getName() + ") {...}" }

  override int getPushCount() { result = 1 }
}

/** A handler for memory faults. */
class FaultHandler extends Handler, @cil_fault_handler {
  override string toString() { result = "fault {...}" }
}
