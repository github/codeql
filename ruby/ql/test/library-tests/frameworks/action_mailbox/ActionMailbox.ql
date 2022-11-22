private import codeql.ruby.frameworks.ActionMailbox
private import codeql.ruby.DataFlow

query predicate processMethods(ActionMailbox::Process p) { any() }

query predicate messageInstances(ActionMailbox::Mail::Message c) { any() }

query predicate remoteContent(ActionMailbox::Mail::RemoteContent r) { any() }
