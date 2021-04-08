import python

from ClassObject cls, ClassObject start, string name, Object val
where not name.substring(0, 2) = "__" and val = cls.lookupMro(start, name)
select cls.getOrigin().getLocation().getStartLine(), cls.toString(), start.toString(), name,
  val.toString(), val.getOrigin().getLocation().getStartLine()
