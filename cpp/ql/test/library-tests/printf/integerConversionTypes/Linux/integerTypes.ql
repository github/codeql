import semmle.code.cpp.commons.Printf

from FormatLiteral format, int n
where exists(format.getConvSpecOffset(n))
select format, n, concat(format.getIntegralConversion(n).toString(), ", "),
  concat(format.getIntegralDisplayType(n).toString(), ", "),
  concat(format.getConversionType(n).toString(), ", "),
  concat(format.getStorePointerConversion(n).toString(), ", ")
