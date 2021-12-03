/**
 * @name Assignment to property of primitive value
 * @description Assigning to a property of a primitive value has no effect
 *              and may trigger a runtime error.
 * @kind problem
 * @problem.severity error
 * @id js/property-assignment-on-primitive
 * @tags correctness
 *       language-features
 *       external/cwe/cwe-704
 * @precision high
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes

/** Gets a description of the property written by `pwn`. */
string describeProp(DataFlow::PropWrite pwn) {
  result = "property " + pwn.getPropertyName()
  or
  not exists(pwn.getPropertyName()) and result = "a property"
}

from DataFlow::PropWrite pwn, DataFlow::AnalyzedNode base
where
  base = pwn.getBase() and
  forex(InferredType tp | tp = base.getAType() |
    tp instanceof PrimitiveType and
    // assignments on `null` and `undefined` are covered by
    // the query 'Property access on null or undefined'
    tp != TTNull() and
    tp != TTUndefined()
  )
select base,
  "Assignment to " + describeProp(pwn) + " of a primitive value with type " + base.ppTypes() + "."
