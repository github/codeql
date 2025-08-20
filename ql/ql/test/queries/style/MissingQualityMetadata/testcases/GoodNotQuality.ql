/**
 * @name Some query
 * @description Some description
 * @kind problem
 * @problem.severity warning
 * @security-severity 10.0
 * @precision very-high
 * @id ql/quality-query-test
 * @tags security
 */

import ql

from Class c
where none()
select c, ""
