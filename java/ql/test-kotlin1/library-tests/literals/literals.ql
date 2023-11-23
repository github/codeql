import java

from Literal l
where l.getFile().isSourceFile()
select l, l.getPrimaryQlClasses()
