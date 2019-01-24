import semmle.javascript.NodeJS

from NodeModule m
select m, m.getAnExportedSymbol()
