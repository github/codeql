/**
 * @name Parameter type trap file generator
 * @description Generate trap files (in CSV form) describing CPython extension function parameter types.
 * @kind trap
 * @id cpp/c-python/argument-type-trap
 */

import cpp

import CPython.Extensions

from TypedPythonExtensionFunction func, int arg, PythonClass cls
where func.getArgumentType(arg) = cls
select "ext_argtype", func.getTrapID(), arg, cls.getTrapID()
