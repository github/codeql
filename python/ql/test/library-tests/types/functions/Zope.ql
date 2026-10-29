import python
import semmle.python.libraries.Zope

from ZopeInterfaceMethodValue f
select f.toString()
