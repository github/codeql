import cpp

from AttributeFormattingFunction f
select f, f.getFormatParameterIndex(), concat(f.getDefaultCharType().toString(), ", "),
  concat(f.getWideCharType().toString(), ", "), concat(f.getNonDefaultCharType().toString(), ", ")
