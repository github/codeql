import semmle.code.cpp.commons.Scanf

from ScanfFunctionCall sfc, string wide
where if sfc.isWideCharDefault() then wide = "wide" else wide = "non-wide"
select sfc, sum(sfc.getInputParameterIndex()), sfc.getFormatParameterIndex(), sfc.getFormat(), wide
