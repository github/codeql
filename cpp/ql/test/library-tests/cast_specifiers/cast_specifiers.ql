import cpp

from Cast c, string cs, string ts, string volatile, string const, string explicit, string padding
where
  (if c.getType().isVolatile() then volatile = "Volatile" else volatile = "--------") and
  (if c.getType().isConst() then const = "Const" else const = "-----") and
  (if c.isImplicit() then explicit = "implicit" else explicit = "explicit") and
  padding = "                                     " and
  cs = c.toString() and
  ts = c.getType().toString()
select c.getLocation().getStartLine(), (cs + padding).prefix(cs.length().maximum(23)),
  (ts + padding).prefix(ts.length().maximum(18)), explicit, volatile, const
