/**
 * @id rb/summary/lines-of-user-code
 * @name Total lines of user written Ruby code in the database
 * @description The total number of lines of Ruby code from the source code
 *   directory, excluding external library and auto-generated files. This
 *   query counts the lines of code, excluding whitespace or comments.
 * @kind metric
 * @tags summary
 *       debug
 */

import codeql.ruby.AST

select sum(RubyFile f |
    f.fromSource() and
    exists(f.getRelativePath()) and
    not f.getAbsolutePath().matches("%/vendor/%")
  |
    f.getNumberOfLinesOfCode()
  )
