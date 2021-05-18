import ruby

/*
 * predicate possible_reflective_name(string name) {
 *  exists(any(ModuleValue m).attr(name))
 *  or
 *  exists(any(ClassValue c).lookup(name))
 *  or
 *  any(ClassValue c).getName() = name
 *  or
 *  exists(Module::named(name))
 *  or
 *  exists(Value::named(name))
 * }
 */

string module_name() { result = any(Namespace m | | m.getName()) }

from string s
where s = module_name()
select s
