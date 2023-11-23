/**
 * Fill in your class name and file path below, to inspect the class hierarchy.
 */

import python
import semmle.python.dataflow.new.internal.DataFlowPublic
import semmle.python.dataflow.new.internal.DataFlowPrivate

predicate interestingClass(Class cls) {
  cls.getName() = "YourClassName"
  // and cls.getLocation().getFile().getAbsolutePath().matches("%/folder/file.py")
}

query predicate superClasses(Class cls, Class super_) {
  interestingClass(cls) and
  super_ = getADirectSuperclass+(cls)
}

query predicate subClasses(Class cls, Class super_) {
  interestingClass(cls) and
  super_ = getADirectSubclass+(cls)
}

from Class cls
where interestingClass(cls)
select cls
