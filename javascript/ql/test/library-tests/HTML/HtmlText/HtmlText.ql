import javascript

from HTML::TextNode t, string cdata
where
  t.toString().trim().length() > 0 and
  if t.isCData() then cdata = "(cdata)" else cdata = ""
select t, t.getParent(), t.getIndex(), cdata
