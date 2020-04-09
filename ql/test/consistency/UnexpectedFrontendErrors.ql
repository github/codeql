/**
 * @name Unexpected frontend error
 * @description This query produces a list of all errors produced by the Go frontend
 *              during extraction, except for those occurring in files annotated with
 *              "// codeql test: expect frontend errors".
 * @id go/unexpected-frontend-error
 */

import go

from Error e
where
  not exists(Comment c | c.getFile() = e.getFile() |
    c.getText().trim() = "codeql test: expect frontend errors"
  )
select e
