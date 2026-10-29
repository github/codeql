class Element extends @element {
  string toString() { none() }
}

from Element file, string filename
where
  db_files(file) and
  files(file, filename) and
  filename.matches("%.swift") and
  not exists(Element error, Element loc |
    diagnostics(error, _, 4) and
    locatable_locations(error, loc) and
    locations(loc, file, _, _, _, _)
  )
select file
