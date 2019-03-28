/** Helper predicates for standard tests in Python commonly
 * used to filter objects by value or by type.
 */


import python
import semmle.dataflow.SSA

/** Holds if `c` is a call to `hasattr(obj, attr)`. */
predicate hasattr(CallNode c, ControlFlowNode obj, string attr) {
    c.getFunction().getNode().(Name).getId() = "hasattr" and
    c.getArg(0) = obj and
    c.getArg(1).getNode().(StrConst).getText() = attr
}

/** Holds if `c` is a call to `callable(obj)`. */
predicate is_callable(CallNode c, ControlFlowNode obj) {
    c.getFunction().(NameNode).getId() = "callable" and
    obj = c.getArg(0)
}

/** Holds if `c` is a call to `isinstance(use, cls)`. */
predicate isinstance(CallNode fc, ControlFlowNode cls, ControlFlowNode use) {
    fc.getFunction().(NameNode).getId() = "isinstance" and
    cls = fc.getArg(1) and fc.getArg(0) = use
}

/** Holds if `c` is a call to `issubclass(use, cls)`. */
predicate issubclass(CallNode fc, ControlFlowNode cls, ControlFlowNode use) {
    fc.getFunction().(NameNode).getId() = "issubclass" and
    fc.getArg(0) = use and cls = fc.getArg(1)
}

