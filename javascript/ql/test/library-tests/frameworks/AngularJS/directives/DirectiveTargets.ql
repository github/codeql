import javascript

from AngularJS::DirectiveTarget dt
where any(AngularJS::DirectiveInstance d).getATarget() = dt
select dt, dt.getName(), dt.getElement(), dt.getType()
