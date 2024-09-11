import cpp
import semmle.code.cpp.headers.PreprocBlock

from PreprocessorBlock b, Include i
where b.getAnInclude() = i
select i, b
