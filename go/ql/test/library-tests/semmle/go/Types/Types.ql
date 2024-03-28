import go

from Type t, string filepath
where
  t.hasLocationInfo(filepath, _, _, _, _) and
  filepath != ""
select t.pp()
