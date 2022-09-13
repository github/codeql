import javascript

from AngularJS::ScopeServiceReference s, DataFlow::MethodCallNode mce
where mce = s.getAMethodCall(_)
select mce
