import python
import analysis.DefinitionTracking
import analysis.CrossProjectDefinitions

predicate local_problem(Definition defn, string issue, string repr) {
  not exists(defn.toString()) and issue = "no toString()" and repr = "a local definition"
  or
  not exists(defn.getAstNode()) and issue = "no getAstNode()" and repr = defn.toString()
  or
  not exists(defn.getLocation()) and issue = "no getLocation()" and repr = defn.toString()
  or
  count(defn.getLocation()) > 1 and issue = "more than one getLocation()" and repr = defn.toString()
}

predicate remote_problem(Symbol s, string issue, string repr) {
  not exists(s.toString()) and issue = "no toString()" and repr = "a symbol"
}

from string issue, string repr
where remote_problem(_, issue, repr) or local_problem(_, issue, repr)
select issue, repr
