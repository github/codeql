/**
 * @name Wrong NaN comparison
 * @description A comparison with 'NaN' using '==' or '!=' will always yield the same result
 *              and is unlikely to be intended.
 * @kind problem
 * @problem.severity error
 * @precision very-high
 * @id java/comparison-with-nan
 * @tags correctness
 */

import java

predicate nanField(Field f) {
  f.getDeclaringType() instanceof FloatingPointType and
  f.hasName("NaN")
}

from EqualityTest eq, Field f, string classname
where
  eq.getAnOperand() = f.getAnAccess() and nanField(f) and f.getDeclaringType().hasName(classname)
select eq,
  "This comparison will always yield the same result since 'NaN != NaN'. Consider using " +
    classname + ".isNaN instead"
