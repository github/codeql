import python

from ClassValue cls, string res
where
  exists(CallNode call |
    call.getFunction().(NameNode).getId() = "test" and
    call.getAnArg().pointsTo(cls)
  ) and
  (
    cls.isSequence() and
    cls.isMapping() and
    res = "IS BOTH. SHOULD NOT HAPPEN. THEY ARE MUTUALLY EXCLUSIVE."
    or
    cls.isSequence() and not cls.isMapping() and res = "sequence"
    or
    not cls.isSequence() and cls.isMapping() and res = "mapping"
    or
    not cls.isSequence() and not cls.isMapping() and res = "neither sequence nor mapping"
  )
select res, cls.toString()
