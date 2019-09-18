/**
 * @name Filter: exclude results from files for which we do not have
 *       source code
 * @description Use this filter to return results only if they are
 *              located in files for which we have source code.
 * @kind problem
 * @id cpp/from-source-filter
 * @tags filter
 */

import cpp
import external.DefectFilter

from DefectResult res
where res.getFile().fromSource()
select res, res.getMessage()
