import javascript

query predicate folding(TemplateLiteral t, string str) { str = t.getStringValue() }

query predicate taggedTemplateExpr(TaggedTemplateExpr tte, Expr tag, TemplateLiteral template) {
  tag = tte.getTag() and
  template = tte.getTemplate()
}

query predicate templateElementCookedValue(TemplateElement te, string val) { te.getValue() = val }

query predicate templateElementRawValue(TemplateElement te, string raw) { raw = te.getRawValue() }

query predicate templateLiteral(TemplateLiteral tl, int i, Expr e) { tl.getElement(i) = e }
