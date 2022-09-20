import ruby
import codeql.ruby.DataFlow
import codeql.ruby.frameworks.ActiveResource

query predicate modelClasses(
  ActiveResource::ModelClass c, DataFlow::Node siteAssignCall, boolean disablesCertificateValidation
) {
  c.getASiteAssignment() = siteAssignCall and
  if c.disablesCertificateValidation(siteAssignCall)
  then disablesCertificateValidation = true
  else disablesCertificateValidation = false
}

query predicate modelClassMethodCalls(ActiveResource::ModelClassMethodCall c) { any() }

query predicate modelInstances(ActiveResource::ModelInstance c) { any() }

query predicate modelInstanceMethodCalls(ActiveResource::ModelInstanceMethodCall c) { any() }

query predicate collections(ActiveResource::Collection c) { any() }
