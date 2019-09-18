/**
 * @name Filter out minified files
 * @description Only keep results from files that are not minified.
 * @kind problem
 * @id js/not-minified-file-filter
 */

import javascript
import external.DefectFilter

from DefectResult defres
where not defres.getFile().getATopLevel().isMinified()
select defres, defres.getMessage()
