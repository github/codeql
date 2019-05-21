/**
 * @name Unsafe array for days of the year 
 * @description An array of 365 items typically indicates one entry per day of the year, but without considering leap years, which would be 366 days. 
 *              An access on a leap year could result in buffer overflow bugs.
 * @kind problem
 * @problem.severity error
 * @id cpp/leap-year/unsafe-array-for-days-of-the-year
 * @precision medium
 * @tags security
 *       leap-year
 */

import cpp

class LeapYearUnsafeDaysOfTheYearArrayType extends ArrayType {
    LeapYearUnsafeDaysOfTheYearArrayType() {
        this.getArraySize() = 365
    }
}

from Element element
where
    exists( NewArrayExpr nae |
        element = nae
        and nae.getAllocatedType() instanceof LeapYearUnsafeDaysOfTheYearArrayType
    )
    or exists( Variable var |
        var = element
        and var.getType() instanceof LeapYearUnsafeDaysOfTheYearArrayType
    )
    or exists( ConstructorCall cc |
        element = cc
        and cc.getTarget().hasName("vector")
        and cc.getArgument(0).getValue().toInt() = 365
    )
select element, "There is an array or std::vector allocation with a hardcoded set of 365 elements, which may indicate number of days of days in a year without considering leap year scenarios"
