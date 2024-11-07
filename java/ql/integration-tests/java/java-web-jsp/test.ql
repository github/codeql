import java

from File f
where f.isSourceFile()
select f

query predicate xmlFiles(XmlFile x) { any() }
