import cpp
import semmle.code.cpp.headers.PreprocBlock

from PreprocessorBlock b, string parent
where if exists(b.getParent()) then parent = b.getParent().toString() else parent = "(no parent)"
select parent, b
