import python
import semmle.python.types.Descriptors

from PropertyValue p, string method_name, FunctionValue method
where
  method_name = "getter" and method = p.getGetter()
  or
  method_name = "setter" and method = p.getSetter()
  or
  method_name = "deleter" and method = p.getDeleter()
select method, method_name, p
