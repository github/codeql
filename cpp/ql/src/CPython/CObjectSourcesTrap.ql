/**
 * @name py_cobject_sources() trap file generator
 * @description Generate trap files (in CSV form) for CPython objects.
 * @kind trap
 * @id cpp/c-python/c-object-sources-trap
 */

import cpp

import CPython.Extensions

from CObject c
select "py_cobject_sources", c.getTrapID(), 1
