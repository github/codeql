/**
 * @name Property type trap file generator
 * @description Generate trap files (in CSV form) describing CPython extension property types.
 * @kind trap
 * @id cpp/c-python/property-type-trap
 */

import cpp

import CPython.Extensions


from TypedPythonExtensionProperty p, PythonClass cls
where cls = p.getPropertyType()
select "ext_proptype", p.getTrapID(), cls.getTrapID()
