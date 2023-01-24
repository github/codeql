private import codeql.ruby.frameworks.ActionMailbox
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources

query predicate messageInstances(ActionMailbox::Mail c) { any() }

query predicate remoteFlowSources(RemoteFlowSource r) { any() }
