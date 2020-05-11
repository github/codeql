import python
import semmle.python.types.Descriptors

int lineof(Object o) { result = o.getOrigin().getLocation().getStartLine() }

from Object m, FunctionObject f
where
  m.(ClassMethodObject).getFunction() = f
  or
  m.(StaticMethodObject).getFunction() = f
select lineof(m), m.toString(), lineof(f), f.toString()
