/**
 * @id cpp/examples/catch-exception
 * @name Catch exception
 * @description Finds places where we catch exceptions of type `parse_error`
 * @tags catch
 *       try
 *       exception
 */

import cpp

from CatchBlock catch
// `stripType` converts `const parse_error &` to `parse_error`.
where catch.getParameter().getType().stripType().hasName("parse_error")
select catch
