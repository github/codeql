import javascript

from ESLint::GlobalsConfigurationObject g, string n, boolean w, GlobalVarAccess gva
where g.declaresGlobal(n, w) and g.appliesTo(gva)
select g, n, w, gva
