private import ruby
private import codeql.ruby.Concepts
private import codeql.ruby.frameworks.Railties

query predicate systemCommandExecutions(SystemCommandExecution e) { any() }
