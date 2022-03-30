import semmle.javascript.frameworks.Bundling

from ObjectExpr oe
where isBrowserifyBundle(oe)
select oe.getTopLevel()
