/**
 * @name Missing return-value check for a 'scanf'-like function
 * @description Failing to check that a call to 'scanf' actually writes to an
 *              output variable can lead to unexpected behavior at reading time.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id cpp/missing-check-scanf
 * @tags security
 *       correctness
 *       external/cwe/cwe-252
 *       external/cwe/cwe-253
 */

import cpp
import semmle.code.cpp.commons.Scanf
import semmle.code.cpp.controlflow.Guards
import semmle.code.cpp.ir.dataflow.DataFlow
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.ValueNumbering

/**
 * Holds if `call` is a `scanf`-like function that may write to `output` at index `index`.
 *
 * Furthermore, `instr` is the instruction that defines the address of the `index`'th argument
 * of `call`, and `vn` is the value number of `instr.`
 */
predicate isSource(ScanfFunctionCall call, int index, Instruction instr, ValueNumber vn, Expr output) {
  output = call.getOutputArgument(index).getFullyConverted() and
  instr.getConvertedResultExpression() = output and
  vn.getAnInstruction() = instr
}

/**
 * Holds if `instr` is control-flow reachable in 0 or more steps from
 * a call to a `scanf`-like function.
 */
pragma[nomagic]
predicate fwdFlow0(Instruction instr) {
  isSource(_, _, instr, _, _)
  or
  exists(Instruction prev |
    fwdFlow0(prev) and
    prev.getASuccessor() = instr
  )
}

/**
 * Holds if `instr` is part of the IR translation of `access` that
 * is not an expression being deallocated, and `instr` has value
 * number `vn`.
 */
predicate isSink(Instruction instr, Access access, ValueNumber vn) {
  instr.getAst() = access and
  not any(DeallocationExpr dealloc).getFreedExpr() = access and
  vn.getAnInstruction() = instr
}

/**
 * Holds if `instr` is part of a path from a call to a `scanf`-like function
 * to a use of the written variable.
 */
pragma[nomagic]
predicate revFlow0(Instruction instr) {
  fwdFlow0(instr) and
  (
    isSink(instr, _, _)
    or
    exists(Instruction succ | revFlow0(succ) | instr.getASuccessor() = succ)
  )
}

/**
 * Holds if `instr` is part of a path from a call to a `scanf`-like function
 * that writes to a variable with value number `vn`, without passing through
 * redefinitions of the variable.
 */
pragma[nomagic]
private predicate fwdFlow(Instruction instr, ValueNumber vn) {
  revFlow0(instr) and
  (
    isSource(_, _, instr, vn, _)
    or
    exists(Instruction prev |
      fwdFlow(prev, vn) and
      prev.getASuccessor() = instr and
      not isBarrier(instr, vn)
    )
  )
}

/**
 * Holds if `instr` is part of a path from a call to a `scanf`-like function
 * that writes to a variable with value number `vn`, without passing through
 * redefinitions of the variable.
 *
 * Note: This predicate only holds for the `(intr, vn)` pairs that are also
 * control-flow reachable from an argument to a `scanf`-like function call.
 */
pragma[nomagic]
predicate revFlow(Instruction instr, ValueNumber vn) {
  fwdFlow(instr, pragma[only_bind_out](vn)) and
  (
    isSink(instr, _, vn)
    or
    exists(Instruction succ | revFlow(succ, vn) |
      instr.getASuccessor() = succ and
      not isBarrier(succ, vn)
    )
  )
}

/**
 * A type that bundles together a reachable instruction with the appropriate
 * value number (i.e., the value number that's transferred from the source
 * to the sink).
 */
newtype TNode = MkNode(Instruction instr, ValueNumber vn) { revFlow(instr, vn) }

class Node extends MkNode {
  ValueNumber vn;
  Instruction instr;

  Node() { this = MkNode(instr, vn) }

  final string toString() { result = instr.toString() }

  final Node getASuccessor() { result = MkNode(pragma[only_bind_out](instr.getASuccessor()), vn) }

  final Location getLocation() { result = instr.getLocation() }
}

/**
 * Holds if `instr` is an instruction with value number `vn` that is
 * used in a store operation, or is overwritten by another call to
 * a `scanf`-like function.
 */
private predicate isBarrier(Instruction instr, ValueNumber vn) {
  // We only need to compute barriers for instructions that we
  // managed to hit during the initial flow stage.
  revFlow0(pragma[only_bind_into](instr)) and
  valueNumber(instr) = vn and
  exists(Expr e | instr.getAst() = e |
    instr = any(StoreInstruction s).getDestinationAddress()
    or
    isSource(_, _, _, _, [e, e.getParent().(AddressOfExpr)])
  )
}

/** Holds if `n1` steps to `n2` in a single step. */
predicate isSuccessor(Node n1, Node n2) { n1.getASuccessor() = n2 }

predicate hasFlow(Node n1, Node n2) = fastTC(isSuccessor/2)(n1, n2)

Node getNode(Instruction instr, ValueNumber vn) { result = MkNode(instr, vn) }

/**
 * Holds if `source` is the `index`'th argument to the `scanf`-like call `call`, and `sink` is
 * an instruction that is part of the translation of `access` which is a transitive
 * control-flow successor of `call`.
 *
 * Furthermore, `source` and `sink` have identical global value numbers.
 */
predicate hasFlow(
  Instruction source, ScanfFunctionCall call, int index, Instruction sink, Access access
) {
  exists(ValueNumber vn |
    isSource(call, index, source, vn, _) and
    hasFlow(getNode(source, pragma[only_bind_into](vn)), getNode(sink, pragma[only_bind_into](vn))) and
    isSink(sink, access, vn)
  )
}

/**
 * Gets the smallest possible `scanf` return value of `call` that would indicate
 * success in writing the output argument at index `index`.
 */
int getMinimumGuardConstant(ScanfFunctionCall call, int index) {
  isSource(call, index, _, _, _) and
  result =
    index + 1 -
      count(ScanfFormatLiteral f, int n |
        // Special case: %n writes to an argument without reading any input.
        // It does not increase the count returned by `scanf`.
        n <= index and f.getUse() = call and f.getConversionChar(n) = "n"
      )
}

/**
 * Holds the access to `e` isn't guarded by a check that ensures that `call` returned
 * at least `minGuard`.
 */
predicate hasNonGuardedAccess(ScanfFunctionCall call, Access e, int minGuard) {
  exists(int index |
    hasFlow(_, call, index, _, e) and
    minGuard = getMinimumGuardConstant(call, index)
  |
    not exists(int value |
      e.getBasicBlock() = blockGuardedBy(value, "==", call) and minGuard <= value
      or
      e.getBasicBlock() = blockGuardedBy(value, "<", call) and minGuard - 1 <= value
      or
      e.getBasicBlock() = blockGuardedBy(value, "<=", call) and minGuard <= value
    )
  )
}

/** Returns a block guarded by the assertion of `value op call` */
BasicBlock blockGuardedBy(int value, string op, ScanfFunctionCall call) {
  exists(GuardCondition g, Expr left, Expr right |
    right = g.getAChild() and
    value = left.getValue().toInt() and
    DataFlow::localExprFlow(call, right)
  |
    g.ensuresEq(left, right, 0, result, true) and op = "=="
    or
    g.ensuresLt(left, right, 0, result, true) and op = "<"
    or
    g.ensuresLt(left, right, 1, result, true) and op = "<="
  )
}

from ScanfFunctionCall call, Access access, int minGuard
where hasNonGuardedAccess(call, access, minGuard)
select access,
  "This variable is read, but may not have been written. " +
    "It should be guarded by a check that the $@ returns at least " + minGuard + ".", call,
  call.toString()
