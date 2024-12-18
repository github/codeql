import rust

from Function f
where exists(f.getLocation().getFile().getRelativePath())
select f
