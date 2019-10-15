/**
 * @name Possible SQL injection
 * @description Possible SQL injection vector through string-based query construction.
 *         https://bandit.readthedocs.io/en/latest/plugins/b608_hardcoded_sql_expressions.html
 * @kind problem
 * @tags security
 * @problem.severity warning
 * @precision low
 * @id py/bandit/sql-statements
 */

import python

from BinaryExpr b, StrConst s
where (
  (s.getText().toUpperCase().indexOf("SELECT") >= 0 and s.getText().toUpperCase().indexOf("FROM") >= 0)
    or     (s.getText().toUpperCase().indexOf("INSERT") >= 0 and s.getText().toUpperCase().indexOf("INTO") >= 0)
    or     (s.getText().toUpperCase().indexOf("DELETE") >= 0 and s.getText().toUpperCase().indexOf("FROM") >= 0)
    or     (s.getText().toUpperCase().indexOf("UDPATE") >= 0 and s.getText().toUpperCase().indexOf("SET") >= 0)    
    or     (s.getText().toUpperCase().indexOf("WITH") >= 0 and s.getText().toUpperCase().indexOf("AS") >= 0)        
  )
   and b.getLeft() = s
select b, "Possible SQL injection vector through string-based query construction."
