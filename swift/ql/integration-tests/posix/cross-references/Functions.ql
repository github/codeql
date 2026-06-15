import codeql.swift.elements.decl.internal.AccessorOrNamedFunction

from AccessorOrNamedFunction f
where
  f.getLocation().getFile().getBaseName() != "Package.swift" and
  exists(f.getLocation().getFile().getRelativePath())
select f
