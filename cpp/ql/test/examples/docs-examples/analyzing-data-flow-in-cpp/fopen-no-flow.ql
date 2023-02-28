import cpp

from Function fopen, FunctionCall fc
where
  fopen.hasQualifiedName("fopen") and
  fc.getTarget() = fopen
select fc.getArgument(0)
