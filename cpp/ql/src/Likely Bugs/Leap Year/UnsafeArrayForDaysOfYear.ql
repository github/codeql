/**
 * @name Unsafe array for days of the year (AntiPattern 4)
 * @description An array of 365 items typically indicates one entry per day of the year, but without considering leap years, which would be 366 days.
 *              An access on a leap year could result in buffer overflow bugs.
 * @kind problem
 * @problem.severity warning
 * @id cpp/microsoft/public/leap-year/unsafe-array-for-days-of-the-year
 * @precision low
 * @tags leap-year
 *       correctness
 */

import cpp

/* Note: We used to have a `LeapYearUnsafeDaysOfTheYearArrayType` class which was the
	set of ArrayType that had a fixed length of 365. However, to eliminate false positives,
	we use `isElementAnArrayOfFixedSize` that *also* finds arrays of 366 items, where the programmer
	has also catered for leap years. 
	So, instead of `instanceof` checks, for simplicity, we simply pass in 365/366 as integers as needed.
*/

bindingset[size]
predicate isElementAnArrayOfFixedSize(
  Element element, Type t, Declaration f, string allocType, int size
) {
  exists(NewArrayExpr nae |
    element = nae and
    nae.getAllocatedType().(ArrayType).getArraySize() = size and
    allocType = "an array allocation" and
    f = nae.getEnclosingFunction() and
    t = nae.getAllocatedType().(ArrayType).getBaseType()
  )
  or
  exists(Variable var |
    var = element and
    var.getType().(ArrayType).getArraySize() = size and
    allocType = "an array allocation" and
    f = var and
    t = var.getType().(ArrayType).getBaseType()
  )
  or
  exists(ConstructorCall cc |
    element = cc and
    cc.getTarget().hasName("vector") and
    cc.getArgument(0).getValue().toInt() = size and
    allocType = "a std::vector allocation" and
    f = cc.getEnclosingFunction() and
    t = cc.getTarget().getDeclaringType()
  )
}

from Element element, string allocType, Declaration f, Type t
where
  isElementAnArrayOfFixedSize(element, t, f, allocType, 365) and
  not exists(Element element2, Declaration f2 |
    isElementAnArrayOfFixedSize(element2, t, f2, _, 366) and
    if f instanceof Function then f = f2 else f.getParentScope() = f2.getParentScope()
  )
select element,
  "$@: There is " + allocType +
    " with a hard-coded set of 365 elements, which may indicate the number of days in a year without considering leap year scenarios.",
  f, f.toString()
