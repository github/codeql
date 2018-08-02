/**
 * @name py_cobject() trap file generator
 * @description Generate trap files (in CSV form) for CPython objects.
 * @kind trap
 * @id cpp/c-python/c-object-trap
 */

import cpp

import CPython.Extensions


from CObject c
select "py_cobjects", c.getTrapID()
