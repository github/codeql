import semmle.code.cpp.commons.Printf

from FormatLiteral fl, int i
select fl, i, concat(fl.getParameterField(i).toString(), ", "), fl.getConversionChar(i),
  fl.getLength(i), concat(fl.getConversionType(i).getLocation().toString(), ", "),
  concat(fl.getConversionType(i).toString(), ", ")
