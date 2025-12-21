/**
 * @name Test PHP Library
 * @description Test that the PHP library compiles
 * @kind problem
 */

import codeql.php.polymorphism.Polymorphism
import codeql.php.types.Type
import codeql.php.frameworks.AllFrameworks
import codeql.php.ast.Expr
import codeql.php.ast.Stmt

from ClassDeclaration c
where c.getClassName() != ""
select c, "Class: " + c.getClassName()
