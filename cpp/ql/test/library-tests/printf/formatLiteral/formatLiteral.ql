import semmle.code.cpp.commons.Printf

from FormatLiteral fl
select fl, concat(fl.getMaxConvertedLength().toString(), ", ")
