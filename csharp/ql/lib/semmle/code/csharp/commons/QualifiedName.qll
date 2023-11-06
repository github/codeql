/** Provides predicates for working with fully qualified names. */

private import csharp
private import dotnet

/**
 * Holds if namespace `n` has the qualified name `qualifier`.`name`.
 *
 * For example if the qualified name is `System.Collections.Generic`, then
 * `qualifier`=`System.Collections` and `name`=`Generic`.
 */
predicate namespaceHasQualifiedName(DotNet::Namespace n, string qualifier, string name) {
  if n instanceof DotNet::GlobalNamespace
  then qualifier = "" and name = ""
  else (
    exists(string pqualifier, string pname |
      namespaceHasQualifiedName(n.getParentNamespace(), pqualifier, pname) and
      qualifier = getQualifiedName(pqualifier, pname)
    ) and
    name = n.getName()
  )
}

/** Gets a string of `N` commas where `N + 1` is the number of type parameters of this unbound generic. */
private string getTypeParameterCommas(UnboundGeneric ug) {
  result = strictconcat(int i | exists(ug.getTypeParameter(i)) | "", ",")
}

/** Provides the input to `QualifiedName`. */
signature module QualifiedNameInputSig {
  /** Gets the suffix to print after unbound generic `ug`. */
  default string getUnboundGenericSuffix(UnboundGeneric ug) {
    result = "<" + getTypeParameterCommas(ug) + ">"
  }
}

/** Provides predicates for computing fully qualified names. */
module QualifiedName<QualifiedNameInputSig Input> {
  private string getDimensionString(ArrayType at, Type elementType) {
    exists(Type et, string res |
      et = at.getElementType() and
      res = at.getArraySuffix() and
      if et instanceof ArrayType
      then result = res + getDimensionString(et, elementType)
      else (
        result = res and elementType = et
      )
    )
  }

  bindingset[t]
  private string getFullName(Type t) {
    exists(string qualifier, string name |
      hasQualifiedName(t, qualifier, name) and
      result = getQualifiedName(qualifier, name)
    )
  }

  /** Gets the concatenation of the `getFullName` of type arguments. */
  language[monotonicAggregates]
  private string getTypeArgumentsQualifiedNames(ConstructedGeneric cg) {
    result =
      strictconcat(Type t, int i | t = cg.getTypeArgument(i) | getFullName(t), "," order by i)
  }

