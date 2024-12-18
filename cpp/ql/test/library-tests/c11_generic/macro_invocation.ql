import cpp

from C11GenericExpr g, MacroInvocation m
where m.getAnExpandedElement() = g
select g, m
