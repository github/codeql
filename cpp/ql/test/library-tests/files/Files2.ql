import cpp

string isCompiledAsC(File f) { if f.compiledAsC() then result = "C" else result = "-" }

string isCompiledAsCpp(File f) { if f.compiledAsCpp() then result = "C++" else result = "---" }

from File f
// On 64bit Linux, __va_list_tag is in the unknown file (""). Ignore it.
where f.getAbsolutePath() != ""
select (f.getAQlClass().toString() + "          ").prefix(10), isCompiledAsC(f), isCompiledAsCpp(f),
  f.toString()
