import javascript

from YieldExpr yield, string s
where if yield.isDelegating() then s = "delegating" else s = "not delegating"
select yield, s
