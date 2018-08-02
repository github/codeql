/**
 * @name Return type trap file generator
 * @description Generate trap files (in CSV form) describing CPython extension function return types.
 * @kind trap
 * @id cpp/c-python/return-type-trap
 */

import cpp

import CPython.Extensions


from TypedPythonExtensionFunction func, PythonClass cls
where cls = func.getReturnType()
select "ext_rettype", func.getTrapID(), cls.getTrapID()
