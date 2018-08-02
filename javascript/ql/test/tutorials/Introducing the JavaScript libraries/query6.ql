import javascript

from Function fun, Parameter p, Parameter q, int i, int j
where p = fun.getParameter(i) and
    q = fun.getParameter(j) and
    i < j and
    p.getAVariable() = q.getAVariable()
select fun, "This function has two parameters that bind the same variable."
