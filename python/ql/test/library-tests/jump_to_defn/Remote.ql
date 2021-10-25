import python
import analysis.DefinitionTracking
import analysis.CrossProjectDefinitions

from Definition defn, Symbol s
where
  s.find() = defn.getAstNode() and
  // Exclude dunder names as these vary from version to version.
  not s.toString().regexpMatch(".+__")
select s.toString()
