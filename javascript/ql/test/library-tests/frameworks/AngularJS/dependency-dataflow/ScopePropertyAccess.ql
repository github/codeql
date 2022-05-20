import javascript

from AngularJS::ScopeServiceReference s, DataFlow::PropRef prop
where prop = s.getAPropertyAccess(_)
select prop
