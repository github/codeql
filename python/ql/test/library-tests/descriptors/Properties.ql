
import python
import semmle.python.types.Descriptors

int lineof(Object o) {
    result = o.getOrigin().getLocation().getStartLine()
}

from PropertyObject p, FunctionObject getter, FunctionObject setter
where
getter = p.getGetter() and setter = p.getSetter()
select lineof(p), p.toString(), lineof(getter), getter.toString(), lineof(setter), setter.toString()

