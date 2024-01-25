/**
 * @name Extracted files
 * @description A list of all files in the source code directory that were extracted
 *              without encountering an extraction or compiler error in the file.
 * @kind diagnostic
 * @id cs/diagnostics/successfully-extracted-files
 * @tags successfully-extracted-files
 */

import csharp
import semmle.code.csharp.commons.Diagnostics

from File file
where file.fromSource()
select file, ""
