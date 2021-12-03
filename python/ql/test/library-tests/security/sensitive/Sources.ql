import python
import semmle.python.security.SensitiveData

from SensitiveData::Source src
select src.getLocation(), src.repr()
