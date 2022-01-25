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
import semmle.code.cpp.ir.dataflow.DataFlow::DataFlow

/** Holds if `f` has a name that we intrepret as evidence of intentionally returning the value of the stack pointer. */
predicate intentionallyReturnsStackPointer(Function f) {
  f.getName().toLowerCase().matches(["%stack%", "%sp%"])
}

/**
 * Holds if `source` is a node that represents the use of a stack variable
 */
predicate isSource(Node source) {
  exists(VariableAddressInstruction var, Function func |
    var = source.asInstruction() and
    func = var.getEnclosingFunction() and
    var.getASTVariable() instanceof StackVariable and
    // Pointer-to-member types aren't properly handled in the dbscheme.
    not var.getResultType() instanceof PointerToMemberType and
    // Rule out FPs caused by extraction errors.
    not any(ErrorExpr e).getEnclosingFunction() = func and
    not intentionallyReturnsStackPointer(func)
  )
}

/**
 * Holds if `sink` is a node that represents the `StoreInstruction` that is subsequently used in
 * a `ReturnValueInstruction`. We use the `StoreInstruction` instead of the instruction that defines the
 * `ReturnValueInstruction`'s source value oprand because the former has better location information.
 */
predicate isSink(Node sink) {
  exists(StoreInstruction store |
    store.getDestinationAddress().(VariableAddressInstruction).getIRVariable() instanceof
      IRReturnVariable and
    sink.asOperand() = store.getSourceValueOperand()
  )
}

/** Holds if `node1` _must_ flow to `node2`. */
predicate step(Node node1, Node node2) {
  instructionToOperandStep(node1.asInstruction(), node2.asOperand())
  or
  operandToInstructionStep(node1.asOperand(), node2.asInstruction())
}

predicate instructionToOperandStep(Instruction instr, Operand operand) { operand.getDef() = instr }

/**
 * Holds if `operand` flows to the result of `instr`.
 *
 * This predicate ignores flow through `PhiInstruction`s to create a 'must flow' relation. It also
 * intentionally conflates addresses of fields and their object, and pointer offsets with their
 * base pointer as this allows us to detect cases where an object's address flows to a return statement
 * via a field. For example:
 *
 * ```cpp
 * struct S { int x, y };
 * int* test() {
 *   S s;
 *   return &s.x; // BAD: &s.x is an address of a variable on the stack.
 * }
 * ```
 */
predicate operandToInstructionStep(Operand operand, Instruction instr) {
  instr.(CopyInstruction).getSourceValueOperand() = operand
  or
  instr.(ConvertInstruction).getUnaryOperand() = operand
  or
  instr.(CheckedConvertOrNullInstruction).getUnaryOperand() = operand
  or
  instr.(InheritanceConversionInstruction).getUnaryOperand() = operand
  or
  instr.(FieldAddressInstruction).getObjectAddressOperand() = operand
  or
  instr.(PointerOffsetInstruction).getLeftOperand() = operand
}

/** Holds if a source node flows to `n`. */
predicate branchlessLocalFlow0(Node n) {
  isSource(n)
  or
  exists(Node mid |
    branchlessLocalFlow0(mid) and
    step(mid, n)
  )
}

/** Holds if `n` is reachable through some source node, and `n` also eventually reaches a sink. */
predicate branchlessLocalFlow1(Node n) {
  branchlessLocalFlow0(n) and
  (
    isSink(n)
    or
    exists(Node mid |
      branchlessLocalFlow1(mid) and
      step(n, mid)
    )
  )
}

newtype TLocalPathNode =
  TLocalPathNodeMid(Node n) {
    branchlessLocalFlow1(n) and
    (
      isSource(n) or
      exists(LocalPathNodeMid mid | step(mid.getNode(), n))
    )
  }

abstract class LocalPathNode extends TLocalPathNode {
  Node n;

  /** Gets the underlying node. */
  Node getNode() { result = n }

  /** Gets a textual representation of this node. */
  string toString() { result = n.toString() }

  /** Gets the location of this element. */
  Location getLocation() { result = n.getLocation() }

  /** Gets a successor `LocalPathNode`, if any. */
  LocalPathNode getASuccessor() { step(this.getNode(), result.getNode()) }
}

class LocalPathNodeMid extends LocalPathNode, TLocalPathNodeMid {
  LocalPathNodeMid() { this = TLocalPathNodeMid(n) }
}

class LocalPathNodeSink extends LocalPathNodeMid {
  LocalPathNodeSink() { isSink(this.getNode()) }
}

/**
 * Holds if `source` is a source node, `sink` is a sink node, and there's flow
 * from `source` to `sink` using `step` relation.
 */
predicate hasFlow(LocalPathNode source, LocalPathNodeSink sink) {
  isSource(source.getNode()) and
  source.getASuccessor+() = sink
}

predicate reach(LocalPathNode n) { n instanceof LocalPathNodeSink or reach(n.getASuccessor()) }

query predicate edges(LocalPathNode a, LocalPathNode b) { a.getASuccessor() = b and reach(b) }

query predicate nodes(LocalPathNode n, string key, string val) {
  reach(n) and key = "semmle.label" and val = n.toString()
}

from LocalPathNode source, LocalPathNodeSink sink, VariableAddressInstruction var
where
  hasFlow(source, sink) and
  source.getNode().asInstruction() = var
select sink.getNode(), source, sink, "May return stack-allocated memory from $@.", var.getAST(),
  var.getAST().toString()
