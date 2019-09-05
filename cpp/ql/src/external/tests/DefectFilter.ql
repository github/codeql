/**
 * @name Defect filter
 * @description Only include results in large files (200) lines of code, and change the message.
 * @tags filter
 */

import cpp
import external.DefectFilter

from DefectResult res
where res.getFile().getMetrics().getNumberOfLinesOfCode() > 200
select res, "Large files: " + res.getMessage()
