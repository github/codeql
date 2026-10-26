import javascript

from PropertyProjection p, boolean singleton
where if p.isSingletonProjection() then singleton = true else singleton = false
select p, p.getObject(), p.getASelector(), singleton
