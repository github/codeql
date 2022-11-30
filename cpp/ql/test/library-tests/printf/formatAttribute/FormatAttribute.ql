import cpp

from FormatAttribute fa
select fa, fa.getArchetype(), concat(fa.getFormatIndex().toString(), ", "),
  concat(fa.getFirstFormatArgIndex().toString(), ", ")
