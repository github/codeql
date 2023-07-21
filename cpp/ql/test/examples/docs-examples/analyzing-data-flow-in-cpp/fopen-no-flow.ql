import cpp

from Function fopen, FunctionCall fc
where
  fopen.hasGlobalName("fopen") and
  fc.getTarget() = fopen
select fc.getArgument(0)
