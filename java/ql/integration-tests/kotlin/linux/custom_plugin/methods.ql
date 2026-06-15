import java

from Method m, string body
where
  m.fromSource() and
  if exists(m.getBody()) then body = "has body" else body = "has no body"
select m, body
