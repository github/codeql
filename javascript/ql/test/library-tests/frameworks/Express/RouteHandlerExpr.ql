import javascript

from Express::RouteHandlerExpr rhe, boolean isLast
where if rhe.isLastHandler() then isLast = true else isLast = false
select rhe, rhe.getSetup(), isLast