  /** Holds if declaration `d` has the qualified name `qualifier`.`name`. */
  predicate hasQualifiedName(Declaration d, string qualifier, string name) {
    d =
      any(ValueOrRefType vort |
        vort =
          any(ArrayType at |
            exists(Type elementType, string name0 |
              hasQualifiedName(elementType, qualifier, name0) and
              name = name0 + getDimensionString(at, elementType)
            )
          )
        or
        hasQualifiedName(vort.(TupleType).getUnderlyingType(), qualifier, name)
        or
        vort =
          any(UnboundGenericType ugt |
            exists(string name0 | name = name0 + Input::getUnboundGenericSuffix(ugt) |
              exists(string enclosing |
                hasQualifiedName(ugt.getDeclaringType(), qualifier, enclosing) and
                name0 = enclosing + "+" + ugt.getUndecoratedName()
              )
              or
              not exists(ugt.getDeclaringType()) and
              qualifier = ugt.getNamespace().getFullName() and
              name0 = ugt.getUndecoratedName()
            )
          )
        or
        vort =
          any(ConstructedType ct |
            exists(string name0 | name = name0 + "<" + getTypeArgumentsQualifiedNames(ct) + ">" |
              exists(string enclosing |
                hasQualifiedName(ct.getDeclaringType(), qualifier, enclosing) and
                name0 = enclosing + "+" + ct.getUndecoratedName()
              )
              or
              not exists(ct.getDeclaringType()) and
              qualifier = ct.getNamespace().getFullName() and
              name0 = ct.getUndecoratedName()
            )
          )
        or
        not vort instanceof ArrayType and
        not vort instanceof TupleType and
        not vort instanceof UnboundGenericType and
        not vort instanceof ConstructedType and
        (
          exists(string enclosing |
            hasQualifiedName(vort.getDeclaringType(), qualifier, enclosing) and
            name = enclosing + "+" + vort.getUndecoratedName()
          )
          or
          not exists(vort.getDeclaringType()) and
          qualifier = vort.getNamespace().getFullName() and
          name = vort.getUndecoratedName()
        )
      )
    or
    exists(string name0 |
      hasQualifiedName(d.(PointerType).getReferentType(), qualifier, name0) and
      name = name0 + "*"
    )
    or
    qualifier = "" and
    name = d.(TypeParameter).getName()
    or
    d =
      any(LocalFunction lf |
        exists(string cqualifier, string type |
          hasQualifiedName(lf.getEnclosingCallable(), cqualifier, type) and
          qualifier = getQualifiedName(cqualifier, type)
        ) and
        name = lf.getName()
      )
    or
    // no case for `LocalScopeVariable`
    namespaceHasQualifiedName(d, qualifier, name)
    or
    not d instanceof ValueOrRefType and
    not d instanceof PointerType and
    not d instanceof TypeParameter and
    not d instanceof LocalFunction and
    not d instanceof LocalScopeVariable and
    not d instanceof Namespace and
    exists(string dqualifier, string dname |
      hasQualifiedName(d.getDeclaringType(), dqualifier, dname) and
      qualifier = getQualifiedName(dqualifier, dname)
    ) and
    (
      name = d.(Operator).getFunctionName()
      or
      not d instanceof Operator and
      name = d.getName()
    )
  }

  /**
   * Holds if member `m` has name `name` and is defined in type `type`
   * with namespace `namespace`.
   */
  predicate hasQualifiedName(Member m, string namespace, string type, string name) {
    m =
      any(ConstructedMethod cm |
        hasQualifiedName(cm.getDeclaringType(), namespace, type) and
        name = cm.getUndecoratedName() + "<" + getTypeArgumentsQualifiedNames(cm) + ">"
      )
    or
    m =
      any(UnboundGenericMethod ugm |
        hasQualifiedName(ugm.getDeclaringType(), namespace, type) and
        name = ugm.getUndecoratedName() + Input::getUnboundGenericSuffix(ugm)
      )
    or
    not m instanceof ConstructedMethod and
    not m instanceof UnboundGenericMethod and
    hasQualifiedName(m.getDeclaringType(), namespace, type) and
    (
      name = m.(Operator).getFunctionName()
      or
      not m instanceof Operator and
      name = m.getName()
    )
  }
}

/**
 * Returns the concatenation of `qualifier` and `name`, separated by a dot.
 */
bindingset[qualifier, name]
string getQualifiedName(string qualifier, string name) {
  if qualifier = "" then result = name else result = qualifier + "." + name
}

/**
 * Returns the concatenation of `namespace`, `type` and `name`, separated by a dot.
 */
bindingset[namespace, type, name]
string getQualifiedName(string namespace, string type, string name) {
  result = getQualifiedName(namespace, type) + "." + name
}

/**
 * Holds if `qualifiedName` is the concatenation of `qualifier` and `name`, separated by a dot.
 */
bindingset[qualifiedName]
predicate splitQualifiedName(string qualifiedName, string qualifier, string name) {
  exists(string nameSplitter | nameSplitter = "(.*)\\.([^\\.]+)$" |
    qualifier = qualifiedName.regexpCapture(nameSplitter, 1) and
    name = qualifiedName.regexpCapture(nameSplitter, 2)
    or
    not qualifiedName.regexpMatch(nameSplitter) and
    qualifier = "" and
    name = qualifiedName
  )
}
