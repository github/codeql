/**
 * @name Invalid prototype value
 * @description An attempt to use a value that is not an object or 'null' as a
 *              prototype will either be ignored or result in a runtime error.
 * @kind problem
 * @problem.severity error
 * @id js/invalid-prototype-value
 * @tags correctness
 *       language-features
 *       external/cwe/cwe-704
 * @precision high
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes

/**
 * Holds if the value of `e` is used as a prototype object.
 */
predicate isProto(DataFlow::AnalyzedNode e) {
  // `o.__proto__ = e`, `{ __proto__: e }`, ...
  e = any(DataFlow::PropWrite pwn | pwn.getPropertyName() = "__proto__").getRhs()
  or
  // Object.create(e)
  e = DataFlow::globalVarRef("Object").getAMemberCall("create").getArgument(0)
  or
  // Object.setPrototypeOf(o, e)
  e = DataFlow::globalVarRef("Object").getAMemberCall("setPrototypeOf").getArgument(1)
  or
  // e.isPrototypeOf(o)
  any(MethodCallExpr mce).calls(e.asExpr(), "isPrototypeOf")
}

from DataFlow::AnalyzedNode proto
where
  isProto(proto) and
  forex(InferredType tp | tp = proto.getAType() | tp instanceof PrimitiveType and tp != TTNull())
select proto, "Values of type " + proto.ppTypes() + " cannot be used as prototypes."
