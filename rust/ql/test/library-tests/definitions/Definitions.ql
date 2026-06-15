import codeql.rust.internal.Definitions

from Definition def, Use use, string kind
where
  def = definitionOf(use, kind) and
  use.fromSource()
select use, def, kind
