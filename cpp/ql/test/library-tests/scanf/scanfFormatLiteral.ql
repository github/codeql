import semmle.code.cpp.commons.Scanf

from ScanfFormatLiteral sfl, int n
select sfl.getUse(), n, sfl.getConversionChar(n), sum(sfl.getMaxWidth(n)),
  sum(sfl.getMaxConvertedLength(n))
