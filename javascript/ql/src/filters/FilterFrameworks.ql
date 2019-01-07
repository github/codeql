/**
 * @name Filter out framework code
 * @description Only keep results in non-framework code
 * @kind problem
 * @problem.severity warning
 * @id js/not-framework-file-filter
 */

import FilterFrameworks
import external.DefectFilter

from DefectResult defres
where nonFrameworkFile(defres.getFile())
select defres, defres.getMessage()
