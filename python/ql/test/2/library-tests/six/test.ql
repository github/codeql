import python

predicate six(ModuleObject m) {
    m.getName() = "six"
    or
    six(m.getPackage())
}

from ModuleObject mod, string name, Object obj
where mod.attributeRefersTo(name, obj, _) and six(mod)
select mod.toString(), name, obj.toString()
