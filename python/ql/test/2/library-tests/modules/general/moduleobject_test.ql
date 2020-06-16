import python

from ModuleObject m, string name
where m.getName() = "package" or m.getName() = "confused_elements"
select m.toString(), name, m.getAttribute(name).toString()
