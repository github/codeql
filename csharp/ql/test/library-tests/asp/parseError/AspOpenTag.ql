import semmle.code.asp.AspNet

from AspOpenTag tag, string name, AspAttribute attrib
where tag.getAttributeByName(name) = attrib
select tag, name, attrib
