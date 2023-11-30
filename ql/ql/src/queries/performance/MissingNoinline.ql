/**
 * @name Missing `noinline` or `nomagic` annotation
 * @description When a predicate is factored out to improve join-ordering, it should be marked as `noinline` or `nomagic`.
 * @kind problem
 * @problem.severity error
 * @id ql/missing-noinline
 * @tags performance
 * @precision high
 */

import ql

from QLDoc doc, Predicate decl
where
  doc.getContents().matches(["%join order%", "%join-order%"]) and
  decl.getQLDoc() = doc and
  not decl.getAnAnnotation() instanceof NoInline and
  not decl.getAnAnnotation() instanceof NoMagic and
  not decl.getAnAnnotation() instanceof NoOpt and
  not decl.getAnAnnotation().getName() = "cached" and
  // If it's marked as inline (or has at least one bindingset annotation)
  // it's probably because the QLDoc says something like "this predicate
  // is inlined because it gives a better join-order".
  not decl.getAnAnnotation() instanceof Inline and
  not decl.getAnAnnotation() instanceof BindingSet
select decl, "This predicate should probably be marked pragma[noinline] to prevent inlining."
