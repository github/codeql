/**
 * @name Get all files in the database
 * @description Get all files in the database
 * @kind problem
 * @id cpp/get_files
 * @problem.severity error
 * @precision very-high
 */

 import cpp

 from File f
 select f, "$@", f, f.getBaseName()
 