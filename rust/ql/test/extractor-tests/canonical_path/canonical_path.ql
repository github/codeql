import rust
import TestUtils

from Item i, string path
where
  toBeTested(i) and
  (
    path = i.getExtendedCanonicalPath()
    or
    not i.hasExtendedCanonicalPath() and path = "None"
  )
select i, path
