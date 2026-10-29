/**
 * @name QL-for-QL encountered an internal consistency error
 * @description This query should have no results on the CodeQL repos.
 *              It's marked as a warning query to make the results visible.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id ql/diagnostics/empty-consistencies
 */

import ql
import codeql_ql.ast.internal.Predicate::PredConsistency as PredConsistency
import codeql_ql.ast.internal.Type::TyConsistency as TypeConsistency
import codeql_ql.ast.internal.Builtins::BuiltinsConsistency as BuiltinsConsistency
import codeql_ql.ast.internal.Module::ModConsistency as ModConsistency
import codeql_ql.ast.internal.Variable::VarConsistency as VarConsistency
import codeql_ql.ast.internal.AstNodes::AstConsistency as AstConsistency

from AstNode node, string msg
where
  (
    PredConsistency::noResolveCall(node) and msg = "PredConsistency::noResolveCall"
    or
    PredConsistency::noResolvePredicateExpr(node) and
    msg = "PredConsistency::noResolvePredicateExpr"
    or
    // This went out the window with parameterised modules.
    // PredConsistency::multipleResolveCall(node, _, _) and
    // msg = "PredConsistency::multipleResolveCall"
    // or
    PredConsistency::multipleResolvePredicateExpr(node, _, _) and
    msg = "PredConsistency::multipleResolvePredicateExpr"
    or
    TypeConsistency::exprNoType(node) and msg = "TypeConsistency::exprNoType"
    or
    TypeConsistency::varDefNoType(node) and msg = "TypeConsistency::varDefNoType"
    or
    TypeConsistency::multiplePrimitives(node, _, _) and msg = "TypeConsistency::multiplePrimitives"
    or
    TypeConsistency::multiplePrimitivesExpr(node, _, _) and
    msg = "TypeConsistency::multiplePrimitivesExpr"
    or
    AstConsistency::nonTotalGetParent(node) and msg = "AstConsistency::nonTotalGetParent"
    or
    AstConsistency::nonUniqueParent(node) and msg = "AstConsistency::nonUniqueParent"
    or
    TypeConsistency::noResolve(node) and msg = "TypeConsistency::noResolve"
    or
    ModConsistency::noName(node) and msg = "ModConsistency::noName"
    or
    ModConsistency::nonUniqueName(node) and msg = "ModConsistency::nonUniqueName"
    or
    VarConsistency::noFieldDef(node) and msg = "VarConsistency::noFieldDef"
    or
    VarConsistency::noVarDef(node) and msg = "VarConsistency::noVarDef"
    or
    ModConsistency::uniqueResolve(node) and msg = "ModConsistency::uniqueResolve"
    or
    ModConsistency::noResolve(node) and msg = "ModConsistency::noResolve"
  ) and
  none() and // disabled for now
  not node.getLocation()
      .getFile()
      .getAbsolutePath()
      .matches("%/" +
          [
            "docs", // docs is not meant to compile on it's own
            "ql/ql/test" // the QL-for-QL tests are not meant to compile
          ] + "/%")
select node, msg
