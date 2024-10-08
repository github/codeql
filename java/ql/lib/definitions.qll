/**
 * Provides classes and predicates related to jump-to-definition links
 * in the code viewer.
 */

import java
import IDEContextual

/**
 * Restricts the location of a method access to the method identifier only,
 * excluding its qualifier, type arguments and arguments.
 *
 * If there is any whitespace between the method identifier and its first argument,
 * or between the method identifier and its qualifier (or last type argument, if any),
 * the location may be slightly inaccurate and include such whitespace,
 * but it should suffice for the purpose of avoiding overlapping definitions.
 */
private class LocationOverridingMethodCall extends MethodCall {
  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    exists(MemberRefExpr e | e.getReferencedCallable() = this.getMethod() |
      exists(int elRef, int ecRef | e.hasLocationInfo(path, _, _, elRef, ecRef) |
        sl = elRef and
        sc = ecRef - this.getMethod().getName().length() + 1 and
        el = elRef and
        ec = ecRef
      )
    )
    or
    not exists(MemberRefExpr e | e.getReferencedCallable() = this.getMethod()) and
    exists(int slSuper, int scSuper, int elSuper, int ecSuper |
      super.hasLocationInfo(path, slSuper, scSuper, elSuper, ecSuper)
    |
      (
        if exists(this.getTypeArgument(_))
        then
          exists(Location locTypeArg |
            locTypeArg = this.getTypeArgument(count(this.getTypeArgument(_)) - 1).getLocation()
          |
            sl = locTypeArg.getEndLine() and
            sc = locTypeArg.getEndColumn() + 2
          )
        else (
          if exists(this.getQualifier())
          then
            // Note: this needs to be the original (full) location of the qualifier, not the modified one.
            exists(Location locQual | locQual = this.getQualifier().getLocation() |
              sl = locQual.getEndLine() and
              sc = locQual.getEndColumn() + 2
            )
          else (
            sl = slSuper and
            sc = scSuper
          )
        )
      ) and
      (
        if this.getNumArgument() > 0
        then
          // Note: this needs to be the original (full) location of the first argument, not the modified one.
          exists(Location locArg | locArg = this.getArgument(0).getLocation() |
            el = locArg.getStartLine() and
            ec = locArg.getStartColumn() - 2
          )
        else (
          el = elSuper and
          ec = ecSuper - 2
        )
      )
    )
  }
}

/**
 * Restricts the location of a type access to exclude
 * the type arguments and qualifier, if any.
 */
private class LocationOverridingTypeAccess extends TypeAccess {
  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    exists(int slSuper, int scSuper, int elSuper, int ecSuper |
      super.hasLocationInfo(path, slSuper, scSuper, elSuper, ecSuper)
    |
      (
        if exists(this.getQualifier())
        then
          // Note: this needs to be the original (full) location of the qualifier, not the modified one.
          exists(Location locQual | locQual = this.getQualifier().getLocation() |
            sl = locQual.getEndLine() and
            sc = locQual.getEndColumn() + 2
          )
        else (
          sl = slSuper and
          sc = scSuper
        )
      ) and
      (
        if exists(this.getTypeArgument(_))
        then
          // Note: this needs to be the original (full) location of the first type argument, not the modified one.
          exists(Location locArg | locArg = this.getTypeArgument(0).getLocation() |
            el = locArg.getStartLine() and
            ec = locArg.getStartColumn() - 2
          )
        else (
          el = elSuper and
          ec = ecSuper
        )
      )
    )
  }
}

/**
 * Restricts the location of a field access to the name of the accessed field only,
 * excluding its qualifier.
 */
private class LocationOverridingFieldAccess extends FieldAccess {
  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    super.hasLocationInfo(path, _, _, el, ec) and
    sl = el and
    sc = ec - this.getField().getName().length() + 1
  }
}

/**
 * Restricts the location of a single-type-import declaration to the name of the imported type only,
 * excluding the `import` keyword and the package name.
 */
private class LocationOverridingImportType extends ImportType {
  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    exists(int elSuper, int ecSuper | super.hasLocationInfo(path, _, _, elSuper, ecSuper) |
      el = elSuper and
      ec = ecSuper - 1 and
      sl = el and
      sc = ecSuper - this.getImportedType().getName().length()
    )
  }
}

/**
 * Restricts the location of a single-static-import declaration to the name of the imported member(s) only,
 * excluding the `import` keyword and the package name.
 */
private class LocationOverridingImportStaticTypeMember extends ImportStaticTypeMember {
  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    exists(int elSuper, int ecSuper | super.hasLocationInfo(path, _, _, elSuper, ecSuper) |
      el = elSuper and
      ec = ecSuper - 1 and
      sl = el and
      sc = ecSuper - this.getName().length()
    )
  }
}

private Element definition(Element e, string kind) {
  e.(MethodCall).getMethod().getSourceDeclaration() = result and
  kind = "M" and
  not result instanceof InitializerMethod
  or
  e.(TypeAccess).getType().(RefType).getSourceDeclaration() = result and kind = "T"
  or
  exists(Variable v | v = e.(VarAccess).getVariable() |
    result = v.(Field) or
    result = v.(Parameter).getSourceDeclaration() or
    result = v.(LocalVariableDecl)
  ) and
  kind = "V"
  or
  e.(ImportType).getImportedType() = result and kind = "I"
  or
  e.(ImportStaticTypeMember).getAMemberImport() = result and kind = "I"
}

private predicate dummyVarAccess(VarAccess va) {
  exists(AssignExpr ae, InitializerMethod im |
    ae.getDest() = va and
    ae.getParent() = im.getBody().getAChild()
  )
}

private predicate dummyTypeAccess(TypeAccess ta) {
  exists(FunctionalExpr e |
    e.getAnonymousClass().getClassInstanceExpr().getTypeName() = ta.getParent*()
  )
}

/**
 * Gets an element, of kind `kind`, that element `e` uses, if any.
 *
 * The `kind` is a string representing what kind of use it is:
 *  - `"M"` for function and method calls
 *  - `"T"` for uses of types
 *  - `"V"` for variable accesses
 *  - `"I"` for import directives
 */
Element definitionOf(Element e, string kind) {
  result = definition(e, kind) and
  result.fromSource() and
  e.fromSource() and
  not dummyVarAccess(e) and
  not dummyTypeAccess(e)
}
