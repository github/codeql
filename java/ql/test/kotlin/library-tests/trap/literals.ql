import java

from Literal l, int len
where len = l.getValue().length()
select l.getLocation(), len, l.getValue().prefix(5) + "..." + l.getValue().suffix(len - 5),
  l.getPrimaryQlClasses()
