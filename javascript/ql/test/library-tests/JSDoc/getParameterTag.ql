import javascript

from Parameter param, JSDocTag tag
where tag = param.getJSDocTag()
select param, param.getName(), tag, tag.getName(), tag.getType()
