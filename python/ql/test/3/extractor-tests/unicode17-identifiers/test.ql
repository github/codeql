import python

from Name name
where name.getLocation().getFile().getShortName() = "test.py"
select name, name.getId()
