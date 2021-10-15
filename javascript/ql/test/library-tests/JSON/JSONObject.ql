import semmle.javascript.JSON

from JSONObject obj, string prop, JSONValue val, string strval
where
  val = obj.getPropValue(prop) and
  (
    if exists(obj.getPropStringValue(prop))
    then strval = obj.getPropStringValue(prop)
    else strval = "(none)"
  )
select obj, prop, val, strval
