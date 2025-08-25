private import codeql.ruby.frameworks.GraphQL
private import codeql.ruby.AST
private import codeql.ruby.dataflow.RemoteFlowSources

query predicate graphqlSchemaObjectClass(GraphqlSchemaObjectClass cls) { any() }

query predicate graphqlSchemaObjectFieldDefinition(
  GraphqlSchemaObjectClass cls, GraphqlFieldDefinitionMethodCall meth
) {
  cls.getAFieldDefinitionMethodCall() = meth
}

query predicate graphqlResolveMethod(GraphqlResolveMethod meth) { any() }

query predicate graphqlResolveMethodRoutedParameter(GraphqlResolveMethod meth, Parameter p) {
  meth.getARoutedParameter() = p
}

query predicate graphqlLoadMethod(GraphqlLoadMethod meth) { any() }

query predicate graphqlLoadMethodRoutedParameter(GraphqlLoadMethod meth, Parameter p) {
  meth.getARoutedParameter() = p
}

query predicate graphqlFieldDefinitionMethodCall(GraphqlFieldDefinitionMethodCall cls) { any() }

query predicate graphqlFieldResolutionMethod(GraphqlFieldResolutionMethod cls) { any() }

query predicate graphqlFieldResolutionRoutedParameter(GraphqlFieldResolutionMethod meth, Parameter p) {
  meth.getARoutedParameter() = p
}

query predicate graphqlFieldResolutionDefinition(
  GraphqlFieldResolutionMethod meth, GraphqlFieldDefinitionMethodCall def
) {
  meth.getDefinition() = def
}

query predicate graphqlRemoteFlowSources(RemoteFlowSource src) { any() }
