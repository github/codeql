import rust

from File f
where exists(f.getRelativePath())
select f
