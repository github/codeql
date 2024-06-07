/**
 * @name Missing return-value check for a 'scanf'-like function
 * @description Failing to check that a call to 'scanf' actually writes to an
 *              output variable can lead to unexpected behavior at reading time.
 * @kind path-problem
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
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import ScanfChecks
import ScanfToUseFlow::PathGraph

/**
 * Holds if `n` represents an uninitialized stack-allocated variable, or a
 * newly (and presumed uninitialized) heap allocation.
 */
predicate isUninitialized(Node n) {
  exists(n.asUninitialized()) or
  n.asIndirectExpr(1) instanceof AllocationExpr
}

predicate isSink(ScanfFunctionCall call, int index, Node n, Expr input) {
  input = call.getOutputArgument(index) and
  n.asIndirectExpr() = input
}

/**
 * A configuration to track a uninitialized data flowing to a `scanf`-like
 * output parameter position.
 *
 * This is meant to be a simple flow to rule out cases like:
 * ```
 * int x = 0;
 * scanf(..., &x);
 * use(x);
 * ```
 * since `x` is already initialized it's not a security concern that `x` is
 * used without checking the return value of `scanf`.
 *
 * Since this flow is meant to be simple, we disable field flow and require the
 * source and the sink to be in the same callable.
 */
module UninitializedToScanfConfig implements ConfigSig {
  predicate isSource(Node source) { isUninitialized(source) }

  predicate isSink(Node sink) { isSink(_, _, sink, _) }

  FlowFeature getAFeature() { result instanceof FeatureEqualSourceSinkCallContext }

  int accessPathLimit() { result = 0 }
}

module UninitializedToScanfFlow = Global<UninitializedToScanfConfig>;

/**
 * Holds if `call` is a `scanf`-like call and `output` is the `index`'th
 * argument that has not been previously initialized.
 */
predicate isRelevantScanfCall(ScanfFunctionCall call, int index, Expr output) {
  exists(Node n | UninitializedToScanfFlow::flowTo(n) and isSink(call, index, n, output)) and
  // Exclude results from incorrectky checked scanf query
  not incorrectlyCheckedScanf(call)
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
 * Holds if `n` is a node such that `n.asExpr() = e` and `e` is not an
 * argument of a deallocation expression.
 */
predicate isSink(Node n, Expr e) {
  n.asExpr() = e and
  not any(DeallocationExpr dealloc).getFreedExpr() = e
}

/**
 * A configuration to track flow from the output argument of a call to a
 * `scanf`-like function, and to a use of the defined variable.
 */
module ScanfToUseConfig implements ConfigSig {
  predicate isSource(Node source) { isSource(_, _, source, _) }

  predicate isSink(Node sink) { isSink(sink, _) }

  predicate isBarrierOut(Node n) {
    // We disable flow out of sinks to reduce result duplication
    isSink(n, _)
    or
    // If the node is being passed to a function it may be
    // modified, and thus it's safe to later read the value.
    exists(n.asIndirectArgument())
  }
}

module ScanfToUseFlow = Global<ScanfToUseConfig>;

/**
 * Holds if `source` is the `index`'th argument to the `scanf`-like call `call`, and `sink` is
 * a dataflow node that represents the expression `e`.
 */
predicate flowPath(
  ScanfToUseFlow::PathNode source, ScanfFunctionCall call, int index, ScanfToUseFlow::PathNode sink,
  Expr e
) {
  isSource(call, index, source.getNode(), _) and
  ScanfToUseFlow::flowPath(source, sink) and
  isSink(sink.getNode(), e)
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
predicate hasNonGuardedAccess(
  ScanfToUseFlow::PathNode source, ScanfFunctionCall call, ScanfToUseFlow::PathNode sink, Expr e,
  int minGuard
) {
  exists(int index |
    flowPath(source, call, index, sink, e) and
    minGuard = getMinimumGuardConstant(call, index)
  |
    not exists(GuardCondition guard |
      // call == k and k >= minGuard so call >= minGuard
      guard
          .ensuresEq(globalValueNumber(call).getAnExpr(), any(int k | minGuard <= k),
            e.getBasicBlock(), true)
      or
      // call >= k and k >= minGuard so call >= minGuard
      guard
          .ensuresLt(globalValueNumber(call).getAnExpr(), any(int k | minGuard <= k),
            e.getBasicBlock(), false)
    )
  )
}

from
  ScanfToUseFlow::PathNode source, ScanfToUseFlow::PathNode sink, ScanfFunctionCall call, Expr e,
  int minGuard
where hasNonGuardedAccess(source, call, sink, e, minGuard)
select e, source, sink,
  "This variable is read, but may not have been written. " +
    "It should be guarded by a check that the $@ returns at least " + minGuard + ".", call,
  call.toString()
