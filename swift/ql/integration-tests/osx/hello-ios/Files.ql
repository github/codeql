import swift

from File f
where exists(f.getRelativePath()) or f instanceof UnknownFile
select f
