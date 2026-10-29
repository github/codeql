import codeql.ruby.AST
import codeql.ruby.DataFlow
import codeql.ruby.frameworks.ActiveResource

query predicate modelClasses(
  ActiveResource::ModelClassNode c, DataFlow::Node siteAssignCall,
  boolean disablesCertificateValidation
) {
  c.getASiteAssignment() = siteAssignCall and
  if c.disablesCertificateValidation(siteAssignCall)
  then disablesCertificateValidation = true
  else disablesCertificateValidation = false
}

query predicate modelClassMethodCalls(ActiveResource::ModelClassMethodCall c) { any() }

query predicate modelInstancesAsSource(
  ActiveResource::ModelClassNode cls, DataFlow::LocalSourceNode node
) {
  node = cls.getAnInstanceReference().asSource()
}

query predicate modelInstanceMethodCalls(ActiveResource::ModelInstanceMethodCall c) { any() }

query predicate collectionSources(ActiveResource::CollectionSource c) { any() }
