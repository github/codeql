import java

query predicate javaFiles(File f) { f.isJavaSourceFile() }

from XmlFile f
select f
