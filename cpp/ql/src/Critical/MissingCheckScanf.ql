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
import semmle.code.cpp.dataflow.new.DataFlow::DataFlow
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.ValueNumbering

/** Holds if `n` reaches an argument  to a call to a `scanf`-like function. */
pragma[nomagic]
predicate revFlow0(Node n) {
  isSink(_, _, n, _)
  or
  exists(Node succ | revFlow0(succ) | localFlowStep(n, succ))
}

/**
 * Holds if `n` represents an uninitialized stack-allocated variable, or a
 * newly (and presumed uninitialized) heap allocation.
 */
predicate isUninitialized(Node n) {
  exists(n.asUninitialized()) or
  n.asIndirectExpr(1) instanceof AllocationExpr
}

pragma[nomagic]
predicate fwdFlow0(Node n) {
  revFlow0(n) and
  (
    isUninitialized(n)
    or
    exists(Node prev |
      fwdFlow0(prev) and
      localFlowStep(prev, n)
    )
  )
}

predicate isSink(ScanfFunctionCall call, int index, Node n, Expr input) {
  input = call.getOutputArgument(index) and
  n.asIndirectExpr() = input
}

/**
 * Holds if `call` is a `scanf`-like call and `output` is the `index`'th
 * argument that has not been previously initialized.
 */
predicate isRelevantScanfCall(ScanfFunctionCall call, int index, Expr output) {
  exists(Node n | fwdFlow0(n) and isSink(call, index, n, output))
}

/**
 * Holds if `call` is a `scanf`-like function that may write to `output` at
 * index `index` and `n` is the dataflow node that represents the data after
 * it has been written to by `call`.
 */
predicate isSource(ScanfFunctionCall call, int index, Node n, Expr output) {
  isRelevantScanfCall(call, index, output) and
  output = call.getOutputArgument(index) and
  n.asDefiningArgument() = output
}

/**
 * Holds if `n` is reachable from an output argument of a relevant call to
 * a `scanf`-like function.
 */
pragma[nomagic]
predicate fwdFlow(Node n) {
  isSource(_, _, n, _)
  or
  exists(Node prev |
    fwdFlow(prev) and
    localFlowStep(prev, n) and
    not isSanitizerOut(prev)
  )
}

/** Holds if `n` should not have outgoing flow. */
predicate isSanitizerOut(Node n) {
  // We disable flow out of sinks to reduce result duplication
  isSink(n, _)
  or
  // If the node is being passed to a function it may be
  // modified, and thus it's safe to later read the value.
  exists(n.asIndirectArgument())
}

/**
 * Holds if `n` is a node such that `n.asExpr() = e` and `e` is not an
 * argument of a deallocation expression.
 */
predicate isSink(Node n, Expr e) {
  n.asExpr() = e and
  not any(DeallocationExpr dealloc).getFreedExpr() = e
}

/**
 * Holds if `n` is part of a path from a call to a `scanf`-like function
 * to a use of the written variable.
 */
pragma[nomagic]
predicate revFlow(Node n) {
  fwdFlow(n) and
  (
    isSink(n, _)
    or
    exists(Node succ |
      revFlow(succ) and
      localFlowStep(n, succ) and
      not isSanitizerOut(n)
    )
  )
}

/** A local flow step, restricted to relevant dataflow nodes. */
private predicate step(Node n1, Node n2) {
  revFlow(n1) and
  revFlow(n2) and
  localFlowStep(n1, n2)
}

predicate hasFlow(Node n1, Node n2) = fastTC(step/2)(n1, n2)

/**
 * Holds if `source` is the `index`'th argument to the `scanf`-like call `call`, and `sink` is
 * a dataflow node that represents the expression `e`.
 */
predicate hasFlow(Node source, ScanfFunctionCall call, int index, Node sink, Expr e) {
  isSource(call, index, source, _) and
  hasFlow(source, sink) and
  isSink(sink, e)
}

/**
 * Gets the smallest possible `scanf` return value of `call` that would indicate
 * success in writing the output argument at index `index`.
 */
int getMinimumGuardConstant(ScanfFunctionCall call, int index) {
  isSource(call, index, _, _) and
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
predicate hasNonGuardedAccess(ScanfFunctionCall call, Expr e, int minGuard) {
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
    localExprFlow(call, right)
  |
    g.ensuresEq(left, right, 0, result, true) and op = "=="
    or
    g.ensuresLt(left, right, 0, result, true) and op = "<"
    or
    g.ensuresLt(left, right, 1, result, true) and op = "<="
  )
}

from ScanfFunctionCall call, Expr e, int minGuard
where hasNonGuardedAccess(call, e, minGuard)
select e,
  "This variable is read, but may not have been written. " +
    "It should be guarded by a check that the $@ returns at least " + minGuard + ".", call,
  call.toString()
