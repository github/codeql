import semmle.javascript.frameworks.React

from ReactComponent c, string n
select c, n, c.getInstanceMethod(n)