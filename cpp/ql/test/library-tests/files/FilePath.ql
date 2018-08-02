import cpp

from File f
where f.toString() != ""
select f.toString(), f.getRelativePath()
