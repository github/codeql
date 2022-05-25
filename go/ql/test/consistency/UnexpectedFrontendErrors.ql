/**
 * @name Unexpected frontend error
 * @description This query produces a list of all errors produced by the Go frontend
 *              during extraction.
 * @id go/unexpected-frontend-error
 */

import go

from Error e
select e
