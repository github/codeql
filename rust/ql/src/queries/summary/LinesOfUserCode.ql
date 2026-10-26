/**
 * @name Total lines of user written Rust code in the database
 * @description The total number of lines of Rust code from the source code directory. This query counts the lines of code, excluding whitespace or comments.
 * @kind metric
 * @id rust/summary/lines-of-user-code
 * @tags summary
 *       lines-of-code
 *       debug
 */

import rust
import Stats

select getLinesOfUserCode()
