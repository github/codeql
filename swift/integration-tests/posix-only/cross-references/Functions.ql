import codeql.swift.elements.decl.AccessorOrNamedFunction

from AccessorOrNamedFunction f
where f.getLocation().getFile().getBaseName() != "Package.swift"
select f
