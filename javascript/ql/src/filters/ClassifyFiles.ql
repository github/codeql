/**
 * @name Classify files
 * @description This query produces a list of all files in a snapshot
 *              that are classified as generated code, test code,
 *              externs declarations, library code or template code.
 * @kind file-classifier
 * @id js/file-classifier
 */

import javascript
import ClassifyFiles

from File f, string category
where classify(f, category)
select f, category
