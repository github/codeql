/**
 * @name Encapsed strings with variables
 * @description Find interpolated strings that contain variable references.
 * @id php/debug/encapsed-strings
 * @kind problem
 */

import codeql.php.AST
import codeql.php.ast.Literal

from EncapsedString es
select es, "Encapsed string with " + count(es.getAnElement()) + " element(s)"
