/**
 * @name (Import additional libraries)
 * @description This query produces no results but imports some libraries we
 *              would like to make available in the LGTM query console even
 *              if they are not used by any queries.
 * @kind file-classifier
 * @id java/lgtm/import-additional-libraries
 */

import java
import semmle.code.java.dataflow.Guards
import semmle.code.java.security.DataFlow

from File f, string tag
where none()
select f, tag
