import csharp

query predicate globalUsing(UsingDirective und) { und.isGlobal() }

query predicate localUsing(UsingDirective ud) { not ud.isGlobal() }

query predicate globalUsingNamespace(UsingNamespaceDirective und, Namespace namespace) {
  und.isGlobal() and
  namespace = und.getImportedNamespace()
}
