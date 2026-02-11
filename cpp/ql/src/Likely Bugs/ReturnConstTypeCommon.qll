import cpp

private predicate mightHaveConstMethods(Type t) {
  t instanceof Class or
  t instanceof TypeTemplateParameter
}

predicate hasSuperfluousConstReturn(Function f) {
  exists(Type t | t = f.getType() |
    // This is the primary thing we're testing for,
    t instanceof SpecifiedType and
    t.hasSpecifier("const") and
    not affectedByMacro(t) and
    // but "const" is meaningful when applied to user defined types,
    not mightHaveConstMethods(t.getUnspecifiedType())
  ) and
  // and therefore "const T" might be meaningful for other values of "T".
  not exists(TemplateFunction t | f = t.getAnInstantiation() |
    t.getType().involvesTemplateParameter()
  )
}
