/* *
 * Predicates that help detect potential non-cryptographic hash functions
 * 
 * By themselves, non-cryptographic functions are common and not dangerous
 * These predicates are intended for helping detect non-cryptographic hashes that may be used
 * in a context that is not appropriate, or for detecting modified hash functions
 */

import csharp
private import DataFlow
private import semmle.code.csharp.dataflow.TaintTracking2

predicate maybeANonCryptogrphicHash( Callable callable, Variable v, Expr xor, Expr mul, LoopStmt loop ) {
	callable = loop.getEnclosingCallable() and
	(
	  maybeUsedInFNVFunction( v, xor, mul, loop) or
	  maybeUsedInElfHashFunction( v, xor, mul, loop)
	)
}

/** 
 * Holds if the arguments are used in a way that resembles a FNV hash function
 * where there is a loop statement `loop` where the variable `v` is used in an xor `xor` expression
 * followed by a multiplication `mul` expression.
 */
predicate maybeUsedInFNVFunction( Variable v, Expr xor, Expr mul, LoopStmt loop) {
	exists( Expr e1, Expr e2  | 
		exists( Operation axore, Operation amule | 
			xor = axore and mul = amule |
			e1.getAChild*() = v.getAnAccess() and
			e2.getAChild*() = v.getAnAccess() and
			e1 = axore.getAnOperand() and
			e2 = amule.getAnOperand() and
			axore.getAControlFlowNode().getASuccessor*() = amule.getAControlFlowNode() and
			(axore instanceof AssignXorExpr or axore instanceof BitwiseXorExpr) and
			(amule instanceof AssignMulExpr or amule instanceof MulExpr)
		) 
  )
  and loop.getAChild*() = mul.getEnclosingStmt()
  and loop.getAChild*() = xor.getEnclosingStmt()
}

/** 
 * Holds if the arguments are used in a way that resembles an Elf-Hash hash function
 * where there is a loop statement `loop` where the variable `v` is used in an xor `xor` expression
 * followed by an addition `add` expression.
 */
predicate maybeUsedInElfHashFunction(Variable v, Expr xorExpr, Expr addExpr, LoopStmt loop) {
	exists( Expr e1, Operation add, Expr e2, AssignExpr addAssign, Operation xor, AssignExpr xorAssign, Operation notOp, AssignExpr notAssign |
		xorExpr = xor and
		addExpr = add and
		( add instanceof AddExpr or add instanceof AssignAddExpr ) and
  	    e1.getAChild*() = add.getAnOperand() and
  		e1 instanceof BinaryBitwiseOperation and
 		e2 = e1.(BinaryBitwiseOperation).getLeftOperand() and
 		v = addAssign.getTargetVariable() and
 		addAssign.getAChild*() = add and
 		( xor instanceof BitwiseXorExpr or xor instanceof AssignXorExpr ) and
		addAssign.getAControlFlowNode().getASuccessor*() = xor.getAControlFlowNode() and
		xorAssign.getAChild*() = xor and
		v = xorAssign.getTargetVariable() and
		(notOp instanceof UnaryBitwiseOperation or notOp instanceof AssignBitwiseOperation ) and
		xor.getAControlFlowNode().getASuccessor*() = notOp.getAControlFlowNode() and
		notAssign.getAChild*() = notOp and
		v = notAssign.getTargetVariable() and 
		loop.getAChild*() = add.getEnclosingStmt() and
  	    loop.getAChild*() = xor.getEnclosingStmt()
	)
}

/**
 * Any dataflow from any source to any sink, used internally
 */
private class AnyDataFlow extends TaintTracking2::Configuration {
  AnyDataFlow() {
    this = "DataFlowFromDataGatheringMethodToVariable"
  }

  override predicate isSource(Node source) {
    any()
  }

  override predicate isSink(Node sink)
  {
    any()
  }
}

/** 
 * Holds if the Callable is a function that behaves like a non-cryptographic hash
 * where the parameter `param` is likely the message to hash
 */
predicate isCallableAPotentialNonCryptographicHashFunction( Callable callable, Parameter param) {
	exists( Variable v, Expr op1, Expr op2, LoopStmt loop |
	  maybeANonCryptogrphicHash(callable, v, op1, op2, loop)
	  and callable.getAParameter() = param
	  and ( 
	    param.getAnAccess() = op1.(Operation).getAnOperand().getAChild*() or
	    param.getAnAccess() = op2.(Operation).getAnOperand().getAChild*() or
	    exists( AnyDataFlow config, Node source, Node sink |
	  	  ( sink.asExpr() = op1.(Operation).getAChild*() or
	  	    sink.asExpr() = op2.(Operation).getAChild*()) and
	  	  source.asExpr() = param.getAnAccess() and
	      config.hasFlow(source, sink)
	    )
	  )
	)
}
