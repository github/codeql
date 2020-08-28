import csharp

/** whether t depends on u */
predicate depends(ValueOrRefType t, ValueOrRefType u) {
  not t instanceof ConstructedType and
  (
    // inheritance
    exists(Type bt | t.getABaseType() = bt and usesType(bt, u))
    or
    // nesting
    exists(NestedType nt, Type bt | nt = t and nt.getDeclaringType() = bt and usesType(bt, u))
    or
    // delegate return type
    usesType(t.(DelegateType).getReturnType(), u)
    or
    // delegate parameter type
    usesType(t.(DelegateType).getAParameter().getType(), u)
    or
    // type of member field
    exists(Field f |
      f.getDeclaringType() = t and
      usesType(f.getType(), u)
    )
    or
    // type of member property
    exists(Property p |
      p.getDeclaringType() = t and
      usesType(p.getType(), u)
    )
    or
    // type of indexer property
    exists(Indexer i |
      i.getDeclaringType() = t and
      usesType(i.getType(), u)
    )
    or
    // type of event property
    exists(Event e |
      e.getDeclaringType() = t and
      usesType(e.getType(), u)
    )
    or
    // return type of member method
    exists(Method m |
      not m instanceof ConstructedMethod and
      m.getDeclaringType() = t and
      usesType(m.getReturnType(), u)
    )
    or
    // type of member method parameters
    exists(Callable c |
      not c instanceof ConstructedMethod and
      c.getDeclaringType() = t and
      usesType(c.getAParameter().getType(), u)
    )
    or
    exists(MethodCall mc, Method m |
      mc.getEnclosingCallable().getDeclaringType() = t and
      mc.getTarget() = m and
      usesType(m.getSourceDeclaration().getDeclaringType(), u)
    )
    or
    exists(ObjectCreation oc |
      oc.getEnclosingCallable().getDeclaringType() = t and
      usesType(oc.getObjectType().getSourceDeclaration(), u)
    )
    or
    exists(ObjectCreation oc, Field f |
      f.getDeclaringType() = t and
      f.getInitializer().getAChild*() = oc and
      usesType(oc.getObjectType().getSourceDeclaration(), u)
    )
    or
    exists(DelegateCreation oc |
      oc.getEnclosingCallable().getDeclaringType() = t and
      usesType(oc.getDelegateType().getSourceDeclaration(), u)
    )
    or
    exists(DelegateCall dc, DelegateType dt |
      dc.getEnclosingCallable().getDeclaringType() = t and
      dc.getDelegateExpr().getType() = dt and
      usesType(dt.getSourceDeclaration(), u)
    )
    or
    exists(OperatorCall oc, Operator o |
      oc.getEnclosingCallable().getDeclaringType() = t and
      oc.getTarget() = o and
      usesType(o.getSourceDeclaration().getDeclaringType(), u)
    )
    or
    exists(MemberAccess ma, Member m |
      ma.getEnclosingCallable().getDeclaringType() = t and
      ma.getTarget() = m and
      usesType(m.getSourceDeclaration().getDeclaringType(), u)
    )
    or
    exists(LocalVariableDeclExpr e, LocalVariable v |
      e.getEnclosingCallable().getDeclaringType() = t and
      e.getVariable() = v and
      usesType(v.getType(), u)
    )
    or
    exists(TypeAccess ta |
      ta.getEnclosingCallable().getDeclaringType() = t and
      usesType(ta.getType(), u)
    )
    or
    exists(CatchClause cc |
      cc.getEnclosingCallable().getDeclaringType() = t and
      usesType(cc.getCaughtExceptionType(), u)
    )
    or
    exists(Attribute a |
      t.getAMember() = a.getTarget() or
      t.getAnAttribute() = a
    |
      a.getType() = u
    )
  )
}

/** does t use dep in any way? */
predicate usesType(Type t, Type u) {
  t.(ValueOrRefType).getSourceDeclaration() = u or
  usesType(t.(ConstructedType).getATypeArgument(), u) or
  usesType(t.(ArrayType).getElementType(), u)
}

/**
 * the afferent coupling of a type is the number of types that
 *  directly depend on it.
 */
predicate afferentCoupling(/* this */ ValueOrRefType t, int ca) {
  ca = count(ValueOrRefType u | depends(u, t))
}

/**
 * The efferent coupling of a type is the number of types that
 *  it directly depends on.
 */
predicate efferentCoupling(/* this */ ValueOrRefType t, int ce) {
  ce = count(ValueOrRefType u | depends(t, u))
}

