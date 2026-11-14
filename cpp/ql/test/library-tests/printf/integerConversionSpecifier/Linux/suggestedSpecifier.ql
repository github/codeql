import semmle.code.cpp.commons.Printf

from FormatLiteral format, int n
where exists(format.getConvSpecOffset(n))
select format, n,
  concat(Expr arg |
    arg = format.getUse().getConversionArgument(n)
  |
    format.getSuggestedIntegerConversionSpecifier(n, arg.getFullyConverted().getType()), ", "
  ),
  concat(Expr arg |
    arg = format.getUse().getConversionArgument(n)
  |
    format.getSuggestedIntegerConversionSpecifier(n, arg.getUnconverted().getType()), ", "
  )
