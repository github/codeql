import java
import semmle.code.java.StringFormat

from FormatString f, int argNo, int offset
where offset = f.getAnArgUsageOffset(argNo)
select f, argNo, offset
