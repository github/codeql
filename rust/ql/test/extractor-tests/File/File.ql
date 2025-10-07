import rust

from File f, string fromSource
where
  exists(f.getRelativePath()) and
  if f.fromSource() then fromSource = "fromSource: yes" else fromSource = "fromSource: no"
select f, fromSource
