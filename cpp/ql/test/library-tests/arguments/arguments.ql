import cpp

from Compilation c, int i, string s
// Skip the extractor name; it'll vary depending on platform
where
  i > 0 and
  s = c.getArgument(i).replaceAll("\\", "/")
select c.getAFileCompiled().toString(), i, s
