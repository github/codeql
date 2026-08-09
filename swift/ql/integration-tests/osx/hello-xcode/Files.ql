import swift

from File f
where
  (exists(f.getRelativePath()) or f instanceof UnknownFile) and
  not f.getBaseName() = "<module-includes>"
select f
