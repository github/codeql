/**
 * @name Total lines of Rust code in the database
 * @description The total number of lines of Rust code across all files, including any libraries and auto-generated files that the extractor sees. This is a useful metric of the size of a database. For all files that were seen during the build, this query counts the lines of code, excluding whitespace or comments.
 * @kind metric
 * @id rust/summary/lines-of-code
 * @tags summary
 *       lines-of-code
 *       telemetry
 */

import rust
import Stats

select getLinesOfCode()
