import codeql.rust.internal.Definitions

from Definition def, Use use, string kind
where def = definitionOf(use, kind)
select def, use, kind
