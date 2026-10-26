import java

from XmlElement e
where e.hasName("doc")
select e.getACharactersSet()
