import semmle.code.asp.AspNet

from AspDirective directive, string name, AspAttribute attrib
where directive.getAttributeByName(name) = attrib
select directive, name, attrib
