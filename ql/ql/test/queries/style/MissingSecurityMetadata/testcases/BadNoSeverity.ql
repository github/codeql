/**
 * @name Some query
 * @description Some description
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id ql/some-query
 * @tags quality
 *       security
 */

import ql

from Class c
where none()
select c
