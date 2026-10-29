import codeql.ruby.frameworks.ActiveSupport
import codeql.ruby.DataFlow
import codeql.ruby.frameworks.stdlib.Logger
import codeql.ruby.Concepts

query DataFlow::Node constantizeCalls(ActiveSupport::CoreExtensions::String::Constantize c) {
  result = c.getCode()
}

query predicate loggerInstantiations(Logger::LoggerInstantiation l) { any() }

query predicate codeExecutions(CodeExecution c) { any() }