/* -------- HENDERSON-SELLERS LACK OF COHESION IN METHODS -------- */
/*
 * The aim of this metric is to try and determine whether a class
 *   represents one abstraction (good) or multiple abstractions (bad).
 *   If a class represents multiple abstractions, it should be split
 *   up into multiple classes.
 *
 *   In the Henderson-Sellers method, this is measured as follows:
 *      M = set of methods in class
 *      F = set of fields or properties in class
 *      r(f) = number of methods that access field, property, indexer or event f
 *      <r> = mean of r(f) over f in F
 *   The lack of cohesion is then given by
 *
 *      <r> - |M|
 *      ---------
 *        1 - |M|
 *
 *   We follow the Eclipse metrics plugin by restricting M to methods
 *   that access some field in the same class, and restrict F to
 *   fields that are read by methods in the same class.
 *
 *   Classes where the value of this metric is higher than 0.9 ought
 *   to be scrutinised for possible splitting.
 */

/** whether m accesses field or property f defined in the same type */
predicate accessesLocalFieldOrProperty(Method m, Declaration f) {
  (
    exists(FieldAccess fa | fa.getEnclosingCallable() = m and fa.getTarget() = f)
    or
    exists(PropertyAccess pa | pa.getEnclosingCallable() = m and pa.getTarget() = f)
  ) and
  m.getDeclaringType() = f.getDeclaringType()
}

/** whether t has a method m that accesses some local field, */
predicate hasAccessingMethod(ValueOrRefType t, Method m) {
  exists(Declaration f | accessesLocalFieldOrProperty(m, f)) and
  m.getDeclaringType() = t
}

/** returns any field or property that is accessed by a local method */
predicate hasAccessedFieldOrProperty(ValueOrRefType t, Declaration f) {
  exists(Method m | accessesLocalFieldOrProperty(m, f)) and
  f.getDeclaringType() = t
}

/** the Henderson-Sellers lack of cohesion metric */
predicate lackOfCohesionHS(/* this */ ValueOrRefType t, float locm) {
  exists(int m, float r |
    // m = number of methods that access some field, property, indexer or event
    m = count(Method method | hasAccessingMethod(t, method)) and
    // r = average (over f) of number of methods that access field or property f
    r =
      avg(Field f |
        hasAccessedFieldOrProperty(t, f)
      |
        count(Method x | accessesLocalFieldOrProperty(x, f))
      ) and
    // avoid division by zero
    m != 1 and
    // compute LCOM
    locm = ((r - m) / (1 - m))
  )
}

/* -------- CHIDAMBER AND KEMERER LACK OF COHESION IN METHODS ------------ */
/** whether the method m should be excluded from the CK cohesion computation */
predicate ignoreLackOfCohesionCK(Method m) { none() }

/** whether m1 and m2 access a common field or property */
predicate shareFieldOrProperty(ValueOrRefType t, Method m1, Method m2) {
  exists(Declaration d |
    methodUsesFieldOrProperty(t, m1, d) and
    methodUsesFieldOrProperty(t, m2, d) and
    m1 != m2
  )
}

/**
 * Holds if the declaring type of method `m` is `t` and `m` accesses declaration
 * `d`, which is either a field or a property.
 */
predicate methodUsesFieldOrProperty(ValueOrRefType t, Method m, Declaration d) {
  m.getDeclaringType() = t and
  (
    exists(FieldAccess fa | fa.getEnclosingCallable() = m and fa.getTarget() = d)
    or
    exists(PropertyAccess pa | pa.getEnclosingCallable() = m and pa.getTarget() = d)
  )
}

/**
 * The Chidamber-Kemerer lack of cohesion metric.
 *
 * The aim of this metric is to try and determine whether a class
 * represents one abstraction (good) or multiple abstractions (bad).
 * If a class represents multiple abstractions, it should be split
 * up into multiple classes.
 *
 * In the Chidamber and Kemerer method, this is measured as follows:
 *
 * - `n1` = number of pairs of distinct methods in a type that do *not*
 *   have at least one commonly accessed field or property.
 * - `n2` = number of pairs of distinct methods in a type that do
 *   have at least one commonly accessed field or property.
 * - `lcom` = `max((n1 - n2)/2, 0)`.
 *
 * We divide by 2 because each pair `(m1, m2)` is counted twice in
 * `n1` and `n2`.
 *
 * High values of `lcom` indicate a lack of cohesion. Specifically,
 * an `lcom` of greater than 500 indicates a potential problem.
 */
predicate lackOfCohesionCK(/* this */ ValueOrRefType t, float locm) {
  exists(int methods, int linked, float n |
    methods = count(Method m | t = m.getDeclaringType() and not ignoreLackOfCohesionCK(m)) and
    linked = count(Method m1, Method m2 | shareFieldOrProperty(t, m1, m2)) and
    // 1. The number of pairs of methods without a field in common is
    // the same as the number of pairs of methods minus the number
    // of pairs of methods *with* a field in common.
    // 2. The number of pairs of methods, if the number of methods
    // is C, is (C - 1) * C.
    n = ((methods - 1) * methods) / 2.0 - linked and
    (
      n < 0 and locm = 0
      or
      n >= 0 and locm = n
    )
  )
}
