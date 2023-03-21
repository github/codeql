// Moves availability_infos into UnspecifiedElements
class Element extends @element {
  string toString() { none() }
}

from Element e, string property, string error
where
  availability_infos(e) and
  property = "" and
  error = "Removed availability infos during the database downgrade"
  or
  unspecified_elements(e, property, error)
select e, property, error
