import python
private import semmle.python.dataflow.new.DataFlow

from DataFlow::AttrRead read
select read, read.getObject(), read.getAttributeName()
