import python

from string name, int mcnt
where mcnt = strictcount(Module m | m.getName() = name) and mcnt > 1
select name, mcnt, strictcount(ModuleValue val | val.getName() = name)
