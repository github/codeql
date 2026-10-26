import semmle.javascript.frameworks.Bundling

from ArrayExpr ae
where isWebpackBundle(ae)
select ae.getTopLevel()
