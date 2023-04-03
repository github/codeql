import cpp

from Declaration d
where d.getLocation().getFile().getBaseName() != ""
select d
