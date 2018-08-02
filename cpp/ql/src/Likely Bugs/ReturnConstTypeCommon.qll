import cpp

private predicate mightHaveConstMethods(Type t) {
  t instanceof Class
  or t instanceof TemplateParameter
}

predicate hasSuperfluousConstReturn(Function f) {
  exists(Type t | t = f.getType() |
    // This is the primary thing we're testing for,
    t instanceof SpecifiedType
    and t.hasSpecifier("const")
    and (not affectedByMacro(t))
    // but "const" is meaningful when applied to user defined types,
    and not mightHaveConstMethods(t.getUnspecifiedType())
  )
  // and therefore "const T" might be meaningful for other values of "T".
  and not exists(TemplateFunction t | f = t.getAnInstantiation() |
    t.getType().involvesTemplateParameter()
  )
}
