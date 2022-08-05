import ruby
import codeql.ruby.DataFlow
import codeql.ruby.frameworks.ActiveResource

query predicate modelClasses(ActiveResource::ModelClass c, DataFlow::Node siteAssignCall) {
  c.getASiteAssignment() = siteAssignCall
}

query predicate modelClassMethodCalls(ActiveResource::ModelClassMethodCall c) { any() }

query predicate modelInstances(ActiveResource::ModelInstance c) { any() }

query predicate modelInstanceMethodCalls(ActiveResource::ModelInstanceMethodCall c) { any() }

query predicate collections(ActiveResource::Collection c) { any() }
