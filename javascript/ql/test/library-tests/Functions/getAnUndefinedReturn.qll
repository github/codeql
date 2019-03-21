import javascript
import semmle.javascript.CFG

query predicate test_getAnUndefinedReturn(Function fun, ConcreteControlFlowNode final) {
	final = fun.getAnUndefinedReturn()
}