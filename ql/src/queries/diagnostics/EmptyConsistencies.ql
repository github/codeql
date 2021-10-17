/**
 * @name Consistency predicate that should be empty
 * @description This query should have no results on the CodeQL repos.
 *              It's marked as a warning query to make the results visible.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id ql/diagnostics/empty-consitencies
 */

import ql
import codeql_ql.ast.internal.Predicate::PredConsistency as PredConsistency
import codeql_ql.ast.internal.Type::TyConsistency as TypeConsistency
import codeql_ql.ast.internal.Builtins::BuildinsConsistency as BuildinsConsistency
import codeql_ql.ast.internal.Module::ModConsistency as ModConsistency
import codeql_ql.ast.internal.Variable::VarConsistency as VarConsistency

from AstNode node, string msg
where
  PredConsistency::noResolveCall(node) and msg = "PredConsistency::noResolveCall"
  or
  PredConsistency::noResolvePredicateExpr(node) and msg = "PredConsistency::noResolvePredicateExpr"
  or
  TypeConsistency::noResolve(node) and msg = "TypeConsistency::noResolve"
  or
  TypeConsistency::exprNoType(node) and msg = "TypeConsistency::exprNoType"
  or
  TypeConsistency::varDefNoType(node) and msg = "TypeConsistency::varDefNoType"
  or
  //or // has 1 result, but the CodeQL compiler also can't figure out that one. I suppoed the file is never imported.
  //TypeConsistency::noResolve(node) and msg = "TypeConsistency::noResolve"
  //or // has 1 result, but the CodeQL compiler also can't figure out that one. Same file as above.
  //ModConsistency::noResolve(node) and msg = "ModConsistency::noResolve"
  ModConsistency::noResolveModuleExpr(node) and msg = "ModConsistency::noResolveModuleExpr"
  or
  VarConsistency::noFieldDef(node) and msg = "VarConsistency::noFieldDef"
  or
  VarConsistency::noVarDef(node) and msg = "VarConsistency::noVarDef"
select node, msg
