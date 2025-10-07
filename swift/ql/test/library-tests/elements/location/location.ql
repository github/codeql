import swift

from Location l
where exists(l.getFile().getRelativePath()) or l instanceof UnknownLocation
select l
