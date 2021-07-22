import python
import experimental.semmle.python.frameworks.ClickHouseDriver
import semmle.python.Concepts

from SqlExecution s
select s, s.getSql()
