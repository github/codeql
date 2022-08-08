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
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.dataflow.MustFlow
import PathGraph

/** Holds if `f` has a name that we interpret as evidence of intentionally returning the value of the stack pointer. */
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

  //  We disable flow into callables in this query as we'd otherwise get a result on this piece of code:
  //   ```cpp
  //  int* id(int* px) {
  //   return px; // this returns the local variable `x`, but it's fine as the local variable isn't declared in this scope.
  //  }
  //  void f() {
  //   int x;
  //   int* px = id(&x);
  //  }
  //   ```
  override predicate allowInterproceduralFlow() { none() }

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
  ReturnStackAllocatedMemoryConfig conf
where
  conf.hasFlowPath(pragma[only_bind_into](source), pragma[only_bind_into](sink)) and
  source.getNode().asInstruction() = var
select sink.getNode(), source, sink, "May return stack-allocated memory from $@.", var.getAst(),
  var.getAst().toString()
