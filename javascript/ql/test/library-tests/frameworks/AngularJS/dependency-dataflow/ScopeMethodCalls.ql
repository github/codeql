import javascript

from AngularJS::ScopeServiceReference s, MethodCallExpr mce
where mce = s.getAMethodCall(_)
select mce
