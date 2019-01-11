import semmle.javascript.NodeJS

from Require r, string fullpath, string prefix
where
  fullpath = r.getImportedPath().getValue() and
  sourceLocationPrefix(prefix)
select r, fullpath.replaceAll(prefix, ""), r.getImportedModule()
