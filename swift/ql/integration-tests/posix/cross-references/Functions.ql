import codeql.swift.elements.decl.internal.AccessorOrNamedFunction

from AccessorOrNamedFunction f
where f.getLocation().getFile().getBaseName() != "Package.swift"
select f
