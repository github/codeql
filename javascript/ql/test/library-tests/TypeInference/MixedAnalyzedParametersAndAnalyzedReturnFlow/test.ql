import javascript

from DataFlow::CallNode c, int i, DataFlow::Node arg
where arg = c.getArgument(i)
select arg, i, arg.analyze().getAValue()
