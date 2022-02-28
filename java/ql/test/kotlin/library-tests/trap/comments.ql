import java

from KtComment c, string s, int len
where s = c.getText()
  and len = s.length()
  // Ignore the comments that are describing what's going on, and only
  // select the large ones
  and len > 1000
select c.getLocation(),
       len,
       s.prefix(5) + "..." + s.suffix(len - 5),
       c.getPrimaryQlClasses()
