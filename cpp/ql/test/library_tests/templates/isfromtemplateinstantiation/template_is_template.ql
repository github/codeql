import cpp

predicate canBeTemplate(Declaration d) {
  d instanceof Class
  or
  d instanceof Function
  or
  d instanceof Variable
}

predicate isTemplate(Declaration d) {
  d instanceof TemplateClass
  or
  d instanceof TemplateFunction
  or
  d instanceof TemplateVariable
}

from Element e, string msg
where
  canBeTemplate(e) and
  (
    isTemplate(e) and
    not e.isFromUninstantiatedTemplate(_) and
    msg = "only isTemplate"
  ) and
  (
    e.isFromUninstantiatedTemplate(_) and
    not isTemplate(e) and
    msg = "only isFromUninstantiatedTemplate"
  )
select e, msg
