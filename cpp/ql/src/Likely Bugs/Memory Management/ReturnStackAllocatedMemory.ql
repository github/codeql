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

  override predicate isSource(Instruction source) {
    exists(Function func |
      // Rule out FPs caused by extraction errors.
      not func.hasErrors() and
      not intentionallyReturnsStackPointer(func) and
      func = source.getEnclosingFunction()
    |
      // `source` is an instruction that represents the use of a stack variable
      exists(VariableAddressInstruction var |
        var = source and
        var.getAstVariable() instanceof StackVariable and
        // Pointer-to-member types aren't properly handled in the dbscheme.
        not var.getResultType() instanceof PointerToMemberType
      )
      or
      // `source` is an instruction that represents the return value of a
      // function that is known to return stack-allocated memory.
      exists(Call call |
        call.getTarget().hasGlobalName(["alloca", "strdupa", "strndupa", "_alloca", "_malloca"]) and
        source.getUnconvertedResultExpression() = call
      )
    )
  }

  override predicate isSink(Operand sink) {
    // Holds if `sink` is a node that represents the `StoreInstruction` that is subsequently used in
    // a `ReturnValueInstruction`.
    // We use the `StoreInstruction` instead of the instruction that defines the
    // `ReturnValueInstruction`'s source value operand because the former has better location information.
    exists(StoreInstruction store |
      store.getDestinationAddress().(VariableAddressInstruction).getIRVariable() instanceof
        IRReturnVariable and
      sink = store.getSourceValueOperand()
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
  override predicate isAdditionalFlowStep(Operand node1, Instruction node2) {
    node2.(FieldAddressInstruction).getObjectAddressOperand() = node1
    or
    node2.(PointerOffsetInstruction).getLeftOperand() = node1
  }

  override predicate isBarrier(Instruction n) { n.getResultType() instanceof ErroneousType }
}

from
  MustFlowPathNode source, MustFlowPathNode sink, Instruction instr,
  ReturnStackAllocatedMemoryConfig conf
where
  conf.hasFlowPath(pragma[only_bind_into](source), pragma[only_bind_into](sink)) and
  source.getInstruction() = instr
select sink.getInstruction(), source, sink, "May return stack-allocated memory from $@.",
  instr.getAst(), instr.getAst().toString()
