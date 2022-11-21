/**
 * @name Unsafe use of this in constructor
 * @description A call to a pure virtual function using a 'this'
 *              pointer of an object that is under construction
 *              may lead to undefined behavior.
 * @kind path-problem
 * @id cpp/unsafe-use-of-this
 * @problem.severity error
 * @security-severity 7.5
 * @precision very-high
 * @tags correctness
 *       language-features
 *       security
 *       external/cwe/cwe-670
 */

import cpp
import semmle.code.cpp.ir.IR
import semmle.code.cpp.ir.dataflow.MustFlow
import PathGraph

class UnsafeUseOfThisConfig extends MustFlowConfiguration {
  UnsafeUseOfThisConfig() { this = "UnsafeUseOfThisConfig" }

  override predicate isSource(Instruction source) { isSource(source, _, _) }

  override predicate isSink(Operand sink) { isSink(sink, _) }
}

/** Holds if `sink` is a `this` pointer used by the call instruction `call`. */
predicate isSink(Operand sink, CallInstruction call) {
  exists(PureVirtualFunction func |
    call.getStaticCallTarget() = func and
    call.getThisArgumentOperand() = sink and
    // Weed out implicit calls to destructors of a base class
    not func instanceof Destructor
  )
}

/**
 * Holds if `source` initializes the `this` pointer in class `c`.
 *
 * The string `msg` describes whether the enclosing function is a
 * constructor or destructor.
 */
predicate isSource(InitializeParameterInstruction source, string msg, Class c) {
  (
    exists(Constructor func |
      not func instanceof CopyConstructor and
      not func instanceof MoveConstructor and
      func = source.getEnclosingFunction() and
      msg = "construction"
    )
    or
    source.getEnclosingFunction() instanceof Destructor and msg = "destruction"
  ) and
  source.getIRVariable() instanceof IRThisVariable and
  source.getEnclosingFunction().getDeclaringType() = c
}

/**
 * Holds if:
 * - `source` is an initialization of a `this` pointer of type `sourceClass`, and
 * - `sink` is a use of the `this` pointer, and
 * - `call` invokes a pure virtual function using `sink` as the `this` pointer, and
 * - `msg` is a string describing whether `source` is from a constructor or destructor.
 */
predicate flows(
  MustFlowPathNode source, string msg, Class sourceClass, MustFlowPathNode sink,
  CallInstruction call
) {
  exists(UnsafeUseOfThisConfig conf |
    conf.hasFlowPath(source, sink) and
    isSource(source.getInstruction(), msg, sourceClass) and
    isSink(sink.getInstruction().getAUse(), call)
  )
}

from
  MustFlowPathNode source, MustFlowPathNode sink, CallInstruction call, string msg,
  Class sourceClass
where
  flows(source, msg, sourceClass, sink, call) and
  // Only raise an alert if there is no override of the pure virtual function in any base class.
  not exists(Class c | c = sourceClass.getABaseClass*() |
    c.getAMemberFunction().getAnOverriddenFunction() = call.getStaticCallTarget()
  )
select call.getUnconvertedResultExpression(), source, sink,
  "Call to pure virtual function during " + msg + "."
