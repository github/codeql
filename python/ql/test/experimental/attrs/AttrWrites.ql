import python
private import semmle.python.dataflow.new.DataFlow

from DataFlow::AttrWrite write
select write, write.getObject(), write.getAttributeName(), write.getValue()
