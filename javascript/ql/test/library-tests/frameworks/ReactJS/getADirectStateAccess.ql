import semmle.javascript.frameworks.React

from ReactComponent c
select c, c.getADirectStateAccess()