/**
 * @name Defect filter
 * @description Only include results in large files (200) lines of code, and change the message.
 */
import cpp
import external.DefectFilter
import external.VCS

from DefectResult res
where res.getFile().getMetrics().getNumberOfLinesOfCode() > 200
select res, "Large files: " + res.getMessage()
