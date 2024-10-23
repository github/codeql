import rust
import TestUtils

from Item i, string path
where
  toBeTested(i) and
  (
    path = i.getCanonicalPath()
    or
    not i.hasCanonicalPath() and path = "None"
  )
select i, path
