import semmle.javascript.NodeJS

from NodeModule m
select m, m.getFile(), m.getPath(), m.getName()
