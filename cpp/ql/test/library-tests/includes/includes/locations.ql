import cpp

from Location l
where not l.getContainer() instanceof Folder
select l
