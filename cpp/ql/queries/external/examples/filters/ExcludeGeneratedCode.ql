/**
 * @name Filter: exclude results from generated code
 * @description This filter demonstrates how to return results only if
 *              they meet certain criteria. In this example, results are
 *              only returned if they do not come from a file which
 *              contains 'generated' anywhere in its path.
 * @tags filter
 */

import cpp
import external.DefectFilter

predicate generatedFile(File f) { f.getAbsolutePath().matches("%generated%") }

from DefectResult res
where not generatedFile(res.getFile())
select res, res.getMessage()
