/**
 * @name Csv Injection
 * @description From user-controlled data saved in CSV files, it is easy to attempt information disclosure
 *              or other malicious activities when automated by spreadsheet software
 * @kind path-problem
 * @problem.severity error
 * @id py/csv-injection
 * @tags security
 *       experimental
 *       external/cwe/cwe-1236
 */

import python
import CsvInjectionFlow::PathGraph
import semmle.python.dataflow.new.DataFlow
import experimental.semmle.python.security.injection.CsvInjection

from CsvInjectionFlow::PathNode source, CsvInjectionFlow::PathNode sink
where CsvInjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Csv injection might include code from $@.", source.getNode(),
  "this user input"
