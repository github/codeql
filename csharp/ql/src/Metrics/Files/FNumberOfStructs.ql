/**
 * @name Number of structs
 * @description Files with a large number of structs are difficult to read. Additionally the structure of the project is not reflected in the file system.
 * @kind treemap
 * @treemap.warnOn highValues
 * @metricType file
 * @metricAggregate avg sum max
 * @tags maintainability
 * @id cs/structs-per-file
 */

import csharp

from SourceFile f, int n
where n = count(Struct s | s.getFile() = f and s.isSourceDeclaration())
select f, n order by n desc
