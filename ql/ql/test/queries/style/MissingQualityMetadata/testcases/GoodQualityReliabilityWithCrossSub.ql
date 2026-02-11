/**
 * @name Some query
 * @description Some description
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id ql/quality-query-test
 * @tags quality
 *       reliability
 *       correctness
 *       readability
 */

import ql

from Class c
where none()
select c, ""
