import cpp

from StringLiteral sl
select sl.getValue().regexpReplaceAll("\\\\x00+", "\\\\x0"), // Normalise for different sizeof(wchar_t)
  sl.getValueText()
