import codeql.ruby.frameworks.ActiveSupport
import codeql.ruby.DataFlow
import codeql.ruby.frameworks.stdlib.Logger

query DataFlow::Node constantizeCalls(ActiveSupport::CoreExtensions::String::Constantize c) {
  result = c.getCode()
}

query predicate loggerInstantiations(Logger::LoggerInstantiation l) { any() }
