/**
 * @name Returning stack-allocated memory
 * @description A function returns a pointer to a stack-allocated region of
 *              memory. This memory is deallocated at the end of the function,
 *              which may lead the caller to dereference a dangling pointer.
 * @kind path-problem
 * @id cpp/return-stack-allocated-memory
 * @problem.severity warning
 * @security-severity 9.3
 * @precision high
 * @tags reliability
 *       security
 *       external/cwe/cwe-825
 */

import cpp
// We don't actually use the global value numbering library in this query, but without it we end up
// recomputing the IR.
private import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.dataflow.MustFlow
import PathGraph

/** Holds if `f` has a name that we intrepret as evidence of intentionally returning the value of the stack pointer. */
predicate intentionallyReturnsStackPointer(Function f) {
  f.getName().toLowerCase().matches(["%stack%", "%sp%"])
}

class ReturnStackAllocatedMemoryConfig extends MustFlowConfiguration {
  ReturnStackAllocatedMemoryConfig() { this = "ReturnStackAllocatedMemoryConfig" }

  override predicate isSource(DataFlow::Node source) {
    // Holds if `source` is a node that represents the use of a stack variable
    exists(VariableAddressInstruction var, Function func |
      var = source.asInstruction() and
      func = var.getEnclosingFunction() and
      var.getAstVariable() instanceof StackVariable and
      // Pointer-to-member types aren't properly handled in the dbscheme.
      not var.getResultType() instanceof PointerToMemberType and
      // Rule out FPs caused by extraction errors.
      not any(ErrorExpr e).getEnclosingFunction() = func and
      not intentionallyReturnsStackPointer(func)
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    // Holds if `sink` is a node that represents the `StoreInstruction` that is subsequently used in
    // a `ReturnValueInstruction`.
    // We use the `StoreInstruction` instead of the instruction that defines the
    // `ReturnValueInstruction`'s source value oprand because the former has better location information.
    exists(StoreInstruction store |
      store.getDestinationAddress().(VariableAddressInstruction).getIRVariable() instanceof
        IRReturnVariable and
      sink.asOperand() = store.getSourceValueOperand()
    )
  }

  /**
   * This configuration intentionally conflates addresses of fields and their object, and pointer offsets
   * with their base pointer as this allows us to detect cases where an object's address flows to a
   * return statement via a field. For example:
   *
   * ```cpp
   * struct S { int x, y };
   * int* test() {
   *   S s;
   *   return &s.x; // BAD: &s.x is an address of a variable on the stack.
   * }
   * ```
   */
  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    node2.asInstruction().(FieldAddressInstruction).getObjectAddressOperand() = node1.asOperand()
    or
    node2.asInstruction().(PointerOffsetInstruction).getLeftOperand() = node1.asOperand()
  }
}

from
  MustFlowPathNode source, MustFlowPathNode sink, VariableAddressInstruction var,
  ReturnStackAllocatedMemoryConfig conf, Function f
where
  conf.hasFlowPath(source, sink) and
  source.getNode().asInstruction() = var and
  // Only raise an alert if we're returning from the _same_ callable as the on that
  // declared the stack variable.
  var.getEnclosingFunction() = pragma[only_bind_into](f) and
  sink.getNode().getEnclosingCallable() = pragma[only_bind_into](f)
select sink.getNode(), source, sink, "May return stack-allocated memory from $@.", var.getAst(),
  var.getAst().toString()
